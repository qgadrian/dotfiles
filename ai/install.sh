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
