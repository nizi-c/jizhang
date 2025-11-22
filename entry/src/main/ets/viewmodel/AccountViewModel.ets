// 账户视图模型
import { AccountRecord, MonthlySummary, CategorySummary } from '../models/AccountRecord';
import { DateUtil } from '../utils/DateUtil';
import { COLORS } from '../constants/Constants';

// 定义本地类型
interface Summary {
  income: number;
  expense: number;
}

// 导出查询过滤器接口，这样其他文件可以导入
export interface QueryFilters {
  type?: 'income' | 'expense';
  category?: string;
  minAmount?: number;
  maxAmount?: number;
  startDate?: string;
  endDate?: string;
}

export class AccountViewModel {
  records: AccountRecord[] = [];

  addRecord(record: AccountRecord): void {
    this.records.unshift(record);
  }

  deleteRecord(id: string): void {
    this.records = this.records.filter(r => r.id !== id);
  }

  updateRecord(id: string, record: AccountRecord): void {
    const index = this.records.findIndex(r => r.id === id);
    if (index !== -1) {
      this.records[index] = record;
    }
  }

  // 获取今日收支
  getTodaySummary(): Summary {
    const today = DateUtil.getTodayStr();
    let income = 0;
    let expense = 0;

    this.records.forEach(record => {
      if (record.dateStr === today) {
        if (record.type === 'income') {
          income += record.amount;
        } else {
          expense += record.amount;
        }
      }
    });

    return { income, expense };
  }

  // 获取本月收支
  getMonthSummary(): Summary {
    const thisMonth = DateUtil.getThisMonthStr();
    let income = 0;
    let expense = 0;

    this.records.forEach(record => {
      if (record.dateStr.startsWith(thisMonth)) {
        if (record.type === 'income') {
          income += record.amount;
        } else {
          expense += record.amount;
        }
      }
    });

    return { income, expense };
  }

  // 按日期分组
  groupByDate(): Map<string, AccountRecord[]> {
    const grouped = new Map<string, AccountRecord[]>();

    this.records.forEach(record => {
      if (!grouped.has(record.dateStr)) {
        grouped.set(record.dateStr, []);
      }
      grouped.get(record.dateStr)!.push(record);
    });

    return grouped;
  }

  // 按月份分组
  groupByMonth(): Map<string, AccountRecord[]> {
    const grouped = new Map<string, AccountRecord[]>();

    this.records.forEach(record => {
      const month = record.dateStr.substring(0, 7);
      if (!grouped.has(month)) {
        grouped.set(month, []);
      }
      grouped.get(month)!.push(record);
    });

    return grouped;
  }

  // 获取月度汇总
  getMonthlySummaries(): MonthlySummary[] {
    const grouped = this.groupByMonth();
    const summaries: MonthlySummary[] = [];

    grouped.forEach((records, month) => {
      let income = 0;
      let expense = 0;

      records.forEach(record => {
        if (record.type === 'income') {
          income += record.amount;
        } else {
          expense += record.amount;
        }
      });

      summaries.push({
        month,
        income,
        expense,
        records
      });
    });

    return summaries.sort((a, b) => b.month.localeCompare(a.month));
  }

  // 获取分类汇总
  getCategorySummary(type: 'income' | 'expense', month?: string): CategorySummary[] {
    let filtered = this.records.filter(r => r.type === type);

    if (month) {
      filtered = filtered.filter(r => r.dateStr.startsWith(month));
    }

    const categoryMap = new Map<string, number>();
    let total = 0;

    filtered.forEach(record => {
      const current = categoryMap.get(record.category) || 0;
      categoryMap.set(record.category, current + record.amount);
      total += record.amount;
    });

    const summaries: CategorySummary[] = [];
    categoryMap.forEach((amount, category) => {
      summaries.push({
        category,
        amount,
        percentage: total > 0 ? (amount / total) * 100 : 0
      });
    });

    return summaries.sort((a, b) => b.amount - a.amount);
  }

  // 按条件查询 - 使用明确的QueryFilters类型
  queryRecords(filters: QueryFilters): AccountRecord[] {
    return this.records.filter(record => {
      if (filters.type && record.type !== filters.type) return false;
      if (filters.category && record.category !== filters.category) return false;
      if (filters.minAmount !== undefined && record.amount < filters.minAmount) return false;
      if (filters.maxAmount !== undefined && record.amount > filters.maxAmount) return false;
      if (filters.startDate && record.dateStr < filters.startDate) return false;
      if (filters.endDate && record.dateStr > filters.endDate) return false;
      return true;
    });
  }
}