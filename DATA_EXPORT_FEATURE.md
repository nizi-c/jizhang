# 数据导出功能

## 功能概述

记账应用现已支持将账单记录导出为CSV格式文件，并通过系统分享功能让用户可以保存到任意位置或分享给其他应用。

## 功能特点

### 1. CSV格式导出
- 标准CSV格式，兼容Excel、Google Sheets等工具
- 包含完整的记录信息
- 自动处理特殊字符和引号转义

### 2. 导出内容
导出的CSV文件包含以下字段：
- **日期** - 记录的日期（YYYY-MM-DD格式）
- **类型** - 收入或支出
- **分类** - 记录的分类名称
- **金额** - 记录金额（保留两位小数）
- **描述** - 记录的详细描述
- **心情** - 记录时的心情（如果有）

### 3. 智能文件命名
- 自动生成文件名：`账单记录_YYYYMMDD_HHMMSS.csv`
- 包含导出时间戳，避免文件名冲突
- 示例：`账单记录_20251123_143025.csv`

### 4. 筛选导出
- 支持导出筛选后的数据
- 可按类型、分类、金额范围、日期范围筛选
- 只导出当前筛选结果

## 使用方法

### 导出步骤

1. **打开流水页面**
   - 从主页进入"流水"页面

2. **（可选）设置筛选条件**
   - 点击右上角搜索图标 🔍
   - 设置需要的筛选条件
   - 只导出符合条件的记录

3. **点击导出按钮**
   - 点击右上角导出图标 📤
   - 系统会弹出分享选择器

4. **选择保存位置**
   - 选择"文件管理器"保存到本地
   - 或选择其他应用（如邮件、云盘）分享文件
   - 文件会以 CSV 格式保存

### 导出示例

#### 导出所有记录
```
1. 进入流水页面
2. 点击 📤 按钮
3. 等待提示"导出成功"
```

#### 导出特定月份记录
```
1. 进入流水页面
2. 使用月份选择器切换到目标月份
3. 点击 📤 按钮
4. 导出该月份的所有记录
```

#### 导出特定分类记录
```
1. 进入流水页面
2. 点击 🔍 打开筛选面板
3. 选择目标分类（如"食物"）
4. 点击 📤 按钮
5. 只导出该分类的记录
```

## CSV文件格式

### 文件结构

```csv
日期,类型,分类,金额,描述,心情
2025-11-23,支出,食物,35.50,"午餐",😊满意
2025-11-23,支出,交通,12.00,"地铁",
2025-11-22,收入,工资,5000.00,"月薪",🎉惊喜
```

### 字段说明

| 字段 | 说明 | 示例 |
|------|------|------|
| 日期 | YYYY-MM-DD格式 | 2025-11-23 |
| 类型 | 收入或支出 | 支出 |
| 分类 | 分类名称 | 食物 |
| 金额 | 保留两位小数 | 35.50 |
| 描述 | 用引号包裹，转义内部引号 | "午餐" |
| 心情 | 心情表情或空 | 😊满意 |

### 特殊字符处理

- **引号转义**：描述中的引号会被转义为两个引号
  - 原文：`他说"很好"`
  - CSV：`"他说""很好"""`

- **逗号处理**：描述用引号包裹，可以包含逗号
  - 原文：`苹果, 香蕉`
  - CSV：`"苹果, 香蕉"`

- **换行符**：描述中的换行符会被保留
  - 原文：`第一行\n第二行`
  - CSV：`"第一行\n第二行"`

## 文件保存位置

### 临时缓存
文件首先保存在应用的缓存目录：
```
/data/storage/el2/base/haps/entry/cache/账单记录_YYYYMMDD_HHMMSS.csv
```

### 用户选择保存位置
- 通过系统分享功能，用户可以选择最终保存位置
- 可以保存到文件管理器的任意目录
- 可以直接分享到其他应用（邮件、云盘等）
- 文件格式为标准 CSV，可用 Excel 等工具打开

## 技术实现

### ExportUtil 工具类

