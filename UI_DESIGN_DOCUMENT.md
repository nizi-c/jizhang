# 记账应用界面详细设计文档

## 概述

本文档详细阐述了记账应用的界面设计，包括页面布局、组件设计、交互逻辑、主题系统以及视觉规范。整个应用采用了现代化的设计语言，注重用户体验和视觉美感，通过精心设计的色彩系统和组件库，为用户提供流畅、直观的记账体验。

应用的界面设计遵循 HarmonyOS 的设计规范，充分利用 ArkUI 声明式开发框架的特性，实现了高度模块化和可复用的组件体系。通过统一的设计语言和交互模式，确保用户在不同页面之间切换时能够保持一致的操作习惯。

---

## 设计理念

### 简洁至上

界面设计追求简洁明了，去除一切不必要的装饰元素，让用户能够专注于核心功能。每个页面都经过精心布局，确保信息层次清晰，重要内容突出显示。通过合理的留白和间距设计，营造出舒适的视觉体验。

### 数据可视化

记账应用的核心价值在于帮助用户理解自己的财务状况。因此，我们在界面设计中大量使用了数据可视化元素，包括饼图、折线图、柱状图、进度条等。这些可视化组件不仅美观，更重要的是能够让用户一目了然地看到收支趋势和分类分布。

### 主题适配

考虑到不同用户的使用习惯和场景需求，应用提供了完整的深色/浅色主题切换功能。两套主题不仅仅是颜色的简单替换，而是针对不同光线环境进行了专门优化，确保在任何情况下都能提供良好的可读性和视觉舒适度。

### 响应式交互

所有交互元素都提供了即时的视觉反馈，包括按钮点击效果、列表滑动、对话框动画等。这些细节设计让应用使用起来更加流畅自然，提升了整体的用户体验。

---

## 色彩系统

### 浅色主题配色方案

浅色主题采用了清新明亮的配色，适合在光线充足的环境下使用。主色调选用了温和的蓝色系，既专业又不失亲和力。


```typescript
// 浅色主题核心颜色
const LIGHT_THEME = {
  // 基础颜色
  primary: '#7B9BC8',           // 主色调 - 柔和的蓝色
  secondary: '#A5C8E8',         // 辅助色 - 浅蓝色
  background: '#F5F7FA',        // 背景色 - 浅灰蓝
  cardBg: '#FFFFFF',            // 卡片背景 - 纯白
  surface: '#FAFBFC',           // 表面色 - 极浅灰
  
  // 文本颜色
  textPrimary: '#2C3E50',       // 主要文本 - 深灰蓝
  textSecondary: '#5A6C7D',     // 次要文本 - 中灰蓝
  textTertiary: '#95A5A6',      // 三级文本 - 浅灰
  textInverse: '#FFFFFF',       // 反色文本 - 白色
  
  // 状态颜色
  income: '#6BCB77',            // 收入 - 清新绿
  incomeLight: '#E8F5E9',       // 收入浅色背景
  expense: '#E8A5A5',           // 支出 - 柔和红
  expenseLight: '#FFEBEE',      // 支出浅色背景
  
  // 边框和分割线
  border: '#E1E8ED',            // 边框色
  divider: '#F0F3F5',           // 分割线色
  
  // 辅助颜色
  success: '#6BCB77',           // 成功 - 绿色
  warning: '#FFA500',           // 警告 - 橙色
  error: '#E8A5A5',             // 错误 - 红色
  info: '#7B9BC8',              // 信息 - 蓝色
};
```

**配色原则：**

- **主色调**：选用 #7B9BC8 作为主色，这是一种介于蓝色和灰色之间的颜色，既有蓝色的专业感，又不会过于冷淡
- **收入色**：使用 #6BCB77 绿色，象征增长和积极，符合用户对收入的心理预期
- **支出色**：使用 #E8A5A5 柔和的红色，既能引起注意，又不会过于刺眼
- **背景色**：采用 #F5F7FA 浅灰蓝色，提供舒适的阅读环境，减少视觉疲劳

### 深色主题配色方案

深色主题专为夜间或低光环境设计，采用了深邃的背景色和柔和的前景色，有效减少屏幕亮度对眼睛的刺激。

```typescript
// 深色主题核心颜色
const DARK_THEME = {
  // 基础颜色
  primary: '#5A7FA8',           // 主色调 - 深蓝色
  secondary: '#7B9BC8',         // 辅助色 - 中蓝色
  background: '#1A1D23',        // 背景色 - 深灰黑
  cardBg: '#252932',            // 卡片背景 - 深灰
  surface: '#2C3038',           // 表面色 - 中深灰
  
  // 文本颜色
  textPrimary: '#E8EAED',       // 主要文本 - 浅灰白
  textSecondary: '#B8BCC2',     // 次要文本 - 中灰
  textTertiary: '#6C7278',      // 三级文本 - 深灰
  textInverse: '#1A1D23',       // 反色文本 - 深色
  
  // 状态颜色
  income: '#5FB878',            // 收入 - 深绿
  incomeLight: '#2A3F2E',       // 收入深色背景
  expense: '#D67373',           // 支出 - 深红
  expenseLight: '#3F2A2A',      // 支出深色背景
  
  // 边框和分割线
  border: '#3A3F47',            // 边框色
  divider: '#2F3339',           // 分割线色
  
  // 辅助颜色
  success: '#5FB878',           // 成功 - 深绿
  warning: '#E6A23C',           // 警告 - 深橙
  error: '#D67373',             // 错误 - 深红
  info: '#5A7FA8',              // 信息 - 深蓝
};
```

**深色主题特点：**

- **降低对比度**：相比浅色主题，深色主题的前景色和背景色对比度适中，避免过强的对比造成眼睛疲劳
- **保持色彩识别度**：虽然整体色调偏暗，但收入绿色和支出红色依然保持了良好的辨识度
- **多层次灰度**：使用多个层次的灰色（background、cardBg、surface）来区分不同的界面层级


### 语义化颜色方案

为了让不同页面和组件使用统一的颜色语义，我们定义了详细的颜色方案，涵盖了导航栏、卡片、列表、按钮等各种场景。

```typescript
// 导航栏颜色方案
NAVBAR: {
  backgroundColor: '#FFFFFF',      // 导航栏背景
  titleColor: '#2C3E50',          // 标题颜色
  backButtonColor: '#2C3E50',     // 返回按钮颜色
  buttonBackground: '#F5F7FA',    // 按钮背景
  borderColor: '#E1E8ED',         // 底部边框
}

// 统计卡片颜色方案
STAT_CARD: {
  backgroundColor: '#FFFFFF',      // 卡片背景
  titleColor: '#2C3E50',          // 标题颜色
  labelColor: '#95A5A6',          // 标签颜色
  incomeColor: '#6BCB77',         // 收入金额颜色
  expenseColor: '#E8A5A5',        // 支出金额颜色
  shadowColor: '#00000010',       // 阴影颜色
}

// 列表项颜色方案
LIST_ITEM: {
  backgroundColor: '#FFFFFF',      // 列表项背景
  itemBackground: '#FAFBFC',      // 子项背景
  categoryColor: '#2C3E50',       // 分类名称颜色
  descriptionColor: '#95A5A6',    // 描述文字颜色
  amountIncomeColor: '#6BCB77',   // 收入金额颜色
  amountExpenseColor: '#E8A5A5',  // 支出金额颜色
  dateColor: '#95A5A6',           // 日期颜色
  dividerColor: '#F0F3F5',        // 分割线颜色
}
```

