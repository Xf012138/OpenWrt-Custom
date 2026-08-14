#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#

# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Add a feed source
#echo 'src-git helloworld https://github.com/fw876/helloworld' >>feeds.conf.default
#echo 'src-git passwall https://github.com/xiaorouji/openwrt-passwall' >>feeds.conf.default

# =========================================
# 添加 rkp‑ipid、UA3F 源码 适配 ImmortalWrt‑23.05
# 先判断文件夹是否存在，存在就跳过，防止重复clone报错
# =========================================
[ ! -d package/UA3F ] && git clone https://mirror.ghproxy.com/https://github.com/SunBK201/UA3F.git package/UA3F --depth=1
[ ! -d package/rkp-ipid ] && git clone https://mirror.ghproxy.com/https://github.com/CHN-beta/rkp-ipid.git package/rkp-ipid --depth=1

# ======================
# Newifi3‑D2 DTS扩容补丁（挪到这里，编译前修改设备树）
# ======================
sed -i 's/reg = <0x080000 0x1780000>/reg = <0x080000 0x1E00000>/' target/linux/ramips/dts/mt7621_newifi_d2.dts
echo "✅ dts分区扩容已完成"
