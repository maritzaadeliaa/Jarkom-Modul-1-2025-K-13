# Jarkom-Modul-1-2025-K-13

| Nama                   | NRP        |
|-------------------------|------------|
| Maritza Adelia Sucipto | 5027241111 |
| Ahmad Rabbani Fata     | 5027241046 |

## Soal 1 - 13

### Soal 1
Untuk mempersiapkan pembuatan entitas selain mereka, Eru yang berperan sebagai Router membuat dua Switch/Gateway. Dimana Switch 1 akan menuju ke dua Ainur yaitu Melkor dan Manwe. Sedangkan Switch 2 akan menuju ke dua Ainur lainnya yaitu Varda dan Ulmo. Keempat Ainur tersebut diberi perintah oleh Eru untuk menjadi Client.

![1](assets/1.jpg)

### Soal 2
Karena menurut Eru pada saat itu Arda (Bumi) masih terisolasi dengan dunia luar, maka buat agar Eru dapat tersambung ke internet

`
auto eth0
iface eth0 inet dhcp
`

![2](assets/2.jpg)


konfigurasi diatas digunakan untuk menghubungkan Eru dengan internet

### Soal 3
Sekarang pastikan agar setiap Ainur (Client) dapat terhubung satu sama lain.

`
auto eth1                   
iface eth1 inet static
	address 10.70.1.1
	netmask 255.255.255.0
`

![2](assets/2.jpg)


config diatas digunakan untuk menghubungkan Eru dengan switch 1

`
auto eth2                   
iface eth2 inet static
	address 10.70.2.1
	netmask 255.255.255.0
`

![2](assets/2.jpg)


config diatas digunakan untuk menghubungkan Eru dengan switch 2

`
auto eth0                  
iface eth0 inet static
	address 10.70.1.2
	netmask 255.255.255.0
	gateway 10.70.1.1
`

![3](assets/3.jpg)


config diatas digunakan untuk menghubungkan switch 1 dengan Melkor

`
auto eth0                   
iface eth0 inet static
	Address 10.70.1.3
	netmask 255.255.255.0
	gateway 10.70.1.1
`

![3a](assets/3a.jpg)


config diatas digunakan untuk menghubungkan switch 1 dengan Manwe

`
auto eth0                   
iface eth0 inet static
	address 10.70.2.2
	netmask 255.255.255.0
	gateway 10.70.2.1
 `

![3b](assets/3b.jpg)

 
config diatas digunakan untuk menghubungkan switch 2 dengan Varda

`
auto eth0                   
iface eth0 inet static
	Address 10.70.2.3
	netmask 255.255.255.0
	Gateway 10.70.2.1
 `

![3c](assets/3c.jpg)

 
config diatas digunakan untuk menghubungkan switch 2 dengan Ulmo

### Soal 4
Setelah berhasil terhubung, sekarang Eru ingin agar setiap Ainur (Client) dapat mandiri. Oleh karena itu pastikan agar setiap Client dapat tersambung ke internet.

`
apt update && apt install  iptables -y
`

menginstall iptables supaya bisa mengkonfigurasi NAT

`
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s10.70.0.0/16
`

Membuat Eru menjadi gateway jaringan internet

`
cat /etc/resolv.conf
`

digunakan untuk mengecek ip di config resolve

`
Echo nameserver [IP] > /etc/resolv.conf
`

digunakan supaya ip di config resolve bisa terbaca oleh client (dilakukan untuk semua client)

![4](assets/4.jpg)
ping google Eru


![4a](assets/4a.jpg)
ping google Melkor


![4b](assets/4b.jpg)
ping google Manwe


![4c](assets/4c.jpg)
ping google Varda


![4d](assets/4d.jpg)
ping google Ulmo


### Soal 5
Ainur terkuat Melkor tetap berusaha untuk menanamkan kejahatan ke dalam Arda (Bumi). Sebelum terjadi kerusakan, Eru dan para Ainur lainnya meminta agar semua konfigurasi tidak hilang saat semua node di restart.

