# TWRP for Redmi Note 9 5G (cannon)

基于本机 OriginOS 4.0 渡江OS 移植包（MIUI V14.0.6.0.SJECNXM 底包）定制的 TWRP 12.1 编译仓库。

## 设备信息（从刷机包提取）

| 项目 | 值 |
|---|---|
| 机型 | 红米 Note 9 5G (M2007J22C) |
| 代号 | cannon |
| SoC | 联发科天玑 800U (MT6853) |
| 内核 | Linux 4.14.186-perf（取自原厂 recovery.img，Image.gz-dtb） |
| 基础系统 | Android 12 / MIUI 14 (V14.0.6.0.SJECNXM) |
| A/B | 否（独立 recovery 分区，128MB） |
| /data | f2fs，FBE v1 (aes-256-xts / aes-256-cts) 加密 |
| 动态分区 | system / vendor / product / system_ext / odm（super 8.5GB） |
| boot 头 | v2，page 2048，base 0x40078000 |

## 仓库结构

```
├── .github/workflows/twrp.yml      # GitHub Actions 自动编译
└── device/xiaomi/cannon/           # TWRP 设备树
    ├── AndroidProducts.mk
    ├── twrp_cannon.mk
    ├── BoardConfig.mk
    ├── device.mk
    ├── prebuilt/Image.gz-dtb       # 预编译内核（原厂提取）
    └── recovery/root/system/etc/recovery.fstab
```

## 编译方法（GitHub Actions）

1. 在 GitHub 新建一个仓库（如 `twrp_cannon`，公开或私有均可）
2. 将本目录全部内容上传上去，两种方式任选：
   - 网页上传：仓库页面点 "uploading an existing file"，把 `.github`、`device` 文件夹拖进去（先压缩成 zip 再上传也行，上传后在线解压不方便，建议逐文件夹拖拽；注意 `.github` 是隐藏文件夹，Windows 资源管理器需开启"显示隐藏项目"）
   - git 命令（需本机安装 git）：
     ```
     cd /d F:\TWRP_cannon\repo
     git init -b main
     git add .
     git commit -m "TWRP 12.1 cannon device tree"
     git remote add origin https://github.com/<你的用户名>/twrp_cannon.git
     git push -u origin main
     ```
3. push 后 GitHub Actions 会自动开始编译；也可到 Actions 页面选 "Build TWRP 12.1 for Redmi Note 9 5G (cannon)" → Run workflow 手动触发
4. 编译约 2~3 小时（源码同步 + 编译），完成后在该次运行页面下载 artifact `twrp-12.1_cannon`，里面就是 `recovery.img`

## 刷入方法

```
fastboot flash recovery recovery.img
fastboot reboot recovery     # 注意：别直接 reboot 进系统，进系统会被原厂 recovery 覆盖回填
```

建议刷入后立即进 TWRP，用 TWRP 里的"安装 Recovery Ramdisk / Fix Recovery Bootloop"类选项固化。

## 注意事项

- 本 TWRP 的解密能力匹配 Android 12 基座（FBE v1）。这个移植包的底是 MIUI 12 (A12)，可正常解密 /data
- 动态分区机型：TWRP 备份/恢复针对整个 super 分区；刷单个逻辑分区（system 等）需进 fastbootd
- 若编译失败，Actions 会上传日志 artifact，可下载查看具体报错
