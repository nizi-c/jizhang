# 设备类型配置修复

## 问题描述

启动应用时出现错误：
```
ErrorCode: 00401026
ErrorDescription: The deviceType or apiVersion of the target device does not match that configured in the module.json5 file.
```

## 原因分析

这个错误表示目标设备（模拟器或真机）的设备类型与 `module.json5` 中配置的设备类型不匹配。

原始配置只支持 "phone"（手机）：
```json
"deviceTypes": [
  "phone"
]
```

但你可能在以下情况下遇到这个错误：
1. 使用平板模拟器运行应用
2. 使用真机平板设备运行应用
3. 模拟器的 API 版本与配置不匹配

## 解决方案

### 修改 module.json5

在 `entry/src/main/module.json5` 中，将 `deviceTypes` 修改为支持手机和平板：

```json
"deviceTypes": [
  "phone",
  "tablet"
]
```

**修改前：**
```json
{
  "module": {
    "name": "entry",
    "type": "entry",
    "deviceTypes": [
      "phone"
    ],
    ...
  }
}
```

**修改后：**
```json
{
  "module": {
    "name": "entry",
    "type": "entry",
    "deviceTypes": [
      "phone",
      "tablet"
    ],
    ...
  }
}
```

## 修复完成

✅ 已修改 `entry/src/main/module.json5`，现在支持：
- 📱 手机设备
- 📱 平板设备

## 后续步骤

1. **清理构建缓存**
   ```bash
   # 在 DevEco Studio 中
   Build → Clean Project
   ```

2. **重新编译**
   ```bash
   # 在 DevEco Studio 中
   Build → Build Project
   ```

3. **重新运行**
   - 选择目标设备（手机或平板模拟器）
   - 点击 Run 按钮

## 支持的设备类型

| 设备类型 | 说明 | 屏幕尺寸 |
|---------|------|---------|
| phone | 手机设备 | < 600vp |
| tablet | 平板设备 | ≥ 600vp |
| wearable | 可穿戴设备 | 小屏幕 |
| tv | 电视设备 | 大屏幕 |
| car | 车载设备 | 特殊尺寸 |

## 常见问题

### Q: 为什么会出现这个错误？

A: 当应用配置的设备类型与实际运行的设备类型不匹配时，系统会拒绝安装应用。

### Q: 支持更多设备类型会影响性能吗？

A: 不会。支持更多设备类型只是在配置中添加声明，不会影响应用的性能。

### Q: 如何只支持手机？

A: 如果只想支持手机，保持原始配置：
```json
"deviceTypes": [
  "phone"
]
```

### Q: 如何支持所有设备类型？

A: 添加所有支持的设备类型：
```json
"deviceTypes": [
  "phone",
  "tablet",
  "wearable",
  "tv",
  "car"
]
```

## 验证修复

修复后，你应该能够：
1. ✅ 在手机模拟器上运行应用
2. ✅ 在平板模拟器上运行应用
3. ✅ 在真机手机上运行应用
4. ✅ 在真机平板上运行应用

---

**修复完成时间**：2024年
**状态**：✅ 设备类型配置已更新

