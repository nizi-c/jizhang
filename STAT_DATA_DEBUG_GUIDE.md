# 统计数据不更新调试指南

## 问题现象
- 最近记录能更新
- 但今日收支、本月收支不更新

## 调试步骤

### 1. 查看完整日志序列

添加账单后，在开发者工具中查看日志，应该看到：

```
Index: 数据已加载，记录数: X 今日收入: Y 支出: Z
Index: updateSummary 被调用，ViewModel 中的记录数: X
ViewModel: getTodaySummary - 今天日期: 2024-XX-XX 总记录数: X
ViewModel: 检查记录 - dateStr: 2024-XX-XX type: expense amount: 100
ViewModel: getTodaySummary 结果 - 收入: 0 支出: 100
Index: 今日统计 - 收入: 0 支出: 100
Index: 统计数据已更新 - 今日收入: 0 支出: 100 本月收入: 0 支出: 100 刷新标记: X
```

### 2. 可能的问题

#### 问题 A：ViewModel 中的记录数为 0
**症状**：
```
Index: updateSummary 被调用，ViewModel 中的记录数: 0
```

**原因**：`this.viewModel.records = this.records` 没有正确执行

**解决**：检查 loadRecords 中是否正确赋值

#### 问题 B：dateStr 格式不匹配
**症状**：
```
ViewModel: 检查记录 - dateStr: 2024-12-25 type: expense amount: 100
ViewModel: getTodaySummary - 今天日期: 2024-12-26 总记录数: 1
ViewModel: getTodaySummary 结果 - 收入: 0 支出: 0
```

**原因**：记录的日期和今天日期不匹配

**解决**：检查 AddRecordPage 中保存的日期是否正确

#### 问题 C：updateSummary 没有被调用
**症状**：
```
Index: 数据已加载，记录数: X
// 没有看到 "updateSummary 被调用" 的日志
```

**原因**：loadRecords 中的 Promise 没有正确执行

**解决**：检查 StorageUtil.getRecords() 是否返回了数据

### 3. 验证数据流

运行以下测试：

1. **打开首页**
   - 查看日志中的初始记录数
   - 记录当前的今日收支数据

2. **添加一条今天的账单**
   - 金额：100 元
   - 日期：今天
   - 类型：支出

3. **返回首页**
   - 查看完整的日志输出
   - 检查 ViewModel 中的记录数是否增加
   - 检查 dateStr 是否匹配
   - 检查统计结果是否正确

### 4. 关键检查点

| 检查项 | 预期结果 | 实际结果 |
|------|--------|--------|
| 最近记录是否更新 | ✅ 是 | ? |
| ViewModel 记录数 | > 0 | ? |
| dateStr 格式 | YYYY-MM-DD | ? |
| getTodaySummary 结果 | > 0 | ? |
| updateSummary 被调用 | ✅ 是 | ? |
| refreshTrigger 增加 | ✅ 是 | ? |
| UI 显示新数据 | ✅ 是 | ? |

### 5. 如果仍然不工作

#### 方案 A：检查 dateStr 的生成
在 AddRecordPage 中添加日志：
```typescript
console.log('AddRecordPage: 保存的日期:', this.selectedDate);
```

#### 方案 B：检查 StorageUtil 的数据隔离
在 StorageUtil 中添加日志：
```typescript
static async getRecords(): Promise<AccountRecord[]> {
  const key = StorageUtil.getCurrentBookKey();
  console.log('StorageUtil: 读取 key:', key);
  // ...
}
```

#### 方案 C：强制同步更新
在 loadRecords 中改为同步调用：
```typescript
loadRecords() {
  const newRecords = StorageUtil.getRecordsSync();  // 如果有同步方法
  this.records = [...newRecords];
  this.viewModel.records = this.records;
  this.updateSummary();
}
```

## 预期的日志输出示例

```
Index: onPageShow 触发，重新加载数据
Index: 数据已加载，记录数: 5 今日收入: 0 支出: 0
Index: updateSummary 被调用，ViewModel 中的记录数: 5
ViewModel: getTodaySummary - 今天日期: 2024-12-26 总记录数: 5
ViewModel: 检查记录 - dateStr: 2024-12-25 type: expense amount: 50
ViewModel: 检查记录 - dateStr: 2024-12-26 type: expense amount: 100
ViewModel: 检查记录 - dateStr: 2024-12-24 type: income amount: 200
ViewModel: 检查记录 - dateStr: 2024-12-26 type: expense amount: 50
ViewModel: 检查记录 - dateStr: 2024-12-23 type: expense amount: 30
ViewModel: getTodaySummary 结果 - 收入: 0 支出: 150
Index: 今日统计 - 收入: 0 支出: 150
ViewModel: getMonthSummary - 本月: 2024-12 总记录数: 5
ViewModel: getMonthSummary 结果 - 收入: 200 支出: 230
Index: 本月统计 - 收入: 200 支出: 230
Index: 统计数据已更新 - 今日收入: 0 支出: 150 本月收入: 200 支出: 230 刷新标记: 1
```

## 总结

通过查看日志，可以快速定位问题：
- 如果 ViewModel 记录数为 0 → 数据没有传递给 ViewModel
- 如果 dateStr 不匹配 → 日期格式或保存有问题
- 如果统计结果为 0 → 日期比较逻辑有问题
- 如果 refreshTrigger 没有增加 → updateSummary 没有被调用
