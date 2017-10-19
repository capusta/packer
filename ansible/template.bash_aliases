alias gbs='git status; git branch'

# Git merge - used for github and github enterprise
function pull_request() {
  git fetch origin pull/$1/head:$1 && git checkout $1
}
alias gm='pull_request'
