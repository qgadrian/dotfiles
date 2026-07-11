read -p "Install ai LLM related tools (ollama)? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  brew install --cask ollamac
  brew install ollama

  # ollama serve
  # ollama run llama2
  # ollama run llama2-uncensored
fi

# ai diffusion related tools (automatic1111)?
#
# git clone git@github.com:AUTOMATIC1111/stable-diffusion-webui.git
# brew install cmake protobuf wget
# asdf local python 3.10.9
# pip3 install virtualenv
# ./webui.sh

########
# vibe code
brew install pipx
pipx install files-to-prompt

########
# Claude Code with DeepSeek
mkdir -p "$HOME/.local/bin"
chmod +x "$(pwd)/ai/deepseekcode"
ln -sf "$(pwd)/ai/deepseekcode" "$HOME/.local/bin/deepseekcode"

########
# Claude Code: status line
source ./ai/claude/install.sh

########
# Claude Code: claudio (interactive agent/model/effort picker)
mkdir -p "$HOME/.local/bin"
chmod +x "$(pwd)/ai/claudio.sh"
ln -sf "$(pwd)/ai/claudio.sh" "$HOME/.local/bin/claudio"
