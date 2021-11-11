# Follow :-> https://www.digitalocean.com/community/tutorials/how-to-set-up-vsftpd-for-a-user-s-directory-on-ubuntu-18-04

#!/bin/bash


# 1. Create a user Be careful here because you are creating credentials for your FTP account. Use something appropriate :)

useradd -d <ftp_path> -p <ftp_password>  -s /usr/sbin/nologin <ftp_login> 

# Part -s /usr/sbin/nologin here is for locking FTP user from accessing server by SSH.
# Now check that user is actually been created:

cat /etc/passwd | grep <ftp_login>

# You should see something like
# your_user_name:1000:1000::/path/to/shared/folder:/usr/sbin/nologin

# 2. Install vsftp (Very Secure FTP)
apt install -y vsftpd

# Check that vsftp is running:
service --status-all | grep vsftpd

#3. Check if 21 port is open
telnet <server_ip> 21 

# You can run this command either from your remote server both from your local computer. So if you don’t have telnet locally, you can execute telnet localhost 21 on your server.
# If everything is ok telnet must “hang”. If it does you probably can exit from it by pressing ctrl+enter.
# If telnet couldn’t connect to 21 port you should check your firewall rules with ufw status and iptables -L . A little help with configuring theese firewalls can be found here for ufw and here for iptables.

#4. Configure vsftp

# First, append this at the end of /etc/vsftpd.conf file:

# listen=YES
# listen_ipv6=NO
# anonymous_enable=NO
# local_enable=YES
# write_enable=YES
# chroot_local_user=YES
# allow_writeable_chroot=YES
# force_dot_files=YES
# pam_service_name=ftp

# userlist_deny=NO
# userlist_enable=YES
# userlist_file=/etc/vsftpd.userlist

# local_umask=0000
# file_open_mode=0777


# Then, create /etc/vsftpd.userlist file and put FTP username there:
echo <ftp_login> >> /etc/vsftpd.userlist

# 5. Restart vsftpd (vsftp daemon)
service vsftpd restart

#6. Set correct folders permissions
# The only option that I figured out trying to make this work is setting 755 permissions on every folder in path to your shared folder. But please don’t do it recursively except you are totally sure that you need it!
# For example, if you have path like /root/domain.ru/shared/your_directory then you need to execute this
chmod 755 /root/
chmod 755 /root/domain.ru/
chmod 755 /root/domain.ru/shared
chmod 755 /root/domain.ru/shared/your_directory

#7. Done
# You should be all set. Try to connect with your favorite FTP-client. Mine is Transmit (Mac OS only). Hope this tutorial will help you. If not please hit me in the comments, I’ll try to reply as fast as I can. ✌️