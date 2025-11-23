# 主题系统完整指南

## 系统架构

### 核心组件

1. **ThemeUtil.ets** - 主题管理工具
   - 定义浅色和深色主题的所有颜色
   - 管理当前主题状态
   - 提供主题切换和获取方法

2. **ThemeProvider.ets** - 主题提供者组件
   - ThemeProvider 组件：统一管理主题状态
   - DynamicColors 类：提供所有颜色的响应式获取
   - GlobalTheme 类：向后兼容的全局颜色访问

3. **Constants.ets** - 常量定义
   - DynamicColorsProxy：实现 ColorScheme 接口的动态颜色代理
   - COLORS：单例实例，所有页面使用

4. **ThemeColors.ets** - 颜色常量
   - DynamicColors 类：提供所有颜色的静态访问方法

## 颜色定义

### 浅色主题 (Light Theme)
- 主色：#8FAADC（柔和蓝）
- 背景：#FAF9F7（米白）
- 卡片背景：#FFFFFF（纯白）
- 文本主色：#5D5C5A（深灰）
- 文本次色：#8E8D8C（中灰）
- 边框：#E4E2E0（浅灰）
- 收入：#95D1B3（柔和绿）
- 支出：#E8A5A5（柔和红）

### 深色主题 (Dark Theme)
- 主色：#7B9BC8（深蓝）
- 背景：#1A1A1A（最深灰）
- 查询背景：#252525（深灰）
- 输入框背景：#3A3A3A（中深灰）
- 记录条背景：#3A3A3A（中深灰）
- 文本主色：#E8E6E3（浅灰）
- 文本次色：#8A8886（深灰）
- 文本三级：#6B6A68（更深灰）
- 边框：#4A4846（深灰）
- 收入：#8BC4A6（深绿）
- 支出：#D49595（深红）

**深色主题颜色层级：**
- 页面背景 (#1A1A1A) < 查询背景 (#252525) < 输入框/记录条 (#3A3A3A)

## 使用方式

### 在页面中使用颜色

所有页面都使用 `COLORS` 常量，它会自动响应主题变化：

```typescript
import { COLORS } from '../constants/Constants';

// 在组件中使用
.backgroundColor(COLORS.background)
.fontColor(COLORS.text)
.borderColor(COLORS.border)
```

### 主题切换

在首页菜单中点击"🌙 深色模式"或"☀️ 浅色模式"按钮切换主题：

```typescript
this.currentTheme = ThemeUtil.toggleTheme();
this.colors = ThemeUtil.getColors();
```

### 获取特定颜色

使用 DynamicColors 类获取特定颜色：

```typescript
import { DynamicColors } from '../constants/ThemeColors';

const primaryColor = DynamicColors.primary;
const backgroundColor = DynamicColors.background;
const incomeColor = DynamicColors.income;
```

## 支持的页面

✅ **所有页面都支持完整的主题切换：**
- Index.ets - 首页（包含主题切换菜单）
- AddRecordPage.ets - 添加账单页面
- RecordsPage.ets - 流水记录页面
- ChartPageEntry.ets - 统计图表页面

## 主题切换流程

1. 用户在首页菜单中点击主题切换按钮
2. ThemeUtil.toggleTheme() 切换主题并保存到本地存储
3. COLORS 代理对象自动获取新主题的颜色
4. 所有使用 COLORS 的组件自动更新颜色
5. 页面重新渲染，显示新主题

## 新增颜色字段

### 深色主题优化颜色
- `inputBg` - 输入框背景色（浅灰色）
- `queryBg` - 查询面板背景色（比页面背景略浅）
- `recordBg` - 记录条背景色（浅灰色）

### 文本颜色层级
- `textPrimary` / `text` - 主文本（浅灰）
- `textSecondary` / `textLight` - 次文本（深灰）
- `textTertiary` - 三级文本（更深灰）

## 颜色访问方式

### 方式 1：使用 COLORS 常量（推荐）
```typescript
import { COLORS } from '../constants/Constants';

Column()
  .backgroundColor(COLORS.background)
  .fontColor(COLORS.text)
  .backgroundColor(COLORS.inputBg)
  .backgroundColor(COLORS.queryBg)
  .backgroundColor(COLORS.recordBg)
```

### 方式 2：使用 DynamicColors 类
```typescript
import { DynamicColors } from '../constants/ThemeColors';

Column()
  .backgroundColor(DynamicColors.background)
  .fontColor(DynamicColors.text)
```

### 方式 3：使用 GlobalTheme 类（向后兼容）
```typescript
import { GlobalTheme } from '../components/ThemeProvider';

Column()
  .backgroundColor(GlobalTheme.getBackgroundColor())
  .fontColor(GlobalTheme.getTextColor())
```

## 扩展主题

要添加新的主题颜色：

1. 在 ThemeUtil.ets 中的 ThemeColors 接口添加新颜色
2. 在 LIGHT_THEME 和 DARK_THEME 中定义新颜色值
3. 在 DynamicColors 类中添加新的 getter 方法
4. 在 DynamicColorsProxy 中添加新的 getter 方法

## 存储和持久化

主题选择会自动保存到本地存储，应用重启后会恢复用户的主题选择。

## 性能优化

- 颜色值通过 getter 方法动态获取，避免不必要的重新渲染
- 主题切换时只更新必要的状态
- 使用代理模式实现颜色的动态访问
