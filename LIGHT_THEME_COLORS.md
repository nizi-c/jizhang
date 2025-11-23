# 浅色主题配色方案完整实现

## 概述

已根据提供的浅色主题配色方案完整更新了所有页面和组件。所有颜色定义集中在 `ColorSchemes.ets` 文件中，便于维护和扩展。

## 文件结构

### 新增文件
- `entry/src/main/ets/constants/ColorSchemes.ets` - 浅色主题配色方案定义

### 更新的页面
- `entry/src/main/ets/pages/Index.ets` - 首页
- `entry/src/main/ets/pages/AddRecordPage.ets` - 添加记录页面
- `entry/src/main/ets/pages/RecordsPage.ets` - 流水记录页面
- `entry/src/main/ets/pages/ChartPageEntry.ets` - 统计图表页面

## 配色方案详解

### 1. 首页 (Index.ets)

#### 导航栏 (NAVBAR)
- 背景色：#FFFFFF（纯白）
- 标题文字：#5D5C5A（主要文字色）
- 按钮背景：#8FAADC（柔和蓝）
- 按钮文字：#FFFFFF（纯白）
- 底部边框：#E4E2E0（浅灰）

#### 统计卡片 (STAT_CARD)
- 背景色：#FFFFFF（纯白）
- 标题文字：#8E8D8C（次要文字色）
- 收入金额：#95D1B3（柔和绿）
- 支出金额：#E8A5A5（柔和粉）
- 结余金额：#5D5C5A（主要文字色）
- 标签文字：#8E8D8C（次要文字色）
- 阴影：#00000008（柔和阴影）

#### 最近记录列表 (RECENT_LIST)
- 背景色：#FFFFFF（纯白）
- 分类文字：#5D5C5A（主要文字色）
- 描述文字：#8E8D8C（次要文字色）
- 收入金额：#95D1B3（柔和绿）
- 支出金额：#E8A5A5（柔和粉）
- 日期文字：#B4B3B2（辅助文字色）
- 分割线：#EDECEA（分割线色）

### 2. 添加记录页面 (AddRecordPage.ets)

#### 类型选择器 (TYPE_SELECTOR)
- 激活背景：#8FAADC（柔和蓝）
- 激活文字：#FFFFFF（纯白）
- 未激活背景：#F5F3F1（表面色）
- 未激活文字：#8E8D8C（次要文字色）
- 支出激活背景：#E8A5A5（柔和粉）
- 收入激活背景：#95D1B3（柔和绿）

#### 分类选择网格 (CATEGORY_GRID)
- 默认背景：#F5F3F1（表面色）
- 激活背景：#8FAADC20（柔和蓝20%透明度）
- 激活边框：#8FAADC（柔和蓝）
- 图标颜色：#5D5C5A（主要文字色）
- 文字颜色：#5D5C5A（主要文字色）
- 激活图标：#8FAADC（柔和蓝）
- 激活文字：#8FAADC（柔和蓝）

#### 输入区域 (INPUT_SECTION)
- 标签文字：#8E8D8C（次要文字色）
- 输入框背景：#FAF9F7（背景色）
- 输入框边框：#E4E2E0（边框色）
- 输入文字：#5D5C5A（主要文字色）
- 提示文字：#B4B3B2（辅助文字色）
- 错误提示：#E8A5A5（柔和红）

#### 按钮区域 (BUTTON_SECTION)
- 取消按钮背景：#F5F3F1（表面色）
- 取消文字：#5D5C5A（主要文字色）
- 保存按钮背景：#8FAADC（柔和蓝）
- 保存文字：#FFFFFF（纯白）

### 3. 流水页面 (RecordsPage.ets)

#### 列表容器 (LIST_CONTAINER)
- 背景色：#FAF9F7（背景色）
- 空状态文字：#8E8D8C（次要文字色）

