function bosh_lite_install_release() {
  declare name="$1" release="$2" release_data release_version release_url release_filename

  local cache_directory="${HOME}/Downloads"

  release_data=$(curl --retry 5 -s -L "https://bosh.io/api/v1/releases/github.com/${release}")
  release_version=$(jq '.[0].version' --raw-output <<< "${release_data}")
  release_url=$(jq '.[0].url' --raw-output <<< "${release_data}")
  release_filename="${name}-release-${release_version}.tgz"

  if [ ! -f "$cache_directory/$release_filename" ]; then
    echo "Downloading ${name} release version ${release_version}"
    aria2c -x 16 -s 16 -d "${cache_directory}" -o "${release_filename}" "${release_url}"
  else
    echo "${name} release version ${release_version} already exists"
  fi

  echo "Uploading ${name}"
  bosh -t lite upload release "${cache_directory}/${release_filename}"
}

function recreate_bosh_lite() {
  (
    cache_directory="$HOME/Downloads"
    set -e
    sudo true

    update=false
    if [[ $1 == "-u" ]]; then
      echo -e '\nWill Update cf-release and diego-release'
      update=true
    fi

    cd ~/workspace/bosh-lite

    echo -e "\nDestroying current Bosh-Lite"
    vagrant destroy --force

    #pull in changes for bosh-lite
    git pull

    #update vagrant box
    vagrant box update

    echo "Starting up Bosh-Lite"
    vagrant up

    echo "Adding route"
    sudo -S bin/add-route

    cd ~/workspace/cf-release

    bosh target lite

    stemcell_data=`curl --retry 5 -s -L https://bosh.io/api/v1/stemcells/bosh-warden-boshlite-ubuntu-trusty-go_agent`
    stemcell_version=`jq '.[0].version' --raw-output <<< $stemcell_data`
    stemcell_url=`jq '.[0].regular.url' --raw-output <<< $stemcell_data`
    stemcell_filename="bosh-stemcell-$stemcell_version-warden-boshlite-ubuntu-trusty-go_agent.tgz"

    if [ ! -f "$cache_directory/$stemcell_filename" ]; then
      echo "Downloading stemcell version $stemcell_version"
      aria2c -x 16 -s 16 -d $cache_directory -o $stemcell_filename $stemcell_url
    else
      echo "Stemcell version $stemcell_version already exists"
    fi

    echo "Uploading Stemcell"
    bosh -t lite upload stemcell "$cache_directory/$stemcell_filename"

    if $update; then
      echo "Updating Diego-Release"
      ~/workspace/diego-release/scripts/update
    fi

    cd ~/workspace/cf-release
    echo "Deploying CF release"

    if $update; then
      ./scripts/update
    fi

    cd ~/workspace/cf-release
    ~/workspace/cf-release/scripts/generate-bosh-lite-dev-manifest

    bosh --parallel 10 sync blobs
    bosh create release --name cf --force
    bosh -t lite upload release
    bosh -t lite -n deploy

    bosh_lite_install_release "garden-linux" "cloudfoundry-incubator/garden-linux-release"
    bosh_lite_install_release "etcd" "cloudfoundry-incubator/etcd-release"
    bosh_lite_install_release "cflinuxfs2-rootfs" "cloudfoundry/cflinuxfs2-rootfs-release"

    cd ~/workspace/diego-release

    ./scripts/generate-bosh-lite-manifests
    echo "Deploying Diego"

    bosh -t lite deployment bosh-lite/deployments/diego.yml
    bosh --parallel 10 sync blobs
    bosh create release --force
    bosh -t lite -n upload release
    bosh -t lite -n deploy

    cd ~/workspace/cf-release
    rm -f $stemcell

    bosh -t lite deployment bosh-lite/deployments/cf.yml

    virtualbox_version=$(brew cask list --versions | grep virtualbox | awk '{print $2}')
    reboot_time=$(last -1 reboot | awk '{print $3, $4, $5, $6}')
    bosh_lite_box=$(vagrant box list | grep bosh-lite | awk '{print $3}' | sed 's/)//g' | sort -r | head -1)
    vagrant_version=$(vagrant --version | awk '{print $2}')

    function log() {
      echo `date "+%Y-%m-%d %H:%M:%S %z"`: $* >> ~/Library/Logs/recreate_bosh_lite.log
    }

    function log_empty() {
      echo '' >> ~/Library/Logs/recreate_bosh_lite.log
    }

    log ======= NEW BOSH LITE
    log Virtualbox  $virtualbox_version
    log Last Reboot $reboot_time
    log Bosh Lite   $bosh_lite_box
    log Vagrant     $vagrant_version
    log_empty
  )
}
export -f recreate_bosh_lite
