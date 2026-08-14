#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
# Copyright (c) 2022-now 1-1-2 <https://github.com/1-1-2>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# File name: _device/Newifi3D2.sh
# Description: Newifi3 D2 (Newifi3) 设备定义
#              支持 LEDE 和 OpenWrt 双系统
#

#=========================================
# Target System
#=========================================
target_inf() {
    cat << 'EOF'
CONFIG_TARGET_ramips=y
CONFIG_TARGET_ramips_mt7621=y
CONFIG_TARGET_ramips_mt7621_DEVICE_d-team_newifi-d2=y
CONFIG_PACKAGE_kmod-usb3=y
EOF
}

#=========================================
# 需要编译安装的软件包（新增这个 add_packages 函数）
#=========================================
add_packages() {
    add_package ua3f
    add_package luci-app-ua3f
    add_package rkp-ipid

    add_package kmod-nft-queue
    add_package kmod-nft-tproxy
    add_package iptables-mod-tproxy
    add_package iptables-mod-filter
    add_package iptables-mod-ipopt
    add_package iptables-mod-u32
    add_package iptables-mod-conntrack-extra

    add_package ipset
    add_package iptables-nft
}

#=========================================
# 默认配置修改
#=========================================
mod_default_config() {
    local system="$1"

    _set_ip

    # OpenWrt 版本额外设置时区
    if [ "$system" = "openwrt" ]; then
        _set_timezone
    fi

    _set_hostname "N3D2"
    _set_theme

    # OpenWrt 版本额外添加 uci-defaults
    if [ "$system" = "openwrt" ]; then
        _set_custom_defaults "$SH_DIR"
    fi
}

#=========================================
# 设备专属补丁：dts扩容已经移到 diy-part1.sh，这里只保留空函数，不能删掉target_patch()，框架会调用
#=========================================
target_patch() {
    echo "[target_patch] dts扩容已迁移至diy-part1.sh，此处跳过"
}
