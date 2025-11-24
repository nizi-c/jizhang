# 记账应用模型详细设计文档

## 概述

本文档详细阐述了记账应用的数据模型设计，包括核心数据结构、业务逻辑模型以及数据持久化方案。整个应用采用了清晰的分层架构，将数据模型（Model）、视图模型（ViewModel）和工具类（Utility）进行了合理的职责划分，确保代码的可维护性和可扩展性。

应用的数据模型设计遵循面向对象的设计原则，充分考虑了记账场景的实际需求，包括多账本管理、预算控制、数据统计分析等核心功能。通过合理的接口定义和类型约束，保证了数据的一致性和类型安全。

---

## 核心数据模型

### AccountRecord - 账户记录模型

账户记录是整个应用最核心的数据实体，代表用户的每一笔收入或支出记录。这个模型设计时充分考虑了记账的实际场景，不仅包含了基本的金额、分类、日期等信息，还支持用户添加心情标记和详细描述，让记账变得更加人性化和有趣。

在数据类型的选择上，我们使用了 TypeScript 的联合类型（Union Type）来约束 `type` 字段只能是 'income' 或 'expense'，这样可以在编译时就发现类型错误，避免运行时的数据异常。日期字段采用了双重存储策略：既保存时间戳（number）用于精确计算和排序，又保存格式化的日期字符串（dateStr）用于快速分组和显示，这种设计在性能和便利性之间取得了很好的平衡。

```typescript
export interface AccountRecord {
  id: string;                      // 唯一标识符
  type: 'income' | 'expense';      // 记录类型：收入或支出
  category: string;                // 分类名称（如：食物、交通、工资等）
  amount: number;                  // 金额（单位：元）
  description: string;             // 用途描述
  date: number;                    // 时间戳（毫秒）
  dateStr: string;                 // 日期字符串（格式：YYYY-MM-DD）
  mood?: string;                   // 可选的心情标记（😊/😟/🎉）
}
```

**设计要点：**


- **唯一标识符**：每条记录都有一个唯一的 ID，由时间戳和随机字符串组合生成，确保在分布式环境下也不会产生冲突
- **类型安全**：使用联合类型限制 type 字段的取值，避免无效数据
- **双重日期存储**：时间戳用于精确排序和计算，日期字符串用于快速分组和展示
- **可选字段**：mood 字段使用可选标记（?），允许用户选择是否添加心情记录
- **描述性命名**：所有字段名都具有明确的业务含义，提高代码可读性

### CategoryItem - 分类项模型

分类是记账应用中的重要概念，它帮助用户对收支进行归类管理。CategoryItem 模型定义了分类的基本属性，包括名称、图标和颜色。这种设计使得分类不仅具有功能性，还具有良好的视觉表现力，用户可以通过图标和颜色快速识别不同的分类。

```typescript
export interface CategoryItem {
  name: string;    // 分类名称
  icon: string;    // 分类图标（Emoji 或图标名称）
  color: string;   // 分类颜色（十六进制色值）
}
```

在实际应用中，我们为收入和支出分别预定义了一组常用分类。支出分类包括食物、交通、娱乐、购物、医疗、教育、住房等，收入分类包括工资、奖金、投资、兼职等。每个分类都配有相应的图标和颜色，形成了一套完整的视觉识别系统。

### DailySummary - 日汇总模型

日汇总模型用于统计某一天的收支情况，这是用户最常查看的统计维度之一。通过日汇总，用户可以快速了解每天的财务状况，发现异常支出或收入。

```typescript
export interface DailySummary {
  date: string;      // 日期（YYYY-MM-DD）
  income: number;    // 当日总收入
  expense: number;   // 当日总支出
}
```

这个模型的设计非常简洁，只包含必要的统计信息。在实际使用中，我们可以通过计算 `income - expense` 得到当日结余，通过比较不同日期的数据来分析消费趋势。

### MonthlySummary - 月汇总模型


月汇总是更高层次的统计维度，它不仅包含收支金额的汇总，还保留了该月所有记录的引用。这种设计使得用户既能看到宏观的月度财务状况，又能深入查看具体的记录明细。

```typescript
export interface MonthlySummary {
  month: string;                // 月份（YYYY-MM）
  income: number;               // 当月总收入
  expense: number;              // 当月总支出
  records: AccountRecord[];     // 当月所有记录
}
```

**设计亮点：**

- **聚合与明细结合**：既提供汇总数据，又保留原始记录，满足不同层次的查询需求
- **便于趋势分析**：通过月份字符串可以方便地进行时间序列分析
- **支持下钻查询**：用户可以从月度汇总直接访问具体的记录明细

### CategorySummary - 分类汇总模型

分类汇总是数据分析的重要维度，它帮助用户了解在各个分类上的支出或收入分布。这个模型不仅包含金额统计，还计算了百分比和配色信息，为数据可视化提供了完整的支持。

```typescript
export interface CategorySummary {
  category: string;     // 分类名称
  amount: number;       // 该分类的总金额
  percentage: number;   // 占比（百分比）
  color: string;        // 显示颜色
}
```

在图表展示中，这个模型可以直接用于绘制饼图或柱状图。percentage 字段已经计算好了占比，color 字段提供了统一的配色方案，使得不同页面的图表保持视觉一致性。

---

## 业务实体模型

### AccountBook - 账本模型

账本是应用的顶层组织单位，允许用户创建多个独立的账本来管理不同场景的财务数据。例如，用户可以创建"个人账本"、"家庭账本"、"旅游账本"等，每个账本的数据完全独立，互不干扰。

