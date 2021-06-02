echo "Install PAM plugin for Apple watch"

git clone git@github.com:biscuitehh/pam-watchid.git

sudo make install

sudo sed -i '2s/^/auth sufficient pam_watchid.so "reason=execute a command as root" /' /etc/pam.d/sudo

rm -rf pam-watchid

#
# Reference steps:
#
# sudo su -
# vim /etc/pam.d/sudo
# add to the first line `auth sufficient pam_watchid.so "reason=execute a command as root"`
