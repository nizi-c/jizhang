// 预算数据模型

export class Budget {
  id: string = '';
  bookId: string = '';
  category: string = '';
  amount: number = 0;
  period: 'week' | 'month' | 'year' = 'month';
  warningThreshold: number = 90;
  createTime: string = '';
}

export class BudgetProgress {
  budgetId: string = '';
  category: string = '';
  budgetAmount: number = 0;
  usedAmount: number = 0;
  remainingAmount: number = 0;
  percentage: number = 0;
  status: 'normal' | 'warning' | 'exceeded' = 'normal';
  recordCount: number = 0;
}
