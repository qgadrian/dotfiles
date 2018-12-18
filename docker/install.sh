echo "Install Docker"

brew cask install docker

# docker alias to remove stopped containers
# docker rm -v $(docker ps -a -q -f status=exited)

# docker alias to stop all containers
# docker stop $(docker ps -a -q)

# stop all exited or dead containers
# docker ps --filter status=dead --filter status=exited -aq | xargs docker rm -v

# remove images
# docker rmi $(docker images |grep '<none>')
