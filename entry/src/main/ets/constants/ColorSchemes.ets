// 浅色主题配色方案接口定义

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
    backgroundColor: '#FFFFFF',
    titleColor: '#5D5C5A',
    buttonBackground: '#8FAADC',
    buttonTextColor: '#FFFFFF',
    borderColor: '#E4E2E0',
    backButtonColor: '#5D5C5A'
  } as NavbarColors,

  // 统计卡片
  STAT_CARD: {
    backgroundColor: '#FFFFFF',
    titleColor: '#8E8D8C',
    incomeColor: '#95D1B3',
    expenseColor: '#E8A5A5',
    balanceColor: '#5D5C5A',
    labelColor: '#8E8D8C',
    borderColor: '#F5F3F1',
    shadowColor: '#00000008'
  } as StatCardColors,

  // 最近记录列表
  RECENT_LIST: {
    backgroundColor: '#FFFFFF',
    itemBackground: '#FFFFFF',
    categoryColor: '#5D5C5A',
    descriptionColor: '#8E8D8C',
    incomeAmountColor: '#95D1B3',
    expenseAmountColor: '#E8A5A5',
    dateColor: '#B4B3B2',
    dividerColor: '#EDECEA'
  } as RecentListColors,

  // 标签页导航
  TAB_BAR: {
    backgroundColor: '#FFFFFF',
    activeTextColor: '#8FAADC',
    inactiveTextColor: '#8E8D8C',
    indicatorColor: '#8FAADC'
  } as TabBarColors,

  // 添加记录弹窗 - 弹窗容器
  DIALOG: {
    backgroundColor: '#FFFFFF',
    titleColor: '#5D5C5A',
    closeButtonColor: '#5D5C5A',
    borderColor: '#E4E2E0'
  } as DialogColors,

  // 类型选择器
  TYPE_SELECTOR: {
    activeBackground: '#8FAADC',
    activeTextColor: '#FFFFFF',
    inactiveBackground: '#F5F3F1',
    inactiveTextColor: '#8E8D8C',
    expenseActiveBackground: '#E8A5A5',
    incomeActiveBackground: '#95D1B3'
  } as TypeSelectorColors,

  // 分类选择网格
  CATEGORY_GRID: {
    itemBackground: '#F5F3F1',
    activeBackground: '#8FAADC20',
    activeBorderColor: '#8FAADC',
    iconColor: '#5D5C5A',
    textColor: '#5D5C5A',
    activeIconColor: '#8FAADC',
    activeTextColor: '#8FAADC'
  } as CategoryGridColors,

  // 输入区域
  INPUT_SECTION: {
    labelColor: '#8E8D8C',
    inputBackground: '#FAF9F7',
    inputBorderColor: '#E4E2E0',
    inputTextColor: '#5D5C5A',
    placeholderColor: '#B4B3B2',
    errorColor: '#E8A5A5'
  } as InputSectionColors,

  // 按钮区域
  BUTTON_SECTION: {
    cancelBackground: '#F5F3F1',
    cancelTextColor: '#5D5C5A',
    saveBackground: '#8FAADC',
    saveTextColor: '#FFFFFF'
  } as ButtonSectionColors,

  // 列表容器
  LIST_CONTAINER: {
    backgroundColor: '#FAF9F7',
    emptyTextColor: '#8E8D8C'
  } as ListContainerColors,

  // 列表项
  LIST_ITEM: {
    backgroundColor: '#FFFFFF',
    swipeDeleteBackground: '#E8A5A5',
    deleteTextColor: '#FFFFFF',
    categoryColor: '#5D5C5A',
    descriptionColor: '#8E8D8C',
    amountIncomeColor: '#95D1B3',
    amountExpenseColor: '#E8A5A5',
    dateColor: '#B4B3B2',
    dividerColor: '#EDECEA'
  } as ListItemColors,

  // 月份选择器
  MONTH_PICKER: {
    backgroundColor: '#FFFFFF',
    textColor: '#5D5C5A',
    buttonBackground: '#F5F3F1',
    buttonTextColor: '#5D5C5A'
  } as MonthPickerColors,

  // 图表容器
  CHART_CONTAINER: {
    backgroundColor: '#FFFFFF',
    titleColor: '#5D5C5A',
    emptyTextColor: '#8E8D8C'
  } as ChartContainerColors,

  // 进度条
  PROGRESS_CHART: {
    trackColor: '#F5F3F1',
    expenseProgressColor: '#E8A5A5',
    incomeProgressColor: '#95D1B3',
    categoryColor: '#5D5C5A',
    percentageColor: '#8E8D8C',
    amountColor: '#5D5C5A'
  } as ProgressChartColors,

  // 详细统计列表
  DETAIL_LIST: {
    sectionTitleColor: '#8E8D8C',
    itemBackground: '#FAF9F7',
    categoryColor: '#5D5C5A',
    expenseAmountColor: '#E8A5A5',
    incomeAmountColor: '#95D1B3'
  } as DetailListColors,

  // 筛选区域
  FILTER_SECTION: {
    labelColor: '#8E8D8C',
    buttonActiveBackground: '#8FAADC',
    buttonActiveTextColor: '#FFFFFF',
    buttonInactiveBackground: '#F5F3F1',
    buttonInactiveTextColor: '#5D5C5A',
    categoryActiveBackground: '#8FAADC',
    categoryActiveTextColor: '#FFFFFF',
    categoryInactiveBackground: '#F5F3F1',
    categoryInactiveTextColor: '#5D5C5A'
  } as FilterSectionColors,

  // 查询按钮
  QUERY_BUTTON: {
    backgroundColor: '#8FAADC',
    textColor: '#FFFFFF'
  } as QueryButtonColors,

  // 结果区域
  RESULT_SECTION: {
    titleColor: '#5D5C5A',
    emptyTextColor: '#8E8D8C',
    itemBackground: '#FFFFFF',
    dividerColor: '#EDECEA'
  } as ResultSectionColors
};

