echo "Setup Slack client"

ln -sf $(pwd)/tools/slack/slackfred ~/.bin/slackfred

current_folder=$(pwd)
cd ~/.bin/slackfred
yarn install
cd $current_folder