```typescript
export class AccountBook {
  id: string = '';              // 账本唯一标识
  name: string = '';            // 账本名称
  icon: string = '📒';          // 账本图标（默认为笔记本图标）
  createTime: string = '';      // 创建时间
  isDefault: boolean = false;   // 是否为默认账本
}
```


**设计考虑：**

- **多账本隔离**：每个账本有独立的 ID，所有记录都关联到特定账本，实现数据隔离
- **默认账本机制**：通过 isDefault 标记，系统可以自动选择默认账本，提升用户体验
- **个性化标识**：支持自定义图标，让账本更具辨识度
- **时间追溯**：记录创建时间，便于管理和排序

在实际应用中，账本的切换会影响所有数据的读取和存储。StorageUtil 会根据当前账本 ID 生成不同的存储键，确保不同账本的数据完全独立。

### Budget - 预算模型

预算管理是帮助用户控制支出的重要功能。Budget 模型定义了预算的基本属性，包括预算金额、周期、预警阈值等。通过设置预算，用户可以对特定分类的支出进行监控和控制。

```typescript
export class Budget {
  id: string = '';                              // 预算唯一标识
  bookId: string = '';                          // 所属账本ID
  category: string = '';                        // 预算分类
  amount: number = 0;                           // 预算金额
  period: 'week' | 'month' | 'year' = 'month';  // 预算周期
  warningThreshold: number = 90;                // 预警阈值（百分比）
  createTime: string = '';                      // 创建时间
}
```

**核心特性：**

- **多周期支持**：支持周、月、年三种预算周期，满足不同的管理需求
- **预警机制**：通过 warningThreshold 设置预警阈值，当支出达到预算的一定比例时提醒用户
- **分类关联**：每个预算针对特定分类，实现精细化的支出控制
- **账本绑定**：预算与账本关联，不同账本可以有独立的预算设置

### BudgetProgress - 预算进度模型

预算进度模型用于实时跟踪预算的执行情况，它通过计算实际支出与预算金额的关系，为用户提供直观的预算使用情况反馈。

```typescript
export class BudgetProgress {
  budgetId: string = '';                              // 关联的预算ID
  category: string = '';                              // 分类名称
  budgetAmount: number = 0;                           // 预算总额
  usedAmount: number = 0;                             // 已使用金额
  remainingAmount: number = 0;                        // 剩余金额
  percentage: number = 0;                             // 使用百分比
  status: 'normal' | 'warning' | 'exceeded' = 'normal';  // 状态
  recordCount: number = 0;                            // 记录数量
}
```


**状态管理：**

- **normal（正常）**：使用率低于预警阈值，显示绿色
- **warning（预警）**：使用率达到预警阈值但未超支，显示橙色
- **exceeded（超支）**：使用金额超过预算，显示红色

这个模型是通过 BudgetUtil 工具类动态计算生成的，它会遍历当前周期内的所有支出记录，统计特定分类的总支出，然后与预算金额进行比较，计算出各项指标。这种设计将计算逻辑与数据模型分离，保持了模型的纯粹性。

---

## 视图模型层

### AccountViewModel - 账户视图模型

AccountViewModel 是连接数据模型和视图层的桥梁，它封装了所有与账户记录相关的业务逻辑和数据操作。这个类采用了典型的 ViewModel 模式，负责数据的增删改查、统计分析、分组聚合等复杂操作。

```typescript
export class AccountViewModel {
  records: AccountRecord[] = [];  // 记录列表

  // 添加记录
  addRecord(record: AccountRecord): void {
    this.records.unshift(record);  // 新记录插入到数组开头
  }

  // 删除记录
  deleteRecord(id: string): void {
    this.records = this.records.filter(r => r.id !== id);
  }

  // 更新记录
  updateRecord(id: string, record: AccountRecord): void {
    const index = this.records.findIndex(r => r.id === id);
    if (index !== -1) {
      this.records[index] = record;
    }
  }
}
```

**基础操作设计：**

- **添加操作**：使用 unshift 将新记录插入数组开头，确保最新记录总是显示在最前面
- **删除操作**：使用 filter 方法创建新数组，保持数据的不可变性
- **更新操作**：先查找索引，再进行替换，确保操作的安全性

### 统计分析功能

AccountViewModel 提供了丰富的统计分析方法，这些方法是应用各个页面展示数据的基础。

#### 今日收支统计

```typescript
getTodaySummary(): Summary {
  const today = DateUtil.getTodayStr();
  let income = 0;
  let expense = 0;

  this.records.forEach(record => {
    if (record.dateStr === today) {
      if (record.type === 'income') {
        income += record.amount;
      } else {
        expense += record.amount;
      }
    }
  });

  return { income, expense };
}
```


这个方法通过遍历所有记录，筛选出今天的记录，然后分别累加收入和支出。它是首页展示今日收支的数据来源，让用户一打开应用就能看到今天的财务状况。

#### 本月收支统计

```typescript
getMonthSummary(): Summary {
  const thisMonth = DateUtil.getThisMonthStr();  // 获取当前月份字符串
  let income = 0;
  let expense = 0;

  this.records.forEach(record => {
    if (record.dateStr.startsWith(thisMonth)) {  // 使用字符串前缀匹配
      if (record.type === 'income') {
        income += record.amount;
      } else {
        expense += record.amount;
      }
    }
  });

  return { income, expense };
}
```

