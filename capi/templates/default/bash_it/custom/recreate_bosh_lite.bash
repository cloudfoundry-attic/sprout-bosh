function recreate_bosh_lite() {
  (
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

    echo "Getting Stemcell"
    bosh upload stemcell https://bosh.io/d/stemcells/bosh-warden-boshlite-ubuntu-trusty-go_agent

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

    bosh create release --name cf --force
    bosh -t lite upload release
    bosh -t lite -n deploy

    echo "Uploading Garden Linux"
    bosh -t lite upload release https://bosh.io/d/github.com/cloudfoundry-incubator/garden-linux-release

    echo "Uploading etcd-release"
    bosh -t lite upload release https://bosh.io/d/github.com/cloudfoundry-incubator/etcd-release

    cd ~/workspace/diego-release

    ./scripts/generate-bosh-lite-manifests
    echo "Deploying Diego"

    bosh -t lite deployment bosh-lite/deployments/diego.yml
    bosh create release --force
    bosh -t lite -n upload release
    bosh -t lite -n deploy

    cd ~/workspace/cf-release
    rm -f $stemcell
  )
}
export -f recreate_bosh_lite
