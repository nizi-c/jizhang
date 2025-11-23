# DocumentPicker 导出功能

## 功能说明

使用 HarmonyOS 的 DocumentPicker API，让用户可以选择保存位置，文件可以直接在文件管理器中访问。

## 用户体验

### 导出流程

1. **点击导出按钮**
   - 在流水页面点击右上角 📤 按钮

2. **选择保存位置**
   - 系统弹出文件选择器
   - 用户可以选择保存位置：
     - 下载目录
     - 文档目录
     - 任意文件夹
     - SD卡（如果有）

3. **确认文件名**
   - 默认文件名：`账单记录_YYYYMMDD_HHMMSS.csv`
   - 用户可以修改文件名

4. **保存完成**
   - 显示成功提示
   - 文件保存到用户选择的位置

### 取消保存

如果用户取消保存：
- 文件会自动保存到应用缓存目录
- 显示提示：已保存到应用缓存目录
- 可以通过ADB命令访问

## 优势

### ✅ 用户友好
- 用户可以选择保存位置
- 可以自定义文件名
- 直接在文件管理器中访问

### ✅ 灵活性高
- 可以保存到任意目录
- 可以保存到SD卡
- 可以保存到云盘同步文件夹

### ✅ 无需权限
- 不需要申请存储权限
- 系统自动处理权限
- 更安全可靠

### ✅ 标准化
- 使用系统标准API
- 符合HarmonyOS设计规范
- 与其他应用体验一致

## 技术实现

### DocumentPicker API

```typescript
import { picker } from '@kit.CoreFileKit';

// 创建保存选项
const documentSaveOptions = new picker.DocumentSaveOptions();
documentSaveOptions.newFileNames = [fileName];

// 创建DocumentPicker
const documentPicker = new picker.DocumentViewPicker();

// 打开保存对话框
const documentSaveResult: Array<string> = await documentPicker.save(documentSaveOptions);

// 获取URI
const uri = documentSaveResult[0];

// 写入文件
const file = fs.openSync(uri, fs.OpenMode.READ_WRITE);
fs.writeSync(file.fd, csvContent);
fs.closeSync(file);
```

### ExportUtil 实现

```typescript
static async saveToPublicDirectory(
  csvContent: string, 
  fileName: string, 
  context: common.UIAbilityContext
): Promise<string> {
  try {
    // 创建DocumentPicker保存选项
    const documentSaveOptions = new picker.DocumentSaveOptions();
    documentSaveOptions.newFileNames = [fileName];
    
    // 创建DocumentPicker
    const documentPicker = new picker.DocumentViewPicker();
    
    // 打开保存对话框
    const documentSaveResult: Array<string> = await documentPicker.save(documentSaveOptions);
    
    if (documentSaveResult && documentSaveResult.length > 0) {
      const uri = documentSaveResult[0];
      
      // 写入文件
      const file = fs.openSync(uri, fs.OpenMode.READ_WRITE);
      fs.writeSync(file.fd, csvContent);
      fs.closeSync(file);
      
      return uri;
    } else {
      throw new Error('用户取消了保存');
    }
  } catch (err) {
    throw err;
  }
}
```

### RecordsPage 集成

```typescript
private async exportData() {
  try {
    // 生成CSV内容
    const csvContent = ExportUtil.exportToCSV(this.filteredRecords);
    const fileName = ExportUtil.generateFileName();
    const context = getContext(this) as common.UIAbilityContext;
    
    // 使用DocumentPicker保存
    const fileUri = await ExportUtil.saveToPublicDirectory(csvContent, fileName, context);
    
    promptAction.showToast({
      message: `导出成功！共${this.filteredRecords.length}条记录\n文件已保存到您选择的位置`,
      duration: 3000
    });
  } catch (saveError) {
    // 降级到缓存目录
    const filePath = await ExportUtil.saveCSVFile(csvContent, fileName, context);
    
    promptAction.showToast({
      message: `导出成功！已保存到应用缓存目录`,
      duration: 3000
    });
  }
}
```

