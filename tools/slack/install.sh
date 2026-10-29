echo "Setup Slack client"

ln -sfn $(pwd)/tools/slack/slackfred ~/.bin/slackfred

current_folder=$(pwd)
cd ~/.bin/slackfred
yarn install
cd $current_folder