这种语义化的颜色定义方式有以下优势：

- **统一性**：所有页面使用相同的颜色语义，确保视觉一致性
- **可维护性**：修改颜色只需在一处更改，所有使用该语义的地方自动更新
- **可扩展性**：新增页面或组件时，可以直接使用现有的颜色语义
- **主题切换**：深色和浅色主题使用相同的语义名称，切换时自动应用对应的颜色值

---

## 页面设计

### 首页（Index）

首页是用户打开应用后看到的第一个页面，承担着展示核心数据和快速导航的重要职责。页面采用卡片式布局，将不同类型的信息清晰地分组展示。

#### 布局结构

```typescript
Column() {
  // 1. 顶部导航栏
  Row() {
    Column() {
      Text('记账本')           // 应用标题
      Text(currentBookName)    // 当前账本名称
    }
    Spacer()
    Button('⋮')               // 菜单按钮
  }
  
  // 2. 今日收支卡片
  Column() {
    Text('今日收支')
    Row() {
      Column() { Text('收入'); Text('¥0.00') }
      Column() { Text('支出'); Text('¥0.00') }
      Column() { Text('结余'); Text('¥0.00') }
    }
  }
  
  // 3. 本月收支卡片
  Column() {
    Text('本月收支')
    Row() {
      Column() { Text('收入'); Text('¥0.00') }
      Column() { Text('支出'); Text('¥0.00') }
      Column() { Text('结余'); Text('¥0.00') }
    }
  }
  
  // 4. 最近记录列表
  Column() {
    Text('最近记录')
    List() {
      ForEach(records, (record) => {
        ListItem() { RecordItem(record) }
      })
    }
  }
}
```


#### 导航栏设计

导航栏采用简洁的设计，左侧显示应用名称和当前账本，右侧是菜单按钮。这种布局既节省空间，又能清晰地传达当前状态。

```typescript
Row() {
  Column() {
    Text('记账本')
      .fontSize(24)
      .fontWeight(FontWeight.Bold)
      .fontColor(colors.textPrimary)
    Text(currentBookName)
      .fontSize(12)
      .fontColor(colors.textSecondary)
      .margin({ top: 2 })
  }
  .alignItems(HorizontalAlign.Start)
  
  Spacer()
  
  Button({ type: ButtonType.Circle }) {
    Text('⋮').fontSize(24)
  }
  .width(44).height(44)
  .backgroundColor(colors.cardBg)
  .onClick(() => { openMenuDialog() })
}
.width('100%')
.padding({ left: 16, right: 16, top: 8, bottom: 8 })
.backgroundColor(colors.cardBg)
```

**设计要点：**

- **双行标题**：第一行显示应用名称，第二行显示当前账本，让用户清楚知道自己在哪个账本中操作
- **圆形菜单按钮**：使用三个竖点（⋮）作为菜单图标，这是移动应用中常见的设计模式
- **适当的内边距**：16px 的左右内边距和 8px 的上下内边距，确保内容不会紧贴屏幕边缘

#### 统计卡片设计

统计卡片是首页最重要的信息展示区域，采用三栏布局，分别显示收入、支出和结余。

```typescript
Column() {
  Text('今日收支')
    .fontSize(14)
    .fontColor(colors.textSecondary)
    .margin({ bottom: 12 })

  Row() {
    // 收入栏
    Column() {
      Text('收入')
        .fontSize(12)
        .fontColor(colors.textTertiary)
        .margin({ bottom: 4 })
      Text(`¥${todayIncome.toFixed(2)}`)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor(colors.income)
    }
    .layoutWeight(1)

    // 支出栏
    Column() {
      Text('支出')
        .fontSize(12)
        .fontColor(colors.textTertiary)
        .margin({ bottom: 4 })
      Text(`¥${todayExpense.toFixed(2)}`)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor(colors.expense)
    }
    .layoutWeight(1)

    // 结余栏
    Column() {
      Text('结余')
        .fontSize(12)
        .fontColor(colors.textTertiary)
        .margin({ bottom: 4 })
      Text(`¥${(todayIncome - todayExpense).toFixed(2)}`)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor(todayIncome >= todayExpense ? colors.income : colors.expense)
    }
    .layoutWeight(1)
  }
  .width('100%')
}
.width('100%')
.padding(16)
.backgroundColor(colors.cardBg)
.borderRadius(12)
.margin({ left: 16, right: 16, top: 16, bottom: 12 })
.shadow({ radius: 8, color: colors.shadow })
```

**设计亮点：**

- **三栏等宽布局**：使用 layoutWeight(1) 确保三栏平均分配空间
- **层次分明的文字**：标签使用小号灰色文字，金额使用大号粗体彩色文字，形成清晰的视觉层次
- **动态颜色**：结余的颜色根据正负值动态变化，正值显示绿色，负值显示红色
- **圆角和阴影**：12px 的圆角和轻微的阴影让卡片有浮起的感觉，增强层次感

#### 记录列表项设计

记录列表项采用左右布局，左侧显示分类和描述，右侧显示金额和日期。

```typescript
Row() {
  // 左侧：分类和描述
  Column() {
    Text(record.category)
      .fontSize(14)
      .fontWeight(FontWeight.Bold)
      .fontColor(colors.textPrimary)
    Text(record.description)
      .fontSize(12)
      .fontColor(colors.textSecondary)
      .margin({ top: 4 })
  }
  .layoutWeight(1)
  .alignItems(HorizontalAlign.Start)

  // 右侧：金额和日期
  Column() {
    Text(`${record.type === 'income' ? '+' : '-'}¥${record.amount.toFixed(2)}`)
      .fontSize(14)
      .fontWeight(FontWeight.Bold)
      .fontColor(record.type === 'income' ? colors.income : colors.expense)
    Text(record.dateStr)
      .fontSize(12)
      .fontColor(colors.textTertiary)
      .margin({ top: 4 })
  }
  .alignItems(HorizontalAlign.End)
}
.width('100%')
.padding(12)
.backgroundColor(colors.surface)
```

**交互设计：**

- **点击查看详情**：用户点击列表项可以查看记录的完整信息
- **滑动删除**：向左滑动列表项可以显示删除按钮
- **视觉反馈**：点击时有轻微的背景色变化，提供即时反馈


### 添加记录页面（AddRecordPage）

添加记录页面是用户最常使用的功能之一，界面设计注重输入效率和操作便捷性。页面采用表单式布局，将所有输入项按逻辑顺序排列。

#### 页面结构

