export PATH=/opt/homebrew/bin:$PATH
source "$(brew --prefix)/etc/profile.d/z.sh"

# clone antidote if necessary
if ! [[ -e ${ZDOTDIR:-~}/.antidote ]]; then
  git clone https://github.com/mattmc3/antidote.git ${ZDOTDIR:-~}/.antidote
fi

# source antidote and load plugins from `${ZDOTDIR:-~}/.zsh_plugins.txt`
source ${ZDOTDIR:-~}/.antidote/antidote.zsh
antidote load


autoload -Uz promptinit
promptinit
prompt adam2 

path+=('/Users/oleeskild/code/scripts')
path+=('/Users/oleeskild/.local/bin')
path+=('/Users/oleeskild/.local/bin/netcoredbg/bin')
export PATH


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
#__conda_setup="$('/Users/oleeskild/opt/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
#if [ $? -eq 0 ]; then
#    eval "$__conda_setup"
#else
#    if [ -f "/Users/oleeskild/opt/anaconda3/etc/profile.d/conda.sh" ]; then
#        . "/Users/oleeskild/opt/anaconda3/etc/profile.d/conda.sh"
#    else
#        export PATH="/Users/oleeskild/opt/anaconda3/bin:$PATH"
#    fi
#fi
#unset __conda_setup
# <<< conda initialize <<<


export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

#eval "$(github-copilot-cli alias -- "$0")"
export PATH=$PATH:/Users/oleeskild/.spicetify

# bun completions
[ -s "/Users/oleeskild/.bun/_bun" ] && source "/Users/oleeskild/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

export PATH="/usr/local/opt/python/libexec/bin:$PATH"
export PATH="/opt/homebrew/sbin:$PATH"
alias python='python3'
export OPENAI_API_KEY='{{OPENAI_API_KEY}}'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/oleeskild/.cache/lm-studio/bin"
if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
  #eval "$(oh-my-posh init zsh --config https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/refs/heads/main/themes/negligible.omp.json)"
fi

export PATH="/opt/arm-gnu-toolchain/bin:$PATH"

export STM32_PRG_PATH=/Applications/STMicroelectronics/STM32Cube/STM32CubeProgrammer/STM32CubeProgrammer.app/Contents/MacOs/bin
#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
export PATH="/opt/homebrew/opt/postgresql@17/bin:$PATH"
export GEMINI_API_KEY="{{GEMINI_API_KEY}}"
export GEMINI_MODEL="gemini-2.5-pro"
alias breath='zenta now --quick'
alias breath='zenta now --quick'
alias reflect='zenta reflect'
alias breathe='zenta now'
alias ai="claude --dangerously-skip-permissions"
#export OPENAI_BASE_URL="http://cuzco:11434/v1"
#export OPENAI_MODEL="hf.co/unsloth/Qwen3-30B-A3B-Instruct-2507-GGUF:UD-Q4_K_XL"

alias n="nvim"
alias s="TERM=xterm-256color spotify_player"
