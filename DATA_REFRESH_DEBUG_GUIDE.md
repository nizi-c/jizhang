# 数据刷新调试指南

## 问题诊断

如果添加账单后首页数据仍不更新，请按以下步骤调试：

### 1. 检查日志输出

在开发者工具中查看以下日志序列：

```
AddRecordPage: 记录已保存，总数: X
AddRecordPage: 发送 RECORDS_CHANGED 事件
AddRecordPage: 返回首页
Index: onPageShow 触发，重新加载数据
Index: 收到 RECORDS_CHANGED 事件，重新加载数据
Index: 数据已加载，记录数: X 今日收入: Y 支出: Z
Index: 统计数据已更新 - 今日收入: Y 支出: Z
```

### 2. 关键改进点

**改进 1：移除 async/await**
- 原因：ArkTS 中 onPageShow 可能不支持 async
- 改进：使用 Promise.then() 替代 async/await

**改进 2：增加延迟时间**
- 原因：1200ms 给足够时间让事件处理和 UI 更新
- 改进：从 800ms 增加到 1200ms

**改进 3：使用 Promise 链**
- 原因：确保异步操作完成后再更新 UI
- 改进：loadRecords 和 loadCurrentBook 使用 .then()

### 3. 数据流程验证

```
保存数据到存储
    ↓
发送 RECORDS_CHANGED 事件
    ↓
延迟 1200ms
    ↓
返回首页 (router.back)
    ↓
onPageShow 触发
    ↓
loadRecords() 从存储读取最新数据
    ↓
更新 this.records 数组引用
    ↓
调用 updateSummary() 计算统计数据
    ↓
更新 @State 变量 (todayIncome, todayExpense 等)
    ↓
UI 自动刷新显示新数据
```

### 4. 如果仍然不更新

检查以下几点：

1. **StorageUtil.getRecords() 是否返回最新数据？**
   - 在 loadRecords 中添加日志：`console.log('读取的记录:', newRecords);`

2. **updateSummary() 是否正确计算？**
   - 检查 AccountViewModel 的 getTodaySummary() 和 getMonthSummary()

3. **@State 变量是否正确声明？**
   - 确保 todayIncome, todayExpense 等都是 @State 变量

4. **UI 是否正确绑定这些变量？**
   - 检查 buildStatCard 中是否使用了这些变量

### 5. 强制刷新方案

如果上述方案仍不工作，可以尝试：

```typescript
// 在 Index.ets 中添加
@State refreshTrigger: number = 0;

loadRecords() {
  StorageUtil.getRecords().then((newRecords: AccountRecord[]) => {
    this.records = [...newRecords];
    this.viewModel.records = this.records;
    this.updateSummary();
    // 强制刷新
    this.refreshTrigger = this.refreshTrigger + 1;
  });
}
```

然后在 UI 中使用：
```typescript
Text(`¥${this.todayIncome.toFixed(2)}`)
  .key(this.refreshTrigger.toString())
```