```typescript
Column() {
  // 1. 导航栏
  Row() {
    Button('←')                    // 返回按钮
    Text('添加账单')               // 页面标题
    Spacer()
  }
  
  Scroll() {
    Column() {
      // 2. 类型选择（收入/支出）
      Row() {
        Button('支出')
        Button('收入')
      }
      
      // 3. 分类选择
      Text('分类')
      TextInput()                  // 分类输入框
      Scroll() {                   // 分类图标网格
        Row() {
          ForEach(categories, (cat) => {
            CategoryIcon(cat)
          })
        }
      }
      
      // 4. 金额输入
      Text('金额')
      TextInput({ type: InputType.Number })
      
      // 5. 用途描述
      Text('用途')
      TextInput()
      
      // 6. 日期选择
      Text('日期')
      TextInput().onClick(() => { DatePickerDialog.show() })
      
      // 7. 心情选择
      Text('心情')
      Row() {
        Button('😊满意')
        Button('😟后悔')
        Button('🎉惊喜')
      }
      
      // 8. 操作按钮
      Row() {
        Button('取消')
        Button('保存')
      }
    }
  }
}
```

#### 类型选择器设计

类型选择器使用两个并排的按钮，让用户在收入和支出之间快速切换。选中状态有明显的视觉区分。

```typescript
Row() {
  Button('支出')
    .width('48%')
    .height(44)
    .backgroundColor(recordType === 'expense' ? 
      colors.expense : colors.surface)
    .fontColor(recordType === 'expense' ? 
      '#FFFFFF' : colors.textPrimary)
    .onClick(() => {
      recordType = 'expense';
      updateCategories();
    })

  Spacer().width('4%')

  Button('收入')
    .width('48%')
    .height(44)
    .backgroundColor(recordType === 'income' ? 
      colors.income : colors.surface)
    .fontColor(recordType === 'income' ? 
      '#FFFFFF' : colors.textPrimary)
    .onClick(() => {
      recordType = 'income';
      updateCategories();
    })
}
.width('100%')
.margin({ bottom: 16 })
```

**设计特点：**

- **48% 宽度**：两个按钮各占 48% 宽度，中间留 4% 间隙，视觉上更加平衡
- **动态背景色**：选中的按钮使用对应的主题色（支出红色、收入绿色），未选中使用灰色
- **白色文字**：选中状态使用白色文字，确保在彩色背景上的可读性
- **即时切换**：点击后立即切换类型，并自动更新分类列表

#### 分类选择器设计

分类选择器是页面的核心交互区域，采用横向滚动的图标网格布局，让用户可以快速浏览和选择分类。

```typescript
// 分类输入框
TextInput({ placeholder: '输入分类名称', text: selectedCategory })
  .width('100%')
  .height(44)
  .padding({ left: 12, right: 12 })
  .backgroundColor(colors.surface)
  .borderRadius(8)
  .onChange((value: string) => {
    selectedCategory = value;
  })
  .margin({ bottom: 8 })

// 分类图标网格
Scroll() {
  Row() {
    ForEach(categories, (category: Category) => {
      Column() {
        Text(category.icon)
          .fontSize(24)
          .margin({ bottom: 4 })
        Text(category.name)
          .fontSize(10)
          .fontColor(selectedCategory === category.name ? 
            colors.primary : colors.textSecondary)
      }
      .width(60)
      .height(80)
      .padding(8)
      .backgroundColor(selectedCategory === category.name ? 
        colors.primaryLight : colors.surface)
      .borderRadius(8)
      .border({
        width: selectedCategory === category.name ? 2 : 0,
        color: colors.primary
      })
      .margin({ right: 8 })
      .onClick(() => {
        selectedCategory = category.name;
      })
    })
    
    // 自定义分类按钮
    Column() {
      Text('➕').fontSize(24)
      Text('自定义').fontSize(10)
    }
    .width(60)
    .height(80)
    .border({ width: 1, style: BorderStyle.Dashed })
    .onClick(() => { showCustomCategoryDialog = true; })
  }
}
.scrollable(ScrollDirection.Horizontal)
.scrollBar(BarState.Off)
.height(90)
```

**交互亮点：**

- **双重输入方式**：既可以直接在输入框输入分类名称，也可以点击图标选择
- **横向滚动**：分类图标采用横向滚动布局，节省垂直空间
- **选中状态**：选中的分类有浅色背景和边框高亮，视觉反馈明确
- **自定义分类**：提供"+"按钮让用户添加自定义分类，增强灵活性


#### 日期选择器集成

日期选择使用 HarmonyOS 系统提供的 DatePickerDialog，确保与系统风格一致。

```typescript
TextInput({ placeholder: 'YYYY-MM-DD', text: selectedDate })
  .width('100%')
  .height(44)
  .backgroundColor(colors.surface)
  .borderRadius(8)
  .onClick(() => {
    DatePickerDialog.show({
      selected: selectedDate ? new Date(selectedDate) : new Date(),
      onAccept: (value: DatePickerResult) => {
        if (value.year && value.month !== undefined && value.day) {
          const year = value.year;
          const month = String(value.month + 1).padStart(2, '0');
          const day = String(value.day).padStart(2, '0');
          selectedDate = `${year}-${month}-${day}`;
        }
      }
    });
  })
```

**用户体验优化：**

- **默认今天**：默认选中今天的日期，减少用户操作
- **格式化显示**：日期以 YYYY-MM-DD 格式显示，清晰易读
- **点击触发**：点击输入框即可打开日期选择器，无需额外按钮

#### 心情选择器设计

心情选择器是一个有趣的功能，让记账变得更加人性化。采用横向排列的按钮组。

```typescript
Scroll() {
  Row() {
    Button('😊满意')
      .height(44)
      .padding({ left: 16, right: 16 })
      .backgroundColor(selectedMood === '😊满意' ? 
        colors.primary : colors.surface)
      .fontColor(selectedMood === '😊满意' ? 
        '#FFFFFF' : colors.textPrimary)
      .onClick(() => { selectedMood = '😊满意'; })
      .margin({ right: 8 })

    Button('😟后悔')
      .height(44)
      .padding({ left: 16, right: 16 })
      .backgroundColor(selectedMood === '😟后悔' ? 
        colors.primary : colors.surface)
      .fontColor(selectedMood === '😟后悔' ? 
        '#FFFFFF' : colors.textPrimary)
      .onClick(() => { selectedMood = '😟后悔'; })
      .margin({ right: 8 })

    Button('🎉惊喜')
      .height(44)
      .padding({ left: 16, right: 16 })
      .backgroundColor(selectedMood === '🎉惊喜' ? 
        colors.primary : colors.surface)
      .fontColor(selectedMood === '🎉惊喜' ? 
        '#FFFFFF' : colors.textPrimary)
      .onClick(() => { selectedMood = '🎉惊喜'; })
  }
}
.scrollable(ScrollDirection.Horizontal)
.scrollBar(BarState.Off)
```

**设计理念：**

- **Emoji 表达**：使用 Emoji 图标直观表达情绪，无需文字解释
- **可选功能**：心情是可选字段，不强制用户填写
- **情感化设计**：让冰冷的数字记录变得有温度

#### 预算预警功能

当用户添加支出记录时，系统会自动检查是否触发预算预警，并通过对话框提醒用户。

