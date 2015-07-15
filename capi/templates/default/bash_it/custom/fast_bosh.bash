function bosh() {
  BUNDLE_GEMFILE=~/workspace/fast-bosh/Gemfile $HOME/.gem/ruby/2.1.6/bin/bundle exec bosh "$@"
}
export -f bosh
