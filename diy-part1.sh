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

#=========================================
# add feeds
#=========================================
if [ -e feeds.conf.default ]; then
    cat >> feeds.conf.default << EOF
src-git kenzo https://github.com/kenzok8/small-package
EOF
    echo 已增补内容至默认源配置文件[feeds.conf.default]
    echo ===========feeds.conf.default===========
    cat feeds.conf.default
    echo ====================================
else
    echo 找不到默认源配置文件[feeds.conf.default]
fi

# =========================================
# 添加 rkp‑ipid、UA3F 源码 适配 ImmortalWrt‑23.05
# =========================================
git clone https://github.com/SunBK201/rkp-ipid.git package/rkp-ipid --depth=1

# UA3F v3.6.0
git clone https://github.com/SunBK201/UA3F.git package/UA3F --depth=1