```typescript
async checkBudgetWarning(record: AccountRecord) {
  const budgets = await BudgetUtil.getAllBudgets();
  const categoryBudget = budgets.find(b => b.category === record.category);
  
  if (!categoryBudget) return;

  const records = await StorageUtil.getRecords();
  const totalUsed = records
    .filter(r => r.category === record.category && r.type === 'expense')
    .reduce((sum, r) => sum + r.amount, 0);

  const percentage = (totalUsed / categoryBudget.amount) * 100;

  if (percentage > 100) {
    const exceeded = totalUsed - categoryBudget.amount;
    AlertDialog.show({
      title: '🕐 预算超支提醒',
      message: `【${record.category}】预算已超支！\n\n` +
               `预算金额：¥${categoryBudget.amount.toFixed(2)}\n` +
               `已使用：¥${totalUsed.toFixed(2)}\n` +
               `超支：¥${exceeded.toFixed(2)}`,
      confirm: { value: '知道了', action: () => {} }
    });
  } else if (percentage >= categoryBudget.warningThreshold) {
    const remaining = categoryBudget.amount - totalUsed;
    AlertDialog.show({
      title: '🕐 预算预警',
      message: `【${record.category}】预算即将超支！\n\n` +
               `预算金额：¥${categoryBudget.amount.toFixed(2)}\n` +
               `已使用：¥${totalUsed.toFixed(2)}（${percentage.toFixed(1)}%）\n` +
               `剩余：¥${remaining.toFixed(2)}`,
      confirm: { value: '知道了', action: () => {} }
    });
  }
}
```

**智能提醒：**

- **超支提醒**：当支出超过预算时，显示红色警告
- **预警提醒**：当支出达到预算的 90% 时，显示橙色预警
- **详细信息**：提醒中包含预算金额、已使用金额、剩余金额等详细信息
- **非侵入式**：提醒以对话框形式出现，用户确认后自动关闭

---

### 统计图表页面（ChartPage）

统计图表页面是应用的数据分析中心，提供了多维度、多图表类型的数据可视化功能。页面设计注重信息的清晰呈现和交互的流畅性。

#### 页面布局

```typescript
Column() {
  // 1. 导航栏
  Row() {
    Button('←')                    // 返回按钮
    Text('统计')                   // 页面标题
    Button('⋮')                    // 菜单按钮
  }
  
  Scroll() {
    Column() {
      // 2. 时间选择器
      Row() {
        Button('<')                // 上一个时间段
        Text('2024年11月')         // 当前时间段
        Button('>')                // 下一个时间段
      }
      
      // 3. 收支概览卡片
      Row() {
        Column() { Text('收入'); Text('¥0.00') }
        Column() { Text('支出'); Text('¥0.00') }
        Column() { Text('结余'); Text('¥0.00') }
      }
      
      // 4. 图表展示区
      // 根据选择的图表类型显示不同的图表
      if (chartType === 'pie') {
        PieCharts()              // 饼图
      } else if (chartType === 'line') {
        LineCharts()             // 折线图
      } else if (chartType === 'bar') {
        BarCharts()              // 柱状图
      }
    }
  }
}
```


#### 时间维度选择器

时间维度选择器允许用户在周、月、年三个维度之间切换，并可以前后浏览不同时间段的数据。

```typescript
// 时间选择器
Row() {
  Button('<')
    .width(40)
    .height(36)
    .backgroundColor(colors.surface)
    .fontColor(colors.textPrimary)
    .onClick(() => { previousPeriod(); })

  Text(getTimeLabel())
    .fontSize(16)
    .fontWeight(FontWeight.Bold)
    .fontColor(colors.textPrimary)
    .layoutWeight(1)
    .textAlign(TextAlign.Center)

  Button('>')
    .width(40)
    .height(36)
    .backgroundColor(colors.surface)
    .fontColor(colors.textPrimary)
    .onClick(() => { nextPeriod(); })
}
.width('100%')
.padding(12)
.backgroundColor(colors.cardBg)
.margin({ bottom: 16 })

// 时间标签生成逻辑
getTimeLabel(): string {
  const year = currentDate.getFullYear();
  const month = currentDate.getMonth() + 1;
  
  switch (timeDimension) {
    case 'week':
      const weekNum = getWeekNumber(currentDate);
      return `${year}年第${weekNum}周`;
    case 'month':
      return `${year}年${month}月`;
    case 'year':
      return `${year}年`;
  }
}
```

**交互设计：**

- **左右箭头**：点击左右箭头可以切换到上一个或下一个时间段
- **动态标签**：根据选择的时间维度显示不同格式的标签
- **循环浏览**：可以无限向前或向后浏览历史数据

#### 饼图设计

饼图使用 HarmonyOS 的 Progress 组件（Ring 类型）实现，通过多个同心圆环叠加展示不同分类的占比。

```typescript
Column() {
  Text('支出分类分布')
    .fontSize(16)
    .fontWeight(FontWeight.Bold)
    .fontColor(colors.textPrimary)
    .margin({ bottom: 16 })

  // 饼图可视化（使用同心圆环）
  Stack() {
    ForEach(expenseCategories.slice(0, 5), (cat: CategorySummary, index: number) => {
      Progress({
        value: cat.percentage,
        total: 100,
        type: ProgressType.Ring
      })
        .width(180 - index * 20)
        .height(180 - index * 20)
        .color(cat.color)
        .style({ strokeWidth: 15 })
    })
  }
  .width('100%')
  .height(180)
  .alignContent(Alignment.Center)
  .margin({ bottom: 16 })

  // 图例
  Column() {
    ForEach(expenseCategories, (cat: CategorySummary) => {
      Row() {
        Row()
          .width(12)
          .height(12)
          .backgroundColor(cat.color)
          .borderRadius(2)
          .margin({ right: 8 })

        Text(cat.category)
          .fontSize(14)
          .fontColor(colors.textPrimary)
          .layoutWeight(1)

        Text(`${cat.percentage.toFixed(1)}%`)
          .fontSize(12)
          .fontColor(colors.textSecondary)
          .margin({ right: 8 })

        Text(`¥${cat.amount.toFixed(2)}`)
          .fontSize(14)
          .fontWeight(FontWeight.Bold)
          .fontColor(colors.expense)
      }
      .width('100%')
      .padding(12)
      .backgroundColor(colors.surface)
      .borderRadius(8)
      .margin({ bottom: 8 })
    })
  }
}
.width('100%')
.padding(16)
.backgroundColor(colors.cardBg)
.borderRadius(8)
```

**设计亮点：**

- **同心圆环**：使用多个不同大小的圆环叠加，形成类似饼图的效果
- **颜色区分**：每个分类使用不同的颜色，便于识别
- **详细图例**：图例不仅显示分类名称和颜色，还包含百分比和金额
- **限制数量**：饼图最多显示前 5 个分类，避免视觉混乱

#### 折线图设计

折线图使用 Canvas 组件绘制，可以同时展示收入和支出的趋势变化。

