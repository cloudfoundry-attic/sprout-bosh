function recreate-bosh-lite() {
  (read -s -p "password: " password
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
  echo $password | sudo -S bin/add-route

  cd ~/workspace/cf-release
  bundle install

  echo "Getting Stemcell"
  stemcell=`bosh public stemcells | grep -o 'bosh.*-warden-boshlite-ubuntu-trusty-go_agent.tgz'`
  bosh download public stemcell $stemcell
  bosh upload stemcell $stemcell
  pause 'Press [Enter] key to continue...'


  echo "Updating Diego-Release"
  cd ~/workspace/diego-release

  if $update; then
    ./scripts/update
  fi

  cd ~/workspace/cf-release
  echo "Deploying CF release"

  if $update; then
    ./scripts/update
  fi

  cd ~/workspace/cf-release
  ~/workspace/cf-release/scripts/generate-bosh-lite-dev-manifest

  bosh create release --name cf --force
  bosh upload release
  bosh -n deploy

  echo "Uploading Garden Linux"
  bosh upload release https://bosh.io/d/github.com/cloudfoundry-incubator/garden-linux-release

  echo "Uploading etcd-release"
  bosh upload release https://bosh.io/d/github.com/cloudfoundry-incubator/etcd-release

  cd ~/workspace/diego-release
  ./scripts/generate-bosh-lite-manifests
  echo "Deploying Diego"

  bosh deployment bosh-lite/deployments/diego.yml
  bosh create release --force
  bosh -n upload release
  bosh -n deploy

  cd ~/workspace/cf-release
  rm -f $stemcell)
}
export -f recreate-bosh-lite
