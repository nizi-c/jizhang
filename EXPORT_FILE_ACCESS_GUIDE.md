# 导出文件访问指南

## 文件位置

导出的CSV文件保存在应用的files目录：
```
/data/storage/el2/base/haps/entry/files/账单记录_YYYYMMDD_HHMMSS.csv
```

## 访问方法

### 方法1：使用ADB命令（推荐）

#### 前提条件
1. 安装ADB工具
2. 启用手机的USB调试模式
3. 使用USB连接手机和电脑

#### 步骤

1. **连接设备**
```bash
adb devices
```
应该看到你的设备列表

2. **查看导出的文件**
```bash
adb shell ls /data/storage/el2/base/haps/entry/files/
```

3. **拉取文件到电脑**
```bash
# 拉取最新的文件
adb pull /data/storage/el2/base/haps/entry/files/账单记录_20251123_143025.csv ./

# 或者拉取所有CSV文件
adb pull /data/storage/el2/base/haps/entry/files/ ./exported_files/
```

4. **用Excel打开**
- 双击CSV文件
- 或在Excel中选择"打开" -> 选择CSV文件

### 方法2：使用HiSuite（华为手机）

1. 下载安装华为HiSuite
2. 连接手机到电脑
3. 打开HiSuite
4. 进入"文件管理"
5. 导航到应用数据目录
6. 找到并复制CSV文件

### 方法3：使用开发者工具

#### DevEco Studio
1. 打开DevEco Studio
2. 连接设备
3. 打开Device File Explorer
4. 导航到 `/data/storage/el2/base/haps/entry/files/`
5. 右键文件 -> Save As

#### Android Studio（如果兼容）
1. 打开Android Studio
2. View -> Tool Windows -> Device File Explorer
3. 导航到应用目录
4. 下载文件

## 快速命令参考

### 查看所有导出的文件
```bash
adb shell ls -lh /data/storage/el2/base/haps/entry/files/*.csv
```

### 拉取最新的文件
```bash
# Windows
adb pull /data/storage/el2/base/haps/entry/files/账单记录_*.csv %USERPROFILE%\Desktop\

# Mac/Linux
adb pull /data/storage/el2/base/haps/entry/files/账单记录_*.csv ~/Desktop/
```

### 查看文件内容（预览）
```bash
adb shell cat /data/storage/el2/base/haps/entry/files/账单记录_20251123_143025.csv
```

### 删除旧的导出文件
```bash
adb shell rm /data/storage/el2/base/haps/entry/files/账单记录_*.csv
```

## 批处理脚本

### Windows批处理（export_csv.bat）
```batch
@echo off
echo 正在导出CSV文件...
adb pull /data/storage/el2/base/haps/entry/files/ ./exported_files/
echo 导出完成！文件保存在 exported_files 目录
pause
```

### Mac/Linux脚本（export_csv.sh）
```bash
#!/bin/bash
echo "正在导出CSV文件..."
mkdir -p ./exported_files
adb pull /data/storage/el2/base/haps/entry/files/*.csv ./exported_files/
echo "导出完成！文件保存在 exported_files 目录"
```

## 常见问题

### Q: 提示"device unauthorized"
A: 
1. 检查手机上是否弹出USB调试授权对话框
2. 点击"允许"
3. 勾选"始终允许这台电脑"

### Q: 提示"no devices/emulators found"
A:
1. 检查USB连接
2. 确认已启用USB调试
3. 尝试重新连接USB
4. 运行 `adb kill-server` 然后 `adb start-server`

### Q: 提示"permission denied"
A:
1. 确认手机已root（如果需要）
2. 或使用 `adb shell` 进入shell后再访问
3. 某些文件可能需要root权限

### Q: 找不到文件
A:
1. 确认已经导出过文件
2. 检查文件路径是否正确
3. 查看应用日志确认文件路径

### Q: CSV文件乱码
A:
1. 使用Excel的"数据" -> "从文本/CSV"导入
2. 选择UTF-8编码
3. 或使用记事本打开，另存为时选择UTF-8编码

## 用Excel打开CSV

### 方法1：直接打开
1. 双击CSV文件
2. Excel会自动打开
3. 如果中文显示正常，完成
4. 如果乱码，使用方法2

### 方法2：导入（推荐）
1. 打开Excel
2. 选择"数据" -> "从文本/CSV"
3. 选择CSV文件
4. 在预览窗口中：
   - 文件原始格式：UTF-8
   - 分隔符：逗号
5. 点击"加载"

### 方法3：使用Google Sheets
1. 打开Google Sheets
2. 文件 -> 导入
3. 上传CSV文件
4. 选择"逗号"作为分隔符
5. 点击"导入数据"

## 自动化导出

### 定时导出脚本（Windows）
```batch
@echo off
:loop
echo [%date% %time%] 开始导出...
adb pull /data/storage/el2/base/haps/entry/files/*.csv ./backup/
echo [%date% %time%] 导出完成
timeout /t 3600
goto loop
```

### 定时导出脚本（Mac/Linux）
```bash
#!/bin/bash
while true; do
    echo "[$(date)] 开始导出..."
    adb pull /data/storage/el2/base/haps/entry/files/*.csv ./backup/
    echo "[$(date)] 导出完成"
    sleep 3600
done
```

## 数据分析

### 使用Python读取CSV
```python
import pandas as pd

# 读取CSV文件
df = pd.read_csv('账单记录_20251123_143025.csv', encoding='utf-8')

# 查看数据
print(df.head())

# 统计分析
print(df.groupby('类型')['金额'].sum())
print(df.groupby('分类')['金额'].sum())

# 导出为Excel
df.to_excel('账单分析.xlsx', index=False)
```

### 使用R读取CSV
```r
# 读取CSV文件
data <- read.csv('账单记录_20251123_143025.csv', encoding='UTF-8')

# 查看数据
head(data)

# 统计分析
aggregate(金额 ~ 类型, data, sum)
aggregate(金额 ~ 分类, data, sum)
```

## 备份建议

1. **定期备份**
   - 每周导出一次
   - 保存到云盘（Google Drive、OneDrive等）

2. **多地备份**
   - 本地电脑
   - 云存储
   - 移动硬盘

3. **版本管理**
   - 保留历史版本
   - 使用日期命名
   - 定期清理旧文件

## 总结

虽然文件保存在应用目录，但通过ADB命令可以轻松访问。建议：
1. 安装ADB工具
2. 创建批处理脚本简化操作
3. 定期导出备份
4. 使用Excel或其他工具分析数据

这样可以充分利用导出功能，进行数据分析和备份。