```typescript
Column() {
  Text('收支趋势')
    .fontSize(16)
    .fontWeight(FontWeight.Bold)
    .margin({ bottom: 16 })

  // 图例
  Row() {
    Row() {
      Row().width(12).height(3).backgroundColor(colors.income)
      Text('收入').fontSize(12).margin({ left: 4 })
    }.margin({ right: 20 })

    Row() {
      Row().width(12).height(3).backgroundColor(colors.expense)
      Text('支出').fontSize(12).margin({ left: 4 })
    }
  }
  .margin({ bottom: 16 })

  // 图表主体
  Row() {
    // Y轴标签
    Column() {
      ForEach([4, 3, 2, 1, 0], (level: number) => {
        Text(getYAxisLabel(level))
          .fontSize(10)
          .fontColor(colors.textSecondary)
          .height(30)
          .textAlign(TextAlign.End)
      })
    }
    .width(50)
    .margin({ right: 8 })

    // 图表区域
    Stack() {
      // 网格线
      Column() {
        ForEach([0, 1, 2, 3, 4], (line: number) => {
          Row()
            .width('100%')
            .height(1)
            .backgroundColor(colors.divider)
            .margin({ bottom: line < 4 ? 29 : 0 })
        })
      }

      // Canvas 绘制折线
      Canvas(chartContext)
        .width('100%')
        .height(150)
        .onReady(() => { drawLineChart(); })
    }
    .layoutWeight(1)
    .height(150)
  }

  // X轴标签
  Row() {
    Row().width(58)
    Row() {
      ForEach(trendLabels, (label: string) => {
        Text(label)
          .fontSize(10)
          .fontColor(colors.textSecondary)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
      })
    }
    .layoutWeight(1)
  }
  .margin({ top: 8 })
}
```

**Canvas 绘制逻辑：**

```typescript
drawLineChart() {
  const ctx = chartContext;
  const width = ctx.width;
  const height = 150;
  const totalPoints = trendLabels.length;
  
  // 清空画布
  ctx.clearRect(0, 0, width, height);
  
  if (totalPoints < 2) return;
  
  const pointSpacing = width / (totalPoints - 1);
  
  // 绘制收入折线
  ctx.beginPath();
  ctx.strokeStyle = colors.income;
  ctx.lineWidth = 2.5;
  ctx.lineJoin = 'round';
  ctx.lineCap = 'round';
  
  for (let i = 0; i < totalPoints; i++) {
    const x = i * pointSpacing;
    const y = height - getBarHeight(trendIncomeData[i]);
    
    if (i === 0) {
      ctx.moveTo(x, y);
    } else {
      ctx.lineTo(x, y);
    }
  }
  ctx.stroke();
  
  // 绘制支出折线（类似逻辑）
  // ...
  
  // 绘制数据点
  for (let i = 0; i < totalPoints; i++) {
    const x = i * pointSpacing;
    
    // 收入数据点
    if (trendIncomeData[i] > 0) {
      const y = height - getBarHeight(trendIncomeData[i]);
      ctx.beginPath();
      ctx.arc(x, y, 4, 0, 2 * Math.PI);
      ctx.fillStyle = colors.income;
      ctx.fill();
      ctx.strokeStyle = '#FFFFFF';
      ctx.lineWidth = 2;
      ctx.stroke();
    }
    
    // 支出数据点（类似逻辑）
    // ...
  }
}
```

**技术特点：**

- **Canvas 绘制**：使用 Canvas API 绘制平滑的折线和数据点
- **双线对比**：同时显示收入和支出两条折线，便于对比
- **数据点标记**：在折线上标记数据点，并用白色边框突出显示
- **网格背景**：添加网格线作为参考，帮助用户读取数值


#### 柱状图设计

柱状图采用横向布局，每个分类一行，通过彩色条形的长度表示金额大小。

```typescript
Column() {
  Text('支出分类对比')
    .fontSize(16)
    .fontWeight(FontWeight.Bold)
    .margin({ bottom: 16 })

  ForEach(expenseCategories, (cat: CategorySummary) => {
    Column() {
      Row() {
        // 分类名称
        Text(cat.category)
          .fontSize(14)
          .fontColor(colors.textPrimary)
          .width(60)

        // 彩色条形
        Column() {
          Row()
            .width(`${cat.percentage}%`)
            .height(24)
            .backgroundColor(cat.color)
            .borderRadius(4)
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)

        // 金额
        Text(`¥${cat.amount.toFixed(2)}`)
          .fontSize(12)
          .fontColor(colors.expense)
          .fontWeight(FontWeight.Bold)
          .margin({ left: 8 })
          .width(80)
          .textAlign(TextAlign.End)
      }
      .width('100%')
    }
    .width('100%')
    .margin({ bottom: 12 })
  })
}
.width('100%')
.padding(16)
.backgroundColor(colors.cardBg)
.borderRadius(8)
```

**设计优势：**

- **直观对比**：条形长度直接反映金额大小，一目了然
- **精确数值**：右侧显示具体金额，满足精确查看需求
- **颜色编码**：每个分类使用独特的颜色，与饼图保持一致
- **紧凑布局**：横向布局节省空间，可以展示更多分类

---

### 预算管理页面（BudgetPage）

预算管理页面帮助用户设置和监控各个分类的支出预算，通过可视化的进度条和状态标识，让用户清楚了解预算使用情况。

#### 页面结构

```typescript
Column() {
  // 1. 导航栏
  Row() {
    Button('←')                    // 返回按钮
    Text('预算管理')               // 页面标题
    Button('+')                    // 添加预算按钮
  }
  
  Scroll() {
    Column() {
      // 2. 总体概览卡片
      Column() {
        Text('本月预算概览')
        Row() {
          Column() { Text('总预算'); Text('¥0') }
          Column() { Text('已使用'); Text('¥0') }
          Column() { Text('剩余'); Text('¥0') }
        }
        Progress()                 // 总体进度条
        Text('0%')
      }
      
      // 3. 预算占比环形图
      BudgetPieChart()
      
      // 4. 预算列表
      ForEach(budgetProgresses, (progress) => {
        BudgetItem(progress)
      })
    }
  }
}
```

#### 预算项设计

每个预算项显示分类名称、预算金额、已使用金额、进度条和状态标识。

```typescript
Column() {
  // 标题行
  Row() {
    Row() {
      Text(progress.category)
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .fontColor(colors.textPrimary)
      
      // 超支或预警标识
      if (progress.status === 'exceeded' || progress.status === 'warning') {
        Image($r('app.media.clock'))
          .width(16).height(16)
          .margin({ left: 6 })
        Text(progress.status === 'exceeded' ? '超支' : '预警')
          .fontSize(12)
          .fontColor(progress.status === 'exceeded' ? 
            colors.expense : '#FFA500')
          .fontWeight(FontWeight.Bold)
          .margin({ left: 2 })
      }
    }
    .layoutWeight(1)

    Button('删除')
      .fontSize(12)
      .height(28)
      .backgroundColor('#E8A5A5')
      .fontColor('#FFFFFF')
      .onClick(() => { deleteBudget(progress.budgetId); })
  }
  .width('100%')
  .margin({ bottom: 8 })

  // 金额显示
  Row() {
    Text(`¥${progress.usedAmount.toFixed(0)}`)
      .fontSize(14)
      .fontColor(colors.expense)
    Text(' / ')
      .fontSize(14)
      .fontColor(colors.textSecondary)
    Text(`¥${progress.budgetAmount.toFixed(0)}`)
      .fontSize(14)
      .fontColor(colors.textPrimary)
  }
  .width('100%')
  .margin({ bottom: 8 })

  // 进度条
  Progress({ 
    value: Math.min(progress.percentage, 100), 
    total: 100, 
    type: ProgressType.Linear 
  })
    .width('100%')
    .height(8)
    .color(getProgressColor(progress.status))
    .margin({ bottom: 8 })

  // 百分比和剩余金额
  Row() {
    Text(`${progress.percentage.toFixed(1)}%`)
      .fontSize(12)
      .fontColor(colors.textSecondary)
    
    Text(progress.status === 'exceeded' ? 
      `超支 ¥${Math.abs(progress.remainingAmount).toFixed(0)}` :
      `剩余 ¥${progress.remainingAmount.toFixed(0)}`)
      .fontSize(12)
      .fontColor(progress.status === 'exceeded' ?
        colors.expense : colors.income)
      .layoutWeight(1)
      .textAlign(TextAlign.End)
  }
  .width('100%')
}
.width('100%')
.padding(16)
.backgroundColor(colors.cardBg)
.borderRadius(12)
.margin({ bottom: 12 })
```

