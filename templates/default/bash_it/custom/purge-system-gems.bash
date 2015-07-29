function purge_system_gems() {
  curent_ruby=`ruby --version`
  system_ruby=`/usr/bin/ruby --version`

  if [ "${current_ruby}" == "${system_ruby}" ]; then
    gem list --no-version | \
      xargs -I % bash -c \
        '\sudo gem uninstall -Ia % || \sudo gem uninstall -Ia % -i /System/Library/Frameworks/Ruby.framework/Versions/2.0/usr/lib/ruby/gems/2.0.0'
  else
    echo "ERROR: only run purge_system_gems against system ruby: [ ${current_ruby} != ${system_ruby} ]"
    return 1
  fi
}
