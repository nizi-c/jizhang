# 浅色主题配色快速参考

## 核心颜色

| 颜色名称 | 十六进制 | 用途 |
|---------|---------|------|
| 纯白 | #FFFFFF | 卡片、列表项、对话框背景 |
| 背景色 | #FAF9F7 | 页面背景、列表容器 |
| 表面色 | #F5F3F1 | 按钮、输入框、次要背景 |
| 浅灰 | #E4E2E0 | 边框、分割线 |
| 分割线 | #EDECEA | 列表分割线 |
| 主要文字 | #5D5C5A | 标题、分类、重要信息 |
| 次要文字 | #8E8D8C | 标签、描述、次要信息 |
| 辅助文字 | #B4B3B2 | 日期、提示、最不重要信息 |
| 柔和蓝 | #8FAADC | 主要操作、激活状态 |
| 柔和绿 | #95D1B3 | 收入、成功状态 |
| 柔和粉 | #E8A5A5 | 支出、删除操作 |

## 配色方案对象

### NAVBAR（导航栏）
```typescript
LIGHT_COLOR_SCHEME.NAVBAR = {
  backgroundColor: '#FFFFFF',
  titleColor: '#5D5C5A',
  buttonBackground: '#8FAADC',
  buttonTextColor: '#FFFFFF',
  borderColor: '#E4E2E0'
}
```

### STAT_CARD（统计卡片）
```typescript
LIGHT_COLOR_SCHEME.STAT_CARD = {
  backgroundColor: '#FFFFFF',
  titleColor: '#8E8D8C',
  incomeColor: '#95D1B3',
  expenseColor: '#E8A5A5',
  balanceColor: '#5D5C5A',
  labelColor: '#8E8D8C',
  borderColor: '#F5F3F1',
  shadowColor: '#00000008'
}
```

### RECENT_LIST（最近记录列表）
```typescript
LIGHT_COLOR_SCHEME.RECENT_LIST = {
  backgroundColor: '#FFFFFF',
  itemBackground: '#FFFFFF',
  categoryColor: '#5D5C5A',
  descriptionColor: '#8E8D8C',
  incomeAmountColor: '#95D1B3',
  expenseAmountColor: '#E8A5A5',
  dateColor: '#B4B3B2',
  dividerColor: '#EDECEA'
}
```

### TYPE_SELECTOR（类型选择器）
```typescript
LIGHT_COLOR_SCHEME.TYPE_SELECTOR = {
  activeBackground: '#8FAADC',
  activeTextColor: '#FFFFFF',
  inactiveBackground: '#F5F3F1',
  inactiveTextColor: '#8E8D8C',
  expenseActiveBackground: '#E8A5A5',
  incomeActiveBackground: '#95D1B3'
}
```

### CATEGORY_GRID（分类选择网格）
```typescript
LIGHT_COLOR_SCHEME.CATEGORY_GRID = {
  itemBackground: '#F5F3F1',
  activeBackground: '#8FAADC20',
  activeBorderColor: '#8FAADC',
  iconColor: '#5D5C5A',
  textColor: '#5D5C5A',
  activeIconColor: '#8FAADC',
  activeTextColor: '#8FAADC'
}
```

### INPUT_SECTION（输入区域）
```typescript
LIGHT_COLOR_SCHEME.INPUT_SECTION = {
  labelColor: '#8E8D8C',
  inputBackground: '#FAF9F7',
  inputBorderColor: '#E4E2E0',
  inputTextColor: '#5D5C5A',
  placeholderColor: '#B4B3B2',
  errorColor: '#E8A5A5'
}
```

### BUTTON_SECTION（按钮区域）
```typescript
LIGHT_COLOR_SCHEME.BUTTON_SECTION = {
  cancelBackground: '#F5F3F1',
  cancelTextColor: '#5D5C5A',
  saveBackground: '#8FAADC',
  saveTextColor: '#FFFFFF'
}
```

### LIST_CONTAINER（列表容器）
```typescript
LIGHT_COLOR_SCHEME.LIST_CONTAINER = {
  backgroundColor: '#FAF9F7',
  emptyTextColor: '#8E8D8C'
}
```

