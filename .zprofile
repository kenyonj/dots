# ~/.zprofile: commands which export environment variables are collected
# here. primarily so that a proper PATH is available to all the
# customizations that occur in ~/.zshrc. Note: noramlly this should be
# zshenv, but Arch uses a not-standard loading order.

_source () {
  local file="$1"
  [[ -r "$file" ]] && source "$file"
}

_add_to_path() {
  local dir

  for dir; do
    if [[ -d "$dir" ]] && [[ ! ":${PATH}:" =~ ":${dir}:" ]]; then
      export PATH="$dir:$PATH"
    fi
  done
}

_add_to_path "$HOME/.bin" "$HOME/Code/bin" "$HOME/.cabal/bin" "$HOME/.rvm/bin"

_source "$HOME/.screen/bashrc.screen"
_source "$HOME/.aws_keys"
_source "$HOME/.secrets"

if (( $+commands[brew] )); then
  _add_to_path "$(brew --prefix coreutils)/libexec/gnubin"
fi

(( $+commands[vim] ))      && export EDITOR=vim
(( $+commands[chromium] )) && export BROWSER=chromium

if (( $+commands[dircolors] )) && [[ -f $HOME/.lscolors ]]; then
  eval $(dircolors -b $HOME/.lscolors)
fi

if (( $+commands[albumart.php] )); then
  export AWS_LIB="$HOME/Code/php/albumart/lib"
  export AWS_CERT_FILE="$HOME/.aws/cert-67RVMJTXXBDL4ZZOYSYBI3A7ZP56N3XD.pem"
  export AWS_PRIVATE_KEY_FILE="$HOME/.aws/pk-67RVMJTXXBDL4ZZOYSYBI3A7ZP56N3XD.pem"
fi

if (( $+commands[dmenu] )); then
  # dmenu-xft required
  export DMENU_OPTIONS='-i -fn Verdana-8 -nb #303030 -nf #909090 -sb #909090 -sf #303030'
fi

if (( $+commands[mpc] )); then
  export MPD_HOST=192.168.0.5
  export MPD_PORT=6600
fi

if (( $+commands[less] )); then
  export PAGER=less

  export LESS=-R # use -X to avoid sending terminal initialization
  export LESS_TERMCAP_mb=$'\e[01;31m'
  export LESS_TERMCAP_md=$'\e[01;31m'
  export LESS_TERMCAP_me=$'\e[0m'
  export LESS_TERMCAP_se=$'\e[0m'
  export LESS_TERMCAP_so=$'\e[01;44;33m'
  export LESS_TERMCAP_ue=$'\e[0m'
  export LESS_TERMCAP_us=$'\e[01;32m'
fi

unset -f _have
unset -f _source
unset -f _add_to_path