supaya konfigurasi tidak hilang ketika di restart, konfigurasi bisa disimpan di /root/ sebelum keluar dari project sehingga tidak reset

### Soal 6
Setelah semua Ainur terhubung ke internet, Melkor mencoba menyusup ke dalam komunikasi antara Manwe dan Eru. Jalankan file berikut (link file) lalu lakukan packet sniffing menggunakan Wireshark pada koneksi antara Manwe dan Eru, lalu terapkan display filter untuk menampilkan semua paket yang berasal dari atau menuju ke IP Address Manwe. Simpan hasil capture tersebut sebagai bukti.

Letakkan traffic.sh di node manwe lalu jalankan

`
./traffic.sh
`

Lalu capture paket di manwe menggunakan tcpdump

`
tcpdump -i eth0 -n -w /root/manwe_eru_traffic.pcap host [ip]
`

yang nanti hasilnya bisa di akses di

`
/root/manwe_eru_traffic.pcap
`

dan bisa dicek menggunakan

`
ls -lh /root/manwe_eru_traffic.pcap
tcpdump -r /root/manwe_eru_traffic.pcap -n | head
`


### Soal 7
Untuk meningkatkan keamanan, Eru memutuskan untuk membuat sebuah FTP Server di node miliknya. Lakukan konfigurasi FTP Server pada node Eru. Buat dua user baru: ainur dengan hak akses write&read dan melkor tanpa hak akses sama sekali ke direktori shared. Buktikan hasil tersebut dengan membuat file teks sederhana kemudian akses file tersebut menggunakan kedua user.

`
apt update
apt install vsftpd -y
`
install vsftpd

`
cat > /etc/vsftpd.conf <<'EOF'
listen=YES
anonymous_enable=NO
local_enable=YES
write_enable=YES
chroot_local_user=YES
allow_writeable_chroot=YES
EOF
`

Konfigurasi ftp supaya hanya user lokal yang bisa login, dan mereka hanya bisa mengakses folder sendiri.

`
useradd -m -s /bin/bash ainur
echo "ainur:ainurpw" | chpasswd
`

Membuat user sistem bernama ainur, memberikan shell login, menetapkan password ainurpw dan otomatis membuat /home/ainur

`
mkdir -p /home/ainur/shared
chown -R ainur:ainur /home/ainur/shared
chmod 755 /home/ainur/shared
`

Membuat folder /home/ainur/shared sebagai tempat upload dan memberi izin hanya untuk user ainur

### Soal 8
Ulmo, sebagai penjaga perairan, perlu mengirimkan data ramalan cuaca ke node Eru. Lakukan koneksi sebagai client dari node Ulmo ke FTP Server Eru menggunakan user ainur. Upload sebuah file berikut (link file). Analisis proses ini menggunakan Wireshark dan identifikasi perintah FTP yang digunakan untuk proses upload.

Jalankan Wireshark di Node Eru, pilih interface eth0, klik Start Capturing untuk mulai menangkap paket. Ini dilakukan untuk menangkap semua paket ftp yang dikirim dari client Ulmo ke server Eru.

akses filezilla dan masukkan kredensial 

`
Host: [ip]
Username: ainur
Password: ainurpw
Port: [port]
`

Selanjutnya, pilih file cuaca.txt & mendung.jpg dari _local_ menuju _remote_ dan setelah itu stop capture wireshark dan simpan di /root/ftp_upload_ulmo.pcap

### Soal 9
Eru ingin membagikan "Kitab Penciptaan" di (link file) kepada Manwe. Dari FTP Server Eru, download file tersebut ke node Manwe. Karena Eru merasa Kitab tersebut sangat penting maka ia mengubah akses user ainur menjadi read-only. Gunakan Wireshark untuk memonitor koneksi, identifikasi perintah FTP yang digunakan, dan uji akses user ainur.

`
cp /root/kitab_penciptaan.txt /home/ainur/shared/
chown ainur:ainur /home/ainur/shared/kitab_penciptaan.txt
`

