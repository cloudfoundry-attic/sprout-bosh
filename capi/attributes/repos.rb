default['cf-runtime']['repos'] = [
  { 'name' => 'bosh-lite' },
  { 'name' => 'cf-release', 'branch' => 'develop' },
  { 'name' => 'ci' },
  { 'name' => 'deployments-runtime' },
  { 'name' => 'runtime-checkman' },
  { 'name' => 'runtime-credentials', 'url' => 'git@github.com:pivotal-cf/runtime-credentials' },
  { 'name' => 'warden-test-infrastructure' },
]
