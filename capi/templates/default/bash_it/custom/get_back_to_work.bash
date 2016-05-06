function get_back_to_work() {
  last_exit_code=$(echo $?)

  author1=$(git config duet.env.git-author-name)
  author2=$(git config duet.env.git-committer-name)

  author1array=($author1)

  if [[ -z $author2 ]]; then
    last_names="${author1array[1]}"
  else
    author2array=($author2)
    last_names="${author1array[1]}%20and%20${author2array[1]}"
  fi

  if [ "$1" == 'cats' ]; then
    success="http://get-back-to-work-meow.cfapps.io/cat-success/${last_names}"
    fail="http://get-back-to-work-meow.cfapps.io/cat-fail/${last_names}"
  else
    success="http://get-back-to-work-meow.cfapps.io/default-success/${last_names}"
    fail="http://get-back-to-work-meow.cfapps.io/default-fail/${last_names}"
  fi

  if [ $last_exit_code -eq 130 ]; then
    exit 0
  elif [ $last_exit_code -eq 0 ]; then
    open $success
  else
    open $fail
  fi
}
export -f get_back_to_work