本月统计使用了字符串前缀匹配的技巧，因为日期格式是 "YYYY-MM-DD"，而月份格式是 "YYYY-MM"，所以只需要判断日期字符串是否以当前月份开头即可。这种方法比日期对象比较更高效。

### 数据分组功能

分组是数据展示的重要手段，AccountViewModel 提供了按日期和按月份两种分组方式。

#### 按日期分组

```typescript
groupByDate(): Map<string, AccountRecord[]> {
  const grouped = new Map<string, AccountRecord[]>();

  this.records.forEach(record => {
    if (!grouped.has(record.dateStr)) {
      grouped.set(record.dateStr, []);
    }
    grouped.get(record.dateStr)!.push(record);
  });

  return grouped;
}
```

这个方法返回一个 Map 对象，键是日期字符串，值是该日期的所有记录数组。使用 Map 而不是普通对象的好处是：Map 保持插入顺序，支持任意类型的键，并且有更好的性能。

在列表页面，我们使用这个方法将记录按日期分组展示，每个日期下显示当天的所有记录，这样用户可以清晰地看到每天的消费情况。

#### 按月份分组

```typescript
groupByMonth(): Map<string, AccountRecord[]> {
  const grouped = new Map<string, AccountRecord[]>();

  this.records.forEach(record => {
    const month = record.dateStr.substring(0, 7);  // 提取月份部分
    if (!grouped.has(month)) {
      grouped.set(month, []);
    }
    grouped.get(month)!.push(record);
  });

  return grouped;
}
```


按月份分组使用了字符串截取方法，从 "YYYY-MM-DD" 格式中提取前 7 个字符得到 "YYYY-MM"。这种方法简单高效，避免了复杂的日期对象操作。

### 高级统计功能

#### 月度汇总

```typescript
getMonthlySummaries(): MonthlySummary[] {
  const grouped = this.groupByMonth();
  const summaries: MonthlySummary[] = [];

  grouped.forEach((records, month) => {
    let income = 0;
    let expense = 0;

    records.forEach(record => {
      if (record.type === 'income') {
        income += record.amount;
      } else {
        expense += record.amount;
      }
    });

    summaries.push({
      month,
      income,
      expense,
      records
    });
  });

  return summaries.sort((a, b) => b.month.localeCompare(a.month));
}
```

这个方法首先调用 groupByMonth 进行分组，然后遍历每个月份的记录，计算收入和支出总额，最后按月份降序排序（最近的月份在前）。返回的数组可以直接用于图表页面的月度趋势展示。

#### 分类汇总

```typescript
getCategorySummary(type: 'income' | 'expense', month?: string): CategorySummary[] {
  // 第一步：筛选记录
  let filtered = this.records.filter(r => r.type === type);
  
  if (month) {
    filtered = filtered.filter(r => r.dateStr.startsWith(month));
  }

  // 第二步：按分类聚合
  const categoryMap = new Map<string, number>();
  let total = 0;

  filtered.forEach(record => {
    const current = categoryMap.get(record.category) || 0;
    categoryMap.set(record.category, current + record.amount);
    total += record.amount;
  });

  // 第三步：计算百分比并生成结果
  const summaries: CategorySummary[] = [];
  categoryMap.forEach((amount: number, category: string) => {
    summaries.push({
      category,
      amount,
      percentage: total > 0 ? (amount / total) * 100 : 0,
      color: this.getCategoryColor(category)
    });
  });

  return summaries.sort((a, b) => b.amount - a.amount);
}
```


分类汇总是最复杂的统计功能之一，它的实现分为三个步骤：

1. **数据筛选**：根据收支类型和可选的月份参数筛选记录
2. **分类聚合**：使用 Map 对象按分类累加金额，同时计算总金额
3. **结果生成**：计算每个分类的占比，分配颜色，按金额降序排序

这个方法支持可选的月份参数，如果不传月份则统计所有时间的数据，如果传入月份则只统计该月的数据。这种灵活的设计使得同一个方法可以服务于不同的展示场景。

#### 分类颜色映射

```typescript
getCategoryColor(category: string): string {
  const colors: Record<string, string> = {
    '食物': '#E8A5A5',
    '交通': '#8FAADC',
    '娱乐': '#E8C9A5',
    '购物': '#C9B6D6',
    '医疗': '#95D1B3',
    '教育': '#A5C8E8',
    '住房': '#B8B5B2',
    '工资': '#95D1B3',
    '奖金': '#E8C9A5',
    '投资': '#8FAADC',
    '兼职': '#C9B6D6',
    '其他': '#D6C9B6'
  };
  return colors[category] || '#B8B5B2';
}
```

这个方法为每个分类分配了固定的颜色，确保在不同页面和图表中，同一分类始终使用相同的颜色，提供一致的视觉体验。如果遇到未定义的分类，则返回默认的灰色。

### 条件查询功能

```typescript
// 查询过滤器接口
export interface QueryFilters {
  type?: 'income' | 'expense';  // 收支类型
  category?: string;             // 分类
  minAmount?: number;            // 最小金额
  maxAmount?: number;            // 最大金额
  startDate?: string;            // 开始日期
  endDate?: string;              // 结束日期
}

// 条件查询方法
queryRecords(filters: QueryFilters): AccountRecord[] {
  return this.records.filter(record => {
    if (filters.type && record.type !== filters.type) return false;
    if (filters.category && record.category !== filters.category) return false;
    if (filters.minAmount !== undefined && record.amount < filters.minAmount) return false;
    if (filters.maxAmount !== undefined && record.amount > filters.maxAmount) return false;
    if (filters.startDate && record.dateStr < filters.startDate) return false;
    if (filters.endDate && record.dateStr > filters.endDate) return false;
    return true;
  });
}
```


