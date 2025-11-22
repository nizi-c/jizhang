# 收支记账APP - 项目指南

## 项目概述

这是一个使用ArkTS语言开发的HarmonyOS收支记账应用，实现了完整的记账功能，包括记录管理、数据统计、灵活查询等功能。

## 快速开始

### 环境要求
- HarmonyOS DevEco Studio 4.0+
- ArkTS SDK
- Node.js 14+

### 项目编译运行

1. **打开项目**
   ```bash
   # 在DevEco Studio中打开项目目录
   ```

2. **安装依赖**
   ```bash
   # 项目已包含所需依赖，无需额外安装
   ```

3. **编译运行**
   ```bash
   # 在DevEco Studio中点击Run按钮
   # 或使用命令行
   hvigor build
   ```

## 功能详解

### 1. 首页（Home Tab）

**功能特点：**
- 显示今日收支总额和结余
- 显示本月收支总额和结余
- 列出最近5条交易记录
- 快速添加按钮

**实现文件：** `entry/src/main/ets/pages/Index.ets`

**关键代码：**
```typescript
// 获取今日统计
const today = this.viewModel.getTodaySummary();
this.todayIncome = today.income;
this.todayExpense = today.expense;

// 获取本月统计
const month = this.viewModel.getMonthSummary();
this.monthIncome = month.income;
this.monthExpense = month.expense;
```

### 2. 流水记录（List Tab）

**功能特点：**
- 显示所有交易记录
- 支持侧滑删除
- 显示分类、金额、用途、日期
- 实时更新统计数据

**实现文件：** `entry/src/main/ets/pages/Index.ets`

**关键代码：**
```typescript
// 侧滑删除实现
Swiper() {
  this.buildRecordItem(record)
  Button('删除')
    .onClick(() => {
      this.viewModel.deleteRecord(record.id);
      this.records = this.records.filter(r => r.id !== record.id);
      this.saveRecords();
      this.updateSummary();
    })
}
```

### 3. 统计图表（Statistics Tab）

**功能特点：**
- 月份切换功能
- 支出分类分布展示
- 收入分类分布展示
- 进度条图表展示
- 详细金额统计

**实现文件：** `entry/src/main/ets/pages/ChartPage.ets`

**关键代码：**
```typescript
// 获取分类汇总
let expenseCategories = this.viewModel.getCategorySummary('expense', this.selectedMonth);

// 显示进度条
Progress({
  value: item.percentage,
  total: 100,
  type: ProgressType.Linear
})
```

### 4. 查询功能（Query Tab）

**功能特点：**
- 交易类型筛选（全部/支出/收入）
- 分类筛选
- 金额范围筛选
- 日期范围筛选
- 多条件组合查询

**实现文件：** `entry/src/main/ets/pages/QueryPage.ets`

**关键代码：**
```typescript
// 执行查询
performQuery() {
  const filters: any = {};
  if (this.queryType !== 'all') {
    filters.type = this.queryType;
  }
  if (this.selectedCategory) {
    filters.category = this.selectedCategory;
  }
  // ... 其他筛选条件
  this.queryResults = this.viewModel.queryRecords(filters);
}
```

### 5. 添加记录对话框

**功能特点：**
- 交易类型选择
- 可视化分类选择
- 金额输入
- 用途描述
- 日期选择

**实现文件：** `entry/src/main/ets/pages/AddRecordDialog.ets`

**关键代码：**
```typescript
// 保存记录
saveRecord() {
  const record: AccountRecord = {
    id: StorageUtil.generateId(),
    type: this.recordType,
    category: this.selectedCategory,
    amount: parseFloat(this.amount),
    description: this.description,
    date: DateUtil.parseDate(this.selectedDate),
    dateStr: this.selectedDate
  };
  this.records.unshift(record);
  StorageUtil.saveRecords(this.records);
}
```

## 核心模块说明

### 数据模型（Models）

**文件：** `entry/src/main/ets/models/AccountRecord.ets`

定义了应用中使用的所有数据结构：
- `AccountRecord` - 单条交易记录
- `CategoryItem` - 分类信息
- `DailySummary` - 日统计
- `MonthlySummary` - 月统计
- `CategorySummary` - 分类统计

### 视图模型（ViewModel）

**文件：** `entry/src/main/ets/viewmodel/AccountViewModel.ets`

处理所有业务逻辑：
- 记录的增删改查
- 数据统计和汇总
- 数据分组和分类
- 灵活查询

**主要方法：**
```typescript
addRecord(record)              // 添加记录
deleteRecord(id)               // 删除记录
getTodaySummary()              // 获取今日统计
getMonthSummary()              // 获取本月统计
getMonthlySummaries()          // 获取月度汇总
getCategorySummary()           // 获取分类汇总
queryRecords(filters)          // 按条件查询
```