simpan file kitab_penciptaan.txt ke dalam folder user ainur

Jalankan Wireshark di Node Eru, pilih interface eth0, klik Start Capturing untuk mulai menangkap paket. Ini dilakukan untuk menangkap semua paket ftp yang dikirim dari client Manwe ke server Eru.

akses filezilla dan masukkan kredensial 

`
Host: [ip]
Username: ainur
Password: ainurpw
Port: [port]
`

selanjutnya, download kitab_penciptaan.txt dari remote menuju local dan setelah itu stop capture wireshark dan simpan di /root/ftp_upload_ulmo.pcap


## Soal 14 - 20
> untuk soal 14 - 20, kita perlu mendownload file zip yang diberikan kemudian membuka file pcapng(wireshark) dan di terminal ketik nc sesuai yang diberikan di soal
> 
### Soal 14
Setelah gagal mengakses FTP, Melkor melancarkan serangan brute force terhadap  Manwe. Analisis file capture yang disediakan dan identifikasi upaya brute force Melkor. nc 10.15.43.32 3401
![14](assets/14.png)
### a. How many packets are recorded in the pcapng file?
```bash
500358
```
 lihat jumlah paket di bagian bawah kanan di wireshark
 ![14a](assets/14a.png)
 ### b. What are the user that successfully logged in?
```bash 
n1enna:y4v4nn4_k3m3nt4r1
```
display filter ```frame contains “success”``` untuk menemukan user yang berhasil log in, akan muncul 1 packet, klik kanan packet -> **follow -> TCP stream**. Maka akan terlihat username dan juga passwordnya
![14b](assets/14b.png)

### c. In which stream were the credentials found?
```bash 
41824
```
lihat dipojok kanan bawah atau setelah close TCP stream akan muncul di display filter untuk streamnya 

![14c](assets/14c.png)
### d. What tools are used for brute force?
```bash 
Fuzz Faster U Fool v2.1.0-dev
```
lihat di TCP stream di bagian User-Agent (baris ke 3) 

setelah menyelesaikan semua pertanyaan kita akan mendapatkan flag:
```bash 
KOMJAR25{Brut3_F0rc3_k29eoD0KSbaBG9ZMd005q909j}
```

### Soal 15
Melkor menyusup ke ruang server dan memasang keyboard USB berbahaya pada node Manwe. Buka file capture dan identifikasi pesan atau ketikan (keystrokes) yang berhasil dicuri oleh Melkor untuk menemukan password rahasia. nc 10.15.43.32 3402

![15](assets/15.png)

### a. What device does Melkor use?
 ```bash 
Keyboard
```
cek packetnya dan di bagian interface descriptor, tertulis bInterfaceProtocol: Keyboard (0x01) atau dari soal juga dijelaskan USB Keyboard
![15a](assets/15a.png)

