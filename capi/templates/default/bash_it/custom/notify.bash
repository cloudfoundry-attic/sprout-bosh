function notify() {
  if [[ "$@" == "" ]]; then
    echo "notify requires an argument. For example:"
    echo -en "\n"
    echo "notify v3-cats"
    echo "notify 'cd cf-release && scripts/deploy'"
    return
  fi

  eval "$1"
  local CMD_EXIT_CODE=$(echo $?)
  get_last_names

  if [ $CMD_EXIT_CODE -eq 130 ]; then
    exit 0
  elif [ $CMD_EXIT_CODE -eq 0 ]; then
    open "http://get-back-to-work-meow.cfapps.io/cat-success/${last_names}"
  else
    open "http://get-back-to-work-meow.cfapps.io/cat-fail/${last_names}"
  fi
}

function get_last_names(){
  local author1=$(git config duet.env.git-author-name)
  local author2=$(git config duet.env.git-committer-name)
  local author1array=($author1)

  if [[ -z $author2 ]]; then
    last_names="${author1array[1]}"
  else
    local author2array=($author2)
    last_names="${author1array[1]}%20and%20${author2array[1]}"
  fi
}

export -f notify

