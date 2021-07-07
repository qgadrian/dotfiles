#! /bin/bash

echo "Install Jira"

brew install go-jira

mkdir -p ~/.jira.d/

ln -sf $(pwd)/jira/config.yml ~/.jira.d/config.yml

echo "Install git-new"

ln -sf $(pwd)/jira/git-new /usr/local/bin/git-new
