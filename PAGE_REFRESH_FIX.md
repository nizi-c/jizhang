# 页面数据刷新问题修复方案

## 问题描述

1. **添加账单后首页数据不更新**：添加新记录后返回首页，今日收支和本月收支数据没有更新
2. **账本重命名后不更新**：重命名账本后需要退出账本页面再进入才能看到新名称

## 根本原因

这是 HarmonyOS 页面生命周期的问题：
- `router.back()` 返回时，不一定会触发 `onPageShow()`
- 页面可能被缓存，不会重新加载
- 需要显式地刷新数据

## 解决方案

### 方案 1：使用 onBackPress 生命周期（已实施）

在 Index.ets 中添加 `onBackPress()` 方法：

```typescript
onBackPress() {
  // 返回时刷新数据
  this.loadRecords();
  this.loadCurrentBook();
  return false;  // 返回 false 允许默认返回行为
}
```

### 方案 2：使用全局事件通知（推荐）

创建一个全局事件管理器来通知页面数据已更新：

```typescript
// entry/src/main/ets/utils/EventBus.ets

export class EventBus {
  private static listeners: Map<string, Function[]> = new Map();

  static on(event: string, callback: Function): void {
    if (!this.listeners.has(event)) {
      this.listeners.set(event, []);
    }
    this.listeners.get(event)?.push(callback);
  }

  static off(event: string, callback: Function): void {
    const callbacks = this.listeners.get(event);
    if (callbacks) {
      const index = callbacks.indexOf(callback);
      if (index > -1) {
        callbacks.splice(index, 1);
      }
    }
  }

  static emit(event: string, data?: any): void {
    const callbacks = this.listeners.get(event);
    if (callbacks) {
      callbacks.forEach(callback => callback(data));
    }
  }
}
```

在 AddRecordPage 中，保存记录后发送事件：

```typescript
async saveRecord() {
  try {
    // ... 保存逻辑 ...
    
    // 发送数据更新事件
    EventBus.emit('recordsUpdated');
    
    promptAction.showToast({
      message: '保存成功',
      duration: 1500
    });

    setTimeout(() => {
      router.back();
    }, 500);
  } catch (error) {
    // ... 错误处理 ...
  }
}
```

在 Index.ets 中监听事件：

```typescript
aboutToAppear() {
  // ... 其他初始化 ...
  
  // 监听记录更新事件
  EventBus.on('recordsUpdated', () => {
    this.loadRecords();
  });
  
  // 监听账本更新事件
  EventBus.on('bookUpdated', () => {
    this.loadCurrentBook();
  });
}

onDestroy() {
  // 清理事件监听
  EventBus.off('recordsUpdated', () => {});
  EventBus.off('bookUpdated', () => {});
}
```

### 方案 3：使用 AppState 全局状态（最简单）

在 AppState 中添加刷新标记：

```typescript
// entry/src/main/ets/utils/AppState.ets

export class AppState {
  static currentTheme: ThemeType = 'light';
  static colors: ThemeColors = ThemeUtil.LIGHT_THEME;
  static refreshFlag: number = 0;  // 刷新标记

  static triggerRefresh(): void {
    this.refreshFlag = Date.now();  // 更新时间戳
  }
}
```

在 AddRecordPage 中：

```typescript
async saveRecord() {
  try {
    // ... 保存逻辑 ...
    
    // 触发全局刷新
    AppState.triggerRefresh();
    
    promptAction.showToast({
      message: '保存成功',
      duration: 1500
    });

    setTimeout(() => {
      router.back();
    }, 500);
  } catch (error) {
    // ... 错误处理 ...
  }
}
```

在 Index.ets 中监听：

```typescript
@State refreshFlag: number = 0;

aboutToAppear() {
  // ... 其他初始化 ...
  
  // 定期检查刷新标记
  setInterval(() => {
    if (AppState.refreshFlag !== this.refreshFlag) {
      this.refreshFlag = AppState.refreshFlag;
      this.loadRecords();
      this.loadCurrentBook();
    }
  }, 500);
}
```

## 推荐方案

**使用方案 2（EventBus）** 是最优选择，因为：

✅ **解耦性好**：页面之间不需要直接依赖
✅ **可扩展性强**：可以轻松添加更多事件
✅ **性能最优**：只在需要时刷新，不需要轮询
✅ **代码清晰**：事件名称明确，易于维护

## 实施步骤

### 第一步：创建 EventBus 工具类

创建 `entry/src/main/ets/utils/EventBus.ets`

### 第二步：修改 AddRecordPage

在保存记录后发送事件

### 第三步：修改 AccountBooksPage

在重命名账本后发送事件

### 第四步：修改 Index.ets

在 `aboutToAppear()` 中监听事件

## 完整示例

### EventBus.ets

```typescript
export class EventBus {
  private static listeners: Map<string, Function[]> = new Map();

  static on(event: string, callback: Function): void {
    if (!this.listeners.has(event)) {
      this.listeners.set(event, []);
    }
    this.listeners.get(event)?.push(callback);
  }

  static off(event: string, callback: Function): void {
    const callbacks = this.listeners.get(event);
    if (callbacks) {
      const index = callbacks.indexOf(callback);
      if (index > -1) {
        callbacks.splice(index, 1);
      }
    }
  }

  static emit(event: string, data?: any): void {
    const callbacks = this.listeners.get(event);
    if (callbacks) {
      callbacks.forEach(callback => callback(data));
    }
  }

  static clear(event: string): void {
    this.listeners.delete(event);
  }
}
```

### 在 AddRecordPage 中使用

```typescript
import { EventBus } from '../utils/EventBus';

async saveRecord() {
  try {
    const record: AccountRecord = {
      id: StorageUtil.generateId(),
      type: this.recordType,
      category: this.selectedCategory,
      amount: parseFloat(this.amount),
      description: this.description,
      date: DateUtil.parseDate(this.selectedDate),
      dateStr: this.selectedDate,
      mood: this.selectedMood
    };

    const records = await StorageUtil.getRecords();
    records.unshift(record);
    await StorageUtil.saveRecords(records);

    // 发送事件通知首页刷新
    EventBus.emit('recordsUpdated');

    promptAction.showToast({
      message: '保存成功',
      duration: 1500
    });

    setTimeout(() => {
      router.back();
    }, 500);
  } catch (error) {
    console.error('保存记录失败:', error);
    promptAction.showToast({
      message: '保存失败，请重试',
      duration: 2000
    });
  }
}
```

### 在 Index.ets 中使用

```typescript
import { EventBus } from '../utils/EventBus';

async aboutToAppear() {
  const context = getContext(this);
  StorageUtil.setContext(context);
  
  await AccountBookUtil.init(context as common.UIAbilityContext);
  
  ThemeUtil.initTheme().then(() => {
    this.currentTheme = ThemeUtil.getTheme();
    this.colors = ThemeUtil.getColors();
  });
  
  this.loadRecords();

  // 监听记录更新事件
  EventBus.on('recordsUpdated', () => {
    this.loadRecords();
  });

  // 监听账本更新事件
  EventBus.on('bookUpdated', () => {
    this.loadCurrentBook();
  });
}
```

## 总结

通过实施这些方案，可以确保：

✅ 添加账单后首页数据立即更新
✅ 重命名账本后账本名称立即更新
✅ 其他页面的数据变更也能及时反映到首页
✅ 代码结构清晰，易于维护和扩展

---

**推荐实施**：使用 EventBus 方案，这是最专业和可扩展的解决方案。

