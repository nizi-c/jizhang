# 公共目录导出功能

## 功能概述

记账应用现在支持将CSV文件导出到公共Documents目录，用户可以通过文件管理器直接访问导出的文件。

## 权限说明

### 需要的权限
- `ohos.permission.WRITE_MEDIA` - 写入媒体文件权限
- `ohos.permission.READ_MEDIA` - 读取媒体文件权限

### 权限用途
- 将CSV文件保存到公共Documents目录
- 用户可以通过文件管理器访问导出的文件
- 不需要root权限或ADB命令

## 使用流程

### 1. 首次导出
1. 打开"流水"页面
2. 点击右上角 📤 导出按钮
3. 系统弹出权限请求对话框
4. 点击"允许"授予存储权限
5. 文件自动保存到Documents目录
6. 显示成功提示

### 2. 后续导出
1. 点击 📤 导出按钮
2. 直接保存到Documents目录（已有权限）
3. 显示成功提示

### 3. 拒绝权限
1. 如果用户拒绝权限
2. 文件会保存到应用缓存目录
3. 提示用户可以授予权限以保存到Documents目录

## 文件位置

### 有权限（推荐）
```
/storage/media/100/local/files/Documents/账单记录_YYYYMMDD_HHMMSS.csv
```
用户可以通过文件管理器的"Documents"文件夹直接访问

### 无权限（降级）
```
/data/storage/el2/base/haps/entry/cache/账单记录_YYYYMMDD_HHMMSS.csv
```
需要ADB命令或root权限访问

## 访问导出的文件

### 方法1：文件管理器（推荐）
1. 打开系统文件管理器
2. 进入"Documents"文件夹
3. 找到以"账单记录_"开头的CSV文件
4. 可以直接打开、分享或复制

### 方法2：第三方文件管理器
1. 安装第三方文件管理器（如ES文件浏览器）
2. 导航到Documents目录
3. 找到导出的CSV文件

### 方法3：连接电脑
1. 使用USB连接手机和电脑
2. 选择"文件传输"模式
3. 在电脑上打开手机存储
4. 进入Documents文件夹
5. 复制CSV文件到电脑

## 权限管理

### 授予权限
- 首次导出时会自动请求权限
- 点击"允许"即可授予

### 撤销权限
1. 打开系统设置
2. 进入"应用管理"
3. 找到记账应用
4. 点击"权限"
5. 关闭"存储"权限

### 重新授予权限
1. 撤销权限后再次导出
2. 系统会再次请求权限
3. 点击"允许"重新授予

## 技术实现

### 权限声明（module.json5）
```json
"requestPermissions": [
  {
    "name": "ohos.permission.WRITE_MEDIA",
    "reason": "$string:permission_write_media_reason",
    "usedScene": {
      "abilities": ["EntryAbility"],
      "when": "inuse"
    }
  },
  {
    "name": "ohos.permission.READ_MEDIA",
    "reason": "$string:permission_read_media_reason",
    "usedScene": {
      "abilities": ["EntryAbility"],
      "when": "inuse"
    }
  }
]
```

### 权限请求（PermissionUtil）
```typescript
static async requestStoragePermissions(context: common.UIAbilityContext): Promise<boolean> {
  const permissions: Array<Permissions> = [
    'ohos.permission.WRITE_MEDIA',
    'ohos.permission.READ_MEDIA'
  ];

  const atManager = abilityAccessCtrl.createAtManager();
  
  // 检查权限
  const writeGranted = await atManager.checkAccessToken(
    context.applicationInfo.accessTokenId,
    'ohos.permission.WRITE_MEDIA'
  );
  
  if (writeGranted === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED) {
    return true;
  }

  // 请求权限
  const result = await atManager.requestPermissionsFromUser(context, permissions);
  return result.authResults.every(status => 
    status === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED
  );
}
```