**状态颜色逻辑：**

```typescript
getProgressColor(status: string): string {
  switch (status) {
    case 'normal':
      return colors.income;      // 绿色 - 正常
    case 'warning':
      return '#FFA500';          // 橙色 - 预警
    case 'exceeded':
      return colors.expense;     // 红色 - 超支
    default:
      return colors.income;
  }
}
```

**设计特点：**

- **三色状态**：绿色表示正常，橙色表示预警，红色表示超支
- **视觉警示**：超支和预警状态有明显的图标和文字标识
- **详细信息**：显示已使用金额、预算金额、百分比、剩余金额等完整信息
- **快速操作**：提供删除按钮，方便管理预算


#### 添加预算对话框

添加预算对话框采用模态设计，覆盖在页面上方，引导用户完成预算设置。

```typescript
Column() {
  Column() {
    Text('添加预算')
      .fontSize(18)
      .fontWeight(FontWeight.Bold)
      .margin({ bottom: 20 })

    // 分类选择
    Text('分类').fontSize(14).margin({ bottom: 8 })
    Scroll() {
      Row() {
        ForEach(availableCategories, (cat: Category) => {
          Button() {
            Column() {
              Text(cat.icon).fontSize(20)
              Text(cat.name).fontSize(10)
            }
          }
          .width(60).height(60)
          .backgroundColor(newCategory === cat.name ?
            colors.primary : colors.surface)
          .borderRadius(8)
          .margin({ right: 8 })
          .onClick(() => { newCategory = cat.name; })
        })
      }
    }
    .scrollable(ScrollDirection.Horizontal)
    .scrollBar(BarState.Off)
    .margin({ bottom: 16 })

    // 金额输入
    Text('金额').fontSize(14).margin({ bottom: 8 })
    TextInput({ placeholder: '请输入预算金额', text: newAmount })
      .type(InputType.Number)
      .width('100%')
      .height(44)
      .backgroundColor(colors.surface)
      .margin({ bottom: 16 })

    // 周期选择
    Text('周期').fontSize(14).margin({ bottom: 8 })
    Row() {
      Button('周')
        .width('30%').height(36)
        .backgroundColor(newPeriod === 'week' ?
          colors.primary : colors.surface)
        .onClick(() => { newPeriod = 'week'; })
        .margin({ right: 8 })

      Button('月')
        .width('30%').height(36)
        .backgroundColor(newPeriod === 'month' ?
          colors.primary : colors.surface)
        .onClick(() => { newPeriod = 'month'; })
        .margin({ right: 8 })

      Button('年')
        .width('30%').height(36)
        .backgroundColor(newPeriod === 'year' ?
          colors.primary : colors.surface)
        .onClick(() => { newPeriod = 'year'; })
    }
    .width('100%')
    .margin({ bottom: 20 })

    // 操作按钮
    Row() {
      Button('取消')
        .width('48%').height(44)
        .backgroundColor(colors.surface)
        .onClick(() => { showAddDialog = false; })

      Button('确定')
        .width('48%').height(44)
        .backgroundColor(colors.primary)
        .fontColor('#FFFFFF')
        .onClick(() => { addBudget(); })
    }
    .width('100%')
    .justifyContent(FlexAlign.SpaceBetween)
  }
  .width('85%')
  .padding(20)
  .backgroundColor(colors.cardBg)
  .borderRadius(12)
  .shadow({ radius: 20, color: '#00000040' })
}
.width('100%')
.height('100%')
.backgroundColor('#00000040')
.justifyContent(FlexAlign.Center)
.onClick(() => { showAddDialog = false; })
```

**对话框设计要点：**

- **半透明遮罩**：使用 #00000040 半透明黑色作为背景遮罩
- **居中显示**：对话框在屏幕中央显示，宽度为屏幕的 85%
- **圆角阴影**：12px 圆角和阴影效果，让对话框有浮起的感觉
- **点击遮罩关闭**：点击对话框外的遮罩区域可以关闭对话框

---

### 账本管理页面（AccountBooksPage）

账本管理页面允许用户创建、切换和管理多个账本，每个账本的数据完全独立。

#### 账本列表项设计

```typescript
Row() {
  // 图标
  Text(book.icon)
    .fontSize(32)
    .margin({ right: 16 })

  // 名称和信息
  Column() {
    Row() {
      Text(book.name)
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .fontColor(colors.textPrimary)
        .onClick(() => { showRenameBookDialog(book); })
      
      // 默认标签
      if (book.isDefault) {
        Text('默认')
          .fontSize(10)
          .fontColor('#FFFFFF')
          .backgroundColor(colors.income)
          .padding({ left: 6, right: 6, top: 2, bottom: 2 })
          .borderRadius(4)
          .margin({ left: 8 })
      }

      // 当前标签
      if (book.id === currentBookId) {
        Text('当前')
          .fontSize(10)
          .fontColor('#FFFFFF')
          .backgroundColor('#7B9BC8')
          .padding({ left: 6, right: 6, top: 2, bottom: 2 })
          .borderRadius(4)
          .margin({ left: 8 })
      }
    }

    Text(`创建于 ${formatDate(book.createTime)}`)
      .fontSize(12)
      .fontColor(colors.textSecondary)
      .margin({ top: 4 })
  }
  .layoutWeight(1)
  .alignItems(HorizontalAlign.Start)

  // 操作按钮
  Row() {
    if (book.id !== currentBookId) {
      Button('切换')
        .fontSize(14)
        .height(32)
        .backgroundColor(colors.primary)
        .fontColor('#FFFFFF')
        .onClick(() => { switchBook(book.id); })
        .margin({ right: 8 })
    }

    if (!book.isDefault && book.id !== currentBookId) {
      Button('删除')
        .fontSize(14)
        .height(32)
        .backgroundColor('#E8A5A5')
        .fontColor('#FFFFFF')
        .onClick(() => { deleteBook(book); })
    }
  }
}
.width('100%')
.padding(16)
.backgroundColor(colors.cardBg)
.borderRadius(12)
.margin({ bottom: 12 })
.shadow({ radius: 4, color: colors.shadow })
```

**交互设计：**

