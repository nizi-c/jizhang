// 浅色主题配色方案接口定义

// 辅助函数：将十六进制颜色转换为带透明度的颜色（ARGB格式）
function addOpacity(color: string, opacity: number): string {
  // 如果颜色已经有透明度，直接返回
  if (color.length === 9) {
    return color;
  }
  // 将透明度转换为十六进制（0-255），放在颜色前面
  const alpha = Math.round(opacity * 255).toString(16).padStart(2, '0').toUpperCase();
  // 移除 # 号，添加透明度，再加回 #
  return '#' + alpha + color.substring(1);
}

interface NavbarColors {
  backgroundColor: string;
  titleColor: string;
  buttonBackground: string;
  buttonTextColor: string;
  borderColor: string;
  backButtonColor: string;
}

interface StatCardColors {
  backgroundColor: string;
  titleColor: string;
  incomeColor: string;
  expenseColor: string;
  balanceColor: string;
  labelColor: string;
  borderColor: string;
  shadowColor: string;
}

interface RecentListColors {
  backgroundColor: string;
  itemBackground: string;
  categoryColor: string;
  descriptionColor: string;
  incomeAmountColor: string;
  expenseAmountColor: string;
  dateColor: string;
  dividerColor: string;
}

interface TabBarColors {
  backgroundColor: string;
  activeTextColor: string;
  inactiveTextColor: string;
  indicatorColor: string;
}

interface DialogColors {
  backgroundColor: string;
  titleColor: string;
  closeButtonColor: string;
  borderColor: string;
}

interface TypeSelectorColors {
  activeBackground: string;
  activeTextColor: string;
  inactiveBackground: string;
  inactiveTextColor: string;
  expenseActiveBackground: string;
  incomeActiveBackground: string;
}

interface CategoryGridColors {
  itemBackground: string;
  activeBackground: string;
  activeBorderColor: string;
  iconColor: string;
  textColor: string;
  activeIconColor: string;
  activeTextColor: string;
}

interface InputSectionColors {
  labelColor: string;
  inputBackground: string;
  inputBorderColor: string;
  inputTextColor: string;
  placeholderColor: string;
  errorColor: string;
}

interface ButtonSectionColors {
  cancelBackground: string;
  cancelTextColor: string;
  saveBackground: string;
  saveTextColor: string;
}

interface ListContainerColors {
  backgroundColor: string;
  emptyTextColor: string;
}

interface ListItemColors {
  backgroundColor: string;
  swipeDeleteBackground: string;
  deleteTextColor: string;
  categoryColor: string;
  descriptionColor: string;
  amountIncomeColor: string;
  amountExpenseColor: string;
  dateColor: string;
  dividerColor: string;
}

interface MonthPickerColors {
  backgroundColor: string;
  textColor: string;
  buttonBackground: string;
  buttonTextColor: string;
}

interface ChartContainerColors {
  backgroundColor: string;
  titleColor: string;
  emptyTextColor: string;
}

interface ProgressChartColors {
  trackColor: string;
  expenseProgressColor: string;
  incomeProgressColor: string;
  categoryColor: string;
  percentageColor: string;
  amountColor: string;
}

interface DetailListColors {
  sectionTitleColor: string;
  itemBackground: string;
  categoryColor: string;
  expenseAmountColor: string;
  incomeAmountColor: string;
}

interface FilterSectionColors {
  labelColor: string;
  buttonActiveBackground: string;
  buttonActiveTextColor: string;
  buttonInactiveBackground: string;
  buttonInactiveTextColor: string;
  categoryActiveBackground: string;
  categoryActiveTextColor: string;
  categoryInactiveBackground: string;
  categoryInactiveTextColor: string;
}

interface QueryButtonColors {
  backgroundColor: string;
  textColor: string;
}

interface ResultSectionColors {
  titleColor: string;
  emptyTextColor: string;
  itemBackground: string;
  dividerColor: string;
}

interface LightColorScheme {
  NAVBAR: NavbarColors;
  STAT_CARD: StatCardColors;
  RECENT_LIST: RecentListColors;
  TAB_BAR: TabBarColors;
  DIALOG: DialogColors;
  TYPE_SELECTOR: TypeSelectorColors;
  CATEGORY_GRID: CategoryGridColors;
  INPUT_SECTION: InputSectionColors;
  BUTTON_SECTION: ButtonSectionColors;
  LIST_CONTAINER: ListContainerColors;
  LIST_ITEM: ListItemColors;
  MONTH_PICKER: MonthPickerColors;
  CHART_CONTAINER: ChartContainerColors;
  PROGRESS_CHART: ProgressChartColors;
  DETAIL_LIST: DetailListColors;
  FILTER_SECTION: FilterSectionColors;
  QUERY_BUTTON: QueryButtonColors;
  RESULT_SECTION: ResultSectionColors;
}

