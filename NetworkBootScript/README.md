# ファイルの配置
```
/home/data/
├── nfs
│   └── ubuntu
│       ├── preseed
│       └── isoの中身
└── tftp
    ├── bootx64.efi
    ├── centos
    │   ├── boot.cat
    │   ├── boot.msg
    │   ├── grub.conf
    │   ├── initrd.img
    │   ├── isolinux.bin
    │   ├── isolinux.cfg
    │   ├── ldlinux.c32
    │   ├── libcom32.c32
    │   ├── libutil.c32
    │   ├── memtest
    │   ├── splash.png
    │   ├── vesamenu.c32
    │   └── vmlinuz
    ├── grub
    │   ├── fonts
    │   ├── grub.cfg
    │   ├── i386-pc
    │   ├── loopback.cfg
    │   └── x86_64-efi
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