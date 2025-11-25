// 响应式工具类 - 用于检测设备类型和屏幕尺寸

import { display } from '@kit.ArkUI';

export enum DeviceType {
  PHONE = 'phone',      // 手机：< 600vp
  TABLET = 'tablet',    // 平板：600vp - 840vp
  LARGE = 'large'       // 大屏：> 840vp
}

export class ResponsiveUtil {
  // 获取设备类型
  static getDeviceType(): DeviceType {
    try {
      const screenWidth = px2vp(display.getDefaultDisplaySync().width);
      
      if (screenWidth < 600) {
        return DeviceType.PHONE;
      } else if (screenWidth < 840) {
        return DeviceType.TABLET;
      } else {
        return DeviceType.LARGE;
      }
    } catch (error) {
      console.error('获取设备类型失败:', error);
      return DeviceType.PHONE;
    }
  }

  // 获取屏幕宽度（vp）
  static getScreenWidth(): number {
    try {
      return px2vp(display.getDefaultDisplaySync().width);
    } catch (error) {
      console.error('获取屏幕宽度失败:', error);
      return 360;
    }
  }

  // 获取屏幕高度（vp）
  static getScreenHeight(): number {
    try {
      return px2vp(display.getDefaultDisplaySync().height);
    } catch (error) {
      console.error('获取屏幕高度失败:', error);
      return 800;
    }
  }

  // 获取屏幕方向
  static isLandscape(): boolean {
    try {
      const width = px2vp(display.getDefaultDisplaySync().width);
      const height = px2vp(display.getDefaultDisplaySync().height);
      return width > height;
    } catch (error) {
      console.error('获取屏幕方向失败:', error);
      return false;
    }
  }

  // 获取响应式内边距
  static getPadding(): number {
    const deviceType = ResponsiveUtil.getDeviceType();
    if (deviceType === DeviceType.PHONE) {
      return 16;
    } else if (deviceType === DeviceType.TABLET) {
      return 24;
    } else {
      return 32;
    }
  }

  // 获取响应式字体大小
  static getFontSize(baseSize: number): number {
    const deviceType = ResponsiveUtil.getDeviceType();
    if (deviceType === DeviceType.PHONE) {
      return baseSize;
    } else if (deviceType === DeviceType.TABLET) {
      return baseSize * 1.1;
    } else {
      return baseSize * 1.2;
    }
  }

  // 获取响应式卡片宽度
  static getCardWidth(): string {
    const deviceType = ResponsiveUtil.getDeviceType();
    if (deviceType === DeviceType.PHONE) {
      return '100%';
    } else if (deviceType === DeviceType.TABLET) {
      return '90%';
    } else {
      return '80%';
    }
  }

  // 获取响应式列数（用于网格布局）
  static getGridColumns(): number {
    const deviceType = ResponsiveUtil.getDeviceType();
    if (deviceType === DeviceType.PHONE) {
      return 4;
    } else if (deviceType === DeviceType.TABLET) {
      return 5;
    } else {
      return 6;
    }
  }

  // 获取响应式最大宽度
  static getMaxWidth(): number {
    const deviceType = ResponsiveUtil.getDeviceType();
    if (deviceType === DeviceType.PHONE) {
      return 600;
    } else if (deviceType === DeviceType.TABLET) {
      return 840;
    } else {
      return 1200;
    }
  }

  // 判断是否为手机
  static isPhone(): boolean {
    return ResponsiveUtil.getDeviceType() === DeviceType.PHONE;
  }

  // 判断是否为平板
  static isTablet(): boolean {
    return ResponsiveUtil.getDeviceType() === DeviceType.TABLET;
  }

  // 判断是否为大屏
  static isLarge(): boolean {
    return ResponsiveUtil.getDeviceType() === DeviceType.LARGE;
  }

  // 获取响应式间距
  static getSpacing(size: string): number {
    const deviceType = ResponsiveUtil.getDeviceType();
    let base: number = 12;
    
    if (size === 'small') {
      base = 8;
    } else if (size === 'medium') {
      base = 12;
    } else if (size === 'large') {
      base = 16;
    }
    
    if (deviceType === DeviceType.PHONE) {
      return base;
    } else if (deviceType === DeviceType.TABLET) {
      return base * 1.1;
    } else {
      return base * 1.2;
    }
  }

  // 获取响应式圆角
  static getBorderRadius(size: string): number {
    const deviceType = ResponsiveUtil.getDeviceType();
    let base: number = 8;
    
    if (size === 'small') {
      base = 4;
    } else if (size === 'medium') {
      base = 8;
    } else if (size === 'large') {
      base = 12;
    }
    
    if (deviceType === DeviceType.PHONE) {
      return base;
    } else if (deviceType === DeviceType.TABLET) {
      return base * 1.1;
    } else {
      return base * 1.2;
    }
  }
}
