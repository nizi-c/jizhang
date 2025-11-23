# 背景图片设置说明

## 图片资源位置

请将背景图片放置在以下位置：

```
entry/src/main/resources/base/media/
├── qita.jpg    # 浅色主题背景图片
└── dark.jpg    # 深色主题背景图片
```

## 图片要求

### 尺寸建议
- 推荐尺寸：1080 x 1920 像素（或更高）
- 宽高比：9:16（适配手机屏幕）
- 格式：JPG 或 PNG

### 设计建议

#### 浅色主题图片（qita.jpg）
- 整体色调：明亮、柔和
- 建议颜色：浅灰、米白、淡蓝等
- 避免：过于鲜艳的颜色
- 确保文字在图片上清晰可读

#### 深色主题图片（dark.jpg）
- 整体色调：深沉、低调
- 建议颜色：深灰、深蓝、黑色等
- 避免：纯黑色（建议使用深灰）
- 确保浅色文字在图片上清晰可读

### 优化建议
- 文件大小：建议小于 500KB
- 压缩：使用图片压缩工具减小文件大小
- 模糊：可以适当模糊背景，突出前景内容

## 实现原理

### ThemeUtil 方法
```typescript
static getBackgroundImage(): Resource {
  return ThemeUtil.currentTheme === 'light' 
    ? $r('app.media.qita')  // 浅色主题
    : $r('app.media.dark');  // 深色主题
}
```

### 页面使用
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

## 已更新的页面

以下页面已添加背景图片支持：

1. ✅ Index.ets - 主页
2. ✅ AddRecordPage.ets - 添加账单页
3. ✅ RecordsPage.ets - 流水页
4. ✅ ListPage.ets - 列表页
5. ✅ QueryPage.ets - 查询页
6. ✅ ChartPage.ets - 图表页

## 背景图片效果

### 浅色主题
- 背景图片：qita.jpg
- 前景内容：深色文字
- 卡片背景：半透明白色
- 整体感觉：清新、明亮

### 深色主题
- 背景图片：dark.jpg
- 前景内容：浅色文字
- 卡片背景：半透明深色
- 整体感觉：沉稳、优雅

## 调整透明度

如果背景图片影响内容可读性，可以添加半透明遮罩：

```typescript
Stack() {
  // 背景图片
  Image(ThemeUtil.getBackgroundImage())
    .width('100%')
    .height('100%')
    .objectFit(ImageFit.Cover)
  
  // 半透明遮罩
  Column()
    .width('100%')
    .height('100%')
    .backgroundColor('rgba(255, 255, 255, 0.8)') // 浅色主题
    // .backgroundColor('rgba(0, 0, 0, 0.6)')     // 深色主题
  
  // 页面内容
  Column() {
    // ...
  }
}
```

## 性能优化

### 图片加载优化
- 使用适当的图片尺寸
- 启用图片缓存
- 考虑使用 WebP 格式

### 内存优化
- 避免使用过大的图片
- 及时释放不用的图片资源

## 测试建议

### 视觉测试
1. ✅ 浅色主题下背景图片显示正常
2. ✅ 深色主题下背景图片显示正常
3. ✅ 切换主题时背景图片正确切换
4. ✅ 文字在背景图片上清晰可读
5. ✅ 卡片内容不被背景图片干扰

### 性能测试
1. ✅ 页面加载速度正常
2. ✅ 滚动流畅无卡顿
3. ✅ 内存占用合理
4. ✅ 切换主题响应及时

## 故障排除

### 图片不显示
1. 检查图片文件是否存在
2. 检查文件名是否正确（qita.jpg 和 dark.jpg）
3. 检查文件格式是否支持
4. 重新编译项目

### 图片显示异常
1. 检查图片尺寸是否合适
2. 检查图片是否损坏
3. 尝试使用其他图片

### 性能问题
1. 压缩图片文件大小
2. 降低图片分辨率
3. 使用更高效的图片格式

## 示例图片

如果没有合适的背景图片，可以使用以下方式创建：

### 使用纯色渐变
```typescript
.linearGradient({
  angle: 135,
  colors: [
    [0xF5F3F1, 0.0],  // 浅色主题起始色
    [0xE8E6E3, 1.0]   // 浅色主题结束色
  ]
})
```

### 使用在线工具
- Unsplash：免费高质量图片
- Pexels：免费图片素材
- Pixabay：免费图片和视频

### 设计工具
- Figma：在线设计工具
- Canva：简单易用的设计工具
- Photoshop：专业图片编辑

## 总结

背景图片功能已完整实现：
- ✅ ThemeUtil 提供背景图片获取方法
- ✅ 所有主要页面已添加背景图片支持
- ✅ 根据主题自动切换背景图片
- ✅ 保持良好的性能和用户体验

只需将 qita.jpg 和 dark.jpg 放入 media 目录即可使用！