条件查询功能允许用户根据多个维度筛选记录。QueryFilters 接口定义了所有可用的筛选条件，所有字段都是可选的，用户可以组合使用任意条件。查询方法使用链式判断，只要有一个条件不满足就排除该记录，所有条件都满足才保留。

这种设计的优点是：
- **灵活性高**：支持任意条件组合
- **类型安全**：通过接口约束参数类型
- **性能良好**：使用短路逻辑，不满足条件立即返回
- **易于扩展**：添加新的筛选条件只需修改接口和判断逻辑

---

## 应用状态管理

### AppState - 全局状态管理

AppState 是应用的全局状态管理类，采用静态类的设计模式，负责管理应用级别的状态，特别是主题相关的状态。这种设计使得主题状态可以在整个应用中共享，任何组件都可以访问和修改主题。

```typescript
export class AppState {
  static currentTheme: ThemeType = 'light';      // 当前主题
  static colors: ThemeColors = ThemeUtil.LIGHT_THEME;  // 当前颜色方案

  // 初始化应用状态
  static async init(): Promise<void> {
    await ThemeUtil.initTheme();
    AppState.currentTheme = ThemeUtil.getTheme();
    AppState.colors = ThemeUtil.getColors();
  }

  // 设置主题
  static async setTheme(theme: ThemeType): Promise<void> {
    await ThemeUtil.setTheme(theme);
    AppState.currentTheme = theme;
    AppState.colors = ThemeUtil.getColors();
  }

  // 切换主题
  static toggleTheme(): ThemeType {
    const newTheme = ThemeUtil.toggleTheme();
    AppState.currentTheme = newTheme;
    AppState.colors = ThemeUtil.getColors();
    return newTheme;
  }
}
```

**设计特点：**

- **静态类模式**：所有成员都是静态的，无需实例化即可使用
- **异步初始化**：init 方法从本地存储加载主题设置
- **状态同步**：每次主题变更都会同步更新 currentTheme 和 colors
- **简化访问**：组件可以直接通过 AppState.colors 访问当前颜色方案

这种全局状态管理方式特别适合主题这种需要在整个应用中保持一致的状态。当用户切换主题时，所有使用 AppState.colors 的组件都会自动获取新的颜色值。

---

## 数据持久化方案

### StorageUtil - 存储工具类


StorageUtil 封装了应用的所有数据持久化操作，使用 HarmonyOS 的 preferences API 实现本地数据存储。这个工具类采用了单例模式的思想，通过静态方法提供全局访问点。

```typescript
export class StorageUtil {
  private static context: Context;

  // 设置应用上下文
  static setContext(context: Context) {
    StorageUtil.context = context;
  }

  // 获取当前账本的存储键
  private static getCurrentBookKey(): string {
    const bookId = AccountBookUtil.getCurrentBookId();
    return bookId ? `${STORAGE_KEY}_${bookId}` : STORAGE_KEY;
  }
}
```

**上下文管理：**

StorageUtil 需要应用上下文才能访问本地存储，因此在应用启动时必须调用 setContext 方法注入上下文。这种依赖注入的方式使得工具类与具体的应用环境解耦，便于测试和维护。

**多账本存储策略：**

getCurrentBookKey 方法实现了多账本数据隔离的关键逻辑。它根据当前选中的账本 ID 生成不同的存储键，例如：
- 默认账本：`account_records`
- 账本1：`account_records_book1`
- 账本2：`account_records_book2`

这样，不同账本的数据存储在不同的键下，实现了完全的数据隔离。

### 记录的保存与读取

```typescript
// 保存记录
static async saveRecords(records: AccountRecord[]): Promise<void> {
  try {
    const pref = await preferences.getPreferences(StorageUtil.context, 'account_app');
    const key = StorageUtil.getCurrentBookKey();
    await pref.put(key, JSON.stringify(records));
    await pref.flush();
  } catch (error) {
    console.error('保存记录失败:', error);
  }
}

// 读取记录
static async getRecords(): Promise<AccountRecord[]> {
  try {
    const pref = await preferences.getPreferences(StorageUtil.context, 'account_app');
    const key = StorageUtil.getCurrentBookKey();
    const data = await pref.get(key, '[]');
    return JSON.parse(data as string);
  } catch (error) {
    console.error('读取记录失败:', error);
    return [];
  }
}
```

**存储流程：**

1. 获取 preferences 实例（数据库名为 'account_app'）
2. 根据当前账本生成存储键
3. 将记录数组序列化为 JSON 字符串
4. 调用 put 方法写入数据
5. 调用 flush 方法确保数据持久化到磁盘

**读取流程：**

1. 获取 preferences 实例
2. 根据当前账本生成存储键
3. 调用 get 方法读取数据，如果不存在则返回空数组字符串
4. 将 JSON 字符串反序列化为记录数组
5. 如果发生错误，返回空数组保证应用不会崩溃


### 通用键值存储

```typescript
// 保存键值对
static async set(key: string, value: string): Promise<void> {
  try {
    const pref = await preferences.getPreferences(StorageUtil.context, 'account_app');
    await pref.put(key, value);
    await pref.flush();
  } catch (error) {
    console.error('保存数据失败:', error);
  }
}

// 读取键值对
static async get(key: string): Promise<string> {
  try {
    const pref = await preferences.getPreferences(StorageUtil.context, 'account_app');
    const data = await pref.get(key, '');
    return data as string;
  } catch (error) {
    console.error('读取数据失败:', error);
    return '';
  }
}
```

