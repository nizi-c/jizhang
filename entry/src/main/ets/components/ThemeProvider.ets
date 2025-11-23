import { ThemeUtil, ThemeColors, ThemeType } from '../utils/ThemeUtil';

// 主题变化监听器接口
interface ThemeChangeListener {
  onThemeChanged(theme: ThemeType, colors: ThemeColors): void;
}

// 主题提供者组件 - 统一管理所有颜色和主题切换
@Component
export struct ThemeProvider {
  @State colors: ThemeColors = ThemeUtil.LIGHT_THEME;
  @State currentTheme: ThemeType = 'light';
  @BuilderParam content: () => void;
  private listeners: ThemeChangeListener[] = [];

  aboutToAppear() {
    this.initTheme();
    // 注册为全局主题提供者
    DynamicColors.setProvider(this);
  }

  private initTheme() {
    this.currentTheme = ThemeUtil.getTheme();
    this.colors = ThemeUtil.getColors();
  }

  onPageShow() {
    this.initTheme();
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

  // 添加主题变化监听器
  addListener(listener: ThemeChangeListener) {
    if (!this.listeners.includes(listener)) {
      this.listeners.push(listener);
    }
  }

  // 移除主题变化监听器
  removeListener(listener: ThemeChangeListener) {
    const index = this.listeners.indexOf(listener);
    if (index > -1) {
      this.listeners.splice(index, 1);
    }
  }

  // 通知所有监听器
  private notifyListeners() {
    this.listeners.forEach(listener => {
      listener.onThemeChanged(this.currentTheme, this.colors);
    });
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

// 动态颜色管理器 - 提供响应式的颜色获取
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

  static getSecondaryColor(): string {
    return ThemeUtil.getColors().secondary;
  }

  static getBackgroundColor(): string {
    return ThemeUtil.getColors().background;
  }

  static getCardBgColor(): string {
    return ThemeUtil.getColors().cardBg;
  }

  static getSurfaceColor(): string {
    return ThemeUtil.getColors().surface;
  }

  // 文本颜色
  static getTextColor(): string {
    return ThemeUtil.getColors().textPrimary;
  }

  static getTextSecondaryColor(): string {
    return ThemeUtil.getColors().textSecondary;
  }

  static getTextTertiaryColor(): string {
    return ThemeUtil.getColors().textTertiary;
  }

  static getTextInverseColor(): string {
    return ThemeUtil.getColors().textInverse;
  }

  // 边框和分割线
  static getBorderColor(): string {
    return ThemeUtil.getColors().border;
  }

  static getDividerColor(): string {
    return ThemeUtil.getColors().divider;
  }

  // 状态颜色
  static getIncomeColor(): string {
    return ThemeUtil.getColors().income;
  }

  static getIncomeLightColor(): string {
    return ThemeUtil.getColors().incomeLight;
  }

  static getExpenseColor(): string {
    return ThemeUtil.getColors().expense;
  }

  static getExpenseLightColor(): string {
    return ThemeUtil.getColors().expenseLight;
  }

  static getSuccessColor(): string {
    return ThemeUtil.getColors().success;
  }

  static getWarningColor(): string {
    return ThemeUtil.getColors().warning;
  }

  static getErrorColor(): string {
    return ThemeUtil.getColors().error;
  }

  static getInfoColor(): string {
    return ThemeUtil.getColors().info;
  }

  // 辅助颜色
  static getAccentColor(): string {
    return ThemeUtil.getColors().accent;
  }

  static getNeutralColor(): string {
    return ThemeUtil.getColors().neutral;
  }

  // 浅色变体
  static getPrimaryLightColor(): string {
    return ThemeUtil.getColors().primaryLight;
  }

  static getSecondaryLightColor(): string {
    return ThemeUtil.getColors().secondaryLight;
  }

  // 获取当前主题
  static getCurrentTheme(): ThemeType {
    return ThemeUtil.getTheme();
  }

  // 判断是否为深色主题
  static isDarkTheme(): boolean {
    return ThemeUtil.getTheme() === 'dark';
  }

  // 判断是否为浅色主题
  static isLightTheme(): boolean {
    return ThemeUtil.getTheme() === 'light';
  }
}

// 全局颜色管理器 - 用于在任何地方获取当前主题颜色（向后兼容）
export class GlobalTheme {
  static getColors(): ThemeColors {
    return DynamicColors.getColors();
  }

  static getPrimaryColor(): string {
    return DynamicColors.getPrimaryColor();
  }

  static getBackgroundColor(): string {
    return DynamicColors.getBackgroundColor();
  }

  static getTextColor(): string {
    return DynamicColors.getTextColor();
  }

  static getTextSecondaryColor(): string {
    return DynamicColors.getTextSecondaryColor();
  }

  static getBorderColor(): string {
    return DynamicColors.getBorderColor();
  }

  static getCardBgColor(): string {
    return DynamicColors.getCardBgColor();
  }

  static getSurfaceColor(): string {
    return DynamicColors.getSurfaceColor();
  }

  static getIncomeColor(): string {
    return DynamicColors.getIncomeColor();
  }

  static getExpenseColor(): string {
    return DynamicColors.getExpenseColor();
  }
}
