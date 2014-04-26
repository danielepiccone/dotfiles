# Dotfiles

deploy in ~/dotfiles

run ./link.sh to propagate settings

# Xubuntu specific

### Install Adobe reader
manually
 
### Install Adobe flash

sudo apt-get install flashplugin-installer

### Install Adobe air
http://askubuntu.com/questions/87447/how-can-i-install-adobe-air

**64 bit**

http://www.tkalin.com/blog_posts/installing-adobe-air-and-elance-tracker-on-ubuntu-13-10-saucy-salamander-64-bit

wget http://airdownload.adobe.com/air/lin/download/2.6/AdobeAIRInstaller.bin

chmod +x AdobeAIRInstaller.bin
 
locate libgnome-keyring.so
 
sudo ln -s /usr/lib/i386-linux-gnu/libgnome-keyring.so.0 /usr/lib/libgnome-keyring.so.0

sudo ln -s /usr/lib/i386-linux-gnu/libgnome-keyring.so.0.2.0 /usr/lib/libgnome-keyring.so.0.2.0
 
sudo rm /usr/lib/libgnome-keyring.so.0

sudo rm /usr/lib/libgnome-keyring.so.0.2.0

### Install Oracle Java 6/7
http://askubuntu.com/questions/56104/how-can-i-install-sun-oracles-proprietary-java-6-7-jre-or-jdk

http://xubuntugeek.blogspot.dk/2012/05/install-oracle-java-7-in-xubuntu-1204.html

sudo add-apt-repository ppa:webupd8team/java -y

sudo apt-get update

sudo apt-get install oracle-java7-installer

### Mount folders with CurlFTPfs
 
mount_fftp.sh:

curlftpfs -o allow_other,disable_epsv,ftp_port=-,skip_pasv_ip,user=$1 ftp://$2 ./ftp/$2

### Install Ctags

sudo apt-get install exuberant-ctags