- **点击名称重命名**：点击账本名称可以打开重命名对话框
- **状态标签**：使用彩色标签标识默认账本和当前账本
- **条件按钮**：根据账本状态显示不同的操作按钮
- **保护机制**：默认账本和当前账本不能删除

#### 创建账本对话框

创建账本对话框提供了图标选择功能，让用户可以为账本选择个性化的图标。

```typescript
Column() {
  Text('创建新账本')
    .fontSize(18)
    .fontWeight(FontWeight.Bold)
    .margin({ bottom: 20 })

  // 账本名称
  Text('账本名称').fontSize(14).margin({ bottom: 8 })
  TextInput({ placeholder: '请输入账本名称', text: newBookName })
    .width('100%')
    .height(44)
    .backgroundColor(colors.surface)
    .onChange((value: string) => { newBookName = value; })
    .margin({ bottom: 16 })

  // 选择图标
  Text('选择图标').fontSize(14).margin({ bottom: 8 })
  Grid() {
    ForEach(bookIcons, (icon: string) => {
      GridItem() {
        Text(icon)
          .fontSize(32)
          .width(60)
          .height(60)
          .textAlign(TextAlign.Center)
          .backgroundColor(newBookIcon === icon ? 
            colors.primaryLight : colors.surface)
          .borderRadius(8)
          .onClick(() => { newBookIcon = icon; })
      }
    })
  }
  .columnsTemplate('1fr 1fr 1fr 1fr 1fr')
  .rowsGap(8)
  .columnsGap(8)
  .width('100%')
  .height(140)
  .margin({ bottom: 20 })

  // 按钮
  Row() {
    Button('取消')
      .width('48%').height(44)
      .backgroundColor(colors.surface)
      .onClick(() => { showCreateDialog = false; })

    Button('创建')
      .width('48%').height(44)
      .backgroundColor(colors.primary)
      .fontColor('#FFFFFF')
      .onClick(() => { createBook(); })
  }
  .width('100%')
  .justifyContent(FlexAlign.SpaceBetween)
}
.width('85%')
.padding(20)
.backgroundColor(colors.cardBg)
.borderRadius(12)
```

**图标网格设计：**

- **5 列布局**：使用 Grid 组件创建 5 列的图标网格
- **选中高亮**：选中的图标有浅色背景高亮
- **丰富选择**：提供 10 个不同的 Emoji 图标供选择
- **即时反馈**：点击图标立即更新选中状态

---

## 组件设计

### 主题提供者（ThemeProvider）

主题提供者是一个全局组件，负责管理应用的主题状态和颜色方案。

```typescript
@Component
export struct ThemeProvider {
  @State colors: ThemeColors = ThemeUtil.LIGHT_THEME;
  @State currentTheme: ThemeType = 'light';
  @BuilderParam content: () => void;
  private listeners: ThemeChangeListener[] = [];

  aboutToAppear() {
    this.initTheme();
    DynamicColors.setProvider(this);
  }

  private initTheme() {
    this.currentTheme = ThemeUtil.getTheme();
    this.colors = ThemeUtil.getColors();
  }

  // 切换主题
  switchTheme() {
    const newTheme = ThemeUtil.toggleTheme();
    this.currentTheme = newTheme;
    this.colors = ThemeUtil.getColors();
    this.notifyListeners();
  }

  // 设置主题
  setTheme(theme: ThemeType) {
    ThemeUtil.setTheme(theme);
    this.currentTheme = theme;
    this.colors = ThemeUtil.getColors();
    this.notifyListeners();
  }

  build() {
    Column() {
      this.content()
    }
    .width('100%')
    .height('100%')
    .backgroundColor(this.colors.background)
  }
}
```

**设计模式：**

- **Provider 模式**：作为全局主题提供者，向下传递主题状态
- **观察者模式**：支持注册监听器，主题变化时通知所有监听者
- **BuilderParam**：使用 BuilderParam 接收子组件内容
- **状态管理**：使用 @State 装饰器管理主题状态，自动触发 UI 更新


### 动态颜色管理器（DynamicColors）

动态颜色管理器提供了一套静态方法，让任何组件都能方便地获取当前主题的颜色。

```typescript
export class DynamicColors {
  private static provider: ThemeProvider | null = null;

  static setProvider(provider: ThemeProvider) {
    DynamicColors.provider = provider;
  }

  static getColors(): ThemeColors {
    return ThemeUtil.getColors();
  }

  // 基础颜色
  static getPrimaryColor(): string {
    return ThemeUtil.getColors().primary;
  }

  static getBackgroundColor(): string {
    return ThemeUtil.getColors().background;
  }

  static getCardBgColor(): string {
    return ThemeUtil.getColors().cardBg;
  }

  // 文本颜色
  static getTextColor(): string {
    return ThemeUtil.getColors().textPrimary;
  }

  static getTextSecondaryColor(): string {
    return ThemeUtil.getColors().textSecondary;
  }

  // 状态颜色
  static getIncomeColor(): string {
    return ThemeUtil.getColors().income;
  }

  static getExpenseColor(): string {
    return ThemeUtil.getColors().expense;
  }

  // 主题判断
  static isDarkTheme(): boolean {
    return ThemeUtil.getTheme() === 'dark';
  }

  static isLightTheme(): boolean {
    return ThemeUtil.getTheme() === 'light';
  }
}
```

**使用示例：**

```typescript
// 在任何组件中使用
Text('标题')
  .fontColor(DynamicColors.getTextColor())
  .backgroundColor(DynamicColors.getCardBgColor())

// 条件样式
if (DynamicColors.isDarkTheme()) {
  // 深色主题特殊处理
}
```

---

## 交互设计

### 页面导航

应用使用 HarmonyOS 的 router 模块实现页面导航，支持前进、后退和参数传递。

```typescript
// 跳转到添加记录页面
router.pushUrl({ url: 'pages/AddRecordPage' });

// 跳转到统计页面
router.pushUrl({ url: 'pages/ChartPageEntry' });

// 带参数跳转到列表页面
router.pushUrl({ 
  url: 'pages/ListPage',
  params: {
    queryFilters: {
      type: 'expense',
      category: '食物'
    }
  }
});

// 返回上一页
router.back();
```

**导航模式：**

- **Push 导航**：使用 pushUrl 跳转到新页面，保留导航历史
- **参数传递**：通过 params 对象传递页面参数
- **返回导航**：使用 back() 返回上一页，自动刷新数据

### 对话框交互

应用中大量使用对话框进行二次确认和信息输入，提供了统一的对话框设计模式。

#### 自定义对话框

```typescript
// 对话框状态
@State showDialog: boolean = false;

// 显示对话框
showDialog = true;

// 对话框 UI
if (showDialog) {
  Column() {
    Column() {
      Text('对话框标题')
      // 对话框内容
      Row() {
        Button('取消').onClick(() => { showDialog = false; })
        Button('确定').onClick(() => { 
          // 处理逻辑
          showDialog = false;
        })
      }
    }
    .width('85%')
    .padding(20)
    .backgroundColor(colors.cardBg)
    .borderRadius(12)
  }
  .width('100%')
  .height('100%')
  .backgroundColor('#00000040')
  .justifyContent(FlexAlign.Center)
  .onClick(() => { showDialog = false; })
}
```