### 工具类（Utils）

#### StorageUtil - 本地存储
```typescript
// 保存记录
await StorageUtil.saveRecords(records);

// 读取记录
const records = await StorageUtil.getRecords();

// 生成唯一ID
const id = StorageUtil.generateId();
```

#### DateUtil - 日期处理
```typescript
// 格式化日期
DateUtil.formatDate(timestamp)        // YYYY-MM-DD
DateUtil.formatDateTime(timestamp)    // YYYY-MM-DD HH:mm

// 获取时间段字符串
DateUtil.getMonthStr(timestamp)       // YYYY-MM
DateUtil.getWeekStr(timestamp)        // YYYY-Www
DateUtil.getYearStr(timestamp)        // YYYY

// 日期判断
DateUtil.isToday(timestamp)           // 是否是今天
DateUtil.isThisMonth(timestamp)       // 是否是本月
```

### 常量定义（Constants）

**文件：** `entry/src/main/ets/constants/Constants.ets`

定义了应用中使用的所有常量：
- 支出分类列表
- 收入分类列表
- 颜色方案

## 数据流程

### 添加记录流程
```
用户点击"+"按钮
    ↓
打开AddRecordDialog对话框
    ↓
用户填写记录信息
    ↓
点击"保存"按钮
    ↓
创建AccountRecord对象
    ↓
调用StorageUtil.saveRecords()保存到本地
    ↓
更新viewModel中的records列表
    ↓
更新首页的统计数据
    ↓
关闭对话框
```

### 查询流程
```
用户设置查询条件
    ↓
点击"查询"按钮
    ↓
调用viewModel.queryRecords(filters)
    ↓
返回符合条件的记录列表
    ↓
显示查询结果
```

## 状态管理

应用使用ArkUI的@State装饰器进行状态管理：

```typescript
@State records: AccountRecord[] = [];           // 所有记录
@State todayIncome: number = 0;                // 今日收入
@State todayExpense: number = 0;               // 今日支出
@State monthIncome: number = 0;                // 本月收入
@State monthExpense: number = 0;               // 本月支出
@State viewModel: AccountViewModel = new AccountViewModel();  // 业务逻辑
```

## 性能优化

1. **数据缓存**：使用viewModel缓存数据，避免重复计算
2. **列表优化**：使用ForEach的key参数优化列表渲染
3. **异步操作**：使用async/await处理本地存储操作
4. **条件渲染**：使用if语句避免渲染不必要的组件

## 测试建议

### 功能测试
1. 测试添加各种类型的记录
2. 测试删除记录功能
3. 测试统计数据的准确性
4. 测试查询功能的各种条件组合
5. 测试月份切换功能

### 边界测试
1. 测试空数据情况
2. 测试大金额输入
3. 测试日期边界（月初、月末）
4. 测试查询无结果的情况

### 性能测试
1. 测试大量数据（1000+条记录）的加载速度
2. 测试列表滚动的流畅度
3. 测试查询的响应时间

## 常见问题

### Q: 数据会丢失吗？
A: 不会。所有数据都保存在本地Preferences中，应用卸载时数据会被清除。

### Q: 支持多账户吗？
A: 当前版本不支持，所有数据都保存在同一个账户中。

### Q: 可以导出数据吗？
A: 当前版本不支持导出，这是后续版本的计划功能。

### Q: 支持离线使用吗？
A: 支持。应用完全离线运行，不需要网络连接。

## 扩展建议

1. **云同步**：添加云端备份和多设备同步功能
2. **预算管理**：设置月度预算并提醒
3. **更多图表**：添加折线图、柱状图等
4. **数据分析**：提供趋势分析和预测
5. **标签系统**：为记录添加自定义标签
6. **重复记录**：支持定期自动记录
7. **账户管理**：支持多个账户
8. **数据导出**：支持导出为CSV/Excel

## 文件清单

```
entry/src/main/ets/
├── models/
│   └── AccountRecord.ets              # 数据模型
├── viewmodel/
│   └── AccountViewModel.ets           # 业务逻辑
├── utils/
│   ├── StorageUtil.ets                # 本地存储
│   ├── DateUtil.ets                   # 日期处理
│   └── MockData.ets                   # 模拟数据
├── constants/
│   └── Constants.ets                  # 常量定义
└── pages/
    ├── Index.ets                      # 主页面
    ├── AddRecordDialog.ets            # 添加对话框
    ├── QueryPage.ets                  # 查询页面
    └── ChartPage.ets                  # 统计页面
```

## 许可证

本项目为学习项目，可自由使用和修改。

## 联系方式

如有问题或建议，欢迎反馈。
