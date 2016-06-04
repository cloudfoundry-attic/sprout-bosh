function notify() {
  if [[ "$@" == "" ]]; then
    echo "notify requires an argument. For example:"
    echo -en "\n"
    echo "notify v3-cats"
    echo "notify 'sleep 1'"
    echo "notify 'cd cf-release && scripts/deploy'"
    return
  fi

  eval "$1"
  local CMD_EXIT_CODE=$(echo $?)
  local CAT_OR_NOT="default"
  get_last_names

  if [[ "$1" =~ "cat" ]]; then
    CAT_OR_NOT="cat"
  fi

  if [ $CMD_EXIT_CODE -eq 130 ]; then
    return 0
  elif [ $CMD_EXIT_CODE -eq 0 ]; then
    open "http://get-back-to-work-meow.cfapps.io/${CAT_OR_NOT}-success/${LAST_NAMES}"
  else
    open "http://get-back-to-work-meow.cfapps.io/${CAT_OR_NOT}-fail/${LAST_NAMES}"
  fi
}

function get_last_names(){
  local author1=$(git config duet.env.git-author-name)
  local author2=$(git config duet.env.git-committer-name)
  local author1array=($author1)

  if [[ -z $author2 ]]; then
    LAST_NAMES="${author1array[1]}"
  else
    local author2array=($author2)
    LAST_NAMES="${author1array[1]}%20and%20${author2array[1]}"
  fi
}

export -f notify