### b. What did Melkor write?
 ```bash 
UGx6X3ByMHYxZGVfeTB1cl91czNybjRtZV80bmRfcDRzc3cwcmQ=
```
buat file hiddata.py, yang berisikan code ini:
```bash
#!/usr/bin/env python3

# USB HID Keyboard scan codes
hid_map = {
    0x04: 'a', 0x05: 'b', 0x06: 'c', 0x07: 'd', 0x08: 'e', 0x09: 'f', 0x0a: 'g', 0x0b: 'h',
    0x0c: 'i', 0x0d: 'j', 0x0e: 'k', 0x0f: 'l', 0x10: 'm', 0x11: 'n', 0x12: 'o', 0x13: 'p',
    0x14: 'q', 0x15: 'r', 0x16: 's', 0x17: 't', 0x18: 'u', 0x19: 'v', 0x1a: 'w', 0x1b: 'x',
    0x1c: 'y', 0x1d: 'z', 0x1e: '1', 0x1f: '2', 0x20: '3', 0x21: '4', 0x22: '5', 0x23: '6',
    0x24: '7', 0x25: '8', 0x26: '9', 0x27: '0',
    0x28: '\n', 0x2c: ' ', 0x2d: '-', 0x2e: '=', 0x2f: '[', 0x30: ']', 0x33: ';', 0x34: "'",
    0x36: ',', 0x37: '.', 0x38: '/', 0x2a: 'Backspace', 0x31: '\\'
}

shift_map = {
    0x04: 'A', 0x05: 'B', 0x06: 'C', 0x07: 'D', 0x08: 'E', 0x09: 'F', 0x0a: 'G', 0x0b: 'H',
    0x0c: 'I', 0x0d: 'J', 0x0e: 'K', 0x0f: 'L', 0x10: 'M', 0x11: 'N', 0x12: 'O', 0x13: 'P',
    0x14: 'Q', 0x15: 'R', 0x16: 'S', 0x17: 'T', 0x18: 'U', 0x19: 'V', 0x1a: 'W', 0x1b: 'X',
    0x1c: 'Y', 0x1d: 'Z', 0x1e: '!', 0x1f: '@', 0x20: '#', 0x21: '$', 0x22: '%', 0x23: '^',
    0x24: '&', 0x25: '*', 0x26: '(', 0x27: ')', 0x2d: '_', 0x2e: '+', 0x2f: '{', 0x30: '}',
    0x33: ':', 0x34: '"', 0x36: '<', 0x37: '>', 0x38: '?', 0x31: '|'
}

def decode_keystrokes(filename):
    """Decode USB HID keystrokes from file"""
    try:
        with open(filename, 'r') as f:
            lines = f.readlines()
    except FileNotFoundError:
        print(f"File {filename} tidak ditemukan!")
        return
    
    output = ""
    
    for line in lines:
        line = line.strip()
        if not line:
            continue
            
        # Format: 8 byte hex string (contoh: "00001e0000000000")
        if len(line) == 16:  # 16 karakter hex = 8 byte
            try:
                # Parse bytes
                bytes_data = [int(line[i:i+2], 16) for i in range(0, 16, 2)]
                
                modifier = bytes_data[0]  # Byte 1: Modifier
                keycode = bytes_data[2]   # Byte 3: Keycode
                
                # Skip jika keycode = 0 (no key pressed)
                if keycode == 0:
                    continue
                
                # Decode berdasarkan modifier
                if modifier == 0x02 or modifier == 0x20:  # Shift
                    if keycode in shift_map:
                        output += shift_map[keycode]
                    else:
                        output += f'[Shift+{keycode:02x}]'
                else:
                    if keycode in hid_map:
                        output += hid_map[keycode]
                    else:
                        output += f'[{keycode:02x}]'
                        
            except ValueError:
                continue
    
    return output

def main():
    
    # File dari output tshark Anda
    filename = "keystroke.txt"
    
    decoded = decode_keystrokes(filename)
    
    print(decoded)

if __name__ == "__main__":
    main()
```
gunakan command:
```
tshark -r <namafile.pcapng> -Y "usb.capdata" -T fields -e usb.capdata | tr -d : > keystroke.txt
```
lalu jalankan:
```
python3 hiddata.py
```

### c. What is Melkor's secret message?
 ```bash 
Plz_pr0v1de_y0ur_us3rn4me_4nd_p4ssw0rd
```
gunakan command: 
```
echo "UGx6X3ByMHYxZGVfeTB1cl91czNybjRtZV80bmRfcDRzc3cwcmQ=" | base64 -d
```
![15abc](assets/15abc.png)

### Soal 16
Melkor semakin murka ia meletakkan file berbahaya di server milik Manwe. Dari file capture yang ada, identifikasi file apa yang diletakkan oleh Melkor. nc 10.15.43.32 3403
![16](assets/16.png)
### a. What credential did the attacker use to log in?
 ```bash 
ind@psg420.com:{6r_6e#TfT1p
```
display filter: ```frame contains "user"``` untuk mencari string "user" di seluruh bagian paket, klik salah satu packet -> **follow -> TCP stream**
di packet pertama yang saya buka, sudah ketemu user dan juga passwordnya
![16a](assets/16a.png)
### b. How many files are suspected of containing malware?
```bash 
5
```
jenis file malware yang paling umum adalah .exe, maka kita hitung ada berapa file .exe di TCP stream. Totalnya ada 5 malware (5 file .exe)

