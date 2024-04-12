# warning

This script is only tested on ubuntu 22.04 LTS, and can compile linux 6.5 kernel completely. 
For anyone who is using the same os verison should be able to use the kernel I upload.


# view immou group

immou_viewer.sh
```
#!/bin/bash
shopt -s nullglob
for g in $(find /sys/kernel/iommu_groups/* -maxdepth 0 -type d | sort -V); do
    echo "IOMMU Group ${g##*/}:"
    for d in $g/devices/*; do
        echo -e "\t$(lspci -nns ${d##*/})"
    done;
done;
~         
```


```
IOMMU Group 15:
	02:00.0 USB controller [0c03]: Advanced Micro Devices, Inc. [AMD] 400 Series Chipset USB 3.1 XHCI Controller [1022:43d5] (rev 01)
	02:00.1 SATA controller [0106]: Advanced Micro Devices, Inc. [AMD] 400 Series Chipset SATA Controller [1022:43c8] (rev 01)
	02:00.2 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] 400 Series Chipset PCIe Bridge [1022:43c6] (rev 01)
	03:00.0 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] 400 Series Chipset PCIe Port [1022:43c7] (rev 01)
	03:01.0 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] 400 Series Chipset PCIe Port [1022:43c7] (rev 01)
	03:04.0 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] 400 Series Chipset PCIe Port [1022:43c7] (rev 01)
	05:00.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd. RTL8125 2.5GbE Controller [10ec:8125] (rev 04)
	06:00.0 VGA compatible controller [0300]: NVIDIA Corporation GK208B [GeForce GT 720] [10de:1288] (rev a1)
	06:00.1 Audio device [0403]: NVIDIA Corporation GK208 HDMI/DP Audio Controller [10de:0e0f] (rev a1)
IOMMU Group 16:
	07:00.0 VGA compatible controller [0300]: NVIDIA Corporation TU102 [GeForce RTX 2080 Ti] [10de:1e04] (rev a1)
	07:00.1 Audio device [0403]: NVIDIA Corporation TU102 High Definition Audio Controller [10de:10f7] (rev a1)
	07:00.2 USB controller [0c03]: NVIDIA Corporation TU102 USB 3.1 Host Controller [10de:1ad6] (rev a1)
	07:00.3 Serial bus controller [0c80]: NVIDIA Corporation TU102 USB Type-C UCSI Controller [10de:1ad7] (rev a1)
```

in group 15, gt720 and ethernet controller  are in the same group. it is impossible to passthrough a single video card. 

# alternative ways

+ enable acs and  acr in bios (not always work as expected)
+ switch pcie slot

# acs override patch

# repository
```
git clone https://github.com/fanguohao/ubuntu-acs-override-patch
```

# build kernel

```
chmod +x ./build_kernel.sh
```


#  install kernel

```
sudo dpkg -i *.deb
```

# grub settings

sudo vim /etc/default/grub
set  pcie_acs_override=downstream,multifunction

```
GRUB_CMDLINE_LINUX_DEFAULT="quiet video=efifb:off splash amd_iommu=on kvm.ignore_msrs=1 pcie_acs_override=downstream,multifunction"
```


#  problems

1. dpkg-buildpackage: error: debian/rules binary subprocess returned exit status 2

```
scripts/config --disable SYSTEM_TRUSTED_KEYS
```

 >https://www.mail-archive.com/kernelnewbies@kernelnewbies.org/msg21536.html

2. - SSL error:FFFFFFFF80000002:system library::No such file or directory: ../crypto/bio/bss_file.c:67

chang kernel configuration (.config) as follows:
```
CONFIG_MODULE_COMPRESS_NONE=y
# CONFIG_MODULE_COMPRESS_ZSTD is not set
```

> https://askubuntu.com/questions/1495051/ssl-error-building-signed-kernel


# Thanks:
 https://github.com/benbaker76/linux-acs-override
 gg
