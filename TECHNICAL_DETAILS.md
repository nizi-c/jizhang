# 收支记账APP - 详细技术要点

## 一、HarmonyOS核心技术栈

### 1.1 开发语言与框架详解

**ArkTS语言特性**

ArkTS是HarmonyOS专用的开发语言，它是TypeScript的超集，在TypeScript的基础上扩展了声明式UI、状态管理等能力。本项目充分利用了ArkTS的以下特性：

1. **装饰器系统**：使用`@Entry`、`@Component`、`@State`、`@Builder`等装饰器实现组件化和状态管理
2. **类型安全**：通过TypeScript的静态类型检查，在编译时发现潜在错误
3. **声明式语法**：使用声明式的方式描述UI结构，代码更简洁直观
4. **异步编程**：使用async/await处理异步操作，代码逻辑更清晰

**ArkUI框架核心能力**

ArkUI是HarmonyOS的原生UI框架，提供了丰富的组件和布局能力。本项目使用的核心特性包括：

1. **声明式UI范式**：通过`@Component`装饰器定义组件，使用`build()`方法构建UI
2. **响应式状态管理**：通过`@State`装饰器实现数据与UI的自动绑定
3. **组件化开发**：通过`@Builder`装饰器创建可复用的UI构建函数
4. **生命周期管理**：使用`aboutToAppear()`、`onPageShow()`等生命周期钩子

### 1.2 HarmonyOS API详解

**@ohos.data.preferences (数据持久化)**

Preferences是HarmonyOS提供的轻量级键值对存储方案，适合存储应用配置和少量数据。本项目使用Preferences存储所有记账数据：

```typescript
import preferences from '@ohos.data.preferences';

// 获取Preferences实例
const dataPreferences = await preferences.getPreferences(context, 'accountData');

// 存储数据（JSON序列化）
await dataPreferences.put('records', JSON.stringify(records));
await dataPreferences.flush(); // 持久化到磁盘

// 读取数据
const recordsStr = await dataPreferences.get('records', '[]');
const records = JSON.parse(recordsStr as string);
```

**技术要点**：
- 使用Context对象获取Preferences实例
- 数据以JSON字符串形式存储，支持复杂数据结构
- `flush()`方法确保数据立即写入磁盘
- 提供默认值机制，避免数据不存在时出错

**@ohos.router (页面路由)**

Router模块提供页面跳转和参数传递能力，是应用导航的核心：

```typescript
import router from '@ohos.router';

// 跳转到指定页面
router.pushUrl({ 
  url: 'pages/AddRecordPage' 
});

// 带参数跳转
router.pushUrl({ 
  url: 'pages/RecordsPage',
  params: { bookId: '123' }
});

// 返回上一页
router.back();

// 获取页面参数
const params = router.getParams();
```

**技术要点**：
- 使用页面路径进行导航
- 支持参数传递，实现页面间数据通信
- 提供返回功能，支持页面栈管理

**@ohos.promptAction (用户提示)**

PromptAction模块提供Toast提示、对话框等用户反馈功能：

```typescript
import promptAction from '@ohos.promptAction';

// 显示Toast提示
promptAction.showToast({
  message: '保存成功',
  duration: 2000  // 显示时长（毫秒）
});

// 显示对话框（使用AlertDialog组件）
AlertDialog.show({
  title: '预算超支提醒',
  message: '本月食物支出已超出预算',
  confirm: {
    value: '知道了',
    action: () => {
      console.log('用户确认');
    }
  }
});
```

**技术要点**：
- Toast用于轻量级提示，不打断用户操作
- AlertDialog用于重要提示，需要用户确认
- 支持自定义提示内容和按钮


## 二、UI组件技术详解

### 2.1 容器组件的使用

**Column组件（垂直布局容器）**

Column是最常用的垂直布局容器，用于将子组件按垂直方向排列：

```typescript
Column() {
  Text('标题')
  Text('内容')
  Button('按钮')
}
.width('100%')
.height('100%')
.padding(16)
.backgroundColor('#FFFFFF')
```

**技术要点**：
- 子组件从上到下垂直排列
- 支持`justifyContent`设置主轴对齐方式
- 支持`alignItems`设置交叉轴对齐方式
- 可设置`space`属性控制子组件间距

**应用场景**：
- 页面主体布局（Index.ets中的主Column）
- 表单布局（AddRecordPage.ets中的输入表单）
- 卡片内容布局（统计卡片的内容排列）

**Row组件（水平布局容器）**

Row用于将子组件按水平方向排列：

```typescript
Row() {
  Button('取消')
    .width('48%')
  Row().width('4%')  // 间隔
  Button('确定')
    .width('48%')
}
.width('100%')
```

**技术要点**：
- 子组件从左到右水平排列
- 使用`layoutWeight`实现弹性布局
- 支持`justifyContent`和`alignItems`对齐控制

**应用场景**：
- 顶部导航栏（返回按钮+标题+操作按钮）
- 按钮组（取消/确定按钮并排）
- 统计数据展示（收入/支出/结余并排显示）

**Stack组件（层叠布局容器）**

Stack用于将子组件层叠放置，后面的组件覆盖前面的组件：

```typescript
Stack() {
  // 底层：主内容
  Column() {
    // 页面内容
  }
  
  // 顶层：对话框
  if (this.showDialog) {
    Column() {
      // 对话框内容
    }
    .backgroundColor('#00000040')  // 半透明遮罩
  }
}
.alignContent(Alignment.Center)
```

