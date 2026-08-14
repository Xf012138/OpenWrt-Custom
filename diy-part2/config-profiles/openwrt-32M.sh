#!/bin/bash
#
# Copyright (c) 2022-now 1-1-2 <https://github.com/1-1-2>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# File name: config-profiles/openwrt-32M.sh
# Description: OpenWrt 32M 闪存设备的配置 tier 函数
#              Newifi3‑D2 精简版，仅保留UA3F+指定业务包
#

config_clean() {
    #=========================================
    # Stripping options
    #=========================================
    cat << EOF
CONFIG_STRIP_KERNEL_EXPORTS=y
# CONFIG_USE_MKLIBS is not set
EOF
    #=========================================
    # Luci
    #=========================================
    cat << EOF
CONFIG_LUCI_LANG_zh_Hans=y
CONFIG_PACKAGE_luci=y
CONFIG_PACKAGE_luci-compat=y
EOF
}

config_basic() {
    config_clean
    #=========================================
    # 基础包和应用（只保留你需要的）
    #=========================================
    cat << EOF
# ----------基础工具
CONFIG_BUSYBOX_CONFIG_BASE64=y
CONFIG_BUSYBOX_CONFIG_NOHUP=y
CONFIG_BUSYBOX_CONFIG_SENDMAIL=y
CONFIG_BUSYBOX_CUSTOM=y
CONFIG_PACKAGE_bash=y
CONFIG_PACKAGE_htop=y
CONFIG_PACKAGE_jq=y
CONFIG_PACKAGE_fping=y
CONFIG_PACKAGE_socat=y
CONFIG_PACKAGE_ethtool=y
CONFIG_PACKAGE_openssh-sftp-server=y

# ----------Wireless
# CONFIG_PACKAGE_wpad-basic-mbedtls is not set
CONFIG_PACKAGE_wpad-mbedtls=y

# ----------USB基础（Newifi3‑D2有USB）
CONFIG_PACKAGE_usbutils=y

# ----------Luci 组件
#CONFIG_PACKAGE_luci-theme-argon=y
#CONFIG_PACKAGE_luci-app-argon-config=y
CONFIG_PACKAGE_luci-app-ttyd=y
CONFIG_PACKAGE_luci-app-taskplan=y

#===== 你指定的iptables/netfilter全套依赖 =====
CONFIG_PACKAGE_ipset=y
CONFIG_PACKAGE_iptables-nft=y
CONFIG_PACKAGE_iptables-mod-filter=y
CONFIG_PACKAGE_iptables-mod-u32=y
CONFIG_PACKAGE_iptables-mod-conntrack-extra=y
CONFIG_PACKAGE_iptables-mod-ipopt=y
CONFIG_PACKAGE_iptables-mod-nfqueue=y
CONFIG_PACKAGE_kmod-ipt-ipopt=y
CONFIG_PACKAGE_kmod-rkp-ipid=y

#===== UA3F nftables底层依赖（23.05） =====
CONFIG_PACKAGE_nftables=y
CONFIG_PACKAGE_kmod-nft-core=y
CONFIG_PACKAGE_kmod-nft-compat=y
CONFIG_PACKAGE_xtables-nft=y
CONFIG_PACKAGE_kmod-nft-queue=y
CONFIG_PACKAGE_libmnl=y
CONFIG_PACKAGE_libnetfilter-queue=y
EOF
}

# config_func 置空，不再额外增加软件包
config_func() {
    config_basic
    cat << EOF
EOF
}

# config_test 置空
config_test() {
    config_func
    cat << EOF
EOF
}
