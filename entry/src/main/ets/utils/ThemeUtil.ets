import { StorageUtil } from './StorageUtil';

export type ThemeType = 'light' | 'dark';

export interface ThemeColors {
  primary: string;
  primaryLight: string;
  secondary: string;
  secondaryLight: string;
  income: string;
  incomeLight: string;
  expense: string;
  expenseLight: string;
  background: string;
  cardBg: string;
  surface: string;
  inputBg: string;
  queryBg: string;
  recordBg: string;
  textPrimary: string;
  textSecondary: string;
  textTertiary: string;
  textInverse: string;
  border: string;
  divider: string;
  success: string;
  warning: string;
  error: string;
  info: string;
  accent: string;
  neutral: string;
}

export class ThemeUtil {
  private static readonly THEME_KEY = 'appTheme';
  private static currentTheme: ThemeType = 'light';

  static readonly LIGHT_THEME: ThemeColors = {
    primary: '#8FAADC',
    primaryLight: '#E8EDF7',
    secondary: '#A8D5BA',
    secondaryLight: '#F0F7F2',
    income: '#95D1B3',
    incomeLight: '#F0F7F2',
    expense: '#E8A5A5',
    expenseLight: '#FDF0F0',
    background: '#FAF9F7',
    cardBg: '#FFFFFF',
    surface: '#F5F3F1',
    inputBg: '#F5F3F1',
    queryBg: '#F5F3F1',
    recordBg: '#FFFFFF',
    textPrimary: '#5D5C5A',
    textSecondary: '#8E8D8C',
    textTertiary: '#B4B3B2',
    textInverse: '#FFFFFF',
    border: '#E4E2E0',
    divider: '#EDECEA',
    success: '#95D1B3',
    warning: '#E8C9A5',
    error: '#E8A5A5',
    info: '#8FAADC',
    accent: '#C9B6D6',
    neutral: '#B8B5B2'
  };

  static readonly DARK_THEME: ThemeColors = {
    primary: '#7B9BC8',
    primaryLight: '#2A3A5A',
    secondary: '#8BC4A6',
    secondaryLight: '#2A4A3A',
    income: '#8BC4A6',
    incomeLight: '#1E3A2A',
    expense: '#D49595',
    expenseLight: '#3A1E1E',
    background: '#1A1A1A',
    cardBg: '#2D2D2D',
    surface: '#3A3A3A',
    inputBg: '#3A3A3A',
    queryBg: '#252525',
    recordBg: '#3A3A3A',
    textPrimary: '#E8E6E3',
    textSecondary: '#8A8886',
    textTertiary: '#6B6A68',
    textInverse: '#1E1E1E',
    border: '#4A4846',
    divider: '#3A3836',
    success: '#8BC4A6',
    warning: '#D4B895',
    error: '#D49595',
    info: '#7B9BC8',
    accent: '#B8A6C8',
    neutral: '#9E9B98'
  };

  static async initTheme(): Promise<void> {
    try {
      const savedTheme = await StorageUtil.get(ThemeUtil.THEME_KEY);
      if (savedTheme) {
        ThemeUtil.currentTheme = savedTheme as ThemeType;
      }
    } catch (e) {
      console.error('Failed to init theme:', e);
    }
  }

  static async setTheme(theme: ThemeType): Promise<void> {
    try {
      ThemeUtil.currentTheme = theme;
      await StorageUtil.set(ThemeUtil.THEME_KEY, theme);
    } catch (e) {
      console.error('Failed to set theme:', e);
    }
  }

  static getTheme(): ThemeType {
    return ThemeUtil.currentTheme;
  }

  static getColors(): ThemeColors {
    return ThemeUtil.currentTheme === 'light' ? ThemeUtil.LIGHT_THEME : ThemeUtil.DARK_THEME;
  }

  static toggleTheme(): ThemeType {
    const newTheme = ThemeUtil.currentTheme === 'light' ? 'dark' : 'light';
    ThemeUtil.setTheme(newTheme);
    return newTheme;
  }

  /**
   * 获取当前主题的背景图片资源
   */
  static getBackgroundImage(theme?: ThemeType): Resource {
    const currentTheme = theme || ThemeUtil.currentTheme;
    console.log(`获取背景图片 - 主题: ${currentTheme}`);
    const bgImage = currentTheme === 'light' ? $r('app.media.qita') : $r('app.media.dark');
    console.log(`返回背景: ${currentTheme === 'light' ? 'qita.jpg' : 'dark.jpg'}`);
    return bgImage;
  }
}
