function bosh() {
  BUNDLE_GEMFILE=~/workspace/fast-bosh/Gemfile chruby-exec 2.1.6 -- $HOME/.gem/ruby/2.1.6/bin/bundle exec bosh "$@"
}
export -f bosh
