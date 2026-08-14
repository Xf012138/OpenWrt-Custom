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

# =========================================
# 添加第三方 feed 源（part1 的正确用法）
# =========================================

# taskplan 定时/开机任务
echo 'src-git taskplan https://github.com/sirpdboy/luci-app-taskplan' >> feeds.conf.default

# =========================================
# Clone 第三方包到 package/ 目录（不走 feed）
# 直接用 GitHub 原地址，不用 ghproxy（已挂）
# 先判断文件夹是否存在，防止重复 clone 报错
# =========================================

# UA3F 主程序
[ ! -d package/UA3F ] && git clone https://github.com/SunBK201/UA3F.git package/UA3F --depth=1

# UA3F LuCI 管理界面（之前漏了！）
[ ! -d package/luci-app-ua3f ] && git clone https://github.com/SunBK201/luci-app-ua3f.git package/luci-app-ua3f --depth=1

# rkp-ipid 内核模块（IPID 防检测）
[ ! -d package/rkp-ipid ] && git clone https://github.com/CHN-beta/rkp-ipid.git package/rkp-ipid --depth=1

# =========================================
# Newifi3‑D2 DTS 扩容补丁（32M flash）
# 0x1780000 = 23.5MB → 0x1E00000 = 30MB
# =========================================
sed -i 's/reg = <0x080000 0x1780000>/reg = <0x080000 0x1E00000>/' target/linux/ramips/dts/mt7621_newifi3_d2.dts
echo "✅ dts 分区扩容已完成"
