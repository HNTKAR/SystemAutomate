# ファイルの配置
各osのインストール用isoファイルの名称は以下の通りとする。
|OS名|iso名|
|:---:|:---:|
|CentOS|centos.iso|
|ubuntu|ubuntu.iso|
|WindowsPE|windows.iso|
```
/home/data/
├── http
│   ├── 404.html
│   ├── 50x.html
│   ├── icons
│   │   └── poweredby.png
│   ├── index.html
│   ├── nginx-logo.png
│   ├── poweredby.png
│   └── test.txt
├── iso
│   ├── centos
│   │   ├── .discinfo
│   │   ├── EFI
│   │   ├── LICENSE
│   │   ├── images
│   │   └── isolinux
│   ├── centos.iso
│   ├── ubuntu
│   │   ├── .disk
│   │   ├── EFI
│   │   ├── boot
│   │   ├── boot.catalog
│   │   ├── casper
│   │   ├── dists
│   │   ├── install
│   │   ├── md5sum.txt
│   │   ├── pool
│   │   ├── preseed
│   │   └── ubuntu -> .
│   └── ubuntu.iso
├── nfs
│   ├── centos
│   │   ├── .discinfo
│   │   ├── EFI
│   │   ├── LICENSE
│   │   ├── images
│   │   └── isolinux
│   └── ubuntu
│       ├── .disk
│       ├── EFI
│       ├── boot
│       ├── boot.catalog
│       ├── casper
│       ├── dists
│       ├── install
│       ├── md5sum.txt
│       ├── pool
│       ├── preseed
│       └── ubuntu -> .
└── tftp
    ├── BOOTX64.EFI
    ├── centos
    │   ├── initrd.img
    │   └── vmlinuz
    ├── fonts
    │   └── unicode.pf2
    ├── grub.cfg
    ├── grubx64.efi
    ├── mmx64.efi
    └── ubuntu
        ├── filesystem.manifest
        ├── filesystem.manifest-minimal-remove
        ├── filesystem.manifest-remove
        ├── filesystem.size
        ├── filesystem.squashfs
        ├── filesystem.squashfs.gpg
        ├── initrd
        └── vmlinuz
```