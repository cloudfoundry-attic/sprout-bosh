function bosh_lite_cache_directory() {
  echo "${HOME}/.bosh-lite/cache"
}

function bosh_lite_install_resource() {
  declare resource_type="$1" name="$2" source_url="$3" cache_dir="$4" url_matcher="$5" data version url filename

  DEFAULT_URL_MATCHER='.[0].url'
  url_matcher=${url_matcher:-$DEFAULT_URL_MATCHER}

  data=$(curl --retry 5 -s -L "${source_url}")
  version=$(jq '.[0].version' --raw-output <<< "${data}")
  url=$(jq ${url_matcher} --raw-output <<< "${data}")
  filename="${name}-${version}.tgz"

  if [ ! -f "${cache_dir}/${filename}" ]; then
    echo "Downloading ${name} ${resource_type} version ${version}"
    aria2c -x 16 -s 16 -d "${cache_dir}" -o "${filename}" "${url}"
  else
    echo "${resource_type} ${name} version ${version} already exists"
  fi

  echo "Uploading ${resource_type} ${name}"
  bosh -t lite upload "${resource_type}" "${cache_dir}/${filename}"
}

function bosh_lite_install_release() {
  declare name="$1" release="$2"
  local release_cache_directory="$(bosh_lite_cache_directory)/releases"

  bosh_lite_install_resource "release" "${name}" "https://bosh.io/api/v1/releases/github.com/${release}" "${release_cache_directory}"
}

function bosh_lite_install_stemcell() {
  declare name="$1"
  local stemcell_cache_directory="$(bosh_lite_cache_directory)/stemcells"

  bosh_lite_install_resource "stemcell" "${name}" "https://bosh.io/api/v1/stemcells/${name}" "${stemcell_cache_directory}" '.[0].regular.url'
}

function initialize_bosh_lite_directories() {
  local cache_dir=$(bosh_lite_cache_directory)
  mkdir -p "${cache_dir}/stemcells"
  mkdir -p "${cache_dir}/releases"
}

function recreate_bosh_lite() {
  (
    initialize_bosh_lite_directories

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

    git pull

    #update vagrant box
    vagrant box update

    echo "Starting up Bosh-Lite"
    vagrant up

    echo "Adding route"
    sudo -S bin/add-route

    cd ~/workspace/cf-release

    bosh target lite

    bosh_lite_install_stemcell "bosh-warden-boshlite-ubuntu-trusty-go_agent"

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
