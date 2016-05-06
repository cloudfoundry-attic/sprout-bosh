alias resprout='(cd ~/workspace/sprout-capi && git pull && chruby-exec system -- bundle exec soloist)'

# CATs
alias cats='(cd ~/workspace/cf-release/src/github.com/cloudfoundry/cf-acceptance-tests && CONFIG=$PWD/integration_config.json bin/test_default -p)'
alias v3-cats='(cd ~/workspace/cf-release/src/github.com/cloudfoundry/cf-acceptance-tests && CONFIG=$PWD/integration_config.json bin/test -p v3)'

alias cats-notify='(cd ~/workspace/cf-release/src/github.com/cloudfoundry/cf-acceptance-tests && CONFIG=$PWD/integration_config.json bin/test_default -p ; get_back_to_work cats)'
alias v3-cats-notify='(cd ~/workspace/cf-release/src/github.com/cloudfoundry/cf-acceptance-tests && CONFIG=$PWD/integration_config.json bin/test -p v3 ; get_back_to_work cats )'
alias all-da-cats-notify='(cd ~/workspace/cf-release/src/github.com/cloudfoundry/cf-acceptance-tests && CONFIG=$PWD/integration_config.json bin/test_default -p && bin/test -p v3 ; get_back_to_work cats)'

# Bosh-lite setup
alias qnd-deploy='(cd ~/workspace/cf-release && scripts/deploy --no-manifest)'
alias qnd-deploy-diego='(cd ~/workspace/diego-release && bosh --parallel 10 sync blobs && scripts/update && scripts/deploy && bosh deployment ~/workspace/cf-release/bosh-lite/deployments/cf.yml)'
alias qnd-deploy-manifest='(cd ~/workspace/cf-release && scripts/deploy)'

alias qnd-deploy-notify='(cd ~/workspace/cf-release && scripts/deploy --no-manifest ; get_back_to_work)'
alias qnd-deploy-diego-notify='(cd ~/workspace/diego-release && bosh --parallel 10 sync blobs && scripts/update && scripts/deploy && bosh deployment ~/workspace/cf-release/bosh-lite/deployments/cf.yml ; get_back_to_work)'
alias qnd-deploy-manifest-notify='(cd ~/workspace/cf-release && scripts/deploy ; get_back_to_work)'

# PSQL
alias psql-bosh-lite='psql -h 10.244.0.30 -p 5524 -U ccadmin ccdb'

# Notify

alias notify='(get_back_to_work)'
alias notify-cats='(get_back_to_work cats)'

#FASD
alias v='fasd -e vim'

alias b='bundle exec'
alias bake='bundle exec rake'

# Git aliases
alias gd='git diff'
alias gdc='git diff --cached'
alias g='git status'

# Misc aliases
alias gi='gem install'
