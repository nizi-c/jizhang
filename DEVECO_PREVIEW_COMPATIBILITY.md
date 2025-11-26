# DevEco 预览器兼容性指南

## 问题
- 在真机模拟器中可以保存账单
- 在 DevEco 自带的预览器中无法保存账单

## 根本原因

DevEco 预览器与真机模拟器的差异：

1. **Context 初始化时机不同**
   - 真机模拟器：aboutToAppear 中的 async/await 会被正确等待
   - DevEco 预览器：aboutToAppear 中的 async/await 可能不会被等待

2. **存储权限不同**
   - 真机模拟器：有完整的文件系统和存储权限
   - DevEco 预览器：存储权限可能受限

3. **生命周期处理不同**
   - 真机模拟器：严格遵循 ArkTS 生命周期
   - DevEco 预览器：生命周期处理可能有差异

## 解决方案

### 1. 改进 aboutToAppear 的初始化

**之前（不兼容）**：
```typescript
async aboutToAppear() {
  const context = getContext(this) as common.UIAbilityContext;
  StorageUtil.setContext(context);
  await BudgetUtil.init(context);
  await this.updateCategories();
}
```

**之后（兼容）**：
```typescript
aboutToAppear() {
  const context = getContext(this) as common.UIAbilityContext;
  StorageUtil.setContext(context);
  
  BudgetUtil.init(context).then(() => {
    this.updateCategories();
  }).catch((error: Error) => {
    console.error('初始化失败:', error);
    this.updateCategories();
  });
}
```

### 2. 改进 StorageUtil 的错误处理

添加详细的日志和错误检查：
```typescript
static async saveRecords(records: AccountRecord[]): Promise<void> {
  try {
    if (!StorageUtil.context) {
      console.error('Context 未初始化！');
      throw new Error('Context is not initialized');
    }
    
    console.log('开始保存记录，数量:', records.length);
    const pref = await preferences.getPreferences(StorageUtil.context, 'account_app');
    const key = StorageUtil.getCurrentBookKey();
    
    await pref.put(key, JSON.stringify(records));
    await pref.flush();
    console.log('记录保存成功');
  } catch (error) {
    console.error('保存记录失败:', error);
    throw error;
  }
}
```

### 3. 改进 updateCategories 的异步处理

```typescript
updateCategories() {
  const baseCategories = this.recordType === 'income' ? INCOME_CATEGORIES : EXPENSE_CATEGORIES;
  
  CategoryUtil.getCustomCategories().then((customCategories: Category[]) => {
    const expenseCustom = customCategories.filter(c => this.recordType === 'expense');
    this.categories = [...baseCategories, ...expenseCustom];
    
    if (!this.selectedCategory || !this.categories.find(c => c.name === this.selectedCategory)) {
      this.selectedCategory = this.categories[0]?.name || '';
    }
  }).catch((error: Error) => {
    console.error('加载分类失败:', error);
    this.categories = baseCategories;
    this.selectedCategory = this.categories[0]?.name || '';
  });
}
```

## 关键改进点

| 改进项 | 原因 | 效果 |
|------|------|------|
| aboutToAppear 改为非 async | DevEco 预览器不等待 async | 立即返回，异步初始化 |
| 使用 Promise.then() | 确保异步操作完成 | 兼容 DevEco 预览器 |
| 添加 Context 检查 | 防止 Context 未初始化 | 提前发现问题 |
| 添加详细日志 | 便于调试 | 快速定位问题 |
| 添加错误处理 | 捕获异常 | 提高稳定性 |

## 测试方法

### 在 DevEco 预览器中测试

1. **打开 DevEco 预览器**
   - 点击 "预览" 按钮
   - 选择 "预览器" 选项

2. **添加账单**
   - 点击菜单 → 添加账单
   - 填写信息并保存

3. **查看日志**
   - 打开 DevEco 的日志面板
   - 查看是否有错误信息

4. **预期日志**
   ```
   AddRecordPage: aboutToAppear 被调用
   AddRecordPage: StorageUtil Context 已设置
   AddRecordPage: BudgetUtil 已初始化
   AddRecordPage: 分类已加载，总数: X
   StorageUtil: Context 已设置
   StorageUtil: 开始保存记录，数量: X
   StorageUtil: 记录保存成功
   AddRecordPage: 记录已保存，总数: X
   ```

### 在真机模拟器中测试

1. **启动真机模拟器**
   - 使用 DevEco 的模拟器管理器

2. **运行应用**
   - 点击 "运行" 按钮
   - 选择模拟器

3. **添加账单**
   - 同上

4. **验证数据**
   - 检查首页是否显示新账单
   - 检查统计数据是否更新

## 推荐做法

1. **开发阶段**
   - 使用真机模拟器进行主要测试
   - 使用 DevEco 预览器进行 UI 预览

2. **调试阶段**
   - 在真机模拟器中调试逻辑
   - 在 DevEco 预览器中验证兼容性

3. **发布前**
   - 在真机模拟器中进行完整测试
   - 确保所有功能正常工作

## 总结

DevEco 预览器与真机模拟器的主要差异在于：
- 生命周期处理
- 异步操作的等待机制
- 存储权限

通过改进异步处理和添加错误检查，可以提高应用在 DevEco 预览器中的兼容性。
