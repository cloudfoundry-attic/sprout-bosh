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

    garden_release_data=`curl --retry 5 -s -L https://bosh.io/api/v1/releases/github.com/cloudfoundry-incubator/garden-linux-release`
    garden_release_version=`jq '.[0].version' --raw-output <<< $garden_release_data`
    garden_release_url=`jq '.[0].url' --raw-output <<< $garden_release_data`
    garden_release_filename="garden-linux-release-$garden_release_version.tgz"

    if [ ! -f "$cache_directory/$garden_release_filename" ]; then
      echo "Downloading garden release version $garden_release_version"
      aria2c -x 16 -s 16 -d $cache_directory -o $garden_release_filename $garden_release_url
    else
      echo "Garden release version $garden_release_version already exists"
    fi

    echo "Uploading Garden Linux"
    bosh -t lite upload release "$cache_directory/$garden_release_filename"

    etcd_release_data=`curl --retry 5 -s -L https://bosh.io/api/v1/releases/github.com/cloudfoundry-incubator/etcd-release`
    etcd_release_version=`jq '.[0].version' --raw-output <<< $etcd_release_data`
    etcd_release_url=`jq '.[0].url' --raw-output <<< $etcd_release_data`
    etcd_release_filename="etcd-release-$etcd_release_version.tgz"

    if [ ! -f "$cache_directory/$etcd_release_filename" ]; then
      echo "Downloading etcd release version $etcd_release_version"
      aria2c -x 16 -s 16 -d $cache_directory -o $etcd_release_filename $etcd_release_url
    else
      echo "Etcd release version $etcd_release_version already exists"
    fi

    echo "Uploading etcd-release"
    bosh -t lite upload release "$cache_directory/$etcd_release_filename"

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
