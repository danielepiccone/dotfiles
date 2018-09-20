echo "Installing deps..."
sudo apt-get install fprintd libpam-fprintd
echo "Registering fingerprint for user `whoami`.."
fprintd-enroll

sudo pam-auth-update