```typescript
export class ExportUtil {
  // 导出为CSV格式
  static exportToCSV(records: AccountRecord[]): string
  
  // 保存CSV文件
  static async saveCSVFile(csvContent: string, fileName: string): Promise<string>
  
  // 生成文件名
  static generateFileName(): string
}
```

### 核心方法

#### 1. exportToCSV
```typescript
static exportToCSV(records: AccountRecord[]): string {
  // CSV 表头
  const headers = ['日期', '类型', '分类', '金额', '描述', '心情'];
  let csv = headers.join(',') + '\n';

  // 添加数据行
  records.forEach(record => {
    const row = [
      record.dateStr,
      record.type === 'income' ? '收入' : '支出',
      record.category,
      record.amount.toFixed(2),
      `"${record.description.replace(/"/g, '""')}"`,
      record.mood || ''
    ];
    csv += row.join(',') + '\n';
  });

  return csv;
}
```

#### 2. saveCSVFile
```typescript
static async saveCSVFile(csvContent: string, fileName: string, context: Context): Promise<string> {
  // 使用缓存目录，这样文件可以被分享
  const cacheDir = context.cacheDir;
  const filePath = `${cacheDir}/${fileName}`;

  // 创建并写入文件
  const file = fs.openSync(filePath, fs.OpenMode.CREATE | fs.OpenMode.WRITE_ONLY | fs.OpenMode.TRUNC);
  fs.writeSync(file.fd, csvContent);
  fs.closeSync(file);

  // 转换为URI格式
  const uri = fileUri.getUriFromPath(filePath);
  
  return uri;
}
```

#### 3. generateFileName
```typescript
static generateFileName(): string {
  const now = new Date();
  const year = now.getFullYear();
  const month = String(now.getMonth() + 1).padStart(2, '0');
  const day = String(now.getDate()).padStart(2, '0');
  const hour = String(now.getHours()).padStart(2, '0');
  const minute = String(now.getMinutes()).padStart(2, '0');
  const second = String(now.getSeconds()).padStart(2, '0');
  
  return `账单记录_${year}${month}${day}_${hour}${minute}${second}.csv`;
}
```

### RecordsPage 集成

```typescript
// 导出按钮
Button({ type: ButtonType.Circle, stateEffect: true }) {
  Text('📤')
    .fontSize(18)
    .fontColor(this.getColorScheme().NAVBAR.buttonTextColor)
}
.onClick(() => {
  this.exportData();
})

// 导出方法
private async exportData() {
  if (this.filteredRecords.length === 0) {
    promptAction.showToast({
      message: '暂无数据可导出',
      duration: 2000
    });
    return;
  }

  try {
    // 生成CSV并保存到缓存
    const csvContent = ExportUtil.exportToCSV(this.filteredRecords);
    const fileName = ExportUtil.generateFileName();
    const context = getContext(this);
    const fileUri = await ExportUtil.saveCSVFile(csvContent, fileName, context);
    
    // 使用系统分享功能
    const want = {
      action: wantConstant.Action.ACTION_SEND_DATA,
      type: 'text/csv',
      uri: fileUri,
      parameters: {
        'ability.params.stream': fileUri
      }
    };
    
    await context.startAbility(want);
    
    promptAction.showToast({
      message: '请选择保存位置',
      duration: 2000
    });
  } catch (error) {
    promptAction.showToast({
      message: '导出失败，请重试',
      duration: 2000
    });
  }
}
```

## UI界面

### 导出按钮位置
```
┌─────────────────────────────────┐
│ [←]    流水    [📤] [🔍]        │
└─────────────────────────────────┘
```

### 导出流程
```
用户点击 📤
    ↓
检查是否有数据
    ↓
生成CSV内容
    ↓
保存到文件
    ↓
显示成功提示
```

## 错误处理

### 无数据提示
```typescript
if (this.filteredRecords.length === 0) {
  promptAction.showToast({
    message: '暂无数据可导出',
    duration: 2000
  });
  return;
}
```

### 导出失败处理
```typescript
try {
  // 导出逻辑
} catch (error) {
  promptAction.showToast({
    message: '导出失败，请重试',
    duration: 2000
  });
  console.error('导出失败:', error);
}
```

### 防止重复导出
```typescript
@State isExporting: boolean = false;

