#!/bin/bash
#
# Copyright (c) 2022-now 1-1-2 <https://github.com/1-1-2>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# File name: _device/Newifi3D2.sh
# Description: Newifi3 D2 设备定义（OpenWrt 23.05 / ImmortalWrt）
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
# 默认配置修改（IP / 时区 / 主机名 / 主题）
#=========================================
mod_default_config() {
    local system="$1"

    _set_ip
    _set_timezone
    _set_hostname "N3D2"
    _set_theme

    if [ "$system" = "openwrt" ]; then
        _set_custom_defaults "$SH_DIR"
    fi
}

#=========================================
# DTS 扩容补丁已在 diy-part1.sh 里 sed 完成，
# 这里留空函数以满足框架调用约定
#=========================================
target_patch() {
    echo "[target_patch] dts 扩容已迁移至 diy-part1.sh，此处跳过"
}