#### 列表项 (LIST_ITEM)
- 背景色：#FFFFFF（纯白）
- 删除按钮背景：#E8A5A5（柔和红）
- 删除文字：#FFFFFF（纯白）
- 分类文字：#5D5C5A（主要文字色）
- 描述文字：#8E8D8C（次要文字色）
- 收入金额：#95D1B3（柔和绿）
- 支出金额：#E8A5A5（柔和粉）
- 日期文字：#B4B3B2（辅助文字色）
- 分割线：#EDECEA（分割线色）

### 4. 统计页面 (ChartPageEntry.ets)

#### 月份选择器 (MONTH_PICKER)
- 背景色：#FFFFFF（纯白）
- 文字颜色：#5D5C5A（主要文字色）
- 按钮背景：#F5F3F1（表面色）
- 按钮文字：#5D5C5A（主要文字色）

#### 图表容器 (CHART_CONTAINER)
- 背景色：#FFFFFF（纯白）
- 标题文字：#5D5C5A（主要文字色）
- 空状态文字：#8E8D8C（次要文字色）

#### 进度条 (PROGRESS_CHART)
- 轨道背景：#F5F3F1（表面色）
- 支出进度：#E8A5A5（柔和粉）
- 收入进度：#95D1B3（柔和绿）
- 分类文字：#5D5C5A（主要文字色）
- 百分比文字：#8E8D8C（次要文字色）
- 金额文字：#5D5C5A（主要文字色）

#### 详细统计列表 (DETAIL_LIST)
- 分区标题：#8E8D8C（次要文字色）
- 项背景：#FAF9F7（背景色）
- 分类文字：#5D5C5A（主要文字色）
- 支出金额：#E8A5A5（柔和粉）
- 收入金额：#95D1B3（柔和绿）

## 颜色使用指南

### 文字颜色层级
1. **主要文字色** (#5D5C5A) - 标题、分类、重要信息
2. **次要文字色** (#8E8D8C) - 标签、描述、次要信息
3. **辅助文字色** (#B4B3B2) - 日期、提示、最不重要的信息

### 背景色层级
1. **纯白** (#FFFFFF) - 卡片、列表项、对话框
2. **表面色** (#F5F3F1) - 按钮、输入框、次要背景
3. **背景色** (#FAF9F7) - 页面背景、列表容器

### 强调色
- **柔和蓝** (#8FAADC) - 主要操作、激活状态
- **柔和绿** (#95D1B3) - 收入、成功状态
- **柔和粉** (#E8A5A5) - 支出、删除操作

## 使用方式

### 在页面中使用配色方案

```typescript
import { LIGHT_COLOR_SCHEME } from '../constants/ColorSchemes';

// 使用导航栏配色
.backgroundColor(LIGHT_COLOR_SCHEME.NAVBAR.backgroundColor)
.fontColor(LIGHT_COLOR_SCHEME.NAVBAR.titleColor)

// 使用统计卡片配色
.backgroundColor(LIGHT_COLOR_SCHEME.STAT_CARD.backgroundColor)
.fontColor(LIGHT_COLOR_SCHEME.STAT_CARD.titleColor)

// 使用列表项配色
.backgroundColor(LIGHT_COLOR_SCHEME.LIST_ITEM.backgroundColor)
.fontColor(LIGHT_COLOR_SCHEME.LIST_ITEM.categoryColor)
```

## 深色主题支持

当前实现的是浅色主题。深色主题可以通过以下方式扩展：

1. 在 `ColorSchemes.ets` 中添加 `DARK_COLOR_SCHEME` 对象
2. 根据当前主题选择相应的配色方案
3. 在页面中动态切换配色方案

## 维护建议

1. 所有颜色定义集中在 `ColorSchemes.ets` 中
2. 避免在页面中硬编码颜色值
3. 使用配色方案中的颜色常量
4. 定期审查和更新配色方案以保持一致性

## 完成的更新

✅ Index.ets - 导航栏、统计卡片、最近记录列表
✅ AddRecordPage.ets - 类型选择器、分类网格、输入区域、按钮区域
✅ RecordsPage.ets - 列表容器、列表项
✅ ChartPageEntry.ets - 月份选择器、图表容器、进度条、详细统计列表

所有页面现在都使用统一的浅色主题配色方案，提供一致的视觉体验。