export const LIGHT_COLOR_SCHEME: LightColorScheme = {
  // 首页导航栏
  NAVBAR: {
    backgroundColor: addOpacity('#FDF0CE', 0.4),
    titleColor: '#5D5C5A',
    buttonBackground: addOpacity('#FDF0CE', 0.4),
    buttonTextColor: '#FFFFFF',
    borderColor: addOpacity('#FDF0CE', 0.4),
    backButtonColor: '#5D5C5A'
  } as NavbarColors,

  // 统计卡片
  STAT_CARD: {
    backgroundColor: addOpacity('#FDF0CE', 0.4),
    titleColor: '#8E8D8C',
    incomeColor: '#95D1B3',
    expenseColor: '#E8A5A5',
    balanceColor: '#5D5C5A',
    labelColor: '#8E8D8C',
    borderColor: addOpacity('#FDF0CE', 0.4),
    shadowColor: '#00000008'
  } as StatCardColors,

  // 最近记录列表
  RECENT_LIST: {
    backgroundColor: addOpacity('#FDF0CE', 0.4),
    itemBackground: addOpacity('#FDF0CE', 0.4),
    categoryColor: '#5D5C5A',
    descriptionColor: '#8E8D8C',
    incomeAmountColor: '#95D1B3',
    expenseAmountColor: '#E8A5A5',
    dateColor: '#B4B3B2',
    dividerColor: addOpacity('#FDF0CE', 0.4)
  } as RecentListColors,

  // 标签页导航
  TAB_BAR: {
    backgroundColor: addOpacity('#FDF0CE', 0.4),
    activeTextColor: '#8FAADC',
    inactiveTextColor: '#8E8D8C',
    indicatorColor: '#8FAADC'
  } as TabBarColors,

  // 添加记录弹窗 - 弹窗容器
  DIALOG: {
    backgroundColor: '#FDF0CE',
    titleColor: '#5D5C5A',
    closeButtonColor: '#5D5C5A',
    borderColor: '#FDF0CE'
  } as DialogColors,

  // 类型选择器
  TYPE_SELECTOR: {
    activeBackground: addOpacity('#8FAADC', 0.4),
    activeTextColor: '#5D5C5A',
    inactiveBackground: addOpacity('#FDF0CE', 0.4),
    inactiveTextColor: '#5D5C5A',
    expenseActiveBackground: addOpacity('#8FAADC', 0.4),
    incomeActiveBackground: addOpacity('#8FAADC', 0.4)
  } as TypeSelectorColors,

  // 分类选择网格
  CATEGORY_GRID: {
    itemBackground: addOpacity('#FDF0CE', 0.4),
    activeBackground: '#FDF0CE',
    activeBorderColor: '#8FAADC',
    iconColor: '#5D5C5A',
    textColor: '#5D5C5A',
    activeIconColor: '#5D5C5A',
    activeTextColor: '#5D5C5A'
  } as CategoryGridColors,

  // 输入区域
  INPUT_SECTION: {
    labelColor: '#8E8D8C',
    inputBackground: addOpacity('#FDF0CE', 0.4),
    inputBorderColor: addOpacity('#FDF0CE', 0.4),
    inputTextColor: '#5D5C5A',
    placeholderColor: '#B4B3B2',
    errorColor: '#E8A5A5'
  } as InputSectionColors,

  // 按钮区域
  BUTTON_SECTION: {
    cancelBackground: addOpacity('#FDF0CE', 0.4),
    cancelTextColor: '#5D5C5A',
    saveBackground: addOpacity('#FDF0CE', 0.4),
    saveTextColor: '#5D5C5A'
  } as ButtonSectionColors,

  // 列表容器
  LIST_CONTAINER: {
    backgroundColor: addOpacity('#FDF0CE', 0.4),
    emptyTextColor: '#8E8D8C'
  } as ListContainerColors,

  // 列表项
  LIST_ITEM: {
    backgroundColor: addOpacity('#FDF0CE', 0.4),
    swipeDeleteBackground: addOpacity('#E8A5A5', 0.4),
    deleteTextColor: '#FFFFFF',
    categoryColor: '#5D5C5A',
    descriptionColor: '#8E8D8C',
    amountIncomeColor: '#95D1B3',
    amountExpenseColor: '#E8A5A5',
    dateColor: '#B4B3B2',
    dividerColor: addOpacity('#FDF0CE', 0.4)
  } as ListItemColors,

  // 月份选择器
  MONTH_PICKER: {
    backgroundColor: addOpacity('#FDF0CE', 0.4),
    textColor: '#5D5C5A',
    buttonBackground: addOpacity('#FDF0CE', 0.4),
    buttonTextColor: '#5D5C5A'
  } as MonthPickerColors,

  // 图表容器
  CHART_CONTAINER: {
    backgroundColor: addOpacity('#FDF0CE', 0.4),
    titleColor: '#5D5C5A',
    emptyTextColor: '#8E8D8C'
  } as ChartContainerColors,

  // 进度条
  PROGRESS_CHART: {
    trackColor: addOpacity('#FDF0CE', 0.4),
    expenseProgressColor: '#E8A5A5',
    incomeProgressColor: '#95D1B3',
    categoryColor: '#5D5C5A',
    percentageColor: '#8E8D8C',
    amountColor: '#5D5C5A'
  } as ProgressChartColors,

  // 详细统计列表
  DETAIL_LIST: {
    sectionTitleColor: '#8E8D8C',
    itemBackground: addOpacity('#FDF0CE', 0.4),
    categoryColor: '#5D5C5A',
    expenseAmountColor: '#E8A5A5',
    incomeAmountColor: '#95D1B3'
  } as DetailListColors,

  // 筛选区域
  FILTER_SECTION: {
    labelColor: '#8E8D8C',
    buttonActiveBackground: addOpacity('#FDF0CE', 0.4),
    buttonActiveTextColor: '#FFFFFF',
    buttonInactiveBackground: addOpacity('#FDF0CE', 0.4),
    buttonInactiveTextColor: '#5D5C5A',
    categoryActiveBackground: addOpacity('#FDF0CE', 0.4),
    categoryActiveTextColor: '#FFFFFF',
    categoryInactiveBackground: addOpacity('#FDF0CE', 0.4),
    categoryInactiveTextColor: '#5D5C5A'
  } as FilterSectionColors,

  // 查询按钮
  QUERY_BUTTON: {
    backgroundColor: addOpacity('#FDF0CE', 0.4),
    textColor: '#FFFFFF'
  } as QueryButtonColors,

  // 结果区域
  RESULT_SECTION: {
    titleColor: '#5D5C5A',
    emptyTextColor: '#8E8D8C',
    itemBackground: addOpacity('#FDF0CE', 0.4),
    dividerColor: addOpacity('#FDF0CE', 0.4)
  } as ResultSectionColors
};

