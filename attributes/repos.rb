default['cf-bosh']['repos'] = [
  { 'name' => 'deployments-bosh' },
  { 'name' => 'bosh', 'branch' => 'develop' },
  { 'name' => 'bosh-agent' },
  { 'name' => 'bosh-micro-cli' },
  { 'name' => 'bosh-lite' },
  { 'name' => 'bosh-checkman' },
  { 'name' => 'bosh-jenkins-config' },
  { 'name' => 'bosh-sample-release' },
  { 'name' => 'bosh-packer-templates' },
  
  { 'name' => 'bosh-ci', 'url' => 'git@github.com:pivotal-cf-experimental/bosh-ci.git' },
  { 'name' => 'dummy-boshrelease', 'url' => 'git@github.com:pivotal-cf-experimental/dummy-boshrelease.git' },
]
