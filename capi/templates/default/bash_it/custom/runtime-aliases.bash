alias resprout='(~/workspace/sprout-capi && git pull && bundle exec soloist)'
alias create-lite='bosh create release --force && bosh target 192.168.50.4 lite && ./bosh-lite/make_manifest && bosh -n upload release && bosh -n deploy'
alias cats='(cd ~/workspace/cf-release/src/acceptance-tests && CONFIG=$PWD/integration_config.json bin/test -nodes 4)'
