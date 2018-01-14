alias gbs='git status; git branch'

# Git merge - used for github and github enterprise
{% raw %}
function pull_request() {
  git fetch origin pull/$1/head:$1 && git checkout $1
}
alias pr='pull_request'
alias dps='docker ps --format "table {{.Names}}\t{{.Status}}"'
{% endraw %}

alias drm='docker ps -a | grep Exit | cut -d " " -f 1 | xargs docker rm'
alias mm='~/bin/mm'
