# 统计页面重新设计方案

## 整体页面架构

```
统计页面 (ChartPage)
├── 顶部导航栏
│   ├── 返回按钮
│   ├── 标题 "统计"
│   └── 菜单按钮（点击显示选项）
│       ├── 时间维度选择（周/月/年）
│       └── 图表类型选择（饼图/折线图/柱状图）
├── 时间选择器
│   ├── 上一个按钮 <
│   ├── 当前时间显示（根据维度显示）
│   └── 下一个按钮 >
├── 收支概览卡片
│   ├── 总收入
│   ├── 总支出
│   └── 结余
└── 图表展示区（可滚动）
    ├── 收支对比图表
    ├── 支出分类分布图表
    └── 收入分类分布图表
```

## 详细设计

### 1. 状态管理

```typescript
@State timeDimension: 'week' | 'month' | 'year' = 'month'  // 时间维度
@State chartType: 'pie' | 'line' | 'bar' = 'pie'           // 图表类型
@State currentDate: Date = new Date()                       // 当前选择的日期
@State showMenu: boolean = false                            // 是否显示菜单
@State totalIncome: number = 0                              // 总收入
@State totalExpense: number = 0                             // 总支出
@State expenseCategories: CategorySummary[] = []            // 支出分类数据
@State incomeCategories: CategorySummary[] = []             // 收入分类数据
```

### 2. 顶部导航栏

```typescript
Row() {
  // 返回按钮
  Button({ type: ButtonType.Circle }) {
    Image($r('app.media.back')).width(24).height(24)
  }
  .onClick(() => router.back())
  
  // 标题
  Text('统计')
    .fontSize(18)
    .fontWeight(FontWeight.Bold)
    .layoutWeight(1)
    .textAlign(TextAlign.Center)
  
  // 菜单按钮
  Button({ type: ButtonType.Circle }) {
    Text('⋮').fontSize(24)
  }
  .onClick(() => this.showMenu = !this.showMenu)
}
```

### 3. 菜单弹窗

```typescript
if (this.showMenu) {
  Column() {
    // 时间维度选择
    Text('时间维度').fontSize(14).fontWeight(FontWeight.Bold)
    Row() {
      Button('周').onClick(() => this.timeDimension = 'week')
      Button('月').onClick(() => this.timeDimension = 'month')
      Button('年').onClick(() => this.timeDimension = 'year')
    }
    
    Divider()
    
    // 图表类型选择
    Text('图表类型').fontSize(14).fontWeight(FontWeight.Bold)
    Row() {
      Button('饼图').onClick(() => this.chartType = 'pie')
      Button('折线图').onClick(() => this.chartType = 'line')
      Button('柱状图').onClick(() => this.chartType = 'bar')
    }
  }
  .backgroundColor('#FFFFFF')
  .borderRadius(8)
  .padding(16)
}
```

### 4. 时间选择器

根据 `timeDimension` 显示不同格式：
- 周：2024年第12周
- 月：2024年3月
- 年：2024年

```typescript
Row() {
  Button('<').onClick(() => this.previousPeriod())
  Text(this.getTimeLabel()).layoutWeight(1).textAlign(TextAlign.Center)
  Button('>').onClick(() => this.nextPeriod())
}
```

### 5. 收支概览卡片

```typescript
Row() {
  Column() {
    Text('收入').fontSize(12).fontColor('#8E8D8C')
    Text(`¥${this.totalIncome.toFixed(2)}`).fontSize(18).fontColor('#95D1B3')
  }.layoutWeight(1)
  
  Column() {
    Text('支出').fontSize(12).fontColor('#8E8D8C')
    Text(`¥${this.totalExpense.toFixed(2)}`).fontSize(18).fontColor('#E8A5A5')
  }.layoutWeight(1)
  
  Column() {
    Text('结余').fontSize(12).fontColor('#8E8D8C')
    Text(`¥${(this.totalIncome - this.totalExpense).toFixed(2)}`)
      .fontSize(18)
      .fontColor(this.totalIncome >= this.totalExpense ? '#95D1B3' : '#E8A5A5')
  }.layoutWeight(1)
}
.backgroundColor('#FFFFFF')
.borderRadius(8)
.padding(16)
```

### 6. 图表展示区

根据 `chartType` 显示不同类型的图表：

#### 饼图 (Pie Chart)
- 使用 Canvas 绘制
- 显示分类占比
- 点击显示详细金额

#### 折线图 (Line Chart)
- 显示时间趋势
- 周：显示7天数据
- 月：显示30天数据
- 年：显示12个月数据

#### 柱状图 (Bar Chart)
- 显示分类对比
- 横向柱状图
- 显示金额和占比

### 7. 数据计算方法

