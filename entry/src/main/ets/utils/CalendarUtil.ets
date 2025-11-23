// 日历工具类

export class DayInfo {
  year: number = 0;
  month: number = 0;
  day: number = 0;
  dateStr: string = '';
  balance: number = 0;
  income: number = 0;
  expense: number = 0;
  isCurrentMonth: boolean = false;
  isToday: boolean = false;
  dominantMood: string = ''; // 当天占比最大的心情
}

export class MonthInfo {
  year: number = 0;
  month: number = 0;
}

export class CalendarUtil {
  // 获取某月的第一天是星期几（0-6，0表示周日）
  static getFirstDayOfMonth(year: number, month: number): number {
    const date = new Date(year, month - 1, 1);
    return date.getDay();
  }

  // 获取某月有多少天
  static getDaysInMonth(year: number, month: number): number {
    return new Date(year, month, 0).getDate();
  }

  // 获取上个月的年月
  static getPreviousMonth(year: number, month: number): MonthInfo {
    const result = new MonthInfo();
    if (month === 1) {
      result.year = year - 1;
      result.month = 12;
    } else {
      result.year = year;
      result.month = month - 1;
    }
    return result;
  }

  // 获取下个月的年月
  static getNextMonth(year: number, month: number): MonthInfo {
    const result = new MonthInfo();
    if (month === 12) {
      result.year = year + 1;
      result.month = 1;
    } else {
      result.year = year;
      result.month = month + 1;
    }
    return result;
  }

  // 生成日历数据（包含空白填充以对齐星期）
  static generateCalendarDays(year: number, month: number): DayInfo[] {
    const days: DayInfo[] = [];
    const firstDay = CalendarUtil.getFirstDayOfMonth(year, month);
    const daysInMonth = CalendarUtil.getDaysInMonth(year, month);
    const today = new Date();
    const todayStr = `${today.getFullYear()}-${String(today.getMonth() + 1).padStart(2, '0')}-${String(today.getDate()).padStart(2, '0')}`;

    // 转换为周一开始的格式
    // JavaScript getDay(): 0=周日, 1=周一, 2=周二, ..., 6=周六
    // 我们需要: 0=周一, 1=周二, ..., 5=周六, 6=周日
    // 转换公式: (firstDay + 6) % 7
    const firstDayMondayBased = (firstDay + 6) % 7;

    // 添加空白填充（上月日期，但不显示）
    for (let i = 0; i < firstDayMondayBased; i++) {
      const dayInfo = new DayInfo();
      dayInfo.year = year;
      dayInfo.month = month;
      dayInfo.day = 0; // 0 表示空白
      dayInfo.dateStr = `${year}-${month}-blank-${i}`; // 给空白单元格唯一标识
      dayInfo.balance = 0;
      dayInfo.income = 0;
      dayInfo.expense = 0;
      dayInfo.isCurrentMonth = false;
      dayInfo.isToday = false;
      days.push(dayInfo);
    }

    // 添加当前月的日期
    for (let day = 1; day <= daysInMonth; day++) {
      const dateStr = `${year}-${String(month).padStart(2, '0')}-${String(day).padStart(2, '0')}`;
      const dayInfo = new DayInfo();
      dayInfo.year = year;
      dayInfo.month = month;
      dayInfo.day = day;
      dayInfo.dateStr = dateStr;
      dayInfo.balance = 0;
      dayInfo.income = 0;
      dayInfo.expense = 0;
      dayInfo.isCurrentMonth = true;
      dayInfo.isToday = dateStr === todayStr;
      days.push(dayInfo);
    }

    return days;
  }

  // 格式化月份显示
  static formatMonth(year: number, month: number): string {
    return `${year}年${month}月`;
  }

  // 解析日期字符串
  static parseDate(dateStr: string): MonthInfo {
    const parts = dateStr.split('-');
    const result = new MonthInfo();
    result.year = parseInt(parts[0]);
    result.month = parseInt(parts[1]);
    return result;
  }
}