### c. What is the hash of the first file (q.exe)?
```bash 
ca34b0926cdc3242bbfad1c4a0b42cc2750d90db9a272d92cfb6cb7034d2a3bd
```

### d. What is the hash of the second file (w.exe)?
```bash 
08eb941447078ef2c6ad8d91bb2f52256c09657ecd3d5344023edccf7291e9fc
```

### e. What is the hash of the third file (e.exe)?
```bash 
32e1b3732cd779af1bf7730d0ec8a7a87a084319f6a0870dc7362a15ddbd3199
```

### f. What is the hash of the fourth file (r.exe)?
```bash 
4ebd58007ee933a0a8348aee2922904a7110b7fb6a316b1c7fb2c6677e613884
```
### g. What is the hash of the fifth file (t.exe)?
```bash 
10ce4b79180a2ddd924fdc95951d968191af2ee3b7dfc96dd6a5714dbeae613a
```

untuk soal 16c - 16g download file .exe dalam format **raw**
gunakan filter 
```
_ws.col.info contains "<namafile>"
```
pindahkan ke linux, kemudian buka terminal baru dan masuk ke folder tempat file tersebut
command: ```sha256sum <namafile>```
![16hash](assets/16hash.png)
setelah menyelesaikan semua pertanyaan kita akan mendapatkan flag:
```bash 
KOMJAR25{Y0u_4r3_4_g00d_4nalyz3r_IfdYDdJncH98aj75bbRW9Uv06}
```


### Soal 17
Manwe membuat halaman web di node-nya yang menampilkan gambar cincin agung. Melkor yang melihat web tersebut merasa iri sehingga ia meletakkan file berbahaya agar web tersebut dapat dianggap menyebarkan malware oleh Eru. Analisis file capture untuk menggagalkan rencana Melkor dan menyelamatkan web Manwe.
![17](assets/17.png)
### a. What is the name of the first suspicious file?
```bash 
Invoice&MSO-Request.doc
```
 klik **file -> export objects -> HTTP** karena protokol network yang paling umum untuk Malware adalah HTTP
 muncul 3 file, tapi karena yang memiliki high risk sebagai malware adalah application untuk file pertama kita pakai yang **Invoice&MSO-Request.doc**
 ![17a](assets/17a.png)
 ### b. What is the name of the second suspicious file?
 ```bash 
knr.exe
```
sama seperti soal sebelumnya, kali ini gunakan file terakhir

### c. What is the hash of the second suspicious file (knr.exe)?
```bash 
749e161661290e8a2d190b1a66469744127bc25bf46e5d0c6f2e835f4b92db18
```
untuk menemukan file hashnya sama seperti di nomor sebelumnya

setelah menyelesaikan semua pertanyaan kita akan mendapatkan flag:
 ```bash 
 KOMJAR25{M4ster_4n4lyzer_pyvb1CJH85GbmPe6K5wx1E0TT}
```

 
### Soal 18
Karena rencana Melkor yang terus gagal, ia akhirnya berhenti sejenak untuk berpikir. Pada saat berpikir ia akhirnya memutuskan untuk membuat rencana jahat lainnya dengan meletakkan file berbahaya lagi tetapi dengan metode yang berbeda. Gagalkan lagi rencana Melkor dengan mengidentifikasi file capture yang disediakan agar dunia tetap aman. (link file) nc 10.15.43.32 3405
![18](assets/18.png)
### a. How many files are suspected of containing malware?
```bash 
2
```
 karena dijelaskan di soal kalau menggunakan metode yang berbeda (selain HTTP), cek object list yang lain, dan yang muncul file hanya SMB. Lihat file yang .exe saja
 ![18a](assets/18a.png)
 ### b. What is the name of the first malicious file?
 ```bash 
d0p2nc6ka3f_fixhohlycj4ovqfcy_smchzo_ub83urjpphrwahjwhv_o5c0fvf6.exe
```
lihat nama filenya di bagian filename

