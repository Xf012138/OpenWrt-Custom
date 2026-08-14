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
# src-git openclash https://github.com/vernesong/OpenClash.git;master
# src-git helloworld https://github.com/fw876/helloworld
# src-git passwall https://github.com/xiaorouji/openwrt-passwall
# 包含 openclash , SSR+ 和 passwall 等
src-git kenzo https://github.com/kenzok8/small-package
# src-git kenzo https://github.com/kenzok8/openwrt-packages
# passwall 等的依赖
# src-git small https://github.com/kenzok8/small

EOF
    echo 已增补内容至默认源配置文件[feeds.conf.default]
    echo ===========feeds.conf.default===========
    cat feeds.conf.default
    echo ====================================
else
    echo 找不到默认源配置文件[feeds.conf.default]
fi

# =========================================
# 添加 rkp‑ipid、UA2F、UA3F 源码（适配 immortalwrt‑21.02）
# =========================================

# =========================================
# 添加 rkp‑ipid、UA2F、UA3F 源码（适配 immortalwrt‑21.02）
# =========================================

git clone https://github.com/CHN-beta/rkp-ipid.git package/rkp-ipid --depth=1
git clone https://github.com/Zxilly/UA2F.git package/UA2F --depth=1

# UA3F：去掉--depth 1，要拉完整历史才能checkout旧commit
git clone https://github.com/SunBK201/UA3F.git package/UA3F
cd package/UA3F
# 适配21.02的可用commit
git checkout 960114470541300490083100441201031034021
# 删除tproxy硬依赖
sed -i 's/+iptables-mod-tproxy//g' Makefile
# 修复cmake CMP0135报错
sed -i '/cmake_policy(SET CMP0135 NEW)/d' src/CMakeLists.txt
cd ../..

# ==========新增：修复openssl mips汇编报错 放在这里！==========
if [ -f package/libs/openssl/crypto/aes/aes-mips.S ];then
sed -i 's/32-1\*4/28/g' package/libs/openssl/crypto/aes/aes-mips.S
sed -i 's/32-2\*4/24/g' package/libs/openssl/crypto/aes/aes-mips.S
sed -i 's/32-3\*4/20/g' package/libs/openssl/crypto/aes/aes-mips.S
sed -i 's/32-4\*4/16/g' package/libs/openssl/crypto/aes/aes-mips.S
sed -i 's/32-5\*4/12/g' package/libs/openssl/crypto/aes/aes-mips.S
sed -i 's/32-6\*4/8/g' package/libs/openssl/crypto/aes/aes-mips.S
sed -i 's/32-7\*4/4/g' package/libs/openssl/crypto/aes/aes-mips.S
sed -i 's/32-8\*4/0/g' package/libs/openssl/crypto/aes/aes-mips.S
else
  echo "openssl aes-mips.S 不存在，跳过sed修补，将使用.config关闭MIPS汇编"
fi
# ==========================================================
