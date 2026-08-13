#!/bin/bash
#
# Copyright (c) 2022-now 1-1-2 <https://github.com/1-1-2>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# File name: config-profiles/lede-32M.sh
# Description: LEDE 32M 闪存设备的配置 tier 函数
#              原位于 Configurator-LEDE-32M.sh
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
    # Remove defaults Apps
    #=========================================
    cat << EOF
# ----------luci-app-ssr-plus
# CONFIG_PACKAGE_luci-app-ssr-plus is not set

EOF
    #=========================================
    # unset some default to avoid duplication
    #=========================================
    cat << EOF
# CONFIG_PACKAGE_luci-app-passwall_Transparent_Proxy is not set
# CONFIG_PACKAGE_luci-app-passwall2_Transparent_Proxy is not set
EOF
}

config_basic() {
    config_clean
    #=========================================
    # 基础包和应用
    #=========================================
    cat << EOF
# ----------extra packages-automount
CONFIG_PACKAGE_automount=y
# ----------extra packages-ipv6helper
CONFIG_PACKAGE_ipv6helper=y
# ----------Utilities-Disc-cfdisk&fdisk
CONFIG_PACKAGE_cfdisk=y
CONFIG_PACKAGE_fdisk=y
# ----------Utilities-Filesystem-e2fsprogs
CONFIG_PACKAGE_e2fsprogs=y
# ----------Utilities-usbutils
CONFIG_PACKAGE_usbutils=y
# ----------Utilities-jq
CONFIG_PACKAGE_jq=y
# ----------Utilities-coreutils-base64
CONFIG_PACKAGE_coreutils-base64=y
# ----------Kernel modules-USB Support-kmod-usb3
CONFIG_DEFAULT_kmod-usb3=y
# ----------luci-app-hd-idle
CONFIG_PACKAGE_luci-app-hd-idle=y
# ----------luci-app-cifsd
CONFIG_PACKAGE_luci-app-cifsd=y
# ----------luci-app-commands
CONFIG_PACKAGE_luci-app-commands=y
# ----------luci-app-qos
CONFIG_PACKAGE_luci-app-qos=y
# ----------luci-app-eqos
CONFIG_PACKAGE_luci-app-eqos=y
# ----------luci-app-sqm
CONFIG_PACKAGE_luci-app-sqm=y
# ----------luci-app-ttyd
CONFIG_PACKAGE_luci-app-ttyd=y
# ----------luci-app-wrtbwmon
CONFIG_PACKAGE_luci-app-wrtbwmon=y
# ----------luci-theme-argon
CONFIG_PACKAGE_luci-theme-bootstrap=y
#CONFIG_PACKAGE_luci-theme-argonne=y
#CONFIG_PACKAGE_luci-app-argonne-config=y
# ----------luci-app-webadmin
CONFIG_PACKAGE_luci-app-webadmin=y
# ----------自定义包
CONFIG_PACKAGE_bash=y
CONFIG_PACKAGE_htop=y
CONFIG_PACKAGE_openssh-sftp-server=y
CONFIG_PACKAGE_luci-app-taskplan=y
CONFIG_PACKAGE_ipset=y
CONFIG_PACKAGE_iptables-nft=y
CONFIG_PACKAGE_iptables-mod-filter=y
CONFIG_PACKAGE_iptables-mod-u32=y
CONFIG_PACKAGE_iptables-mod-conntrack-extra=y
CONFIG_PACKAGE_kmod-ipt-ipopt=y
CONFIG_PACKAGE_kmod-rkp-ipid=y
#CONFIG_PACKAGE_ua2f=y
# nftables核心
CONFIG_PACKAGE_nftables=y
CONFIG_PACKAGE_kmod‑nft‑core=y
CONFIG_PACKAGE_kmod‑nft‑compat=y
CONFIG_PACKAGE_xtables‑nft=y

# UA3F还依赖
CONFIG_PACKAGE_kmod‑nft‑queue=y
CONFIG_PACKAGE_kmod‑nft‑tproxy=y

EOF
}

config_func() {
    config_basic
    #=========================================
    # 功能包
    #=========================================
    cat << EOF
# ----------luci-app-aria2
CONFIG_PACKAGE_luci-app-aria2=y
# ----------luci-app-VPNs
CONFIG_PACKAGE_luci-app-nps=y
CONFIG_PACKAGE_luci-app-frpc=y
CONFIG_PACKAGE_luci-app-n2n_v2=y
CONFIG_PACKAGE_luci-app-zerotier=y
# ----------luci-app-openclash
CONFIG_PACKAGE_luci-app-openclash=y
# ----------network-firewall-ip6tables-ip6tables-mod-nat
# CONFIG_PACKAGE_ip6tables-mod-nat=y
# ----------luci-app-transmission
CONFIG_PACKAGE_luci-app-transmission=y
# ----------luci-app-watchcat
CONFIG_PACKAGE_luci-app-watchcat=y
# ----------luci-app-v2ray-server
CONFIG_PACKAGE_luci-app-v2ray-server=y
# ===== 界面类(安全) =====
CONFIG_PACKAGE_luci-theme-argon=y
CONFIG_PACKAGE_luci-app-ttyd=y
CONFIG_PACKAGE_luci-app-taskplan=y

# ===== 工具类(安全) =====
CONFIG_PACKAGE_ipset=y
CONFIG_PACKAGE_iptables-nft=y

# ===== 模块类(配合规则才生效) =====
CONFIG_PACKAGE_iptables-mod-filter=y
CONFIG_PACKAGE_iptables-mod-ipopt=y
CONFIG_PACKAGE_iptables-mod-u32=y
CONFIG_PACKAGE_iptables-mod-conntrack-extra=y
CONFIG_PACKAGE_kmod-ipt-ipopt=y

# ===== 内核模块(开机自加载) =====
CONFIG_PACKAGE_kmod-rkp-ipid=y

# ===== 高风险(会接管网络流量) =====
CONFIG_PACKAGE_=y

EOF
}

config_test() {
    config_func
    #=========================================
    # 测试域
    #=========================================
    cat << EOF
# CONFIG_PACKAGE_luci-app-verysync=y
EOF
}
