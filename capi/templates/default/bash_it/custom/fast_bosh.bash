function bosh() {
  GEM_PATH= BUNDLE_GEMFILE=~/workspace/fast-bosh/Gemfile chruby-exec 2.1.6 -- bundle exec bosh "$@"
}
export -f bosh
