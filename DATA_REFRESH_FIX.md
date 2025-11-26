# 数据刷新问题修复说明

## 问题描述

1. **添加账单后首页数据不更新**：今日收支、本月收支数据没有实时刷新
2. **账本重命名后需要重新进入页面才更新**：账本名称改变不会立即反映在首页

## 根本原因

### 原因 1：事件监听与页面生命周期的竞态条件
- `aboutToAppear` 中注册的 EventBus 监听器在页面返回时仍然存在
- 但 `onPageShow` 也会重新加载数据，两者可能产生竞态条件
- 导致数据更新不稳定

### 原因 2：数据更新后 UI 没有正确刷新
- 虽然数据被加载到 `this.records`，但 ArkTS 的状态管理需要数组引用改变才能触发 UI 更新
- 直接赋值 `this.records = newRecords` 可能不会触发 UI 刷新

### 原因 3：事件发送与页面返回的时序问题
- AddRecordPage 保存数据后立即返回，EventBus 事件可能还没被完全处理
- 需要延迟返回以确保事件被处理

## 解决方案

### 1. 改进 Index.ets 的数据加载机制

```typescript
async loadRecords() {
  try {
    const newRecords = await StorageUtil.getRecords();
    // 强制更新数组引用，触发 UI 刷新
    this.records = [...newRecords];
    this.viewModel.records = this.records;
    this.updateSummary();
  } catch (error) {
    console.error('Index: 加载记录失败:', error);
  }
}
```

**关键点**：使用 `[...newRecords]` 创建新数组引用，确保 ArkTS 的状态管理系统检测到变化

### 2. 确保 onPageShow 总是重新加载数据

```typescript
async onPageShow() {
  // 每次页面显示时都重新加载数据，确保数据最新
  console.log('Index: onPageShow 触发，重新加载数据');
  await this.loadRecords();
  await this.loadCurrentBook();
}
```

**关键点**：`onPageShow` 在页面每次显示时都会被调用，包括从其他页面返回时

### 3. 改进 EventBus 监听器

```typescript
// 监听记录更新事件 - 使用箭头函数保持 this 上下文
EventBus.on(Events.RECORDS_CHANGED, async () => {
  console.log('Index: 收到 RECORDS_CHANGED 事件，重新加载数据');
  await this.loadRecords();
});
```

**关键点**：使用 `async` 箭头函数确保异步操作完成

### 4. 延迟页面返回

在 AddRecordPage 和 AccountBooksPage 中，发送事件后延迟 800ms 再返回：

```typescript
// 发送事件通知其他页面数据已更新
EventBus.emit(Events.RECORDS_CHANGED, record);

// 延迟返回，确保事件已被处理
setTimeout(() => {
  router.back();
}, 800);
```

**关键点**：给 EventBus 事件处理留出足够的时间

## 数据流程

```
AddRecordPage 保存数据
    ↓
发送 RECORDS_CHANGED 事件
    ↓
延迟 800ms
    ↓
返回首页 (router.back)
    ↓
onPageShow 触发
    ↓
重新加载数据 (loadRecords)
    ↓
EventBus 监听器也触发 (如果事件还在处理中)
    ↓
UI 更新显示最新数据
```

## 测试步骤

1. **测试添加账单**：
   - 打开首页，记录当前的今日收支数据
   - 点击菜单 → 添加账单
   - 添加一条新账单
   - 返回首页，检查数据是否立即更新

2. **测试账本重命名**：
   - 打开首页，记录当前账本名称
   - 点击菜单 → 账本管理
   - 点击账本名称进行重命名
   - 返回首页，检查账本名称是否立即更新

## 调试日志

已添加以下日志便于调试：

- `Index: onPageShow 触发，重新加载数据`
- `Index: 收到 RECORDS_CHANGED 事件，重新加载数据`
- `Index: 数据已加载，记录数: X`
- `AddRecordPage: 记录已保存，总数: X`
- `AddRecordPage: 发送 RECORDS_CHANGED 事件`
- `AccountBooksPage: 账本已重命名为: X`
- `AccountBooksPage: 发送 BOOK_UPDATED 事件`

在开发者工具中查看日志可以验证数据流程是否正确。

## 关键改进点总结

| 问题 | 解决方案 |
|------|--------|
| 数据加载后 UI 不刷新 | 使用 `[...newRecords]` 创建新数组引用 |
| 事件处理不及时 | 延迟 800ms 再返回页面 |
| 页面返回时数据不更新 | 在 `onPageShow` 中重新加载数据 |
| 竞态条件 | 使用 `async/await` 确保异步操作完成 |
