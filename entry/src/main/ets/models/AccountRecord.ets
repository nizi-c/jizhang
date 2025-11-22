// 账户记录数据模型
export interface AccountRecord {
  id: string;
  type: 'income' | 'expense'; // 收入或支出
  category: string; // 分类
  amount: number; // 金额
  description: string; // 用途描述
  date: number; // 时间戳
  dateStr: string; // 日期字符串 YYYY-MM-DD
}

export interface CategoryItem {
  name: string;
  icon: string;
  color: string;
}

export interface DailySummary {
  date: string;
  income: number;
  expense: number;
}

export interface MonthlySummary {
  month: string;
  income: number;
  expense: number;
  records: AccountRecord[];
}

export interface CategorySummary {
  category: string;
  amount: number;
  percentage: number;
}