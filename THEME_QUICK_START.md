# 主题系统快速开始指南

## 用户使用

### 如何切换主题

1. 打开应用，进入首页
2. 点击右上角的"⋮"菜单按钮
3. 在菜单中选择"🌙 深色模式"或"☀️ 浅色模式"
4. 所有页面会自动应用新主题

### 主题特点

**浅色主题**
- 清爽明亮的设计
- 适合白天使用
- 高对比度，易于阅读

**暗色主题**
- 护眼深灰设计
- 适合夜间使用
- 减少眼睛疲劳

## 开发者使用

### 在新页面中添加主题支持

#### 1. 导入配色方案

```typescript
import { LIGHT_COLOR_SCHEME, DARK_COLOR_SCHEME } from '../constants/ColorSchemes';
import { ThemeUtil } from '../utils/ThemeUtil';
```

#### 2. 添加 getColorScheme 方法

```typescript
getColorScheme() {
  return ThemeUtil.getTheme() === 'light' ? LIGHT_COLOR_SCHEME : DARK_COLOR_SCHEME;
}
```

#### 3. 在组件中使用

```typescript
Column()
  .backgroundColor(this.getColorScheme().NAVBAR.backgroundColor)
  .fontColor(this.getColorScheme().NAVBAR.titleColor)
```

### 常用配色方案

#### 导航栏
```typescript
this.getColorScheme().NAVBAR
```

#### 统计卡片
```typescript
this.getColorScheme().STAT_CARD
```

#### 列表项
```typescript
this.getColorScheme().LIST_ITEM
```

#### 输入框
```typescript
this.getColorScheme().INPUT_SECTION
```

#### 按钮
```typescript
this.getColorScheme().BUTTON_SECTION
```

### 颜色速查表

| 用途 | 浅色 | 暗色 |
|------|------|------|
| 页面背景 | #FAF9F7 | #1E1E1E |
| 卡片背景 | #FFFFFF | #2D2D2D |
| 主要文字 | #5D5C5A | #E8E6E3 |
| 次要文字 | #8E8D8C | #B8B6B3 |
| 主要按钮 | #8FAADC | #7B9BC8 |
| 收入颜色 | #95D1B3 | #8BC4A6 |
| 支出颜色 | #E8A5A5 | #D49595 |

## 常见问题

### Q: 如何在特定页面禁用主题切换？
A: 在页面中不调用 getColorScheme() 方法，使用固定颜色即可。

### Q: 如何添加新的配色方案？
A: 
1. 在 ColorSchemes.ets 中定义新的接口
2. 在 LIGHT_COLOR_SCHEME 和 DARK_COLOR_SCHEME 中添加配色对象
3. 在页面中使用 `this.getColorScheme().NEW_SCHEME`

### Q: 主题设置会被保存吗？
A: 是的，主题选择会自动保存到本地存储，应用重启后会恢复用户的选择。

### Q: 如何在深色主题中调整颜色？
A: 编辑 ColorSchemes.ets 中的 DARK_COLOR_SCHEME 对象，修改相应的颜色值。

### Q: 可以添加更多主题吗？
A: 可以，在 ColorSchemes.ets 中添加新的主题对象（如 CUSTOM_COLOR_SCHEME），然后在 getColorScheme() 方法中添加相应的逻辑。

## 文件位置

- **配色方案定义** - `entry/src/main/ets/constants/ColorSchemes.ets`
- **主题管理工具** - `entry/src/main/ets/utils/ThemeUtil.ets`
- **首页** - `entry/src/main/ets/pages/Index.ets`
- **添加记录** - `entry/src/main/ets/pages/AddRecordPage.ets`
- **流水记录** - `entry/src/main/ets/pages/RecordsPage.ets`
- **统计图表** - `entry/src/main/ets/pages/ChartPageEntry.ets`

## 相关文档

- `LIGHT_THEME_COLORS.md` - 浅色主题详细说明
- `DARK_THEME_COLORS.md` - 暗色主题详细说明
- `COLOR_REFERENCE.md` - 颜色快速参考
- `THEME_SYSTEM_GUIDE.md` - 主题系统完整指南
- `THEME_IMPLEMENTATION_COMPLETE.md` - 实现总结

## 支持的页面

✅ 首页 (Index.ets)
✅ 添加记录 (AddRecordPage.ets)
✅ 流水记录 (RecordsPage.ets)
✅ 统计图表 (ChartPageEntry.ets)

## 下一步

1. 测试主题切换功能
2. 根据需要调整颜色
3. 在新页面中集成主题支持
4. 收集用户反馈并优化设计