### 保存到公共目录（ExportUtil）
```typescript
static async saveToPublicDirectory(csvContent: string, fileName: string): Promise<string> {
  const documentsPath = '/storage/media/100/local/files/Documents';
  const filePath = `${documentsPath}/${fileName}`;

  const file = fs.openSync(filePath, fs.OpenMode.CREATE | fs.OpenMode.WRITE_ONLY | fs.OpenMode.TRUNC);
  fs.writeSync(file.fd, csvContent);
  fs.closeSync(file);
  
  return filePath;
}
```

### 导出流程（RecordsPage）
```typescript
private async exportData() {
  // 1. 生成CSV内容
  const csvContent = ExportUtil.exportToCSV(this.filteredRecords);
  const fileName = ExportUtil.generateFileName();
  
  // 2. 请求权限
  const context = getContext(this) as common.UIAbilityContext;
  const hasPermission = await PermissionUtil.requestStoragePermissions(context);
  
  // 3. 保存文件
  if (hasPermission) {
    // 保存到公共Documents目录
    filePath = await ExportUtil.saveToPublicDirectory(csvContent, fileName);
  } else {
    // 降级到缓存目录
    filePath = await ExportUtil.saveCSVFile(csvContent, fileName, context);
  }
}
```

## 优势对比

### 公共目录（有权限）
✅ 用户可以直接访问
✅ 通过文件管理器查看
✅ 可以直接分享给其他应用
✅ 连接电脑可以直接复制
✅ 不会被系统清理

### 缓存目录（无权限）
❌ 用户无法直接访问
❌ 需要ADB命令
❌ 可能被系统清理
✅ 不需要权限
✅ 适合临时文件

## 用户体验

### 权限授予后
```
导出成功！共50条记录
已保存到Documents目录
文件：账单记录_20251123_143025.csv
```

### 权限拒绝后
```
导出成功！共50条记录
已保存到应用缓存目录
文件：账单记录_20251123_143025.csv

提示：授予存储权限可保存到Documents目录
```

## 安全性

### 权限最小化
- 只请求必要的存储权限
- 不请求其他敏感权限
- 权限用途明确说明

### 数据保护
- 导出的文件只包含用户自己的数据
- 文件保存在用户可控的位置
- 用户可以随时删除导出的文件

### 隐私保护
- 不上传数据到服务器
- 不访问其他应用的数据
- 只在用户主动导出时才保存文件

## 常见问题

### Q: 为什么需要存储权限？
A: 为了将文件保存到公共Documents目录，让用户可以直接访问导出的文件。

### Q: 不授予权限可以导出吗？
A: 可以。文件会保存到应用缓存目录，但需要ADB命令才能访问。

### Q: 导出的文件会占用很多空间吗？
A: 不会。CSV是文本格式，1000条记录大约只有100KB。

### Q: 可以导出到SD卡吗？
A: 当前版本保存到内部存储的Documents目录。SD卡支持可以在后续版本添加。

### Q: 文件会被其他应用访问吗？
A: Documents是公共目录，其他有存储权限的应用可以访问。建议导出后及时备份并删除。

### Q: 如何批量导出多个月的数据？
A: 使用筛选功能设置日期范围，然后导出。或者不设置筛选条件导出所有数据。

## 测试建议

### 功能测试
1. ✅ 首次导出，授予权限
2. ✅ 首次导出，拒绝权限
3. ✅ 有权限时导出
4. ✅ 撤销权限后导出
5. ✅ 重新授予权限后导出

### 文件验证
1. ✅ 检查Documents目录是否有文件
2. ✅ 用文件管理器打开文件
3. ✅ 用Excel打开文件验证内容
4. ✅ 检查文件编码是否正确

### 边界测试
1. ✅ 导出0条记录
2. ✅ 导出大量记录（1000+）
3. ✅ 存储空间不足时导出
4. ✅ 重复导出多次

## 总结

通过添加存储权限和公共目录保存功能，用户现在可以：
- 直接通过文件管理器访问导出的CSV文件
- 不需要ADB命令或root权限
- 轻松分享或备份账单数据
- 连接电脑直接复制文件

这大大提升了导出功能的实用性和用户体验！
