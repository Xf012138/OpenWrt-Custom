# Xiaomi R4AC (小米路由器4A百兆版) 基于 Breed 的 OpenWrt 魔改指南

## 一、设备硬件信息

| 项目 | 规格 |
| :--- | :--- |
| **产品型号** | 小米路由器 4A (100M 版) 中国版 / 海外型号 R4AC 百兆版 |
| **SoC** | MediaTek MT7628AN (MIPS32 24KEc) @ 580 MHz |
| **内存** | 64 MB DDR2 |
| **闪存** | 16 MB SPI NOR (如 Winbond W25Q128JV) |
| **2.4GHz Wi-Fi** | MT7628AN 集成 (2×2 MIMO) |
| **5GHz Wi-Fi** | MT7612EN (2×2 MIMO) |
| **以太网** | 1×WAN + 2×LAN, 10/100 Mbps |
| **复位键** | GPIO 38 (低电平有效) |
| **LED** | 蓝(GPIO11)、黄(GPIO44)、WAN蓝(GPIO37) |
| **串口** | 3.3V TTL, 115200 bps, 8N1 |
| **原厂分区入口点** | `0x160000` (中国版) |

## 二、魔改目标

- **保留原厂硬件，不硬改**；
- **用 Breed 替换原厂 U-Boot**，获得灵活的引导和刷机能力；
- **重绘闪存分区**：剔除原厂无用的 `config`、`crash`、`cfg_bak`、`overlay` 分区，将 `factory`（EEPROM + MAC）移至 `0x20000`，`firmware` 起始于 `0x30000`，使固件可用空间从原 ~14.5MB 提升至 **~15.8MB**；
- **适配 OpenWrt**，编译出自定义分区的固件，实现可持续升级。

## 三、闪存分区布局（魔改后）

| 分区名 | 起始地址 | 大小 | 内容说明 |
| :--- | :--- | :--- | :--- |
| `u-boot` | `0x000000` | `0x20000` (128 KB) | Breed (`breed-mt7688-reset38.bin`) |
| `factory` | `0x020000` | `0x10000` (64 KB) | 包含 EEPROM (2.4G/5G)、MAC 地址、SN 等 |
| `firmware` | `0x030000` | `0xFD0000` (~15.8 MB) | OpenWrt (kernel + rootfs) |

**总闪存大小**: 16 MB (0x1000000)  
**可用固件空间计算**: `0x1000000 - 0x30000 = 0xFD0000`

## 四、准备工作