### LIST_ITEM（列表项）
```typescript
LIGHT_COLOR_SCHEME.LIST_ITEM = {
  backgroundColor: '#FFFFFF',
  swipeDeleteBackground: '#E8A5A5',
  deleteTextColor: '#FFFFFF',
  categoryColor: '#5D5C5A',
  descriptionColor: '#8E8D8C',
  amountIncomeColor: '#95D1B3',
  amountExpenseColor: '#E8A5A5',
  dateColor: '#B4B3B2',
  dividerColor: '#EDECEA'
}
```

### MONTH_PICKER（月份选择器）
```typescript
LIGHT_COLOR_SCHEME.MONTH_PICKER = {
  backgroundColor: '#FFFFFF',
  textColor: '#5D5C5A',
  buttonBackground: '#F5F3F1',
  buttonTextColor: '#5D5C5A'
}
```

### CHART_CONTAINER（图表容器）
```typescript
LIGHT_COLOR_SCHEME.CHART_CONTAINER = {
  backgroundColor: '#FFFFFF',
  titleColor: '#5D5C5A',
  emptyTextColor: '#8E8D8C'
}
```

### PROGRESS_CHART（进度条）
```typescript
LIGHT_COLOR_SCHEME.PROGRESS_CHART = {
  trackColor: '#F5F3F1',
  expenseProgressColor: '#E8A5A5',
  incomeProgressColor: '#95D1B3',
  categoryColor: '#5D5C5A',
  percentageColor: '#8E8D8C',
  amountColor: '#5D5C5A'
}
```

### DETAIL_LIST（详细统计列表）
```typescript
LIGHT_COLOR_SCHEME.DETAIL_LIST = {
  sectionTitleColor: '#8E8D8C',
  itemBackground: '#FAF9F7',
  categoryColor: '#5D5C5A',
  expenseAmountColor: '#E8A5A5',
  incomeAmountColor: '#95D1B3'
}
```

## 使用示例

### 在页面中导入和使用
```typescript
import { LIGHT_COLOR_SCHEME } from '../constants/ColorSchemes';

// 使用配色方案
Column()
  .backgroundColor(LIGHT_COLOR_SCHEME.STAT_CARD.backgroundColor)
  .borderRadius(12)
  .shadow({ radius: 8, color: LIGHT_COLOR_SCHEME.STAT_CARD.shadowColor })

Text('标题')
  .fontColor(LIGHT_COLOR_SCHEME.STAT_CARD.titleColor)

Text('¥100.00')
  .fontColor(LIGHT_COLOR_SCHEME.STAT_CARD.incomeColor)
```

## 颜色选择指南

### 何时使用各种颜色

| 场景 | 推荐颜色 | 原因 |
|------|---------|------|
| 页面背景 | #FAF9F7 | 柔和背景，不刺眼 |
| 卡片背景 | #FFFFFF | 高对比度，清晰 |
| 主标题 | #5D5C5A | 深色，易读性强 |
| 副标题 | #8E8D8C | 中等灰度，视觉层级 |
| 提示文字 | #B4B3B2 | 浅灰，不突出 |
| 主要按钮 | #8FAADC | 柔和蓝，专业感 |
| 收入显示 | #95D1B3 | 柔和绿，正面感 |
| 支出显示 | #E8A5A5 | 柔和粉，警示感 |
| 删除操作 | #E8A5A5 | 柔和粉，危险感 |

## 深色主题扩展

要添加深色主题支持，可以在 `ColorSchemes.ets` 中添加：

```typescript
export const DARK_COLOR_SCHEME = {
  NAVBAR: {
    backgroundColor: '#2D2D2D',
    titleColor: '#E8E6E3',
    buttonBackground: '#7B9BC8',
    buttonTextColor: '#FFFFFF',
    borderColor: '#4A4846'
  },
  // ... 其他配色方案
};
```

然后在页面中根据主题选择：

```typescript
const scheme = isDarkTheme ? DARK_COLOR_SCHEME : LIGHT_COLOR_SCHEME;
.backgroundColor(scheme.NAVBAR.backgroundColor)
```
