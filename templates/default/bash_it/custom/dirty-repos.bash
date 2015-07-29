function repos() {
    find . -name .git -type d | sed 's/\.git$//g'
}

function uncommitted-changes() {
    git status --porcelain
}

function unpushed-commits() {
    git log origin..HEAD --pretty=oneline
}

function dirty-repos() {
    for repo in $(repos)
    do
        (
            cd $repo
            if [ -n "$(uncommitted-changes)" ]
            then
                echo "Uncommitted changes in $repo"
            fi

            if [ -n "$(unpushed-commits)" ]
            then
                echo "Unpushed commits in $repo"
            fi
        )
    done
}
