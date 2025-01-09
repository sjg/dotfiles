export BASH_SILENCE_DEPRECATION_WARNING=1
export PATH=$PWD/flutter/bin:$PATH
if [ -f $(brew --prefix)/etc/bash_completion ]; then source $(brew --prefix)/etc/bash_completion; fi
# [ -f ~/.fzf.bash ] && source ~/.fzf.bash

if [ -f `brew --prefix`/etc/bash_completion ]; then
  . `brew --prefix`/etc/bash_completion
fi
