#! /bin/bash

echo "Install Jira"

brew install go-jira

mkdir -p ~/.jira.d/

ln -sf $(pwd)/config.yml ~/.jira.d/config.yml

