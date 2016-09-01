shopt -s checkwinsize
[ -z "$PS1" ] && return
[ -f $HOME/.git-completion.bash ] && source $HOME/.git-completion.bash
[ -f $HOME/.git-prompt.sh ] && source $HOME/.git-prompt.sh

__prompt_command () {
  local EXIT="$?"
  if [ $EXIT != 0 ] ; then
    PS1="\[\e[0;31m\]•\[\e[0m\] "
  else
    PS1="\[\e[0;32m\]•\[\e[0m\] "
  fi
  PS1+='\w/$(__git_ps1 " \[\e[0;32m\]%s\[\e[0m\]") '
}

extract () {
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2) tar xvjf $1 ;;
      *.tar.gz)  tar xvzf $1 ;;
      *.tar.xz)  tar xvf $1 ;;
      *.tbz2)    tar xjf $1 ;;
      *.tar)     tar xf $1 ;;
      *.tgz)     tar xzf $1 ;;
      *.bz2)     bunzip2 -k $1 ;;
      *.zip)     unzip $1 ;;
      *.rar)     unrar e $1 ;;
      *.gz)      gunzip -c $1 > `echo $1 | cut -d'.' --complement -f2-` ;;
      *.7z)      7za e $1 ;;
      *.Z)       uncompress $1 ;;
      *)         echo "'$1' cannot be extracted by extract()" ; return 1 ;;
    esac
    return 0
  else
    echo "'$1' is not a valid file"
    return 1
  fi
}

manageiq () {
  tmux new-session -s manageiq   -n server -d 'cd ~/devel/manageiq; bash -i'
  tmux new-window  -t manageiq:2 -n worker    'cd ~/devel/manageiq; bash -i '
  tmux new-window  -t manageiq:3 -n console   'cd ~/devel/manageiq; bash -i'
  tmux new-window  -t manageiq:4 -n ssui      'cd ~/devel/manageiq-ssui; bash -i'

  tmux select-window -t manageiq:1
  tmux -2 attach-session -t manageiq
}

dock_toggle () {
  local dp2_1="`xrandr | grep '^DP2-1 connected'`"
  local dp2_2="`xrandr | grep '^DP2-2 connected'`"
  if [ -z "$dp2_1" ] && [ -z "$dp2_2" ] ; then
    xrandr --auto --output eDP1 --primary
  else
    xrandr --output eDP1  --crtc 0 --auto --rotation normal \
           --output DP2-1 --crtc 1 --auto --rotation left --right-of eDP1 --primary \
           --output DP2-2 --crtc 2 --auto --rotation left --right-of DP2-1
  fi
  setxkbmap -option ctrl:nocaps
}

alias diff='diff -s'
alias df='df -h'
alias cal='cal -m -3'
alias grep='grep --color=auto'
alias egrep='egrep --color'
alias ls='ls --color'

eval "$(rbenv init -)"
