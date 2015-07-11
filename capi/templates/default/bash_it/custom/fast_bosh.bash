function bosh() {
  BUNDLE_GEMFILE=~/workspace/fast-bosh/Gemfile chruby-exec system -- bundle exec bosh "$@"
}
export -f bosh
