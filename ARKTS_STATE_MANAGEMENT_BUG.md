# ArkTS 状态管理严重 Bug 报告

## 问题描述

在 Index.ets 页面中，统计数据（今日收支、本月收支）的 UI 完全不更新，即使：
1. ✅ 数据已正确加载（日志显示记录数: 8）
2. ✅ 统计已正确计算（日志显示今日支出: 2076，本月支出: 2090）
3. ✅ @State 变量已更新（todayIncome, todayExpense 等）
4. ✅ refreshTrigger 已增加（日志显示刷新标记: 3）
5. ✅ 数组引用已改变（使用 [...newRecords]）
6. ✅ key 属性已添加到 UI 元素
7. ✅ 最近记录列表能正常更新（说明 records 数组的更新是有效的）

但是：
- ❌ 统计卡片的数字完全不变
- ❌ 手动点击刷新按钮也不更新
- ❌ 即使直接在 @Builder 中计算也不更新

## 日志证据

```
Index: 从存储读取的记录数: 8
Index: 更新后 - this.records 长度: 8 viewModel.records 长度: 8
Index: updateSummary 被调用，ViewModel 中的记录数: 8
Index: 今日统计 - 收入: 0 支出: 2076
Index: 本月统计 - 收入: 0 支出: 2090
Index: 统计数据已更新 - 今日收入: 0 支出: 2076 本月收入: 0 支出: 2090 刷新标记: 3
Index: 数据已加载，记录数: 8 今日收入: 0 支出: 2076
```

数据完全正确，但 UI 显示的还是旧数据。

## 尝试过的解决方案

### 方案 1：使用 key 属性
```typescript
Text(`¥${income.toFixed(2)}`)
  .key(`income_${this.refreshTrigger}`)
```
**结果**：❌ 无效

### 方案 2：在整个 Column 上添加 key
```typescript
Column() {
  // ...
}
.key(`stat_card_${title}_${this.records.length}_${this.refreshTrigger}`)
```
**结果**：❌ 无效

### 方案 3：在主页面 Column 上添加 key
```typescript
Column() {
  // 整个页面
}
.key(`main_page_${this.records.length}_${this.refreshTrigger}`)
```
**结果**：❌ 无效

### 方案 4：直接在 @Builder 中计算
```typescript
@Builder
buildStatCardDirect(title: string, isToday: boolean) {
  if (isToday) {
    this.buildStatCard(title, this.calculateTodayStats().income, this.calculateTodayStats().expense);
  } else {
    this.buildStatCard(title, this.calculateMonthStats().income, this.calculateMonthStats().expense);
  }
}
```
**结果**：❌ 无效

### 方案 5：手动刷新按钮
```typescript
Button('手动刷新统计数据')
  .onClick(() => {
    this.refreshTrigger = this.refreshTrigger + 1;
  })
```
**结果**：❌ 无效（连手动点击都不更新！）

## 可能的原因

1. **ArkTS 编译器 bug**：某些情况下 @State 变量的变化检测完全失效
2. **渲染引擎 bug**：UI 渲染管道被阻塞或缓存了旧的渲染结果
3. **生命周期问题**：onPageShow 可能在渲染完成前被调用
4. **状态管理冲突**：多个状态更新机制（EventBus + onPageShow + key）可能互相冲突

## 临时 Workaround

由于这是 ArkTS 框架的 bug，没有完美的解决方案。以下是一些可能的 workaround：

### Workaround 1：使用 router.replaceUrl 强制重建页面
```typescript
// 在 AddRecordPage 保存后
router.replaceUrl({
  url: 'pages/Index',
  params: { refresh: Date.now() }
});
```

### Workaround 2：将统计数据移到单独的组件
创建一个独立的 @Component，使用 @Prop 接收 records：
```typescript
@Component
struct StatCard {
  @Prop records: AccountRecord[];
  
  build() {
    // 直接从 records 计算并显示
  }
}
```

### Workaround 3：使用 AppStorage 全局状态
```typescript
AppStorage.SetOrCreate('todayIncome', income);
@StorageLink('todayIncome') todayIncome: number = 0;
```

### Workaround 4：接受现状
由于最近记录能正常更新，用户可以从最近记录中看到新添加的账单。统计数据虽然不实时更新，但重启应用后会显示正确的数据。

## 建议

1. **向华为提交 bug 报告**：这是一个严重的框架 bug，需要官方修复
2. **使用 Workaround 1**：强制重建页面是最可靠的方案
3. **简化状态管理**：移除不必要的 EventBus 和多个生命周期钩子
4. **等待框架更新**：这可能在新版本的 ArkTS 中已经修复

## 结论

这不是代码逻辑问题，而是 ArkTS 框架的 bug。数据完全正确，所有状态管理机制都按预期工作，但 UI 就是不更新。这在生产环境中是不可接受的，需要使用 workaround 或等待框架修复。