**技术要点**：
- 子组件按添加顺序层叠
- 使用`alignContent`控制子组件对齐位置
- 常用于实现遮罩层、浮动按钮等

**应用场景**：
- 自定义对话框实现（AddRecordPage.ets中的自定义分类对话框）
- 加载遮罩层
- 浮动操作按钮

**Scroll组件（滚动容器）**

Scroll提供内容滚动能力，当内容超出容器大小时自动显示滚动条：

```typescript
Scroll() {
  Column() {
    // 可能超出屏幕的内容
    ForEach(this.longList, (item) => {
      Text(item)
    })
  }
}
.width('100%')
.height('100%')
.scrollable(ScrollDirection.Vertical)  // 垂直滚动
.scrollBar(BarState.Auto)  // 滚动条显示策略
```

**技术要点**：
- 支持垂直和水平滚动
- 可控制滚动条显示/隐藏
- 支持滚动事件监听

**应用场景**：
- 长列表内容（RecordsPage.ets中的日历网格）
- 表单页面（AddRecordPage.ets中的输入表单）
- 分类选择器（水平滚动的分类列表）

### 2.2 基础组件的使用

**Text组件（文本显示）**

Text是最基础的文本显示组件：

```typescript
Text('收入')
  .fontSize(14)
  .fontColor('#6BCB77')
  .fontWeight(FontWeight.Bold)
  .textAlign(TextAlign.Center)
  .maxLines(1)
  .textOverflow({ overflow: TextOverflow.Ellipsis })
```

**技术要点**：
- 支持丰富的文本样式设置
- 可设置文本对齐方式
- 支持文本溢出处理（省略号、裁剪等）
- 支持多行文本和行高设置

**应用场景**：
- 标题显示（页面标题、卡片标题）
- 数据展示（金额、日期、分类名称）
- 提示文本（空状态提示、说明文字）

**TextInput组件（文本输入）**

TextInput提供文本输入功能，是表单的核心组件：

```typescript
TextInput({ 
  placeholder: '请输入金额', 
  text: this.amount 
})
  .type(InputType.Number)  // 输入类型：数字
  .width('100%')
  .height(44)
  .padding({ left: 12, right: 12 })
  .backgroundColor('#F5F3F1')
  .borderRadius(8)
  .placeholderColor('#B4B3B2')
  .onChange((value: string) => {
    this.amount = value;  // 双向绑定
  })
```

**技术要点**：
- 支持多种输入类型（文本、数字、密码等）
- 提供placeholder占位符
- 通过onChange实现双向数据绑定
- 支持输入验证和格式化

**应用场景**：
- 金额输入（AddRecordPage.ets，type: InputType.Number）
- 分类名称输入（AddRecordPage.ets，普通文本输入）
- 用途描述输入（AddRecordPage.ets，多行文本）
- 查询条件输入（RecordsPage.ets，筛选条件）

**Button组件（按钮）**

Button是用户交互的核心组件：

```typescript
// 普通按钮
Button('保存')
  .width('48%')
  .height(44)
  .backgroundColor('#8FAADC')
  .fontColor('#FFFFFF')
  .borderRadius(8)
  .onClick(() => {
    this.saveRecord();
  })

// 圆形按钮
Button({ type: ButtonType.Circle, stateEffect: true }) {
  Text('←')
    .fontSize(20)
}
.width(36)
.height(36)
.backgroundColor('#FFFFFF')
.onClick(() => {
  router.back();
})
```

**技术要点**：
- 支持多种按钮类型（Normal、Capsule、Circle）
- stateEffect属性提供点击反馈效果
- 可包含文本或自定义内容
- 支持禁用状态和加载状态

**应用场景**：
- 操作按钮（保存、取消、删除）
- 导航按钮（返回按钮、菜单按钮）
- 类型选择（支出/收入切换按钮）
- 分类选择（分类网格中的按钮）

**Image组件（图片显示）**

Image用于显示图片资源：

```typescript
Image($r('app.media.icon'))
  .width(24)
  .height(24)
  .objectFit(ImageFit.Contain)
```

**技术要点**：
- 使用$r()引用资源文件
- 支持多种图片适配模式
- 支持网络图片和本地图片

**应用场景**：
- 图标显示（导航栏图标、功能图标）
- 背景图片（页面背景）
- 分类图标（使用emoji文本代替）

### 2.3 列表组件的使用

**List和ListItem组件（列表）**

List是高性能的列表组件，配合ListItem使用：

```typescript
List() {
  ForEach(this.records, (record: AccountRecord) => {
    ListItem() {
      this.buildRecordItem(record)
    }
    .swipeAction({ end: this.buildDeleteButton(record) })
  }, (record: AccountRecord) => record.id)
}
.width('100%')
.layoutWeight(1)
.divider({ 
  strokeWidth: 1, 
  color: '#EDECEA' 
})
```

**技术要点**：
- 支持虚拟滚动，性能优秀
- swipeAction实现侧滑操作
- divider设置分割线
- 配合ForEach实现数据渲染

**应用场景**：
- 记录列表（RecordsPage.ets中的记录展示）
- 查询结果列表（QueryPage.ets中的查询结果）
- 账本列表（AccountBooksPage.ets中的账本展示）