```typescript
// 根据时间维度获取数据
private getDataByDimension() {
  const startDate = this.getStartDate()
  const endDate = this.getEndDate()
  
  const filteredRecords = this.records.filter(record => {
    const recordDate = new Date(record.dateStr)
    return recordDate >= startDate && recordDate <= endDate
  })
  
  // 计算总收入和总支出
  this.totalIncome = filteredRecords
    .filter(r => r.type === 'income')
    .reduce((sum, r) => sum + r.amount, 0)
    
  this.totalExpense = filteredRecords
    .filter(r => r.type === 'expense')
    .reduce((sum, r) => sum + r.amount, 0)
  
  // 计算分类汇总
  this.expenseCategories = this.calculateCategorySummary(filteredRecords, 'expense')
  this.incomeCategories = this.calculateCategorySummary(filteredRecords, 'income')
}

// 获取开始日期
private getStartDate(): Date {
  switch (this.timeDimension) {
    case 'week':
      // 获取本周第一天
      const weekStart = new Date(this.currentDate)
      weekStart.setDate(weekStart.getDate() - weekStart.getDay())
      return weekStart
    case 'month':
      // 获取本月第一天
      return new Date(this.currentDate.getFullYear(), this.currentDate.getMonth(), 1)
    case 'year':
      // 获取本年第一天
      return new Date(this.currentDate.getFullYear(), 0, 1)
  }
}

// 获取结束日期
private getEndDate(): Date {
  switch (this.timeDimension) {
    case 'week':
      // 获取本周最后一天
      const weekEnd = new Date(this.currentDate)
      weekEnd.setDate(weekEnd.getDate() + (6 - weekEnd.getDay()))
      return weekEnd
    case 'month':
      // 获取本月最后一天
      return new Date(this.currentDate.getFullYear(), this.currentDate.getMonth() + 1, 0)
    case 'year':
      // 获取本年最后一天
      return new Date(this.currentDate.getFullYear(), 11, 31)
  }
}
```

### 8. 图表绘制方法

#### 饼图绘制
```typescript
@Builder
buildPieChart(categories: CategorySummary[], type: 'income' | 'expense') {
  Canvas(this.context)
    .width('100%')
    .height(200)
    .onReady(() => {
      this.drawPieChart(categories, type)
    })
  
  // 图例
  Column() {
    ForEach(categories, (cat: CategorySummary) => {
      Row() {
        // 颜色块
        Row().width(12).height(12).backgroundColor(cat.color).borderRadius(2)
        // 分类名称
        Text(cat.category).fontSize(12)
        // 占比
        Text(`${cat.percentage.toFixed(1)}%`).fontSize(12).fontColor('#8E8D8C')
        // 金额
        Text(`¥${cat.amount.toFixed(2)}`).fontSize(12).fontColor('#8E8D8C')
      }
    })
  }
}
```

#### 折线图绘制
```typescript
@Builder
buildLineChart(data: number[], labels: string[]) {
  Canvas(this.context)
    .width('100%')
    .height(200)
    .onReady(() => {
      this.drawLineChart(data, labels)
    })
}
```

#### 柱状图绘制
```typescript
@Builder
buildBarChart(categories: CategorySummary[]) {
  Column() {
    ForEach(categories, (cat: CategorySummary) => {
      Row() {
        Text(cat.category).width(60).fontSize(12)
        Row()
          .width(`${cat.percentage}%`)
          .height(24)
          .backgroundColor(cat.color)
          .borderRadius(4)
        Text(`¥${cat.amount.toFixed(2)}`).fontSize(12).margin({ left: 8 })
      }
    })
  }
}
```

## 实现优先级

1. **第一阶段**：基础架构
   - 导航栏和菜单
   - 时间维度切换
   - 数据计算逻辑

2. **第二阶段**：饼图实现
   - 饼图绘制
   - 图例显示
   - 交互效果

3. **第三阶段**：其他图表
   - 折线图实现
   - 柱状图实现
   - 图表类型切换

4. **第四阶段**：优化
   - 动画效果
   - 主题适配
   - 性能优化

## 技术要点

1. **Canvas 绘图**：使用 Canvas API 绘制饼图和折线图
2. **数据计算**：根据时间维度动态计算统计数据
3. **状态管理**：使用 @State 管理多个状态变量
4. **响应式布局**：适配不同屏幕尺寸
5. **主题适配**：支持浅色和深色主题

## 颜色方案

### 分类颜色
- 食物：#E8A5A5
- 交通：#8FAADC
- 娱乐：#E8C9A5
- 购物：#C9B6D6
- 医疗：#95D1B3
- 教育：#A5C8E8
- 住房：#B8B5B2
- 其他：#D6C9B6

### 收支颜色
- 收入：#95D1B3
- 支出：#E8A5A5
- 结余正：#95D1B3
- 结余负：#E8A5A5

## 下一步行动

是否需要我开始实现这个设计方案？我可以：
1. 先实现基础架构和菜单系统
2. 然后实现饼图功能
3. 最后添加折线图和柱状图

请告诉我是否开始实现，或者需要调整设计方案。