## 使用场景

### 场景1：保存到下载目录
1. 点击导出按钮
2. 在文件选择器中选择"下载"
3. 确认文件名
4. 点击保存
5. 在文件管理器的"下载"文件夹中查看

### 场景2：保存到文档目录
1. 点击导出按钮
2. 在文件选择器中选择"文档"
3. 确认文件名
4. 点击保存
5. 在文件管理器的"文档"文件夹中查看

### 场景3：保存到自定义文件夹
1. 点击导出按钮
2. 在文件选择器中导航到目标文件夹
3. 确认文件名
4. 点击保存
5. 在该文件夹中查看

### 场景4：保存到云盘同步文件夹
1. 点击导出按钮
2. 选择云盘同步文件夹（如百度网盘、OneDrive）
3. 确认文件名
4. 点击保存
5. 文件自动同步到云端

## 文件访问

### 在手机上
1. 打开文件管理器
2. 导航到保存位置
3. 找到CSV文件
4. 点击打开或分享

### 在电脑上
1. USB连接手机
2. 打开手机存储
3. 导航到保存位置
4. 复制文件到电脑

### 通过云盘
1. 如果保存到云盘同步文件夹
2. 在电脑上打开云盘
3. 文件自动同步
4. 直接下载使用

## 错误处理

### 用户取消保存
```typescript
catch (saveError) {
  // 降级到缓存目录
  const filePath = await ExportUtil.saveCSVFile(csvContent, fileName, context);
  
  promptAction.showToast({
    message: '已保存到应用缓存目录',
    duration: 3000
  });
}
```

### 保存失败
- 自动降级到应用缓存目录
- 显示友好提示
- 记录错误日志

## 与旧方案对比

### 旧方案（直接保存）
❌ 需要申请存储权限
❌ 固定保存位置
❌ 用户难以找到文件
❌ 可能被系统清理

### 新方案（DocumentPicker）
✅ 无需申请权限
✅ 用户选择保存位置
✅ 文件易于访问
✅ 不会被系统清理
✅ 符合系统设计规范

## 常见问题

### Q: 为什么不需要存储权限了？
A: DocumentPicker 是系统提供的标准API，系统会自动处理权限，应用不需要申请。

### Q: 用户可以保存到哪些位置？
A: 用户可以保存到任意有权限的位置，包括：
- 下载目录
- 文档目录
- 自定义文件夹
- SD卡
- 云盘同步文件夹

### Q: 如果用户取消保存会怎样？
A: 文件会自动保存到应用缓存目录，确保数据不丢失。

### Q: 可以修改默认文件名吗？
A: 可以。在保存对话框中，用户可以修改文件名。

### Q: 文件会被系统清理吗？
A: 不会。保存到用户选择的位置后，文件由用户管理，不会被系统自动清理。

## 测试建议

### 功能测试
1. ✅ 测试保存到下载目录
2. ✅ 测试保存到文档目录
3. ✅ 测试保存到自定义文件夹
4. ✅ 测试修改文件名
5. ✅ 测试取消保存

### 边界测试
1. ✅ 测试存储空间不足
2. ✅ 测试文件名冲突
3. ✅ 测试特殊字符文件名
4. ✅ 测试大文件导出

### 用户体验测试
1. ✅ 测试文件选择器界面
2. ✅ 测试保存成功提示
3. ✅ 测试取消保存提示
4. ✅ 测试文件访问

## 总结

使用 DocumentPicker API 是 HarmonyOS 推荐的文件保存方式：

✅ **用户体验好**
- 用户可以选择保存位置
- 文件易于访问和管理
- 符合用户习惯

✅ **开发简单**
- 无需申请权限
- API简单易用
- 错误处理完善

✅ **安全可靠**
- 系统自动处理权限
- 文件不会丢失
- 符合安全规范

这是目前最佳的文件导出方案！