**ForEach循环渲染**

ForEach是ArkUI提供的循环渲染语法：

```typescript
ForEach(
  this.records,  // 数据源
  (record: AccountRecord) => {  // 渲染函数
    ListItem() {
      this.buildRecordItem(record)
    }
  },
  (record: AccountRecord) => record.id  // key生成函数
)
```

**技术要点**：
- 第一个参数：数据源数组
- 第二个参数：渲染函数，返回UI组件
- 第三个参数：key生成函数，用于优化渲染性能
- key必须唯一且稳定，通常使用id字段

**性能优化**：
- 正确使用key函数可以避免不必要的重渲染
- 当数据项变化时，框架通过key识别变化的项
- 只更新变化的项，而不是重新渲染整个列表

**Grid和GridItem组件（网格布局）**

Grid用于创建网格布局，常用于图标网格、相册等场景：

```typescript
Grid() {
  ForEach(this.calendarDays, (day: DayInfo) => {
    GridItem() {
      this.buildDayCell(day)
    }
  }, (day: DayInfo, index: number) => `${this.currentYear}-${this.currentMonth}-${index}`)
}
.columnsTemplate('1fr 1fr 1fr 1fr 1fr 1fr 1fr')  // 7列
.rowsGap(1)
.columnsGap(1)
.width('100%')
```

**技术要点**：
- columnsTemplate定义列数和宽度分配
- rowsGap和columnsGap设置间距
- 支持自动换行
- 配合GridItem使用

**应用场景**：
- 日历网格（RecordsPage.ets中的月历显示）
- 分类选择网格（虽然使用Scroll+Row实现，但概念类似）


### 2.4 对话框组件的使用

**DatePickerDialog（日期选择对话框）**

DatePickerDialog是HarmonyOS提供的日期选择器对话框：

```typescript
DatePickerDialog.show({
  selected: this.selectedDate ? new Date(this.selectedDate) : new Date(),
  onAccept: (value: DatePickerResult) => {
    if (value.year !== undefined && 
        value.month !== undefined && 
        value.day !== undefined) {
      const year = value.year;
      const month = String(value.month + 1).padStart(2, '0');
      const day = String(value.day).padStart(2, '0');
      this.selectedDate = `${year}-${month}-${day}`;
    }
  }
});
```

**技术要点**：
- 使用静态方法show()显示对话框
- selected参数设置初始选中日期
- onAccept回调处理用户选择
- DatePickerResult包含year、month、day字段
- 注意：month从0开始，需要+1

**应用场景**：
- 记录日期选择（AddRecordPage.ets中的日期输入）
- 查询日期范围选择（RecordsPage.ets中的筛选条件）

**AlertDialog（警告对话框）**

AlertDialog用于显示警告、确认等对话框：

```typescript
AlertDialog.show({
  title: '预算超支提醒',
  message: `【食物】预算已超支！\n\n预算金额：¥500.00\n已使用：¥650.00\n超支：¥150.00`,
  confirm: {
    value: '知道了',
    action: () => {
      console.log('用户确认');
    }
  },
  cancel: {
    value: '取消',
    action: () => {
      console.log('用户取消');
    }
  }
});
```

**技术要点**：
- 支持标题和消息内容
- confirm定义确认按钮
- cancel定义取消按钮（可选）
- 支持多行文本和格式化

**应用场景**：
- 预算超支提醒（AddRecordPage.ets中的预算检查）
- 删除确认（虽然当前使用侧滑删除，但可扩展）
- 错误提示

**CustomDialogController（自定义对话框）**

CustomDialogController用于创建完全自定义的对话框：

```typescript
// 定义对话框控制器
menuDialogController: CustomDialogController = new CustomDialogController({
  builder: () => {
    this.buildMenuDialog();  // 自定义对话框内容
  },
  autoCancel: true,  // 点击遮罩自动关闭
  alignment: DialogAlignment.Center,  // 对齐方式
  customStyle: true  // 使用自定义样式
});

// 显示对话框
this.menuDialogController.open();

// 关闭对话框
this.menuDialogController.close();

// 自定义对话框内容
@Builder
buildMenuDialog() {
  Column() {
    Text('菜单标题')
    Button('选项1').onClick(() => {
      this.menuDialogController.close();
    })
    Button('选项2').onClick(() => {
      this.menuDialogController.close();
    })
  }
  .backgroundColor('#FFFFFF')
  .borderRadius(12)
  .padding(20)
}
```

**技术要点**：
- builder函数定义对话框内容
- autoCancel控制点击遮罩是否关闭
- alignment设置对话框位置
- customStyle允许完全自定义样式

**应用场景**：
- 菜单对话框（Index.ets中的功能菜单）
- 自定义分类对话框（AddRecordPage.ets中的添加分类）
- 复杂的表单对话框

### 2.5 进度和图表组件

**Progress组件（进度条）**

Progress用于显示进度或百分比：

```typescript
Progress({
  value: item.percentage,  // 当前值
  total: 100,  // 总值
  type: ProgressType.Linear  // 线性进度条
})
  .width('100%')
  .height(8)
  .color('#8FAADC')  // 进度条颜色
  .backgroundColor('#E4E2E0')  // 背景色
```

**技术要点**：
- 支持多种类型（Linear、Ring、ScaleRing等）
- value和total定义进度
- 可自定义颜色和样式

