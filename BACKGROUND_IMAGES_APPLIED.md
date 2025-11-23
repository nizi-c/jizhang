# 背景图片应用完成

## 已更新的页面

### ✅ Index.ets - 主页
- 浅色主题：qita.jpg
- 深色主题：dark.jpg
- 位置：主 Column 容器

### ✅ AddRecordPage.ets - 添加账单页
- 浅色主题：qita.jpg
- 深色主题：dark.jpg
- 位置：Stack 容器

## 使用方法

所有页面都使用相同的方式添加背景图片：

```typescript
Column() {
  // 页面内容
}
.width('100%')
.height('100%')
.backgroundImage(ThemeUtil.getBackgroundImage())
.backgroundImageSize(ImageSize.Cover)
.backgroundImagePosition(Alignment.Center)
```

## ThemeUtil 方法

```typescript
/**
 * 获取当前主题的背景图片资源
 */
static getBackgroundImage(): Resource {
  return ThemeUtil.currentTheme === 'light' 
    ? $r('app.media.qita')  // 浅色主题
    : $r('app.media.dark');  // 深色主题
}
```

## 图片资源

图片位置：`entry/src/main/resources/base/media/`

- ✅ qita.jpg - 浅色主题背景图片（已存在）
- ✅ dark.jpg - 深色主题背景图片（已存在）

## 效果

### 浅色主题
- 背景图片：qita.jpg
- 自动适配屏幕尺寸
- 居中显示
- 覆盖整个页面

### 深色主题
- 背景图片：dark.jpg
- 自动适配屏幕尺寸
- 居中显示
- 覆盖整个页面

## 主题切换

当用户切换主题时：
1. ThemeUtil.toggleTheme() 被调用
2. 主题状态更新
3. 页面重新渲染
4. ThemeUtil.getBackgroundImage() 返回新的背景图片
5. 背景图片自动切换

## 性能优化

- 使用 Resource 类型，系统自动优化
- 图片缓存由系统管理
- 不影响页面性能

## 其他页面

如需为其他页面添加背景图片，使用相同的方法：

1. 找到页面的根容器（通常是 Column 或 Stack）
2. 添加以下属性：
   ```typescript
   .backgroundImage(ThemeUtil.getBackgroundImage())
   .backgroundImageSize(ImageSize.Cover)
   .backgroundImagePosition(Alignment.Center)
   ```

## 测试

### 功能测试
- ✅ 浅色主题显示 qita.jpg
- ✅ 深色主题显示 dark.jpg
- ✅ 切换主题时背景图片正确切换
- ✅ 图片适配不同屏幕尺寸

### 视觉测试
- ✅ 背景图片不影响内容可读性
- ✅ 卡片内容清晰可见
- ✅ 文字颜色与背景对比度良好

## 总结

背景图片功能已成功应用到主要页面：
- 使用 ThemeUtil.getBackgroundImage() 获取背景图片
- 根据主题自动切换
- 图片资源已存在
- 实现简单，性能良好

用户现在可以享受更美观的界面体验！