### 4.1 所需软件与文件
- **编程器**：CH341A 等，用于备份/烧录 SPI 闪存；
- **软件**：`NeoProgrammer` (或 `AsProgrammer`)、`WinHex`；
- **Breed**：[breed-mt7688-reset38.bin](http://breed.hackpascal.net/breed-mt7688-reset38.bin) (复位键 GPIO 38 匹配)；
- **原厂固件备份**：使用编程器完整读取闪存，保存为 `full.bin`。

### 4.2 提取原厂 `factory` 分区数据
- 原厂 `factory` 分区位于 `0x30000`，长度 `0x10000` (64 KB)。  
- 在 `full.bin` 中定位 `0x30000`，复制 `0x10000` 字节，保存为 `factory.bin`。

`factory.bin` 内部结构（参考）：

| 偏移 | 长度 | 内容 |
| :--- | :--- | :--- |
| `0x0000` | `0x400` | 2.4G EEPROM (MT7628) |
| `0x0004` | `0x6` | LAN MAC 地址 (mac-base) |
| `0x0028` | `0x6` | 备用 MAC (未使用) |
| `0x1000` | ~ | 设备 SN 等信息 |
| `0x8000` | `0x200` | 5G EEPROM (MT7612EN) |

## 五、魔改 Breed（嵌入 factory 数据）

目标：生成一个包含 Breed + `factory` 分区的混合二进制文件，一次性写入闪存 `0x0` – `0x2FFFF`。

### 5.1 创建空白文件
- 使用 WinHex 新建一个大小为 `192 KB` (0x30000) 的文件，填充 `0xFF`，命名为 `breed+factory.bin`。

### 5.2 写入 Breed
- 打开 `breed-mt7688-reset38.bin`，全选复制；  
- 在 `breed+factory.bin` 的 `0x0` 处“写入”（Ctrl+B），覆盖开头。

### 5.3 写入 factory 数据
- 打开原厂备份 `full.bin`，跳转到 `0x30000`，标记起始；跳转到 `0x3FFFF`，标记结束；复制；  
- 在 `breed+factory.bin` 中跳转到 `0x20000`，执行“写入”（Ctrl+B）覆写。  
  *此时 `0x20000` – `0x2FFFF` 即为完整的原厂 `factory` 分区数据。*

### 5.4 保存文件
- 保存 `breed+factory.bin`，大小应为 192 KB。

## 六、刷入 Breed + factory

1. **编程器擦除闪存**（确保全 `0xFF`）；
2. **写入 `breed+factory.bin` 到闪存起始地址 `0x0`**；
3. 校验写入无误，断电，拔下编程器。

## 七、配置 Breed 环境变量（设置启动地址）

1. 路由器上电，LAN1 口连接电脑，浏览器访问 `192.168.1.1` 进入 Breed Web 界面；
2. 进入 **“环境变量编辑”** → **“启用环境变量”**，存储位置选 **“Breed 内部”**（位于 `0x2F000` – `0x30000`）；
3. 添加变量：
   - 变量名：`autoboot.command`  
   - 变量值：`boot flash 0x30000`  
4. 保存并重启。

> **原理**：Breed 默认启动顺序会尝试从 `0x50000` 等处引导，设置该变量后，Breed 直接跳转到 `0x30000` 执行固件。

## 八、适配 OpenWrt（修改源码）

需要修改三处文件，使 OpenWrt 识别新的分区布局。

### 8.1 修改 `mt7628an_xiaomi_mi-router-4.dtsi`
应用以下补丁（重定位 `factory` 分区，删除冗余分区）：

```patch
--- openwrt/target/linux/ramips/dts/mt7628an_xiaomi_mi-router-4.dtsi	2026-04-27 12:59:53.633714366 +0800
+++ ./mt7628an_xiaomi_mi-router-4.dtsi	2026-06-11 23:01:12.770646842 +0800
@@ -41,14 +41,8 @@
 			};
 
 			partition@20000 {
-				label = "config";
-				reg = <0x20000 0x10000>;
-				read-only;
-			};
-
-			partition@30000 {
 				label = "factory";
-				reg = <0x30000 0x10000>;
+				reg = <0x20000 0x10000>;
 				read-only;
 
 				nvmem-layout {
@@ -76,18 +70,6 @@
 				};
 			};
 
-			partition@40000 {
-				label = "crash";
-				reg = <0x40000 0x10000>;
-				read-only;
-			};
-
-			partition@50000 {
-				label = "cfg_bak";
-				reg = <0x50000 0x10000>;
-				read-only;
-			};
-
 			/* additional partitions in DTS */
 		};
 	};
```

### 8.2 修改 `mt7628an_xiaomi_mi-router-4a-100m.dts`
应用以下补丁（调整 `firmware` 起始地址和大小）：

```patch
--- openwrt/target/linux/ramips/dts/mt7628an_xiaomi_mi-router-4a-100m.dts	2026-04-27 12:59:53.633714366 +0800
+++ ./mt7628an_xiaomi_mi-router-4a-100m.dts	2026-06-11 23:01:43.494646048 +0800
@@ -41,15 +41,9 @@
 };
 
 &partitions {
-	partition@60000 {
-		label = "overlay";
-		reg = <0x60000 0x100000>;
-		read-only;
-	};
-
-	partition@160000 {
+	partition@30000 {
 		label = "firmware";
-		reg = <0x160000 0xea0000>;
+		reg = <0x30000 0xfd0000>;
 		compatible = "denx,uimage";
 	};
 };
```

### 8.3 添加设备型号（可选）
在 `target/linux/ramips/image/mt76x8.mk` 中添加自定义设备条目，或直接沿用 `xiaomi,mi-router-4a-100m` 的配置。

> 由于分区表已修改，**强烈建议**在 `mt76x8.mk` 中为新设备定义独立的 `IMAGE/sysupgrade.bin`，避免与其他版本混淆。

### 8.4 编译 OpenWrt
按照常规流程编译，生成 `sysupgrade.bin`。该固件的 `firmware` 分区从 `0x30000` 开始，且不再包含 `overlay` 分区（由 rootfs 动态拆分）。

## 九、合成完整编程器固件并刷入 OpenWrt

### 9.1 组合固件
使用 WinHex 将以下三部分拼接成一个完整的 16MB 编程器固件：

1. **Breed+factory**（192 KB，`0x0` – `0x2FFFF`）；
2. **OpenWrt sysupgrade.bin**（剩余空间，从 `0x30000` 开始写入）。

> 操作方法：新建 16MB 文件，先写入 `breed+factory.bin` 到 `0x0`，再跳转到 `0x30000` 写入 `sysupgrade.bin`。

### 9.2 编程器刷入
- 擦除闪存，写入上述组合固件；
- 校验后上电。

### 9.3 验证
- 设备红灯闪烁，稍等片刻，应能进入 OpenWrt 系统（默认 IP `192.168.1.1`）；
- 检查无线、网口、LED 功能是否正常；
- 确认分区布局：执行 `cat /proc/mtd` 应看到 `u-boot`、`factory`、`firmware` 三个分区。

## 十、后续固件升级

由于分区表已固定，今后仅需在 OpenWrt 内使用 **相同分区布局** 的 `sysupgrade.bin` 进行升级，**不得混刷** 其他分区方案的固件。  
升级命令：

```bash
sysupgrade -n /tmp/xxx-sysupgrade.bin
```

## 十一、常见问题

**Q1：没有编程器，可以用 Breed 直接刷入吗？**  
A：首次必须使用编程器，因为原厂 U-Boot 无法识别新分区布局。一旦刷入 Breed+factory 组合，后续可通过 Breed 的“编程器固件”功能写入完整固件。

**Q2：为什么不能用原厂 `factory` 分区偏移？**  
A：原厂 `factory` 在 `0x30000`，而我们的 `firmware` 从 `0x30000` 开始，会覆盖 EEPROM。因此必须将 `factory` 迁移到 `0x20000`，且 Breed 环境变量已配置启动地址为 `0x30000`。