除了记录数据，应用还需要存储其他配置信息，如主题设置、当前账本 ID、预算数据等。set 和 get 方法提供了通用的键值存储能力，可以存储任意字符串数据。

**使用示例：**

```typescript
// 保存主题设置
await StorageUtil.set('theme', 'dark');

// 保存当前账本ID
await StorageUtil.set('current_book_id', 'book123');

// 保存预算数据
await StorageUtil.set('budgets', JSON.stringify(budgets));
```

### ID 生成策略

```typescript
static generateId(): string {
  return Date.now().toString() + Math.random().toString(36).substr(2, 9);
}
```

generateId 方法用于生成唯一标识符，它结合了时间戳和随机字符串：
- **时间戳部分**：确保 ID 按时间递增，便于排序
- **随机部分**：使用 36 进制随机字符串，降低冲突概率

生成的 ID 示例：`1700123456789abc123def`

这种 ID 生成策略的优点是：
- 无需中心化的 ID 分配服务
- 在客户端即可生成，无需网络请求
- 冲突概率极低
- 包含时间信息，便于调试

---

## 数据流转流程

### 添加记录的完整流程

让我们通过一个完整的例子来理解数据在各层之间的流转：

```typescript
// 1. 用户在 AddRecordPage 填写表单并提交
async function handleSubmit() {
  // 2. 创建记录对象
  const record: AccountRecord = {
    id: StorageUtil.generateId(),
    type: selectedType,
    category: selectedCategory,
    amount: parseFloat(amountInput),
    description: descriptionInput,
    date: Date.now(),
    dateStr: DateUtil.formatDate(new Date()),
    mood: selectedMood
  };

  // 3. 添加到 ViewModel
  viewModel.addRecord(record);

  // 4. 持久化到本地存储
  await StorageUtil.saveRecords(viewModel.records);

  // 5. 返回首页，触发界面刷新
  router.back();
}
```


**流程说明：**

1. **用户交互层**：用户在添加记录页面填写表单
2. **数据构建层**：根据用户输入构建 AccountRecord 对象
3. **业务逻辑层**：调用 ViewModel 的 addRecord 方法
4. **持久化层**：调用 StorageUtil 保存数据到本地
5. **视图更新层**：返回首页，页面重新加载数据并刷新显示

### 查询统计的数据流程

```typescript
// 1. 页面加载时初始化数据
async function aboutToAppear() {
  // 2. 从本地存储加载记录
  const records = await StorageUtil.getRecords();
  
  // 3. 填充到 ViewModel
  viewModel.records = records;
  
  // 4. 调用统计方法获取汇总数据
  const todaySummary = viewModel.getTodaySummary();
  const monthSummary = viewModel.getMonthSummary();
  const categorySummary = viewModel.getCategorySummary('expense');
  
  // 5. 更新界面状态
  this.todayIncome = todaySummary.income;
  this.todayExpense = todaySummary.expense;
  this.monthIncome = monthSummary.income;
  this.monthExpense = monthSummary.expense;
  this.categories = categorySummary;
}
```

**流程说明：**

1. **页面生命周期**：aboutToAppear 钩子函数触发
2. **数据加载**：从 StorageUtil 读取持久化数据
3. **数据注入**：将数据填充到 ViewModel
4. **业务计算**：调用 ViewModel 的统计方法
5. **状态更新**：将计算结果赋值给组件状态变量
6. **界面渲染**：ArkUI 框架自动刷新界面

---

## 模型设计原则

### 单一职责原则

每个模型类都有明确的职责边界：
- **AccountRecord**：只负责表示一条记录的数据结构
- **AccountViewModel**：只负责记录的业务逻辑和统计计算
- **StorageUtil**：只负责数据的持久化操作
- **AppState**：只负责全局状态管理

这种清晰的职责划分使得代码易于理解和维护，当需要修改某个功能时，可以快速定位到对应的类。

### 开闭原则

模型设计对扩展开放，对修改封闭。例如：

**扩展分类：**
```typescript
// 无需修改 AccountRecord 接口，只需添加新的分类配置
const newCategory: CategoryItem = {
  name: '宠物',
  icon: '🐕',
  color: '#FFB6C1'
};
```

**扩展统计维度：**
```typescript
// 在 AccountViewModel 中添加新的统计方法，不影响现有方法
getWeeklySummary(): Summary {
  // 新增的周统计逻辑
}
```


### 依赖倒置原则

高层模块不依赖低层模块，都依赖于抽象。例如：

```typescript
// ViewModel 不直接依赖具体的存储实现
// 而是通过 StorageUtil 接口进行操作
class AccountViewModel {
  async save() {
    await StorageUtil.saveRecords(this.records);
  }
}

// 如果将来需要更换存储方案（如使用云存储）
// 只需修改 StorageUtil 的实现，不影响 ViewModel
```

### 接口隔离原则

接口设计精简，只包含必要的属性。例如：

```typescript
// DailySummary 只包含日汇总需要的字段
export interface DailySummary {
  date: string;
  income: number;
  expense: number;
}

// 而不是包含所有可能的统计字段
// 这样使得接口更加聚焦和易用
```

### 里氏替换原则

子类可以替换父类而不影响程序的正确性。虽然我们的模型主要使用接口而非继承，但在设计时也遵循了这一原则：

