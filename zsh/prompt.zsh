autoload colors && colors
# cheers, @ehrenmurdick
# http://github.com/ehrenmurdick/config/blob/master/zsh/prompt.zsh

if (( $+commands[git] ))
then
  git="$commands[git]"
else
  git="/usr/bin/git"
fi

git_branch() {
  echo $($git symbolic-ref HEAD 2>/dev/null | awk -F/ {'print $NF'})
}

git_dirty() {
  if [[ -f .git/HEAD ]]
  then
    echo -n "%{$fg_bold[yellow]%}($(git_prompt_info)"

    st=$($git status 2>/dev/null | tail -n 1)
    if [[ "$st" =~ ^nothing ]]
    then
      echo -n " ✓"
    else
      echo -n " ✗"
    fi
    echo "$(need_push)%{$fg_bold[yellow]%})%{$reset_color%} "

  else
    echo ""
  fi
}

git_prompt_info () {
 ref=$($git symbolic-ref HEAD 2>/dev/null) || return
# echo "(%{\e[0;33m%}${ref#refs/heads/}%{\e[0m%})"
 echo "${ref#refs/heads/}"
}

unpushed () {
  $git cherry -v @{upstream} 2>/dev/null
}

need_push () {
  if [[ $(unpushed) == "" ]]
  then
    echo ""
  else
    echo " %{$fg_bold[red]%}⤉%{$reset_color%}"
  fi
}

username() {
  echo "%{$fg_bold[green]%}%n%{$reset_color%}"
}

ssh_info() {
  if [ ! -z "$SSH_CONNECTION" ]; then
    echo "@%{$fg_bold[cyan]%}%m%{$reset_color%}"
  fi
}

directory_name() {
  echo "%{$fg_bold[white]%}%~%{$reset_color%}"
}

export PROMPT=$'$(username)$(ssh_info):$(directory_name) $(git_dirty)\n› '
set_prompt () {
  export RPROMPT="%{$fg_bold[cyan]%}%{$reset_color%}"
}

