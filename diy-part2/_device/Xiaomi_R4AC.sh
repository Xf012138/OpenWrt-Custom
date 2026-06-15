#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
# Copyright (c) 2022-now 1-1-2 <https://github.com/1-1-2>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# File name: _device/Xiaomi_R4AC.sh
# Description: Xiaomi Mi Router 4A 100M 设备定义 (OpenWrt only)
#

#=========================================
# Target System
#=========================================
target_inf() {
    cat << 'EOF'
CONFIG_TARGET_ramips=y
CONFIG_TARGET_ramips_mt76x8=y
CONFIG_TARGET_ramips_mt76x8_DEVICE_xiaomi_mi-router-4a-100m=y
EOF
}

#=========================================
# 默认配置修改
#=========================================
mod_default_config() {
    _set_ip
    _set_timezone
    _set_hostname "Mi-R4AC"
    _set_theme
    _set_custom_defaults "$SH_DIR"
}

#=========================================
# 设备专属补丁 (DTS + mk)
#=========================================
target_patch() {
    local PATCH_DIR="$GITHUB_WORKSPACE/patches"

    # dtsi补丁，使用自定义分区，更新数据偏移位置
    echo '[+TARGET] 应用 mt7628an_xiaomi_mi-router-4.dtsi.patch'
    patch target/linux/ramips/dts/mt7628an_xiaomi_mi-router-4.dtsi "${PATCH_DIR}/mt7628an_xiaomi_mi-router-4.dtsi.patch"

    # dts补丁，使用自定义分区，更新数据偏移位置
    echo '[+TARGET] 应用 mt7628an_xiaomi_mi-router-4a-100m.dts.patch'
    patch target/linux/ramips/dts/mt7628an_xiaomi_mi-router-4a-100m.dts "${PATCH_DIR}/mt7628an_xiaomi_mi-router-4a-100m.dts.patch"

    # IMAGE_SIZE(14976k->16192K)
    echo '[+TARGET] 应用 mt76x8.mk.R4AC.patch'
    patch target/linux/ramips/image/mt76x8.mk "${PATCH_DIR}/mt76x8.mk.R4AC.patch"
}