```typescript
// 所有实现 AccountRecord 接口的对象都可以互相替换
function processRecord(record: AccountRecord) {
  console.log(record.amount);
}

// 无论记录来自哪里，只要符合接口定义就可以使用
const record1: AccountRecord = await StorageUtil.getRecords()[0];
const record2: AccountRecord = { /* 手动构建的记录 */ };

processRecord(record1);  // ✓
processRecord(record2);  // ✓
```

---

## 性能优化考虑

### 数据结构选择

在模型设计中，我们针对不同场景选择了合适的数据结构：

**数组（Array）**：
- 用于存储记录列表（records: AccountRecord[]）
- 优点：顺序访问快，支持丰富的数组方法
- 适用场景：需要遍历、过滤、排序的数据

**Map 对象**：
- 用于分组数据（groupByDate、groupByMonth）
- 优点：查找速度快（O(1)），保持插入顺序
- 适用场景：需要按键快速查找的数据

**对象字面量（Object）**：
- 用于配置数据（分类颜色映射）
- 优点：语法简洁，访问方便
- 适用场景：静态配置数据

### 计算缓存策略

对于频繁调用的统计方法，可以考虑添加缓存机制：

```typescript
export class AccountViewModel {
  private summaryCache: Map<string, any> = new Map();
  
  getTodaySummary(): Summary {
    const cacheKey = 'today_' + DateUtil.getTodayStr();
    
    if (this.summaryCache.has(cacheKey)) {
      return this.summaryCache.get(cacheKey);
    }
    
    const summary = this.calculateTodaySummary();
    this.summaryCache.set(cacheKey, summary);
    return summary;
  }
  
  // 当数据变更时清除缓存
  addRecord(record: AccountRecord): void {
    this.records.unshift(record);
    this.summaryCache.clear();
  }
}
```


### 懒加载策略

对于大量数据的场景，可以实现分页加载：

```typescript
export class AccountViewModel {
  private pageSize: number = 50;
  private currentPage: number = 0;
  
  getRecordsByPage(page: number): AccountRecord[] {
    const start = page * this.pageSize;
    const end = start + this.pageSize;
    return this.records.slice(start, end);
  }
  
  loadMore(): AccountRecord[] {
    this.currentPage++;
    return this.getRecordsByPage(this.currentPage);
  }
}
```

### 数据序列化优化

在保存大量数据时，可以考虑压缩策略：

```typescript
static async saveRecords(records: AccountRecord[]): Promise<void> {
  // 只保存必要字段，减少存储空间
  const simplified = records.map(r => ({
    i: r.id,
    t: r.type === 'income' ? 1 : 0,
    c: r.category,
    a: r.amount,
    d: r.description,
    dt: r.date,
    m: r.mood
  }));
  
  const pref = await preferences.getPreferences(StorageUtil.context, 'account_app');
  await pref.put(key, JSON.stringify(simplified));
  await pref.flush();
}
```

---

## 扩展性设计

### 支持多币种

当前模型使用 number 类型存储金额，未来如需支持多币种，可以扩展为：

```typescript
export interface Money {
  amount: number;
  currency: string;  // 'CNY', 'USD', 'EUR' 等
}

export interface AccountRecord {
  id: string;
  type: 'income' | 'expense';
  category: string;
  amount: Money;  // 替换为 Money 对象
  description: string;
  date: number;
  dateStr: string;
  mood?: string;
}
```

### 支持附件

如果需要为记录添加图片或文件附件：

```typescript
export interface Attachment {
  id: string;
  type: 'image' | 'file';
  url: string;
  name: string;
  size: number;
}

export interface AccountRecord {
  // ... 现有字段
  attachments?: Attachment[];  // 添加附件数组
}
```

### 支持标签

为记录添加多标签支持：

```typescript
export interface Tag {
  id: string;
  name: string;
  color: string;
}

export interface AccountRecord {
  // ... 现有字段
  tags?: Tag[];  // 添加标签数组
}
```

### 支持周期性记录

对于固定的周期性支出（如房租、订阅费用）：

```typescript
export interface RecurringRecord {
  id: string;
  baseRecord: AccountRecord;  // 基础记录模板
  frequency: 'daily' | 'weekly' | 'monthly' | 'yearly';
  startDate: string;
  endDate?: string;
  nextOccurrence: string;
}
```


---

## 数据验证与错误处理

### 输入验证

在模型层添加数据验证逻辑，确保数据的完整性和有效性：

```typescript
export class AccountRecordValidator {
  static validate(record: AccountRecord): ValidationResult {
    const errors: string[] = [];
    
    // 验证金额
    if (record.amount <= 0) {
      errors.push('金额必须大于0');
    }
    if (record.amount > 999999999) {
      errors.push('金额超出允许范围');
    }
    
    // 验证分类
    if (!record.category || record.category.trim() === '') {
      errors.push('必须选择分类');
    }
    
    // 验证日期
    if (!record.date || record.date > Date.now()) {
      errors.push('日期不能是未来时间');
    }
    
    // 验证描述长度
    if (record.description.length > 200) {
      errors.push('描述不能超过200个字符');
    }
    
    return {
      isValid: errors.length === 0,
      errors
    };
  }
}

interface ValidationResult {
  isValid: boolean;
  errors: string[];
}
```

### 错误处理策略

在 ViewModel 中实现统一的错误处理：

