# 统计卡片数据刷新修复

## 问题
添加账单后，首页的最近账单会更新，但今日收支、本月收支等统计数据不更新。

## 根本原因
ArkTS 的 @State 变量在某些情况下，即使值改变了，也不会触发 UI 刷新。这是因为：
1. 数字类型的 @State 变量改变可能不被检测到
2. 需要显式的刷新触发机制

## 解决方案

### 1. 添加强制刷新标记
在 Index.ets 中添加：
```typescript
@State refreshTrigger: number = 0;  // 强制刷新标记
```

### 2. 在 updateSummary 中增加刷新标记
```typescript
updateSummary() {
  const today = this.viewModel.getTodaySummary();
  this.todayIncome = today.income;
  this.todayExpense = today.expense;

  const month = this.viewModel.getMonthSummary();
  this.monthIncome = month.income;
  this.monthExpense = month.expense;
  
  // 强制刷新 UI
  this.refreshTrigger = this.refreshTrigger + 1;
}
```

### 3. 在 UI 元素上使用 key
```typescript
Text(`¥${income.toFixed(2)}`)
  .key(`income_${this.refreshTrigger}`)

Text(`¥${expense.toFixed(2)}`)
  .key(`expense_${this.refreshTrigger}`)

Text(`¥${(income - expense).toFixed(2)}`)
  .key(`balance_${this.refreshTrigger}`)
```

## 工作原理

当 `refreshTrigger` 改变时：
1. 所有使用 `key` 的 UI 元素会被重新创建
2. 这强制 ArkTS 重新渲染这些元素
3. 新的数据值会被显示出来

## 数据流程

```
添加账单
    ↓
保存数据
    ↓
发送 RECORDS_CHANGED 事件
    ↓
返回首页
    ↓
onPageShow / onWindowFocusChanged 触发
    ↓
loadRecords() 加载最新数据
    ↓
updateSummary() 计算统计数据
    ↓
refreshTrigger 增加 1
    ↓
所有使用 key 的 UI 元素重新渲染
    ↓
显示最新的统计数据
```

## 验证

1. 打开首页，记录当前的今日收支数据
2. 添加一条新账单
3. 返回首页
4. 检查：
   - ✅ 最近账单列表已更新
   - ✅ 今日收支数据已更新
   - ✅ 本月收支数据已更新

## 日志输出

查看开发者工具日志，应该看到：
```
Index: 统计数据已更新 - 今日收入: X 支出: Y 刷新标记: Z
```

刷新标记 (Z) 应该在每次更新时增加。
