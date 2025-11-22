export class DateUtil {
  // 获取今天日期字符串 (YYYY-MM-DD)
  static getTodayStr(): string {
    const now = new Date();
    return DateUtil.formatDate(now);
  }

  // 获取本月字符串 (YYYY-MM)
  static getThisMonthStr(): string {
    const now = new Date();
    const year = now.getFullYear();
    const month = String(now.getMonth() + 1).padStart(2, '0');
    return `${year}-${month}`;
  }

  // 格式化日期为字符串 - 支持Date对象和时间戳
  static formatDate(date: Date | number): string {
    let dateObj: Date;

    if (typeof date === 'number') {
      dateObj = new Date(date);
    } else {
      dateObj = date;
    }

    const year = dateObj.getFullYear();
    const month = String(dateObj.getMonth() + 1).padStart(2, '0');
    const day = String(dateObj.getDate()).padStart(2, '0');
    return `${year}-${month}-${day}`;
  }

  // 获取时间戳
  static getTimestamp(): number {
    return new Date().getTime();
  }

  // 新增：解析日期字符串为时间戳
  static parseDate(dateStr: string): number {
    // 支持 YYYY-MM-DD 格式
    const parts = dateStr.split('-');
    if (parts.length === 3) {
      const year = parseInt(parts[0]);
      const month = parseInt(parts[1]) - 1; // 月份从0开始
      const day = parseInt(parts[2]);
      return new Date(year, month, day).getTime();
    }
    return new Date().getTime(); // 如果格式错误，返回当前时间
  }

  // 新增：检查时间戳是否是今天
  static isToday(timestamp: number): boolean {
    const today = new Date();
    const date = new Date(timestamp);
    return today.getFullYear() === date.getFullYear() &&
      today.getMonth() === date.getMonth() &&
      today.getDate() === date.getDate();
  }

  // 新增：检查时间戳是否在本月
  static isThisMonth(timestamp: number): boolean {
    const today = new Date();
    const date = new Date(timestamp);
    return today.getFullYear() === date.getFullYear() &&
      today.getMonth() === date.getMonth();
  }

  // 新增：验证日期字符串格式 (YYYY-MM-DD)
  static isValidDate(dateStr: string): boolean {
    const regex = /^\d{4}-\d{2}-\d{2}$/;
    if (!regex.test(dateStr)) return false;

    const parts = dateStr.split('-');
    const year = parseInt(parts[0]);
    const month = parseInt(parts[1]);
    const day = parseInt(parts[2]);

    if (month < 1 || month > 12) return false;
    if (day < 1 || day > 31) return false;

    // 简单的月份天数验证
    const daysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    // 闰年检查
    if (month === 2) {
      const isLeapYear = (year % 4 === 0 && year % 100 !== 0) || (year % 400 === 0);
      if (isLeapYear) {
        return day <= 29;
      } else {
        return day <= 28;
      }
    }

    return day <= daysInMonth[month - 1];
  }
}