```typescript
export class AccountViewModel {
  private errorHandler: (error: Error) => void;
  
  setErrorHandler(handler: (error: Error) => void) {
    this.errorHandler = handler;
  }
  
  async addRecord(record: AccountRecord): Promise<boolean> {
    try {
      // 验证数据
      const validation = AccountRecordValidator.validate(record);
      if (!validation.isValid) {
        throw new Error(validation.errors.join(', '));
      }
      
      // 添加记录
      this.records.unshift(record);
      
      // 保存到本地
      await StorageUtil.saveRecords(this.records);
      
      return true;
    } catch (error) {
      if (this.errorHandler) {
        this.errorHandler(error as Error);
      }
      console.error('添加记录失败:', error);
      return false;
    }
  }
}
```

---

## 测试支持

### Mock 数据生成

为了便于测试和开发，提供 Mock 数据生成工具：

```typescript
export class MockDataGenerator {
  static generateRecord(overrides?: Partial<AccountRecord>): AccountRecord {
    return {
      id: StorageUtil.generateId(),
      type: 'expense',
      category: '食物',
      amount: Math.random() * 1000,
      description: '测试记录',
      date: Date.now(),
      dateStr: DateUtil.formatDate(new Date()),
      mood: '😊',
      ...overrides
    };
  }
  
  static generateRecords(count: number): AccountRecord[] {
    const records: AccountRecord[] = [];
    const categories = ['食物', '交通', '娱乐', '购物'];
    const types: ('income' | 'expense')[] = ['income', 'expense'];
    
    for (let i = 0; i < count; i++) {
      const daysAgo = Math.floor(Math.random() * 90);
      const date = new Date();
      date.setDate(date.getDate() - daysAgo);
      
      records.push({
        id: StorageUtil.generateId(),
        type: types[Math.floor(Math.random() * types.length)],
        category: categories[Math.floor(Math.random() * categories.length)],
        amount: Math.random() * 1000,
        description: `测试记录 ${i + 1}`,
        date: date.getTime(),
        dateStr: DateUtil.formatDate(date),
        mood: ['😊', '😟', '🎉'][Math.floor(Math.random() * 3)]
      });
    }
    
    return records;
  }
}
```


### 单元测试示例

```typescript
// AccountViewModel.test.ts
describe('AccountViewModel', () => {
  let viewModel: AccountViewModel;
  
  beforeEach(() => {
    viewModel = new AccountViewModel();
    viewModel.records = MockDataGenerator.generateRecords(100);
  });
  
  test('getTodaySummary should return correct summary', () => {
    const summary = viewModel.getTodaySummary();
    expect(summary.income).toBeGreaterThanOrEqual(0);
    expect(summary.expense).toBeGreaterThanOrEqual(0);
  });
  
  test('getCategorySummary should calculate percentages correctly', () => {
    const summaries = viewModel.getCategorySummary('expense');
    const totalPercentage = summaries.reduce((sum, s) => sum + s.percentage, 0);
    expect(totalPercentage).toBeCloseTo(100, 1);
  });
  
  test('queryRecords should filter by type', () => {
    const incomeRecords = viewModel.queryRecords({ type: 'income' });
    expect(incomeRecords.every(r => r.type === 'income')).toBe(true);
  });
});
```

---

## 数据迁移策略

### 版本管理

为模型添加版本信息，便于未来的数据迁移：

```typescript
export interface DataVersion {
  version: string;
  records: AccountRecord[];
  metadata: {
    createdAt: string;
    updatedAt: string;
    deviceId: string;
  };
}

export class MigrationManager {
  private static CURRENT_VERSION = '1.0.0';
  
  static async migrate(data: any): Promise<AccountRecord[]> {
    const version = data.version || '0.0.0';
    
    if (version === MigrationManager.CURRENT_VERSION) {
      return data.records;
    }
    
    // 执行迁移
    let records = data.records || data;
    
    if (version < '1.0.0') {
      records = MigrationManager.migrateToV1(records);
    }
    
    return records;
  }
  
  private static migrateToV1(oldRecords: any[]): AccountRecord[] {
    return oldRecords.map(old => ({
      id: old.id || StorageUtil.generateId(),
      type: old.type,
      category: old.category,
      amount: old.amount,
      description: old.description || '',
      date: old.date,
      dateStr: old.dateStr || DateUtil.formatDate(new Date(old.date)),
      mood: old.mood
    }));
  }
}
```

### 数据导入导出

支持数据的导入和导出，便于备份和迁移：

```typescript
export class DataExporter {
  static async exportToJSON(viewModel: AccountViewModel): Promise<string> {
    const data: DataVersion = {
      version: '1.0.0',
      records: viewModel.records,
      metadata: {
        createdAt: new Date().toISOString(),
        updatedAt: new Date().toISOString(),
        deviceId: 'device_id_here'
      }
    };
    
    return JSON.stringify(data, null, 2);
  }
  
  static async importFromJSON(json: string): Promise<AccountRecord[]> {
    const data = JSON.parse(json);
    return await MigrationManager.migrate(data);
  }
}
```

---

## 最佳实践总结


### 模型设计建议

**1. 保持模型的纯粹性**

模型应该只包含数据结构定义，不包含业务逻辑。业务逻辑应该放在 ViewModel 或工具类中。

```typescript
// ✓ 好的做法：纯数据模型
export interface AccountRecord {
  id: string;
  amount: number;
  // ...
}

// ✗ 不好的做法：在模型中包含业务逻辑
export interface AccountRecord {
  id: string;
  amount: number;
  calculateTax(): number;  // 业务逻辑应该在 ViewModel 中
}
```

**2. 使用接口而非类**

对于纯数据结构，优先使用 interface 而非 class，这样更轻量，也更符合 TypeScript 的类型系统。

