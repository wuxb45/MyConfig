#
# ~/.bashrc
#
# vim: fdm=marker

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

shopt -q -s cdspell dirspell checkwinsize no_empty_cmd_completion cmdhist checkhash

# simple alias {{{
alias cd..='cd ..'
alias vi='vim'
alias ls='ls --color=auto'
alias tree='tree -C'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
# add '.' at the end on freebsd
alias gr='egrep -nr'
alias grc='egrep -nr --include=*.{c,cc,cpp,s,S,ld,cxx,C,h,hh,hpp,py,hs,java,sh,pl,tex,go,rs}'
alias du0='du -h -d 0'
alias du1='du -h -d 1'
alias dfh='df -h'
alias remake='make -B'
alias pull='git pull'
alias push='git push'
alias tiga='tig --all'

case "$(uname -s)" in
Linux)
  alias ll='ls -alhF --time-style=long-iso'
  alias lt='ls -lrhFt --time-style=long-iso'
  alias lz='ls -lrhFS --time-style=long-iso'
  alias freeh='free -h'
  alias utags='ctags -R . /usr/include'
  alias mtags='ctags -R . /usr/lib/modules/$(uname -r)/build'
  alias 2tags='ctags -R . ; gtags'
  ;;
FreeBSD)
  alias ll='ls -alhF -D "%F %H:%M"'
  alias lt='ls -lrhFt -D "%F %H:%M"'
  alias lz='ls -lrhFS -D "%F %H:%M"'
  alias ctags='exctags'
  alias 2tags='exctags -R . ; gtags'
  ;;
*)
  ;;
esac
# }}}

# color-man {{{
man()
{
  LESS_TERMCAP_md=$'\e[01;34m' \
  LESS_TERMCAP_me=$'\e[0m' \
  LESS_TERMCAP_se=$'\e[0m' \
  LESS_TERMCAP_so=$'\e[01;44;33m' \
  LESS_TERMCAP_ue=$'\e[0m' \
  LESS_TERMCAP_us=$'\e[01;32m' \
  command man "$@"
}
# }}} color-man

# exports {{{
if [[ -z $BASHRC_LOADED ]]; then

prog=${HOME}/program
if [[ -d "${prog}" ]]; then
  if [[ -f "${prog}/.wl" ]]; then
    wl=$(cat "${prog}/.wl")
  else
    wl=$(ls ${prog})
  fi # white-list

  for home in ${wl}; do
    ph=${prog}/${home}
    if [[ -d "${ph}" ]]; then
      for bd in bin sbin; do
        if [[ -d "${ph}/${bd}" ]]; then
          if [[ -z ${PATH} ]]; then
            PATH=${ph}/${bd}
          else
            PATH=${ph}/${bd}:${PATH}
          fi
        fi
      done
      for ld in lib lib64; do
        if [[ -d "${ph}/${ld}" ]]; then
          if [[ -z ${LD_LIBRARY_PATH} ]]; then
            LD_LIBRARY_PATH=${ph}/${ld}
          else
            LD_LIBRARY_PATH=${ph}/${ld}:${LD_LIBRARY_PATH}
          fi
        fi
      done
    fi
  done
  export PATH
  export LD_LIBRARY_PATH
fi # program

[[ -f ~/.bashrc.local1 ]] && . ~/.bashrc.local1

export HISTCONTROL=ignoreboth:erasedups
export HISTSIZE=10000
export HISTFILESIZE=20000
export HISTIGNORE='&'
export EDITOR='vim'

export BASHRC_LOADED=y
fi # BASHRC_LOADED
# }}}

# PS1 {{{
if [[ -x $(which tput 2>/dev/null) ]]; then
  # user host
  PS_1="$(tput bold)$(tput smul)$(tput setab 0)$(tput setaf 2)\\u$(tput setaf 7)@$(tput setaf 5)\\h"
  # time pwd
  PS_2="$(tput setaf 7)@$(tput setaf 6)\\t$(tput setaf 7):$(tput setaf 3)\\w$(tput sgr0) "
  # working dir info
  [[ -x $(which ps1git 2>/dev/null) ]] && PS_w='$(ps1git)'
  # the prompt $
  PS_p="\n\\$ "
  PS1="${PS_1}${PS_2}${PS_w}${PS_p}"
else
  PS1="\\u@\\h@\\t:\\w\n\\$ "
fi
# }}} PS1

[[ -f ~/.bashrc.localn ]] && . ~/.bashrc.localn