// 暗色主题配色方案
export const DARK_COLOR_SCHEME: LightColorScheme = {
  // 首页导航栏
  NAVBAR: {
    backgroundColor: addOpacity('#2D2D2D', 0.4),
    titleColor: '#E8E6E3',
    buttonBackground: addOpacity('#7B9BC8', 0.4),
    buttonTextColor: '#FFFFFF',
    borderColor: addOpacity('#4A4846', 0.4),
    backButtonColor: '#7B9BC8'
  } as NavbarColors,

  // 统计卡片
  STAT_CARD: {
    backgroundColor: addOpacity('#2D2D2D', 0.4),
    titleColor: '#B8B6B3',
    incomeColor: '#8BC4A6',
    expenseColor: '#D49595',
    balanceColor: '#E8E6E3',
    labelColor: '#B8B6B3',
    borderColor: addOpacity('#3A3A3A', 0.4),
    shadowColor: '#00000020'
  } as StatCardColors,

  // 最近记录列表
  RECENT_LIST: {
    backgroundColor: addOpacity('#1E1E1E', 0.4),
    itemBackground: addOpacity('#2D2D2D', 0.4),
    categoryColor: '#E8E6E3',
    descriptionColor: '#B8B6B3',
    incomeAmountColor: '#8BC4A6',
    expenseAmountColor: '#D49595',
    dateColor: '#8A8886',
    dividerColor: addOpacity('#3A3836', 0.4)
  } as RecentListColors,

  // 标签页导航
  TAB_BAR: {
    backgroundColor: addOpacity('#2D2D2D', 0.4),
    activeTextColor: '#7B9BC8',
    inactiveTextColor: '#B8B6B3',
    indicatorColor: '#7B9BC8'
  } as TabBarColors,

  // 添加记录弹窗 - 弹窗容器
  DIALOG: {
    backgroundColor: '#2D2D2D',
    titleColor: '#E8E6E3',
    closeButtonColor: '#E8E6E3',
    borderColor: '#4A4846'
  } as DialogColors,

  // 类型选择器
  TYPE_SELECTOR: {
    activeBackground: addOpacity('#7B9BC8', 0.4),
    activeTextColor: '#E8E6E3',
    inactiveBackground: addOpacity('#3A3A3A', 0.4),
    inactiveTextColor: '#E8E6E3',
    expenseActiveBackground: addOpacity('#7B9BC8', 0.4),
    incomeActiveBackground: addOpacity('#7B9BC8', 0.4)
  } as TypeSelectorColors,

  // 分类选择网格
  CATEGORY_GRID: {
    itemBackground: addOpacity('#3A3A3A', 0.4),
    activeBackground: '#7B9BC820',
    activeBorderColor: '#7B9BC8',
    iconColor: '#E8E6E3',
    textColor: '#E8E6E3',
    activeIconColor: '#7B9BC8',
    activeTextColor: '#7B9BC8'
  } as CategoryGridColors,

  // 输入区域
  INPUT_SECTION: {
    labelColor: '#B8B6B3',
    inputBackground: addOpacity('#3A3A3A', 0.4),
    inputBorderColor: addOpacity('#4A4846', 0.4),
    inputTextColor: '#E8E6E3',
    placeholderColor: '#8A8886',
    errorColor: '#D49595'
  } as InputSectionColors,

  // 按钮区域
  BUTTON_SECTION: {
    cancelBackground: addOpacity('#3A3A3A', 0.4),
    cancelTextColor: '#E8E6E3',
    saveBackground: addOpacity('#7B9BC8', 0.4),
    saveTextColor: '#E8E6E3'
  } as ButtonSectionColors,

  // 列表容器
  LIST_CONTAINER: {
    backgroundColor: addOpacity('#1E1E1E', 0.4),
    emptyTextColor: '#B8B6B3'
  } as ListContainerColors,

  // 列表项
  LIST_ITEM: {
    backgroundColor: addOpacity('#2D2D2D', 0.4),
    swipeDeleteBackground: addOpacity('#D49595', 0.4),
    deleteTextColor: '#FFFFFF',
    categoryColor: '#E8E6E3',
    descriptionColor: '#B8B6B3',
    amountIncomeColor: '#8BC4A6',
    amountExpenseColor: '#D49595',
    dateColor: '#8A8886',
    dividerColor: addOpacity('#3A3836', 0.4)
  } as ListItemColors,

  // 月份选择器
  MONTH_PICKER: {
    backgroundColor: addOpacity('#2D2D2D', 0.4),
    textColor: '#E8E6E3',
    buttonBackground: addOpacity('#3A3A3A', 0.4),
    buttonTextColor: '#E8E6E3'
  } as MonthPickerColors,

  // 图表容器
  CHART_CONTAINER: {
    backgroundColor: addOpacity('#2D2D2D', 0.4),
    titleColor: '#E8E6E3',
    emptyTextColor: '#B8B6B3'
  } as ChartContainerColors,

  // 进度条
  PROGRESS_CHART: {
    trackColor: addOpacity('#3A3A3A', 0.4),
    expenseProgressColor: '#D49595',
    incomeProgressColor: '#8BC4A6',
    categoryColor: '#E8E6E3',
    percentageColor: '#B8B6B3',
    amountColor: '#E8E6E3'
  } as ProgressChartColors,

  // 详细统计列表
  DETAIL_LIST: {
    sectionTitleColor: '#B8B6B3',
    itemBackground: addOpacity('#3A3A3A', 0.4),
    categoryColor: '#E8E6E3',
    expenseAmountColor: '#D49595',
    incomeAmountColor: '#8BC4A6'
  } as DetailListColors,

  // 筛选区域
  FILTER_SECTION: {
    labelColor: '#B8B6B3',
    buttonActiveBackground: addOpacity('#7B9BC8', 0.4),
    buttonActiveTextColor: '#FFFFFF',
    buttonInactiveBackground: addOpacity('#3A3A3A', 0.4),
    buttonInactiveTextColor: '#E8E6E3',
    categoryActiveBackground: addOpacity('#C9B895', 0.4),
    categoryActiveTextColor: '#FFFFFF',
    categoryInactiveBackground: addOpacity('#3A3A3A', 0.4),
    categoryInactiveTextColor: '#E8E6E3'
  } as FilterSectionColors,

  // 查询按钮
  QUERY_BUTTON: {
    backgroundColor: addOpacity('#7B9BC8', 0.4),
    textColor: '#FFFFFF'
  } as QueryButtonColors,

  // 结果区域
  RESULT_SECTION: {
    titleColor: '#E8E6E3',
    emptyTextColor: '#B8B6B3',
    itemBackground: addOpacity('#2D2D2D', 0.4),
    dividerColor: addOpacity('#3A3836', 0.4)
  } as ResultSectionColors
};
