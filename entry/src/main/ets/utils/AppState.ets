import { ThemeUtil, ThemeType, ThemeColors } from './ThemeUtil';

export class AppState {
  static currentTheme: ThemeType = 'light';
  static colors: ThemeColors = ThemeUtil.LIGHT_THEME;

  static async init(): Promise<void> {
    await ThemeUtil.initTheme();
    AppState.currentTheme = ThemeUtil.getTheme();
    AppState.colors = ThemeUtil.getColors();
  }

  static async setTheme(theme: ThemeType): Promise<void> {
    await ThemeUtil.setTheme(theme);
    AppState.currentTheme = theme;
    AppState.colors = ThemeUtil.getColors();
  }

  static toggleTheme(): ThemeType {
    const newTheme = ThemeUtil.toggleTheme();
    AppState.currentTheme = newTheme;
    AppState.colors = ThemeUtil.getColors();
    return newTheme;
  }
}
