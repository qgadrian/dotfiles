# dotfiles

## Description

Collection of scripts that will automate the setup of a fresh workstation.

## Prerequisites

* Install git with `xcode-select --install`
* Setup git [following these instructions](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)

## Usage

> You can either comment/uncomment the tools to be installed in the entrypoint
> file `./install.sh` or install one by one manually using each tools directory.

run `./install.sh`

## DISCLAIMER

This project is intended to **work only with macOS** and is using my own
personal preferences, therefore it should be used as a template or suggestion.

## Useful stuff in this repo

This is the listing of every day stuff that I use and no longer can live
without.

### Kubernetes aliases

There are aliases to prompt a filterable list of pods to execute  console, list
logs, etc...

Available at `./zsh/profiles/kubernetes`

### GitHub aliases

Besides the personal custom git alises, at `./zsh/profiles/git` you can find
alises to trigger GitHub workflow executions from the console.