**应用场景**：
- 分类支出占比（ChartPage.ets中的分类统计）
- 预算使用进度（BudgetPage.ets中的预算展示）

## 三、状态管理技术详解

### 3.1 @State装饰器

@State是ArkUI最核心的状态管理装饰器，用于定义组件的响应式状态：

```typescript
@Component
struct AddRecordPage {
  @State recordType: 'income' | 'expense' = 'expense';
  @State selectedCategory: string = '';
  @State amount: string = '';
  @State description: string = '';
  @State selectedDate: string = DateUtil.getTodayStr();
  
  build() {
    Column() {
      // 当recordType变化时，UI自动更新
      Text(this.recordType === 'income' ? '收入' : '支出')
      
      // 当amount变化时，按钮状态自动更新
      Button('保存')
        .enabled(this.amount !== '')
    }
  }
}
```

**技术要点**：
- @State装饰的变量是响应式的
- 变量值变化时，使用该变量的UI会自动重新渲染
- 支持基本类型和对象类型
- 对象类型的深层属性变化也会触发更新

**响应式原理**：
1. @State装饰器将变量转换为响应式对象
2. 当变量被读取时，框架记录依赖关系
3. 当变量被修改时，框架通知所有依赖的UI组件
4. UI组件重新执行build()方法，生成新的UI树
5. 框架对比新旧UI树，只更新变化的部分

**性能优化**：
- 只有真正使用了@State变量的UI才会更新
- 框架使用虚拟DOM技术，最小化实际DOM操作
- 批量更新机制，多个状态变化合并为一次更新

### 3.2 数据流向设计

**单向数据流**

本项目采用单向数据流的设计模式：

```
用户操作 → 修改@State → 触发UI更新 → 显示新状态
   ↑                                      ↓
   └──────────── 用户看到变化 ←───────────┘
```

**示例：添加记录的数据流**

```typescript
// 1. 用户输入金额
TextInput({ text: this.amount })
  .onChange((value: string) => {
    this.amount = value;  // 修改@State
  })

// 2. 用户点击保存
Button('保存')
  .onClick(async () => {
    // 3. 创建记录对象
    const record: AccountRecord = {
      id: StorageUtil.generateId(),
      amount: parseFloat(this.amount),
      // ...其他字段
    };
    
    // 4. 保存到存储
    const records = await StorageUtil.getRecords();
    records.unshift(record);
    await StorageUtil.saveRecords(records);
    
    // 5. 返回上一页
    router.back();
  })

// 6. 上一页的onPageShow被调用
onPageShow() {
  this.loadRecords();  // 重新加载数据
}

// 7. loadRecords更新@State
async loadRecords() {
  this.records = await StorageUtil.getRecords();  // 修改@State
  this.updateSummary();  // 更新统计数据
}

// 8. UI自动更新，显示新记录
```

### 3.3 生命周期管理

**组件生命周期钩子**

ArkUI组件提供了多个生命周期钩子函数：

```typescript
@Component
struct RecordsPage {
  // 组件即将出现（首次创建时调用）
  aboutToAppear() {
    console.log('组件创建');
    StorageUtil.setContext(getContext(this));
    this.loadRecords();
  }
  
  // 页面显示时（每次显示都调用）
  onPageShow() {
    console.log('页面显示');
    this.loadRecords();  // 刷新数据
  }
  
  // 页面隐藏时
  onPageHide() {
    console.log('页面隐藏');
    // 可以在这里保存状态
  }
  
  // 组件即将销毁
  aboutToDisappear() {
    console.log('组件销毁');
    // 清理资源，如取消定时器、移除监听器等
  }
}
```

**生命周期应用场景**：

1. **aboutToAppear()**：
   - 初始化Context
   - 加载初始数据
   - 注册事件监听器
   - 初始化第三方库

2. **onPageShow()**：
   - 刷新页面数据
   - 恢复页面状态
   - 重新开始动画
   - 更新时间相关的显示

3. **onPageHide()**：
   - 暂停动画
   - 保存临时状态
   - 停止定时器

4. **aboutToDisappear()**：
   - 清理定时器
   - 移除事件监听器
   - 释放资源
   - 保存重要状态

**实际应用示例**：

```typescript
// Index.ets中的生命周期使用
async aboutToAppear() {
  // 1. 设置Context（必须最先执行）
  const context = getContext(this);
  StorageUtil.setContext(context);
  
  // 2. 初始化账本管理
  await AccountBookUtil.init(context as common.UIAbilityContext);
  
  // 3. 初始化主题
  ThemeUtil.initTheme().then(() => {
    this.currentTheme = ThemeUtil.getTheme();
    this.colors = ThemeUtil.getColors();
  });
  
  // 4. 加载数据
  this.loadRecords();
}

async onPageShow() {
  // 每次显示时刷新数据和账本信息
  await this.loadRecords();
  await this.loadCurrentBook();
}
```


## 四、数据持久化技术深度解析

### 4.1 Preferences API完整使用流程

**初始化Context**

Preferences API需要Context对象才能工作，Context是HarmonyOS应用的运行环境：

```typescript
// StorageUtil.ets
class StorageUtil {
  private static context: Context;
  
  // 设置Context（在应用启动时调用）
  static setContext(ctx: Context) {
    StorageUtil.context = ctx;
  }
}

// 在页面中设置Context
aboutToAppear() {
  const context = getContext(this);
  StorageUtil.setContext(context);
}
```