### c. Apa nama file berbahaya yang kedua?
```bash 
oiku9bu68cxqenfmcsos2aek6t07_guuisgxhllixv8dx2eemqddnhyh46l8n_di.exe
```

### d. What is the hash of the first malicious file?
```bash 
59896ae5f3edcb999243c7bfdc0b17eb7fe28f3a66259d797386ea470c010040
```
### e. What is the hash of the second malicious file?
```bash 
cf99990bee6c378cbf56239b3cc88276eec348d82740f84e9d5c343751f82560
```
untuk menemukan file hashnya sama seperti sebelumnya
 ![18hash](assets/18hash.png)

setelah menyelesaikan semua pertanyaan kita akan mendapatkan flag:
```bash 
KOMJAR25{Y0u_4re_g0dl1ke_FWeYgdADqZRzVM7cBZ3KdGKEu}
```

### Soal 19
Manwe mengirimkan email berisi surat cinta kepada Varda melalui koneksi yang tidak terenkripsi. Melihat hal itu Melkor sipaling jahat langsung melancarkan aksinya yaitu meneror Varda dengan email yang disamarkan. Analisis file capture jaringan dan gagalkan lagi rencana busuk Melkor. nc 10.15.43.32 3406
 ![19](assets/19.png)
### a. Who sent the threatening message?
```bash 
Your Life
```
 Display filter: ```smtp``` Klik kanan -> **follow -> TCP stream**
 karena SMTP menangani pengiriman pesan di jaringan
 ![19a](assets/19a.png)
 
 ### b. How much ransom did the attacker demand ($)?
 ```bash 
1600
```
Kita bisa mencari jawabannya dengan membaca pesannya
 ![19b](assets/19b.png)
### c. What is the attacker's bitcoin wallet?
```bash 
1CWHmuF8dHt7HBGx5RKKLgg9QA2GmE3UyL
```
oiku9bu68cxqenfmcsos2aek6t07_guuisgxhllixv8dx2eemqddnhyh46l8n_di.exe
Kita bisa mencari jawabannya dengan membaca pesannya
 ![19c](assets/19c.png)
 
setelah menyelesaikan semua pertanyaan kita akan mendapatkan flag:
```bash 
KOMJAR25{Y0u_4re_J4rk0m_G0d_YNMPF5MYCP70wlgyVVIfvmHaE}
```

### Soal 20
Untuk yang terakhir kalinya, rencana besar Melkor yaitu menanamkan sebuah file berbahaya kemudian menyembunyikannya agar tidak terlihat oleh Eru. Tetapi Manwë yang sudah merasakan adanya niat jahat dari Melkor, ia menyisipkan bantuan untuk mengungkapkan rencana Melkor. Analisis file capture dan identifikasi kegunaan bantuan yang diberikan oleh Manwë untuk menggagalkan rencana jahat Melkor selamanya. nc 10.15.43.32 3407
 ![20](assets/20.png)

### a. What encryption method is used?
```bash 
TLS
```
**statistics -> Protocol Hierarchy ** terlihat TLS dengan Percent Bytes paling besar

 ### b. What is the name of the malicious file placed by the attacker?
 ```bash 
invest_20.dll
```
di soal ini diberikan file txt, sehingga kita masukkan filenya dengan cara **Edit -> Preferences -> Protocol -> TLS** lalu tambahkan filenya
cara mencari filenya yaitu **file -> export objects -> HTTP** (cari file application dengan ekstensi)

### c. What is the hash of the file containing the malware?
```bash 
31cf42b2a7c5c558f44cfc67684cc344c17d4946d3a1e0b2cecb8eb58173cb2f
```
 ![20c](assets/20c.png)
 
setelah menyelesaikan semua pertanyaan kita akan mendapatkan flag:
```bash 
KOMJAR25{B3ware_0f_M4lw4re_kymFRy5FM3N2vd6FCSthfl99E}
```
