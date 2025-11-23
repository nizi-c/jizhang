import { ThemeUtil, ThemeColors } from '../utils/ThemeUtil';

// 常量定义
export interface Category {
  name: string;
  icon: string;
  color: string;
}

export interface ColorScheme {
  primary: string;
  success: string;
  warning: string;
  danger: string;
  info: string;
  background: string;
  text: string;
  textLight: string;
  textSecondary: string;
  textTertiary: string;
  border: string;
  cardBg: string;
  surface: string;
  inputBg: string;
  queryBg: string;
  recordBg: string;
}

export const EXPENSE_CATEGORIES: Category[] = [
  { name: '食物', icon: '🍔', color: '#E8A5A5' },
  { name: '交通', icon: '🚗', color: '#8FAADC' },
  { name: '娱乐', icon: '🎮', color: '#E8C9A5' },
  { name: '购物', icon: '🛍️', color: '#C9B6D6' },
  { name: '医疗', icon: '⚕️', color: '#95D1B3' },
  { name: '教育', icon: '📚', color: '#A5C8E8' },
  { name: '住房', icon: '🏠', color: '#B8B5B2' },
  { name: '其他', icon: '📌', color: '#D6C9B6' }
];

export const INCOME_CATEGORIES: Category[] = [
  { name: '工资', icon: '💼', color: '#95D1B3' },
  { name: '奖金', icon: '🎁', color: '#E8C9A5' },
  { name: '投资', icon: '📈', color: '#8FAADC' },
  { name: '兼职', icon: '💻', color: '#C9B6D6' },
  { name: '其他', icon: '📌', color: '#A5C8E8' }
];

// 动态颜色对象 - 支持主题切换
export class DynamicColorsProxy implements ColorScheme {
  get primary(): string {
    return ThemeUtil.getColors().primary;
  }

  get success(): string {
    return ThemeUtil.getColors().success;
  }

  get warning(): string {
    return ThemeUtil.getColors().warning;
  }

  get danger(): string {
    return ThemeUtil.getColors().error;
  }

  get info(): string {
    return ThemeUtil.getColors().info;
  }

  get background(): string {
    return ThemeUtil.getColors().background;
  }

  get text(): string {
    return ThemeUtil.getColors().textPrimary;
  }

  get textLight(): string {
    return ThemeUtil.getColors().textSecondary;
  }

  get textSecondary(): string {
    return ThemeUtil.getColors().textSecondary;
  }

  get textTertiary(): string {
    return ThemeUtil.getColors().textTertiary;
  }

  get border(): string {
    return ThemeUtil.getColors().border;
  }

  get cardBg(): string {
    return ThemeUtil.getColors().cardBg;
  }

  get surface(): string {
    return ThemeUtil.getColors().surface;
  }

  get inputBg(): string {
    return ThemeUtil.getColors().inputBg;
  }

  get queryBg(): string {
    return ThemeUtil.getColors().queryBg;
  }

  get recordBg(): string {
    return ThemeUtil.getColors().recordBg;
  }
}

// 导出单例实例
export const COLORS = new DynamicColorsProxy();

// 导出完整的 DynamicColors 类
export { DynamicColors } from './ThemeColors';
