# 多账本功能说明

## 功能概述

多账本功能允许用户创建和管理多个独立的账本，每个账本的数据完全独立，互不影响。

## 核心特性

### 1. 账本管理
- ✅ 创建新账本（自定义名称和图标）
- ✅ 切换当前账本
- ✅ 删除账本（不能删除默认账本和当前账本）
- ✅ 默认账本（首次使用自动创建）

### 2. 数据隔离
- ✅ 每个账本的记录完全独立
- ✅ 切换账本后，所有页面显示对应账本的数据
- ✅ 统计、查询、流水都基于当前账本

### 3. 用户界面
- ✅ 首页显示当前账本名称
- ✅ 菜单中添加"账本管理"入口
- ✅ 账本管理页面支持创建、切换、删除

## 文件结构

### 新增文件

```
entry/src/main/ets/
├── models/
│   └── AccountBook.ets          # 账本数据模型
├── utils/
│   └── AccountBookUtil.ets      # 账本管理工具类
└── pages/
    └── AccountBooksPage.ets     # 账本管理页面
```

### 修改文件

```
entry/src/main/ets/
├── pages/
│   └── Index.ets                # 添加账本管理入口，显示当前账本
└── utils/
    └── StorageUtil.ets          # 支持多账本数据存储
```

## 数据模型

### AccountBook（账本）

```typescript
{
  id: string;           // 唯一标识
  name: string;         // 账本名称
  icon: string;         // 账本图标（emoji）
  createTime: string;   // 创建时间（ISO格式）
  isDefault: boolean;   // 是否为默认账本
}
```

## 存储机制

### 账本列表存储
- **Key**: `account_books`
- **Store**: `account_books_store`
- **格式**: JSON数组

### 当前账本ID
- **Key**: `current_book_id`
- **Store**: `account_books_store`
- **格式**: 字符串

### 账本数据存储
- **Key**: `account_records_{bookId}`
- **Store**: `account_app`
- **格式**: JSON数组
- **示例**: `account_records_book_1234567890_abc123`

## 使用流程

### 1. 首次使用
1. 应用启动时自动创建"默认账本"
2. 设置为当前账本
3. 所有数据保存到默认账本

### 2. 创建新账本
1. 点击首页菜单 → 账本管理
2. 点击右上角"+"按钮
3. 输入账本名称
4. 选择账本图标
5. 点击"创建"

### 3. 切换账本
1. 进入账本管理页面
2. 找到要切换的账本
3. 点击"切换"按钮
4. 自动返回首页并刷新数据

### 4. 删除账本
1. 进入账本管理页面
2. 找到要删除的账本（非默认、非当前）
3. 点击"删除"按钮
4. 确认删除

## 限制和规则

### 不能删除的账本
- ❌ 默认账本（isDefault = true）
- ❌ 当前正在使用的账本

### 账本图标
可选图标：📒 💰 💳 🏦 📊 💵 🎯 📝 🔖 📌

### 账本名称
- 不能为空
- 建议长度：2-10个字符

## API说明

### AccountBookUtil

```typescript
// 初始化（应用启动时调用）
await AccountBookUtil.init(context);

// 获取所有账本
const books = await AccountBookUtil.getAllBooks();

// 获取当前账本
const currentBook = await AccountBookUtil.getCurrentBook();

// 获取当前账本ID
const bookId = AccountBookUtil.getCurrentBookId();

// 设置当前账本
await AccountBookUtil.setCurrentBook(bookId);

// 创建新账本
const newBook = await AccountBookUtil.createBook(name, icon);

// 删除账本
const success = await AccountBookUtil.deleteBook(bookId);
```

### StorageUtil（已自动适配）

```typescript
// 保存记录（自动保存到当前账本）
await StorageUtil.saveRecords(records);

// 获取记录（自动从当前账本读取）
const records = await StorageUtil.getRecords();
```

## 界面展示

### 首页
```
┌─────────────────────────────┐
│ 记账本              ⋮       │
│ 默认账本                    │
├─────────────────────────────┤
│ 今日收支                    │
│ ...                         │
└─────────────────────────────┘
```

### 菜单
```
┌─────────────────────────────┐
│ 📚 账本管理                 │
├─────────────────────────────┤
│ ➕ 添加账单                 │
│ 📋 流水                     │
│ 📊 统计                     │
│ 🌙 深色模式                 │
└─────────────────────────────┘
```

### 账本管理页面
```
┌─────────────────────────────┐
│ ← 账本管理            +     │
├─────────────────────────────┤
│ 📒 默认账本                 │
│    创建于 2024-11-24        │
│    [默认] [当前]            │
├─────────────────────────────┤
│ 💰 生活账本                 │
│    创建于 2024-11-24        │
│    [切换] [删除]            │
└─────────────────────────────┘
```

## 注意事项

1. **数据隔离**：切换账本后，之前账本的数据不会显示
2. **自动刷新**：切换账本后会自动返回首页并刷新数据
3. **默认账本**：首次使用会自动创建，不能删除
4. **当前账本**：正在使用的账本不能删除
5. **数据安全**：删除账本会永久删除该账本的所有数据

## 未来扩展

### 可能的功能
- [ ] 账本重命名
- [ ] 账本排序
- [ ] 账本导入/导出
- [ ] 账本数据统计（显示每个账本的记录数量）
- [ ] 账本颜色主题
- [ ] 账本共享（多人协作）
- [ ] 账本备份和恢复

## 技术细节

### 初始化流程
1. 应用启动 → Index.aboutToAppear()
2. 调用 AccountBookUtil.init()
3. 检查是否有账本
4. 如果没有，创建默认账本
5. 设置当前账本ID

### 数据读写流程
1. 调用 StorageUtil.getRecords()
2. StorageUtil 获取当前账本ID
3. 使用 `account_records_{bookId}` 作为key
4. 从 Preferences 读取数据
5. 返回当前账本的记录

### 切换账本流程
1. 用户点击"切换"按钮
2. 调用 AccountBookUtil.setCurrentBook(bookId)
3. 更新当前账本ID
4. 保存到 Preferences
5. 返回首页
6. 首页重新加载数据（自动读取新账本的数据）

## 总结

多账本功能为用户提供了灵活的数据管理方式，可以：
- 分离不同类型的账目（如个人、家庭、公司）
- 独立管理不同时期的账目
- 保护隐私（不同账本互不干扰）
- 提高数据组织性

所有功能都已完整实现并测试通过！
