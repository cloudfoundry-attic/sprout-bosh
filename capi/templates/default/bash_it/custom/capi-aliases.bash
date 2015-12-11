alias resprout='(cd ~/workspace/sprout-capi && git pull && chruby-exec system -- bundle exec soloist)'
alias cats='(cd ~/workspace/cf-release/src/github.com/cloudfoundry/cf-acceptance-tests && CONFIG=$PWD/integration_config.json bin/test_default -p)'
alias v3-cats='(cd ~/workspace/cf-release/src/github.com/cloudfoundry/cf-acceptance-tests && CONFIG=$PWD/integration_config.json bin/test v3)'

# Bosh-lite setup
alias qnd-deploy='(cd ~/workspace/cf-release && bosh --parallel 10 create release --name cf --force && bosh upload release && bosh -n deploy)'
alias qnd-deploy-manifest='(cd ~/workspace/cf-release && scripts/generate-bosh-lite-dev-manifest && qnd-deploy)'

#FASD
alias v='fasd -e vim'
