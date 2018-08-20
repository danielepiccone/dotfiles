echo "Tested on Ubuntu 16.04"
sudo apt-get install fprintd libpam-fprintd
echo "Enrolling fingerprint for user `whoami`"
fprintd-enroll
