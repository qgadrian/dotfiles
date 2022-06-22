echo "Install PAM plugin for Touch ID"

# Credits: https://sixcolors.com/post/2020/11/quick-tip-enable-touch-id-for-sudo/

sudo sed -i '' '3i\'$'\nauth\tsufficient\t\pam_tid.so\n' /etc/pam.d/sudo