private async exportData() {
  if (this.isExporting) {
    return;
  }
  this.isExporting = true;
  
  try {
    // 导出逻辑
  } finally {
    this.isExporting = false;
  }
}
```

## 使用场景

### 1. 数据备份
- 定期导出数据作为备份
- 防止数据丢失
- 便于数据恢复

### 2. 数据分析
- 导出到Excel进行深度分析
- 制作自定义图表
- 进行财务规划

### 3. 数据迁移
- 更换设备时迁移数据
- 导入到其他记账应用
- 与他人分享数据

### 4. 报表生成
- 生成月度/年度报表
- 制作财务总结
- 用于报销凭证

## 扩展建议

### 1. 多格式支持
- **Excel格式** - 导出为.xlsx文件
- **JSON格式** - 便于程序处理
- **PDF格式** - 生成可打印报表

### 2. 导出选项
- **选择导出字段** - 自定义导出内容
- **导出模板** - 保存常用导出配置
- **批量导出** - 按月份批量导出

### 3. 云端同步
- **自动备份** - 定期自动导出到云端
- **多设备同步** - 在多个设备间同步数据
- **版本管理** - 保留历史版本

### 4. 数据导入
- **CSV导入** - 支持导入CSV文件
- **数据合并** - 合并多个导出文件
- **数据验证** - 导入时验证数据格式

### 5. 分享功能
- **直接分享** - 通过系统分享功能发送文件
- **邮件发送** - 直接发送到邮箱
- **云盘上传** - 上传到云存储服务

## 性能优化

### 1. 大数据处理
```typescript
// 分批处理大量数据
static exportToCSV(records: AccountRecord[]): string {
  const BATCH_SIZE = 1000;
  let csv = headers.join(',') + '\n';
  
  for (let i = 0; i < records.length; i += BATCH_SIZE) {
    const batch = records.slice(i, i + BATCH_SIZE);
    batch.forEach(record => {
      csv += this.formatRecord(record) + '\n';
    });
  }
  
  return csv;
}
```

### 2. 异步处理
```typescript
// 使用异步处理避免阻塞UI
private async exportData() {
  this.isExporting = true;
  
  // 延迟执行，让UI先更新
  setTimeout(async () => {
    try {
      await this.performExport();
    } finally {
      this.isExporting = false;
    }
  }, 100);
}
```

### 3. 进度提示
```typescript
// 显示导出进度
private async exportData() {
  promptAction.showToast({
    message: '正在导出...',
    duration: 1000
  });
  
  // 执行导出
  await this.performExport();
}
```

## 测试建议

### 功能测试
1. ✅ 测试导出所有记录
2. ✅ 测试导出筛选后的记录
3. ✅ 测试导出空数据
4. ✅ 测试文件名生成
5. ✅ 测试特殊字符处理

### 边界测试
1. ✅ 测试大量数据导出（1000+条）
2. ✅ 测试包含特殊字符的描述
3. ✅ 测试包含引号的描述
4. ✅ 测试包含逗号的描述
5. ✅ 测试包含换行符的描述

### 错误测试
1. ✅ 测试存储空间不足
2. ✅ 测试文件权限问题
3. ✅ 测试重复导出
4. ✅ 测试导出中断

## 编译状态

✅ ExportUtil.ets - 无错误
✅ RecordsPage.ets - 无错误

## 总结

数据导出功能为记账应用增加了重要的数据管理能力：

- **CSV格式** - 标准格式，兼容性好
- **完整信息** - 包含所有记录字段
- **智能命名** - 自动生成带时间戳的文件名
- **筛选导出** - 支持导出筛选后的数据
- **错误处理** - 完善的错误提示和处理
- **用户友好** - 简单易用的导出流程

用户现在可以轻松导出账单数据，进行备份、分析和迁移，大大提升了应用的实用性和数据安全性。
