# 数据刷新最终修复方案

## 问题症状
- 添加账单后首页的今日收支、本月收支数据不更新
- 账本重命名后需要重新进入页面才能看到新名称

## 根本原因分析

### 原因 1：onPageShow 可能不被触发
- ArkTS 中 onPageShow 的触发时机不稳定
- 某些情况下页面返回时不会调用 onPageShow

### 原因 2：异步操作时序问题
- 使用 async/await 可能导致状态更新延迟
- 需要使用 Promise.then() 确保同步更新

### 原因 3：数组引用未改变
- ArkTS 的 @State 需要数组引用改变才能触发 UI 更新
- 必须使用 `[...newRecords]` 创建新引用

## 最终修复方案

### 1. 添加多个生命周期钩子

```typescript
onPageShow() {
  console.log('Index: onPageShow 触发');
  this.loadRecords();
  this.loadCurrentBook();
}

onWindowFocusChanged(hasFocus: boolean) {
  if (hasFocus) {
    console.log('Index: 窗口获得焦点');
    this.loadRecords();
    this.loadCurrentBook();
  }
}

onBackPress() {
  console.log('Index: 返回按钮按下');
  this.loadRecords();
  this.loadCurrentBook();
  return false;
}
```

**优势**：多个触发点确保数据一定会被刷新

### 2. 使用 Promise 链替代 async/await

```typescript
loadRecords() {
  StorageUtil.getRecords().then((newRecords: AccountRecord[]) => {
    this.records = [...newRecords];  // 创建新引用
    this.viewModel.records = this.records;
    this.updateSummary();
    console.log('Index: 数据已加载，记录数:', this.records.length);
  }).catch((error: Error) => {
    console.error('Index: 加载记录失败:', error);
  });
}
```

**优势**：确保同步更新 @State 变量

### 3. 增加返回延迟时间

在 AddRecordPage 中：
```typescript
setTimeout(() => {
  console.log('AddRecordPage: 返回首页');
  router.back();
}, 1200);  // 从 800ms 增加到 1200ms
```

**优势**：给足够时间让事件处理和 UI 更新

### 4. EventBus 事件监听

```typescript
EventBus.on(Events.RECORDS_CHANGED, () => {
  console.log('Index: 收到 RECORDS_CHANGED 事件');
  this.loadRecords();
});
```

**优势**：即使页面没有返回，事件也能触发更新

## 数据流程

```
用户在 AddRecordPage 添加账单
    ↓
保存到 StorageUtil
    ↓
发送 RECORDS_CHANGED 事件
    ↓
显示 Toast 提示
    ↓
延迟 1200ms
    ↓
返回首页 (router.back)
    ↓
触发以下任一或多个：
  - onPageShow()
  - onWindowFocusChanged(true)
  - EventBus 监听器
    ↓
loadRecords() 从存储读取最新数据
    ↓
创建新数组引用 [...newRecords]
    ↓
更新 @State 变量
    ↓
调用 updateSummary() 计算统计
    ↓
UI 自动刷新显示新数据
```

## 验证方法

1. **查看日志输出**：
   - 打开开发者工具的日志面板
   - 添加账单后查看是否有以下日志：
     ```
     AddRecordPage: 发送 RECORDS_CHANGED 事件
     Index: onPageShow 触发
     Index: 数据已加载，记录数: X
     Index: 统计数据已更新 - 今日收入: Y 支出: Z
     ```

2. **检查 UI 更新**：
   - 添加账单前记录首页的数据
   - 添加账单后立即返回
   - 检查今日收支、本月收支是否更新

3. **测试账本重命名**：
   - 打开账本管理
   - 重命名当前账本
   - 返回首页检查账本名称是否更新

## 如果仍然不工作

### 方案 A：强制刷新标记

在 Index.ets 中添加：
```typescript
@State refreshTrigger: number = 0;

loadRecords() {
  StorageUtil.getRecords().then((newRecords: AccountRecord[]) => {
    this.records = [...newRecords];
    this.viewModel.records = this.records;
    this.updateSummary();
    this.refreshTrigger++;  // 强制刷新
  });
}
```

### 方案 B：检查数据是否真的保存

在 AddRecordPage 的 saveRecord 中添加：
```typescript
await StorageUtil.saveRecords(records);
// 立即读取验证
const verify = await StorageUtil.getRecords();
console.log('验证保存的数据:', verify);
```

### 方案 C：检查账本隔离

确保 StorageUtil 中的 getCurrentBookKey() 返回正确的 key：
```typescript
private static getCurrentBookKey(): string {
  const bookId = AccountBookUtil.getCurrentBookId();
  console.log('当前账本 ID:', bookId);
  return bookId ? `${STORAGE_KEY}_${bookId}` : STORAGE_KEY;
}
```

## 关键改进总结

| 改进项 | 原因 | 效果 |
|------|------|------|
| 添加 onWindowFocusChanged | 确保页面获得焦点时刷新 | 提高刷新可靠性 |
| 使用 Promise.then() | 避免 async/await 延迟 | 确保同步更新 |
| 创建新数组引用 | ArkTS 需要引用改变 | 触发 UI 更新 |
| 增加延迟到 1200ms | 给足够时间处理 | 避免竞态条件 |
| 多个事件监听点 | 确保至少一个触发 | 提高可靠性 |
