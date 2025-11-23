import { ThemeUtil } from '../utils/ThemeUtil';

// 动态颜色对象 - 每次访问都获取当前主题的颜色
export class DynamicColors {
  // 基础颜色
  static get primary(): string {
    return ThemeUtil.getColors().primary;
  }

  static get secondary(): string {
    return ThemeUtil.getColors().secondary;
  }

  static get background(): string {
    return ThemeUtil.getColors().background;
  }

  static get cardBg(): string {
    return ThemeUtil.getColors().cardBg;
  }

  static get surface(): string {
    return ThemeUtil.getColors().surface;
  }

  static get inputBg(): string {
    return ThemeUtil.getColors().inputBg;
  }

  static get queryBg(): string {
    return ThemeUtil.getColors().queryBg;
  }

  static get recordBg(): string {
    return ThemeUtil.getColors().recordBg;
  }

  // 文本颜色
  static get text(): string {
    return ThemeUtil.getColors().textPrimary;
  }

  static get textPrimary(): string {
    return ThemeUtil.getColors().textPrimary;
  }

  static get textLight(): string {
    return ThemeUtil.getColors().textSecondary;
  }

  static get textSecondary(): string {
    return ThemeUtil.getColors().textSecondary;
  }

  static get textTertiary(): string {
    return ThemeUtil.getColors().textTertiary;
  }

  static get textInverse(): string {
    return ThemeUtil.getColors().textInverse;
  }

  // 边框和分割线
  static get border(): string {
    return ThemeUtil.getColors().border;
  }

  static get divider(): string {
    return ThemeUtil.getColors().divider;
  }

  // 状态颜色
  static get income(): string {
    return ThemeUtil.getColors().income;
  }

  static get incomeLight(): string {
    return ThemeUtil.getColors().incomeLight;
  }

  static get expense(): string {
    return ThemeUtil.getColors().expense;
  }

  static get expenseLight(): string {
    return ThemeUtil.getColors().expenseLight;
  }

  static get success(): string {
    return ThemeUtil.getColors().success;
  }

  static get warning(): string {
    return ThemeUtil.getColors().warning;
  }

  static get error(): string {
    return ThemeUtil.getColors().error;
  }

  static get info(): string {
    return ThemeUtil.getColors().info;
  }

  // 辅助颜色
  static get accent(): string {
    return ThemeUtil.getColors().accent;
  }

  static get neutral(): string {
    return ThemeUtil.getColors().neutral;
  }

  // 浅色变体
  static get primaryLight(): string {
    return ThemeUtil.getColors().primaryLight;
  }

  static get secondaryLight(): string {
    return ThemeUtil.getColors().secondaryLight;
  }
}