**获取Preferences实例**

```typescript
// 获取Preferences实例
const dataPreferences = await preferences.getPreferences(
  StorageUtil.context,  // Context对象
  'accountData'  // 存储文件名
);
```

**技术要点**：
- 第一个参数是Context对象
- 第二个参数是存储文件名，不同文件名对应不同的存储空间
- 返回Promise，需要使用await
- 同一个文件名多次调用返回同一个实例

**数据存储操作**

```typescript
// 保存记录数据
static async saveRecords(records: AccountRecord[]): Promise<void> {
  try {
    // 1. 获取Preferences实例
    const dataPreferences = await preferences.getPreferences(
      StorageUtil.context, 
      'accountData'
    );
    
    // 2. 将对象序列化为JSON字符串
    const recordsJson = JSON.stringify(records);
    
    // 3. 存储数据（键值对）
    await dataPreferences.put('records', recordsJson);
    
    // 4. 持久化到磁盘（重要！）
    await dataPreferences.flush();
    
    console.log(`保存成功：${records.length}条记录`);
  } catch (error) {
    console.error('保存失败:', error);
    throw error;
  }
}
```

**技术要点**：
- put()方法只是将数据写入内存
- flush()方法才会将数据持久化到磁盘
- 必须调用flush()，否则应用崩溃时数据会丢失
- 支持的值类型：string、number、boolean、Array、Object（需序列化）

**数据读取操作**

```typescript
// 读取记录数据
static async getRecords(): Promise<AccountRecord[]> {
  try {
    // 1. 获取Preferences实例
    const dataPreferences = await preferences.getPreferences(
      StorageUtil.context, 
      'accountData'
    );
    
    // 2. 读取数据（提供默认值）
    const recordsJson = await dataPreferences.get('records', '[]');
    
    // 3. 反序列化JSON字符串
    const records = JSON.parse(recordsJson as string) as AccountRecord[];
    
    console.log(`读取成功：${records.length}条记录`);
    return records;
  } catch (error) {
    console.error('读取失败:', error);
    return [];  // 返回空数组作为降级处理
  }
}
```

**技术要点**：
- get()方法的第二个参数是默认值
- 如果键不存在，返回默认值
- 返回值类型是string | number | boolean | Object
- 需要进行类型转换和反序列化

**数据删除操作**

```typescript
// 删除指定键的数据
static async deleteKey(key: string): Promise<void> {
  const dataPreferences = await preferences.getPreferences(
    StorageUtil.context, 
    'accountData'
  );
  await dataPreferences.delete(key);
  await dataPreferences.flush();
}

// 清空所有数据
static async clear(): Promise<void> {
  const dataPreferences = await preferences.getPreferences(
    StorageUtil.context, 
    'accountData'
  );
  await dataPreferences.clear();
  await dataPreferences.flush();
}
```

### 4.2 数据序列化策略

**JSON序列化的优势**

本项目使用JSON作为数据序列化格式，原因如下：

1. **跨平台兼容**：JSON是标准格式，易于迁移
2. **可读性强**：便于调试和数据检查
3. **灵活性高**：支持复杂的嵌套结构
4. **性能良好**：JavaScript原生支持，序列化速度快

**序列化示例**

```typescript
// 复杂对象序列化
const record: AccountRecord = {
  id: '1234567890_abc',
  type: 'expense',
  category: '食物',
  amount: 50.5,
  description: '午餐',
  date: 1699999999999,
  dateStr: '2023-11-15',
  mood: '😊满意'
};

// 序列化为JSON字符串
const json = JSON.stringify(record);
// 结果：{"id":"1234567890_abc","type":"expense",...}

// 反序列化为对象
const obj = JSON.parse(json) as AccountRecord;
```

**数组序列化**

```typescript
// 记录数组序列化
const records: AccountRecord[] = [record1, record2, record3];
const json = JSON.stringify(records);

// 反序列化
const records = JSON.parse(json) as AccountRecord[];
```

**序列化注意事项**：

1. **undefined会被忽略**：
```typescript
const obj = { a: 1, b: undefined };
JSON.stringify(obj);  // {"a":1}
```

2. **Date对象会转为字符串**：
```typescript
const obj = { date: new Date() };
JSON.stringify(obj);  // {"date":"2023-11-15T12:00:00.000Z"}
// 需要手动转换回Date对象
```

3. **函数会被忽略**：
```typescript
const obj = { fn: () => {} };
JSON.stringify(obj);  // {}
```

4. **循环引用会报错**：
```typescript
const obj: any = {};
obj.self = obj;
JSON.stringify(obj);  // TypeError: Converting circular structure to JSON
```

### 4.3 数据一致性保障

**即时保存策略**

本项目采用"即时保存"策略，每次数据变化立即保存：

```typescript
async saveRecord() {
  // 1. 创建新记录
  const record: AccountRecord = {
    id: StorageUtil.generateId(),
    // ...其他字段
  };
  
  // 2. 读取现有记录
  const records = await StorageUtil.getRecords();
  
  // 3. 添加新记录
  records.unshift(record);
  
  // 4. 立即保存（不等待）
  await StorageUtil.saveRecords(records);
  
  // 5. 提示用户
  promptAction.showToast({ message: '保存成功' });
}
```

**优势**：
- 数据不会丢失，即使应用崩溃
- 用户操作立即生效
- 不需要"保存"按钮

