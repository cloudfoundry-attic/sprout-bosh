function recreate_bosh_lite() {
  (
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
    stemcell_filename="$HOME/Downloads/bosh-stemcell-$stemcell_version-warden-boshlite-ubuntu-trusty-go_agent.tgz"

    if [ ! -f $stemcell_filename ]; then
      echo "Downloading stemcell version $stemcell_version"
      curl -L $stemcell_url -o $stemcell_filename
    else
      echo "Stemcell version $stemcell_version already exists"
    fi

    echo "Uploading Stemcell"
    bosh -t lite upload stemcell $stemcell_filename

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
    garden_release_filename="$HOME/Downloads/garden-linux-release-$garden_release_version.tgz"

    if [ ! -f $garden_release_filename ]; then
      echo "Downloading garden release version $garden_release_version"
      curl -L $garden_release_url -o $garden_release_filename
    else
      echo "Garden release version $garden_release_version already exists"
    fi

    echo "Uploading Garden Linux"
    bosh -t lite upload release $garden_release_filename

    etcd_release_data=`curl --retry 5 -s -L https://bosh.io/api/v1/releases/github.com/cloudfoundry-incubator/etcd-release`
    etcd_release_version=`jq '.[0].version' --raw-output <<< $etcd_release_data`
    etcd_release_url=`jq '.[0].url' --raw-output <<< $etcd_release_data`
    etcd_release_filename="$HOME/Downloads/etcd-release-$etcd_release_version.tgz"

    if [ ! -f $etcd_release_filename ]; then
      echo "Downloading etcd release version $etcd_release_version"
      curl -L $etcd_release_url -o $etcd_release_filename
    else
      echo "Etcd release version $etcd_release_version already exists"
    fi

    echo "Uploading etcd-release"
    bosh -t lite upload release $etcd_release_filename

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
  )
}
export -f recreate_bosh_lite
