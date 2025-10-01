cd /root

nano soal_5.sh


#!/bin/bash
# Soal 5 - Konfigurasi FTP Server Eru

apt update
apt install -y vsftpd

systemctl enable vsftpd
systemctl start vsftpd

echo "FTP server berhasil diaktifkan"