**劣势**：
- 频繁IO操作可能影响性能
- 需要处理保存失败的情况

**读写分离设计**

```typescript
class Index {
  @State records: AccountRecord[] = [];  // 内存中的数据
  
  // 启动时一次性加载
  async aboutToAppear() {
    this.records = await StorageUtil.getRecords();
  }
  
  // 所有操作在内存中进行
  addRecord(record: AccountRecord) {
    this.records.unshift(record);  // 修改内存数据
    this.saveRecords();  // 异步保存到存储
  }
  
  // 异步保存，不阻塞UI
  async saveRecords() {
    await StorageUtil.saveRecords(this.records);
  }
}
```

**优势**：
- 读取操作非常快（内存访问）
- UI响应迅速
- 写入操作异步进行，不阻塞UI

**事务性保障**

虽然Preferences不支持事务，但我们通过以下方式保障数据一致性：

```typescript
async updateRecord(id: string, updates: Partial<AccountRecord>) {
  try {
    // 1. 读取所有数据
    const records = await StorageUtil.getRecords();
    
    // 2. 查找并更新
    const index = records.findIndex(r => r.id === id);
    if (index === -1) {
      throw new Error('记录不存在');
    }
    
    // 3. 创建新对象（不修改原对象）
    records[index] = { ...records[index], ...updates };
    
    // 4. 保存所有数据
    await StorageUtil.saveRecords(records);
    
    return true;
  } catch (error) {
    console.error('更新失败:', error);
    // 数据保持原状，不会出现部分更新的情况
    return false;
  }
}
```

### 4.4 多账本数据隔离

**命名空间策略**

不同账本的数据使用不同的存储键：

```typescript
class AccountBookUtil {
  // 获取当前账本的记录
  static async getCurrentBookRecords(): Promise<AccountRecord[]> {
    const currentBookId = await this.getCurrentBookId();
    const key = `records_${currentBookId}`;  // 账本专属键
    
    const dataPreferences = await preferences.getPreferences(
      this.context, 
      'accountData'
    );
    const json = await dataPreferences.get(key, '[]');
    return JSON.parse(json as string);
  }
  
  // 保存到当前账本
  static async saveCurrentBookRecords(records: AccountRecord[]): Promise<void> {
    const currentBookId = await this.getCurrentBookId();
    const key = `records_${currentBookId}`;
    
    const dataPreferences = await preferences.getPreferences(
      this.context, 
      'accountData'
    );
    await dataPreferences.put(key, JSON.stringify(records));
    await dataPreferences.flush();
  }
}
```

**技术要点**：
- 每个账本有唯一的ID
- 使用`records_${bookId}`作为存储键
- 不同账本的数据完全隔离
- 切换账本时只需要切换键名

**账本切换流程**

```typescript
// 切换账本
static async switchBook(bookId: string): Promise<void> {
  // 1. 保存当前账本ID
  await this.setCurrentBookId(bookId);
  
  // 2. 通知应用重新加载数据
  AppState.notifyBookChanged();
}

// 应用监听账本切换事件
AppState.subscribe(() => {
  this.loadRecords();  // 重新加载数据
});
```


## 五、路由导航技术详解

### 5.1 @ohos.router模块深度使用

**页面跳转 - pushUrl()**

pushUrl是最常用的页面跳转方法，会将新页面压入页面栈：

```typescript
import router from '@ohos.router';

// 基本跳转
router.pushUrl({ 
  url: 'pages/AddRecordPage' 
});

// 带参数跳转
router.pushUrl({ 
  url: 'pages/RecordsPage',
  params: { 
    bookId: '123',
    bookName: '旅行账本'
  }
});
```

**技术要点**：
- url参数是页面路径，相对于src/main/ets目录
- params是可选参数，用于传递数据
- 页面会被压入栈顶，可以通过back()返回
- 支持Promise和回调两种方式

**页面返回 - back()**

back()方法返回到上一个页面：

```typescript
// 简单返回
router.back();

// 带参数返回（返回结果给上一页）
router.back({
  url: 'pages/Index',
  params: {
    result: 'success'
  }
});
```

**技术要点**：
- 会销毁当前页面，释放资源
- 可以携带返回参数
- 如果栈中只有一个页面，调用back()会退出应用

**页面替换 - replaceUrl()**

replaceUrl()替换当前页面，不增加栈深度：

```typescript
router.replaceUrl({ 
  url: 'pages/LoginPage' 
});
```

**技术要点**：
- 当前页面会被销毁
- 新页面替换当前页面的位置
- 用户无法通过back()返回到被替换的页面
- 适用于登录后跳转主页等场景

**清空栈并跳转 - clear()**

```typescript
// 清空所有页面，跳转到新页面
router.clear();
router.pushUrl({ url: 'pages/Index' });
```

**获取页面参数 - getParams()**

在目标页面获取传递的参数：

```typescript
// 在RecordsPage中获取参数
aboutToAppear() {
  const params = router.getParams() as {
    bookId?: string;
    bookName?: string;
  };
  
  if (params && params.bookId) {
    this.currentBookId = params.bookId;
    this.currentBookName = params.bookName || '';
  }
}
```

**技术要点**：
- 返回Object类型，需要类型断言
- 如果没有参数，返回undefined
- 参数在页面生命周期内有效

### 5.2 页面栈管理