// 暗色主题配色方案
export const DARK_COLOR_SCHEME: LightColorScheme = {
  // 首页导航栏
  NAVBAR: {
    backgroundColor: '#2D2D2D',
    titleColor: '#E8E6E3',
    buttonBackground: '#7B9BC8',
    buttonTextColor: '#FFFFFF',
    borderColor: '#4A4846',
    backButtonColor: '#7B9BC8'
  } as NavbarColors,

  // 统计卡片
  STAT_CARD: {
    backgroundColor: '#2D2D2D',
    titleColor: '#B8B6B3',
    incomeColor: '#8BC4A6',
    expenseColor: '#D49595',
    balanceColor: '#E8E6E3',
    labelColor: '#B8B6B3',
    borderColor: '#3A3A3A',
    shadowColor: '#00000020'
  } as StatCardColors,

  // 最近记录列表
  RECENT_LIST: {
    backgroundColor: '#1E1E1E',
    itemBackground: '#2D2D2D',
    categoryColor: '#E8E6E3',
    descriptionColor: '#B8B6B3',
    incomeAmountColor: '#8BC4A6',
    expenseAmountColor: '#D49595',
    dateColor: '#8A8886',
    dividerColor: '#3A3836'
  } as RecentListColors,

  // 标签页导航
  TAB_BAR: {
    backgroundColor: '#2D2D2D',
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
    activeBackground: '#7B9BC8',
    activeTextColor: '#FFFFFF',
    inactiveBackground: '#3A3A3A',
    inactiveTextColor: '#B8B6B3',
    expenseActiveBackground: '#D49595',
    incomeActiveBackground: '#8BC4A6'
  } as TypeSelectorColors,

  // 分类选择网格
  CATEGORY_GRID: {
    itemBackground: '#3A3A3A',
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
    inputBackground: '#3A3A3A',
    inputBorderColor: '#4A4846',
    inputTextColor: '#E8E6E3',
    placeholderColor: '#8A8886',
    errorColor: '#D49595'
  } as InputSectionColors,

  // 按钮区域
  BUTTON_SECTION: {
    cancelBackground: '#3A3A3A',
    cancelTextColor: '#E8E6E3',
    saveBackground: '#7B9BC8',
    saveTextColor: '#FFFFFF'
  } as ButtonSectionColors,

  // 列表容器
  LIST_CONTAINER: {
    backgroundColor: '#1E1E1E',
    emptyTextColor: '#B8B6B3'
  } as ListContainerColors,

  // 列表项
  LIST_ITEM: {
    backgroundColor: '#2D2D2D',
    swipeDeleteBackground: '#D49595',
    deleteTextColor: '#FFFFFF',
    categoryColor: '#E8E6E3',
    descriptionColor: '#B8B6B3',
    amountIncomeColor: '#8BC4A6',
    amountExpenseColor: '#D49595',
    dateColor: '#8A8886',
    dividerColor: '#3A3836'
  } as ListItemColors,

  // 月份选择器
  MONTH_PICKER: {
    backgroundColor: '#2D2D2D',
    textColor: '#E8E6E3',
    buttonBackground: '#3A3A3A',
    buttonTextColor: '#E8E6E3'
  } as MonthPickerColors,

  // 图表容器
  CHART_CONTAINER: {
    backgroundColor: '#2D2D2D',
    titleColor: '#E8E6E3',
    emptyTextColor: '#B8B6B3'
  } as ChartContainerColors,

  // 进度条
  PROGRESS_CHART: {
    trackColor: '#3A3A3A',
    expenseProgressColor: '#D49595',
    incomeProgressColor: '#8BC4A6',
    categoryColor: '#E8E6E3',
    percentageColor: '#B8B6B3',
    amountColor: '#E8E6E3'
  } as ProgressChartColors,

  // 详细统计列表
  DETAIL_LIST: {
    sectionTitleColor: '#B8B6B3',
    itemBackground: '#3A3A3A',
    categoryColor: '#E8E6E3',
    expenseAmountColor: '#D49595',
    incomeAmountColor: '#8BC4A6'
  } as DetailListColors,

  // 筛选区域
  FILTER_SECTION: {
    labelColor: '#B8B6B3',
    buttonActiveBackground: '#7B9BC8',
    buttonActiveTextColor: '#FFFFFF',
    buttonInactiveBackground: '#3A3A3A',
    buttonInactiveTextColor: '#E8E6E3',
    categoryActiveBackground: '#C9B895',
    categoryActiveTextColor: '#FFFFFF',
    categoryInactiveBackground: '#3A3A3A',
    categoryInactiveTextColor: '#E8E6E3'
  } as FilterSectionColors,

  // 查询按钮
  QUERY_BUTTON: {
    backgroundColor: '#7B9BC8',
    textColor: '#FFFFFF'
  } as QueryButtonColors,

  // 结果区域
  RESULT_SECTION: {
    titleColor: '#E8E6E3',
    emptyTextColor: '#B8B6B3',
    itemBackground: '#2D2D2D',
    dividerColor: '#3A3836'
  } as ResultSectionColors
};
