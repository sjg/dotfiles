#
# .zshrc
#
# @author Steven Gray
# Based on the .zshrc file by Jeff Geerling.

# Colors.
unset LSCOLORS
export CLICOLOR=1
export CLICOLOR_FORCE=1

# Don't require escaping globbing characters in zsh.
unsetopt nomatch

# Nicer prompt.
export PS1=$'\n'"%F{green} %*%F %3~ %F{white}"$'\n'"$ "

# Enable plugins.
plugins=(git brew history kubectl history-substring-search)

# Custom $PATH with extra locations.
export PATH=$HOME/Library/Python/3.9/bin:/opt/homebrew/bin:/usr/local/bin:/usr/local/sbin:$HOME/bin:$HOME/go/bin:$HOME/.cargo/bin:/usr/local/git/bin:$HOME/.composer/vendor/bin:$PATH

# Bash-style time output.
export TIMEFMT=$'\nreal\t%*E\nuser\t%*U\nsys\t%*S'

# Include alias file (if present) containing aliases for ssh, etc.
if [ -f ~/.aliases ]
then
  source ~/.aliases
fi

# Set architecture-specific brew share path.
arch_name="$(uname -m)"
if [ "${arch_name}" = "x86_64" ]; then
    share_path="/usr/local/share"
elif [ "${arch_name}" = "arm64" ]; then
    share_path="/opt/homebrew/share"
else
    echo "Unknown architecture: ${arch_name}"
fi

# Allow history search via up/down keys.
source ${share_path}/zsh-history-substring-search/zsh-history-substring-search.zsh
bindkey "^[[A" history-substring-search-up
bindkey "^[[B" history-substring-search-down

# Git aliases.
alias gs='git status'
alias gcom='git commit'
alias gp='git pull --rebase'
alias gcam='git commit -am'
alias gl='git log --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit'

# Completions.
autoload -Uz compinit && compinit
# Case insensitive.
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'

# Git upstream branch syncer.
# Usage: gsync master (checks out master, pull upstream, push origin).
function gsync() {
 if [[ ! "$1" ]] ; then
     echo "You must supply a branch."
     return 0
 fi

 BRANCHES=$(git branch --list $1)
 if [ ! "$BRANCHES" ] ; then
    echo "Branch $1 does not exist."
    return 0
 fi

 git checkout "$1" && \
 git pull upstream "$1" && \
 git push origin "$1"
}

# Tell homebrew to not autoupdate every single time I run it (just once a week).
export HOMEBREW_AUTO_UPDATE_SECS=604800

# Super useful Docker container oneshots.
# Usage: dockrun, or dockrun [centos7|fedora27|debian9|debian8|ubuntu1404|etc.]
# Run on arm64 if getting errors: `export DOCKER_DEFAULT_PLATFORM=linux/amd64`
dockrun() {
 docker run -it geerlingguy/docker-"${1:-ubuntu1604}"-ansible /bin/bash
}

# Enter a running Docker container.
function denter() {
 if [[ ! "$1" ]] ; then
     echo "You must supply a container ID or name."
     return 0
 fi

 docker exec -it $1 bash
 return 0
}

# Delete a given line number in the known_hosts file.
knownrm() {
 re='^[0-9]+$'
 if ! [[ $1 =~ $re ]] ; then
   echo "error: line number missing" >&2;
 else
   sed -i '' "$1d" ~/.ssh/known_hosts
 fi
}

# Allow Composer to use almost as much RAM as Chrome.
export COMPOSER_MEMORY_LIMIT=-1

# Setup Oh My Zsh if it's installed. (https://ohmyz.sh/)
if [ -d "$HOME/.oh-my-zsh" ]; then
    export ZSH=$HOME/.oh-my-zsh
    ZSH_THEME="robbyrussell"
    source $ZSH/oh-my-zsh.sh
    plugins=(git)
fi

# Load NVM if it's installed.
if [ -s "$HOME/.nvm/nvm.sh" ]; then
    export NVM_DIR="$HOME/.nvm"
    [ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
    [ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
    source "$NVM_DIR/nvm.sh"
fi

export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=/usr/local/share/zsh-syntax-highlighting/highlighters

source /usr/local/opt/git-extras/share/git-extras/git-extras-completion.zsh
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export GOPATH=$HOME/playground/go
export PATH=${PATH}:$GOPATH/bin

export PATH=$HOME/sdk/flutter/bin:$PATH
export PATH="$PATH":"$HOME/.pub-cache/bin"

export ANDROID_HOME=/Users/$USER/Library/Android/sdk
export PATH=${PATH}:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools

export CODELAB_SERVER=USER@SERVER

alias pg_start="launchctl load ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist"
alias pg_stop="launchctl unload ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist"

export PATH="/usr/local/opt/imagemagick@6/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
export PATH="/usr/local/Cellar/hackrf/2018.01.1/bin:$PATH"
export PATH="/usr/local/Cellar/nano/5.9/bin:$PATH"
export PATH="/Users/sjg/Library/Python/3.8/bin:$PATH"
export PATH="/Users/sjg/Library/Python/3.8/site-packages:$PATH"
export PATH="/Users/sjg/playground/go/bin:$PATH"

# 1Password CLI
eval "$(op completion zsh)"; compdef _op op

source "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"

# Ruby Fix - https://mac.install.guide/ruby/13.html
if [ -d "/usr/local/opt/ruby/bin" ]; then
  export PATH=/usr/local/opt/ruby/bin:$PATH
  export PATH=`gem environment gemdir`/bin:$PATH
fi

# youtube-dl alias
mp3 () {
    youtube-dl --ignore-errors -f bestaudio --extract-audio --audio-format mp3 --audio-quality 0 -o '%(title)s.%(ext)s' "$1"
}

mp3p () {
    youtube-dl --ignore-errors --sleep-interval 30 -i -f bestaudio --extract-audio --audio-format mp3 --audio-quality 0 -o '%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s' "$1"
}

dlv () {
    youtube-dl --ignore-errors -o '%(title)s.%(ext)s' "$1"
}

dlp () {
    youtube-dl --yes-playlist --ignore-errors --sleep-interval 30 -o '%(playlist)s/%(title)s.%(ext)s' "$1"
}

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/terraform terraform

alias l='ls -lha'