#### 系统对话框

```typescript
// 确认对话框
AlertDialog.show({
  title: '确认删除',
  message: '确定要删除这条记录吗？',
  confirm: {
    value: '确定',
    action: () => {
      // 执行删除
    }
  },
  cancel: {
    value: '取消',
    action: () => {}
  }
});

// 日期选择对话框
DatePickerDialog.show({
  selected: new Date(),
  onAccept: (value: DatePickerResult) => {
    // 处理选中的日期
  }
});
```

**对话框设计原则：**

- **模态显示**：对话框覆盖在页面上方，阻止背景交互
- **半透明遮罩**：使用半透明黑色遮罩，突出对话框内容
- **点击遮罩关闭**：点击对话框外的区域可以关闭对话框
- **明确的操作按钮**：提供清晰的"确定"和"取消"按钮

### 列表交互

列表是应用中最常见的交互元素，提供了丰富的交互功能。

#### 滑动删除

```typescript
@Builder
buildRecordItemWithSwipe(record: AccountRecord) {
  Swiper() {
    // 正常显示的内容
    this.buildRecordItem(record)

    // 滑动后显示的删除按钮
    Button('删除')
      .width('100%')
      .height('100%')
      .backgroundColor(colors.expense)
      .fontColor('#FFFFFF')
      .onClick(() => {
        viewModel.deleteRecord(record.id);
        records = records.filter(r => r.id !== record.id);
      })
  }
  .indicator(false)
}
```

**交互流程：**

1. 用户向左滑动列表项
2. 列表项向左移动，露出右侧的删除按钮
3. 用户点击删除按钮
4. 显示确认对话框
5. 确认后删除记录并更新列表

#### 下拉刷新

```typescript
Scroll() {
  Column() {
    // 列表内容
  }
}
.edgeEffect(EdgeEffect.Spring)
.onScrollEdge((side: Edge) => {
  if (side === Edge.Top) {
    // 触发刷新
    loadRecords();
  }
})
```

### 按钮反馈

所有按钮都提供了即时的视觉反馈，增强交互的流畅性。

```typescript
Button('保存')
  .width('48%')
  .height(44)
  .backgroundColor(colors.primary)
  .fontColor('#FFFFFF')
  .stateEffect(true)              // 启用状态效果
  .onClick(() => {
    // 按钮点击处理
  })
```

**反馈效果：**

- **按下效果**：按钮被按下时颜色变深
- **释放效果**：释放时恢复原色
- **禁用状态**：禁用时显示灰色，不响应点击

---

## 响应式设计

### 布局适配

应用使用相对布局和百分比宽度，确保在不同屏幕尺寸下都能正常显示。

```typescript
// 使用百分比宽度
Button('按钮')
  .width('48%')              // 相对于父容器的宽度

// 使用 layoutWeight 实现弹性布局
Row() {
  Column().layoutWeight(1)   // 占据剩余空间
  Column().layoutWeight(1)
  Column().layoutWeight(1)
}

// 使用 Spacer 填充空白
Row() {
  Text('左侧')
  Spacer()                   // 自动填充中间空白
  Text('右侧')
}
```

### 字体缩放

应用支持系统字体缩放设置，确保可访问性。

```typescript
Text('标题')
  .fontSize(18)              // 使用 vp 单位，支持字体缩放
  .fontWeight(FontWeight.Bold)
```

### 触摸目标

所有可交互元素都确保了足够的触摸目标大小（最小 44x44 vp）。

```typescript
Button({ type: ButtonType.Circle }) {
  Text('⋮')
}
.width(44)                   // 最小触摸目标
.height(44)
```

---

## 动画效果

### 页面转场

页面切换使用系统默认的转场动画，提供流畅的导航体验。

```typescript
// 页面进入动画
pageTransition() {
  PageTransitionEnter({ duration: 300 })
    .slide(SlideEffect.Right)
    .opacity(0)
  
  PageTransitionExit({ duration: 300 })
    .slide(SlideEffect.Left)
    .opacity(0)
}
```

### 组件动画

关键组件使用动画增强视觉效果。

```typescript
// 对话框淡入动画
Column() {
  // 对话框内容
}
.transition({ 
  type: TransitionType.Insert,
  opacity: 0,
  scale: { x: 0.9, y: 0.9 }
})
.animation({ 
  duration: 200,
  curve: Curve.EaseOut 
})
```

### 进度动画

进度条使用平滑的动画过渡。

```typescript
Progress({ value: percentage, total: 100 })
  .animation({ 
    duration: 500,
    curve: Curve.EaseInOut 
  })
```

---

## 可访问性设计

### 语义化标签

所有交互元素都提供了语义化的标签，支持屏幕阅读器。

```typescript
Button('删除')
  .accessibilityText('删除记录')
  .accessibilityDescription('删除当前选中的记录')
```

### 颜色对比度

所有文字和背景的颜色对比度都符合 WCAG AA 标准（至少 4.5:1）。

```typescript
// 浅色主题
textPrimary: '#2C3E50',      // 深色文字
background: '#F5F7FA',       // 浅色背景
// 对比度 > 10:1

// 深色主题
textPrimary: '#E8EAED',      // 浅色文字
background: '#1A1D23',       // 深色背景
// 对比度 > 12:1
```

### 焦点指示

所有可聚焦元素都有清晰的焦点指示。

```typescript
Button('按钮')
  .focusable(true)
  .defaultFocus(true)
  .focusOnTouch(true)
```

---

## 性能优化

### 列表优化

使用 LazyForEach 实现列表的懒加载，提升大数据量下的性能。

```typescript
List() {
  LazyForEach(dataSource, (item: AccountRecord) => {
    ListItem() {
      RecordItem(item)
    }
  }, (item: AccountRecord) => item.id)
}
```

### 图片优化

图标使用 SVG 或 Emoji，避免位图资源占用。

```typescript
// 使用 Emoji 作为图标
Text('📊').fontSize(24)

// 使用系统资源
Image($r('app.media.icon'))
```

### 状态管理优化

合理使用 @State、@Prop、@Link 等装饰器，避免不必要的 UI 刷新。

```typescript
// 只在需要响应式更新的数据上使用 @State
@State records: AccountRecord[] = [];

// 不需要响应式的数据使用普通变量
private viewModel: AccountViewModel = new AccountViewModel();
```

---

## 总结

本文档详细阐述了记账应用的界面设计，从色彩系统到页面布局，从组件设计到交互逻辑，形成了一套完整的设计体系。整个设计遵循以下核心原则：

**一致性**：所有页面使用统一的设计语言和交互模式，确保用户体验的连贯性。

**可用性**：界面简洁直观，操作流程清晰，降低用户的学习成本。

**美观性**：精心设计的配色方案和视觉元素，提供愉悦的使用体验。

**响应性**：所有交互都有即时的视觉反馈，动画流畅自然。

**可访问性**：考虑不同用户的需求，提供良好的可访问性支持。

**性能**：通过各种优化手段，确保应用在各种设备上都能流畅运行。

这套设计体系不仅满足了当前的功能需求，也为未来的功能扩展和优化奠定了坚实的基础。