**页面栈概念**

HarmonyOS使用栈结构管理页面：

```
┌─────────────────┐
│  AddRecordPage  │ ← 栈顶（当前页面）
├─────────────────┤
│  RecordsPage    │
├─────────────────┤
│  Index          │ ← 栈底
└─────────────────┘
```

**栈操作示例**：

```typescript
// 1. 应用启动，Index入栈
// 栈：[Index]

// 2. 点击"流水"，RecordsPage入栈
router.pushUrl({ url: 'pages/RecordsPage' });
// 栈：[Index, RecordsPage]

// 3. 点击"添加"，AddRecordPage入栈
router.pushUrl({ url: 'pages/AddRecordPage' });
// 栈：[Index, RecordsPage, AddRecordPage]

// 4. 点击"保存"，AddRecordPage出栈
router.back();
// 栈：[Index, RecordsPage]

// 5. 点击返回，RecordsPage出栈
router.back();
// 栈：[Index]
```

**栈深度限制**：
- HarmonyOS对页面栈深度有限制（通常32层）
- 超过限制会导致pushUrl失败
- 应避免无限制的页面跳转

**栈管理最佳实践**：

1. **使用back()而不是pushUrl()返回**：
```typescript
// ❌ 错误：会增加栈深度
Button('返回').onClick(() => {
  router.pushUrl({ url: 'pages/Index' });
});

// ✅ 正确：减少栈深度
Button('返回').onClick(() => {
  router.back();
});
```

2. **登录后清空栈**：
```typescript
// 登录成功后
async login() {
  const success = await doLogin();
  if (success) {
    router.clear();  // 清空栈
    router.replaceUrl({ url: 'pages/Index' });  // 跳转主页
  }
}
```

3. **避免循环跳转**：
```typescript
// ❌ 错误：A → B → A → B → ...
// PageA
router.pushUrl({ url: 'pages/PageB' });
// PageB
router.pushUrl({ url: 'pages/PageA' });

// ✅ 正确：使用back()返回
// PageB
router.back();
```

### 5.3 页面间通信

**方式一：通过路由参数传递**

```typescript
// 发送页面
router.pushUrl({ 
  url: 'pages/DetailPage',
  params: { 
    recordId: '123',
    record: {
      id: '123',
      amount: 100,
      category: '食物'
    }
  }
});

// 接收页面
aboutToAppear() {
  const params = router.getParams() as {
    recordId?: string;
    record?: AccountRecord;
  };
  
  if (params && params.record) {
    this.record = params.record;
  }
}
```

**优点**：
- 简单直接
- 适合传递少量数据

**缺点**：
- 只能单向传递（父→子）
- 数据会被序列化，不能传递函数
- 大量数据会影响性能

**方式二：通过全局状态管理**

```typescript
// AppState.ets - 全局状态管理
class AppState {
  private static currentBookId: string = '';
  private static listeners: Array<() => void> = [];
  
  static setCurrentBookId(id: string) {
    this.currentBookId = id;
    this.notifyListeners();
  }
  
  static getCurrentBookId(): string {
    return this.currentBookId;
  }
  
  static subscribe(listener: () => void) {
    this.listeners.push(listener);
  }
  
  private static notifyListeners() {
    this.listeners.forEach(listener => listener());
  }
}

// 页面A：修改状态
AppState.setCurrentBookId('new-book-id');

// 页面B：监听状态变化
aboutToAppear() {
  AppState.subscribe(() => {
    this.currentBookId = AppState.getCurrentBookId();
    this.loadData();
  });
}
```

**优点**：
- 支持多页面共享状态
- 支持双向通信
- 适合传递大量数据

**缺点**：
- 需要额外的状态管理代码
- 需要手动管理监听器的生命周期

**方式三：通过存储传递**

```typescript
// 页面A：保存数据
await StorageUtil.set('tempData', JSON.stringify(data));
router.pushUrl({ url: 'pages/PageB' });

// 页面B：读取数据
aboutToAppear() {
  const dataStr = await StorageUtil.get('tempData', '{}');
  this.data = JSON.parse(dataStr);
  
  // 清理临时数据
  await StorageUtil.delete('tempData');
}
```

**优点**：
- 可以传递大量数据
- 数据持久化，应用重启也不丢失

**缺点**：
- 需要序列化/反序列化
- IO操作有性能开销
- 需要手动清理临时数据

## 六、主题系统技术实现

### 6.1 主题切换机制

**主题定义**

```typescript
// ThemeUtil.ets
export type ThemeType = 'light' | 'dark';

export interface ThemeColors {
  primary: string;
  income: string;
  expense: string;
  background: string;
  cardBg: string;
  textPrimary: string;
  textSecondary: string;
  // ...更多颜色定义
}

// 浅色主题
static readonly LIGHT_THEME: ThemeColors = {
  primary: '#8FAADC',
  income: '#95D1B3',
  expense: '#E8A5A5',
  background: '#FAF9F7',
  cardBg: '#FFFFFF',
  textPrimary: '#5D5C5A',
  textSecondary: '#8E8D8C',
  // ...
};

// 深色主题
static readonly DARK_THEME: ThemeColors = {
  primary: '#7B9BC8',
  income: '#8BC4A6',
  expense: '#D49595',
  background: '#1A1A1A',
  cardBg: '#2D2D2D',
  textPrimary: '#E8E6E3',
  textSecondary: '#8A8886',
  // ...
};
```