```typescript
// ✓ 推荐：使用接口
export interface AccountRecord {
  id: string;
  amount: number;
}

// ✗ 不推荐：使用类（除非需要方法）
export class AccountRecord {
  id: string = '';
  amount: number = 0;
}
```

**3. 合理使用可选字段**

只有真正可选的字段才使用 `?` 标记，必填字段不要使用可选标记。

```typescript
// ✓ 好的做法
export interface AccountRecord {
  id: string;           // 必填
  amount: number;       // 必填
  mood?: string;        // 可选
}

// ✗ 不好的做法
export interface AccountRecord {
  id?: string;          // ID 不应该是可选的
  amount?: number;      // 金额不应该是可选的
}
```

**4. 使用联合类型约束取值**

对于有限的取值范围，使用联合类型而非字符串。

```typescript
// ✓ 好的做法
type: 'income' | 'expense'

// ✗ 不好的做法
type: string  // 无法在编译时检查错误
```

**5. 统一命名规范**

- 模型名称使用大驼峰（PascalCase）
- 字段名称使用小驼峰（camelCase）
- 布尔字段使用 is/has 前缀
- 日期字段使用明确的后缀（如 Date、Time、Str）

```typescript
export interface AccountBook {
  id: string;              // 小驼峰
  name: string;
  isDefault: boolean;      // is 前缀
  createTime: string;      // Time 后缀
}
```

### ViewModel 设计建议

**1. 单一数据源**

ViewModel 应该是数据的唯一来源，避免在多个地方维护相同的数据。

```typescript
// ✓ 好的做法：统一的数据源
export class AccountViewModel {
  records: AccountRecord[] = [];
  
  getTodayRecords() {
    return this.records.filter(/* ... */);
  }
}

// ✗ 不好的做法：多个数据源
export class AccountViewModel {
  records: AccountRecord[] = [];
  todayRecords: AccountRecord[] = [];  // 重复的数据
}
```

**2. 方法命名清晰**

方法名应该清楚地表达其功能，使用动词开头。

```typescript
// ✓ 好的命名
getTodaySummary()
addRecord()
deleteRecord()
queryRecords()

// ✗ 不好的命名
today()
add()
remove()
find()
```


**3. 避免过度计算**

对于复杂的计算，考虑缓存结果或使用计算属性。

```typescript
// ✓ 好的做法：缓存计算结果
export class AccountViewModel {
  private _totalCache: number | null = null;
  
  getTotal(): number {
    if (this._totalCache === null) {
      this._totalCache = this.records.reduce((sum, r) => sum + r.amount, 0);
    }
    return this._totalCache;
  }
  
  addRecord(record: AccountRecord) {
    this.records.push(record);
    this._totalCache = null;  // 清除缓存
  }
}
```

**4. 返回不可变数据**

对外提供的数据应该是不可变的，避免外部直接修改内部状态。

```typescript
// ✓ 好的做法：返回副本
getRecords(): AccountRecord[] {
  return [...this.records];
}

// ✗ 不好的做法：返回原始引用
getRecords(): AccountRecord[] {
  return this.records;  // 外部可以直接修改
}
```

### 存储设计建议

**1. 异步操作**

所有存储操作都应该是异步的，避免阻塞主线程。

```typescript
// ✓ 好的做法
static async saveRecords(records: AccountRecord[]): Promise<void> {
  await pref.put(key, JSON.stringify(records));
}

// ✗ 不好的做法
static saveRecords(records: AccountRecord[]): void {
  // 同步操作会阻塞主线程
}
```

**2. 错误处理**

所有存储操作都应该有错误处理，避免应用崩溃。

```typescript
// ✓ 好的做法
static async getRecords(): Promise<AccountRecord[]> {
  try {
    const data = await pref.get(key, '[]');
    return JSON.parse(data as string);
  } catch (error) {
    console.error('读取失败:', error);
    return [];  // 返回默认值
  }
}
```

**3. 数据验证**

从存储读取数据后，应该验证数据的有效性。

```typescript
static async getRecords(): Promise<AccountRecord[]> {
  try {
    const data = await pref.get(key, '[]');
    const records = JSON.parse(data as string);
    
    // 验证数据格式
    if (!Array.isArray(records)) {
      return [];
    }
    
    // 过滤无效记录
    return records.filter(r => 
      r.id && r.type && r.amount !== undefined
    );
  } catch (error) {
    return [];
  }
}
```

---

## 总结

本文档详细阐述了记账应用的模型设计，涵盖了从基础数据模型到业务逻辑层，从数据持久化到状态管理的完整架构。整个设计遵循了面向对象的设计原则，具有以下特点：

**清晰的分层架构**：数据模型、视图模型、工具类各司其职，职责边界清晰，便于维护和扩展。

**类型安全**：充分利用 TypeScript 的类型系统，通过接口定义和联合类型约束，在编译时就能发现大部分错误。

**灵活的扩展性**：模型设计预留了扩展空间，可以方便地添加新功能，如多币种支持、附件管理、标签系统等。

**完善的数据管理**：通过 ViewModel 封装业务逻辑，通过 StorageUtil 管理持久化，实现了数据的统一管理和流转。

**良好的性能考虑**：合理选择数据结构，支持缓存和懒加载，确保应用在大数据量下也能流畅运行。

这套模型设计不仅满足了当前的功能需求，也为未来的功能扩展和性能优化奠定了坚实的基础。通过遵循设计原则和最佳实践，我们构建了一个健壮、可维护、可扩展的数据层架构。

