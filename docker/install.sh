echo "Install Docker"

brew cask install docker

# docker alias to remove stopped containers
# docker rm -v $(docker ps -a -q -f status=exited)
