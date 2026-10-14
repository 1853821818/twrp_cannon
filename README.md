# TWRP 12.1 for Redmi Note 9 5G (cannon)

适配红米 Note 9 5G (cannon / MT6853 / 天玑800U) 的 TWRP 12.1 第三方 Recovery。

## 特性
- 基于可用的 cannong TWRP 设备树移植
- 使用原厂 OriginOS 4 / MIUI 14 内核 (Linux 4.14.186-perf)
- 支持 FBE v1 解密 /data
- 支持动态分区 (super)
- 支持备份/刷入 boot/recovery/vbmeta 等分区
- SELinux Permissive

## 编译
推送代码到 GitHub 后，Actions 会自动编译，约 30-40 分钟。

## 刷入
```bash
fastboot flash recovery recovery.img
fastboot reboot recovery
```

## 注意
- 刷入后立即进 recovery，不要先进系统（系统会回填原厂 recovery）
- 首次进入可能需要输入密码解密 /data