**主题切换实现**

```typescript
class ThemeUtil {
  private static currentTheme: ThemeType = 'light';
  
  // 初始化主题（从存储读取）
  static async initTheme(): Promise<void> {
    const savedTheme = await StorageUtil.get('appTheme');
    if (savedTheme) {
      this.currentTheme = savedTheme as ThemeType;
    }
  }
  
  // 设置主题
  static async setTheme(theme: ThemeType): Promise<void> {
    this.currentTheme = theme;
    await StorageUtil.set('appTheme', theme);
  }
  
  // 获取当前主题
  static getTheme(): ThemeType {
    return this.currentTheme;
  }
  
  // 获取主题颜色
  static getColors(): ThemeColors {
    return this.currentTheme === 'light' 
      ? this.LIGHT_THEME 
      : this.DARK_THEME;
  }
  
  // 切换主题
  static toggleTheme(): ThemeType {
    const newTheme = this.currentTheme === 'light' ? 'dark' : 'light';
    this.setTheme(newTheme);
    return newTheme;
  }
}
```

**在组件中使用主题**

```typescript
@Component
struct Index {
  @State currentTheme: ThemeType = 'light';
  @State colors: ThemeColors = ThemeUtil.LIGHT_THEME;
  
  async aboutToAppear() {
    // 初始化主题
    await ThemeUtil.initTheme();
    this.currentTheme = ThemeUtil.getTheme();
    this.colors = ThemeUtil.getColors();
  }
  
  build() {
    Column() {
      Text('标题')
        .fontColor(this.colors.textPrimary)  // 使用主题颜色
      
      Button('切换主题')
        .onClick(() => {
          // 切换主题
          this.currentTheme = ThemeUtil.toggleTheme();
          this.colors = ThemeUtil.getColors();
        })
    }
    .backgroundColor(this.colors.background)
  }
}
```

**技术要点**：
- 使用@State使主题颜色响应式
- 主题切换时自动更新所有使用颜色的组件
- 主题状态持久化，应用重启后保持

### 6.2 语义化颜色系统

**ColorSchemes配色方案**

不同页面区域使用不同的配色方案：

```typescript
// ColorSchemes.ets
export const LIGHT_COLOR_SCHEME = {
  // 导航栏配色
  NAVBAR: {
    backgroundColor: '#FFFFFF',
    titleColor: '#5D5C5A',
    backButtonColor: '#8FAADC',
    buttonBackground: '#F5F3F1',
    borderColor: '#E4E2E0'
  },
  
  // 统计卡片配色
  STAT_CARD: {
    backgroundColor: '#FFFFFF',
    titleColor: '#5D5C5A',
    labelColor: '#8E8D8C',
    incomeColor: '#95D1B3',
    expenseColor: '#E8A5A5',
    shadowColor: '#00000010'
  },
  
  // 列表项配色
  LIST_ITEM: {
    backgroundColor: '#FFFFFF',
    categoryColor: '#5D5C5A',
    descriptionColor: '#8E8D8C',
    amountIncomeColor: '#95D1B3',
    amountExpenseColor: '#E8A5A5',
    dateColor: '#B4B3B2',
    dividerColor: '#EDECEA'
  },
  
  // ...更多区域配色
};
```

**使用配色方案**

```typescript
getColorScheme() {
  return ThemeUtil.getTheme() === 'light' 
    ? LIGHT_COLOR_SCHEME 
    : DARK_COLOR_SCHEME;
}

build() {
  Column() {
    // 导航栏
    Row() {
      Text('标题')
        .fontColor(this.getColorScheme().NAVBAR.titleColor)
    }
    .backgroundColor(this.getColorScheme().NAVBAR.backgroundColor)
    
    // 统计卡片
    Column() {
      Text('今日收支')
        .fontColor(this.getColorScheme().STAT_CARD.titleColor)
      Text(`¥${this.income}`)
        .fontColor(this.getColorScheme().STAT_CARD.incomeColor)
    }
    .backgroundColor(this.getColorScheme().STAT_CARD.backgroundColor)
  }
}
```

**优势**：
- 颜色语义化，代码可读性强
- 主题切换只需要切换配色方案
- 不同区域可以有不同的配色策略
- 便于设计师和开发者协作

### 6.3 背景图片适配

**背景图片资源**

```typescript
// ThemeUtil.ets
static getBackgroundImage(theme?: ThemeType): Resource {
  const currentTheme = theme || ThemeUtil.currentTheme;
  return currentTheme === 'light' 
    ? $r('app.media.qita')  // 浅色背景图
    : $r('app.media.dark'); // 深色背景图
}
```

**在组件中使用**

```typescript
build() {
  Column() {
    // 页面内容
  }
  .width('100%')
  .height('100%')
  .backgroundImage(ThemeUtil.getBackgroundImage(this.currentTheme))
  .backgroundImageSize(ImageSize.Cover)  // 覆盖整个容器
  .backgroundImagePosition(Alignment.Center)  // 居中对齐
}
```

**技术要点**：
- 使用$r()引用资源文件
- backgroundImageSize设置图片缩放模式
- backgroundImagePosition设置图片位置
- 主题切换时自动更新背景图片

---

**文档版本**: 1.0  
**最后更新**: 2024年  
**维护者**: 收支记账APP开发团队
