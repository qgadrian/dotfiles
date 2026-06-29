# repo: https://github.com/jundot/omlx#install

brew tap jundot/omlx https://github.com/jundot/omlx
brew install omlx

# Run as a background service (auto-restarts on crash)
brew services start omlx

# Optional: MCP (Model Context Protocol) support
/opt/homebrew/opt/omlx/libexec/bin/pip install mcp
