// 响应式常量配置

import { ResponsiveUtil, DeviceType } from '../utils/ResponsiveUtil';

export class ResponsiveConstants {
  // 根据设备类型获取内边距
  static getPadding(size: string): number {
    let baseValue: number = 16;
    
    if (size === 'small') {
      baseValue = 8;
    } else if (size === 'medium') {
      baseValue = 16;
    } else if (size === 'large') {
      baseValue = 24;
    } else if (size === 'extra_large') {
      baseValue = 32;
    }
    
    const deviceType = ResponsiveUtil.getDeviceType();
    
    if (deviceType === DeviceType.PHONE) {
      return baseValue;
    } else if (deviceType === DeviceType.TABLET) {
      return baseValue * 1.2;
    } else {
      return baseValue * 1.5;
    }
  }

  // 根据设备类型获取字体大小
  static getFontSize(size: string): number {
    let baseValue: number = 14;
    
    if (size === 'title') {
      baseValue = 24;
    } else if (size === 'subtitle') {
      baseValue = 18;
    } else if (size === 'body') {
      baseValue = 14;
    } else if (size === 'caption') {
      baseValue = 12;
    } else if (size === 'small') {
      baseValue = 10;
    }
    
    const deviceType = ResponsiveUtil.getDeviceType();
    
    if (deviceType === DeviceType.PHONE) {
      return baseValue;
    } else if (deviceType === DeviceType.TABLET) {
      return baseValue * 1.1;
    } else {
      return baseValue * 1.2;
    }
  }

  // 根据设备类型获取圆角
  static getBorderRadius(size: string): number {
    let baseValue: number = 8;
    
    if (size === 'small') {
      baseValue = 4;
    } else if (size === 'medium') {
      baseValue = 8;
    } else if (size === 'large') {
      baseValue = 12;
    } else if (size === 'extra_large') {
      baseValue = 16;
    }
    
    const deviceType = ResponsiveUtil.getDeviceType();
    
    if (deviceType === DeviceType.PHONE) {
      return baseValue;
    } else if (deviceType === DeviceType.TABLET) {
      return baseValue * 1.1;
    } else {
      return baseValue * 1.2;
    }
  }

  // 获取响应式间距
  static getSpacing(size: string): number {
    let baseValue: number = 12;
    
    if (size === 'extra_small') {
      baseValue = 4;
    } else if (size === 'small') {
      baseValue = 8;
    } else if (size === 'medium') {
      baseValue = 12;
    } else if (size === 'large') {
      baseValue = 16;
    } else if (size === 'extra_large') {
      baseValue = 24;
    }
    
    const deviceType = ResponsiveUtil.getDeviceType();
    
    if (deviceType === DeviceType.PHONE) {
      return baseValue;
    } else if (deviceType === DeviceType.TABLET) {
      return baseValue * 1.1;
    } else {
      return baseValue * 1.2;
    }
  }

  // 获取响应式按钮高度
  static getButtonHeight(size: string): number {
    let baseHeight: number = 44;
    
    if (size === 'small') {
      baseHeight = 36;
    } else if (size === 'medium') {
      baseHeight = 44;
    } else if (size === 'large') {
      baseHeight = 52;
    }
    
    const deviceType = ResponsiveUtil.getDeviceType();
    
    if (deviceType === DeviceType.PHONE) {
      return baseHeight;
    } else if (deviceType === DeviceType.TABLET) {
      return baseHeight * 1.1;
    } else {
      return baseHeight * 1.2;
    }
  }

  // 获取响应式输入框高度
  static getInputHeight(size: string): number {
    let baseHeight: number = 44;
    
    if (size === 'small') {
      baseHeight = 36;
    } else if (size === 'medium') {
      baseHeight = 44;
    } else if (size === 'large') {
      baseHeight = 52;
    }
    
    const deviceType = ResponsiveUtil.getDeviceType();
    
    if (deviceType === DeviceType.PHONE) {
      return baseHeight;
    } else if (deviceType === DeviceType.TABLET) {
      return baseHeight * 1.1;
    } else {
      return baseHeight * 1.2;
    }
  }

  // 获取响应式列表项高度
  static getListItemHeight(): number {
    const deviceType = ResponsiveUtil.getDeviceType();
    
    if (deviceType === DeviceType.PHONE) {
      return 60;
    } else if (deviceType === DeviceType.TABLET) {
      return 70;
    } else {
      return 80;
    }
  }

  // 获取响应式卡片宽度百分比
  static getCardWidthPercent(): number {
    const deviceType = ResponsiveUtil.getDeviceType();
    
    if (deviceType === DeviceType.PHONE) {
      return 100;
    } else if (deviceType === DeviceType.TABLET) {
      return 90;
    } else {
      return 80;
    }
  }

  // 阴影配置 - 使用静态方法返回
  static getShadow(size: string): ShadowOptions {
    if (size === 'small') {
      return { radius: 4, color: '#00000010' };
    } else if (size === 'large') {
      return { radius: 12, color: '#0000001A' };
    } else {
      return { radius: 8, color: '#00000015' };
    }
  }
}

// 阴影选项接口
interface ShadowOptions {
  radius: number;
  color: string;
}
