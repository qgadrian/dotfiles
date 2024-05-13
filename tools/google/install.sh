# Install Google meet tool to avoid the painful process of creating a meeting
# this installs google client library
#
# You will need a Google Cloud project with access to the Calendar API and
# generate a service account credentials
# JSON file to use this tool.
#
# To use the tool, just run `tools/google/linkgen.py` and copy the generated
# meeting id
#
# The script is shlightly modified to work with the current project structure
# Kudos to the original author: https://github.com/rusty-electron/gmeet-linkgen
read -p "Install the Google Meet API tool (to automate meetings creation)? " -n 1 -r; echo
  if [[ $REPLY =~ ^[Cc]$ ]]; then
    pip install --upgrade google-api-python-client google-auth-httplib2 google-auth-oauthlib
fi
