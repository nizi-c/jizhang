// 预算管理工具类
import preferences from '@ohos.data.preferences';
import { Budget } from '../models/Budget';
import { AccountBookUtil } from './AccountBookUtil';
import common from '@ohos.app.ability.common';

export class BudgetUtil {
  private static context: common.UIAbilityContext;
  private static preferences: preferences.Preferences | null = null;
  private static readonly BUDGETS_KEY = 'budgets';

  static async init(context: common.UIAbilityContext) {
    BudgetUtil.context = context;
    try {
      BudgetUtil.preferences = await preferences.getPreferences(context, 'budget_store');
    } catch (error) {
      console.error('初始化预算管理失败:', error);
    }
  }

  // 生成唯一ID
  private static generateId(): string {
    return `budget_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;
  }

  // 获取当前账本的存储key
  private static getCurrentBookKey(): string {
    const bookId = AccountBookUtil.getCurrentBookId();
    return bookId ? `${BudgetUtil.BUDGETS_KEY}_${bookId}` : BudgetUtil.BUDGETS_KEY;
  }

  // 获取所有预算
  static async getAllBudgets(): Promise<Budget[]> {
    try {
      if (!BudgetUtil.preferences) return [];
      
      const key = BudgetUtil.getCurrentBookKey();
      const budgetsJson = await BudgetUtil.preferences.get(key, '[]') as string;
      return JSON.parse(budgetsJson) as Budget[];
    } catch (error) {
      console.error('获取预算列表失败:', error);
      return [];
    }
  }

  // 保存预算
  static async saveBudget(budget: Budget): Promise<void> {
    try {
      if (!BudgetUtil.preferences) return;
      
      const budgets = await BudgetUtil.getAllBudgets();
      const index = budgets.findIndex(b => b.id === budget.id);
      
      if (index >= 0) {
        budgets[index] = budget;
      } else {
        budget.id = BudgetUtil.generateId();
        budget.bookId = AccountBookUtil.getCurrentBookId();
        budget.createTime = new Date().toISOString();
        budgets.push(budget);
      }
      
      const key = BudgetUtil.getCurrentBookKey();
      await BudgetUtil.preferences.put(key, JSON.stringify(budgets));
      await BudgetUtil.preferences.flush();
    } catch (error) {
      console.error('保存预算失败:', error);
    }
  }

  // 删除预算
  static async deleteBudget(budgetId: string): Promise<void> {
    try {
      if (!BudgetUtil.preferences) return;
      
      const budgets = await BudgetUtil.getAllBudgets();
      const newBudgets = budgets.filter(b => b.id !== budgetId);
      
      const key = BudgetUtil.getCurrentBookKey();
      await BudgetUtil.preferences.put(key, JSON.stringify(newBudgets));
      await BudgetUtil.preferences.flush();
    } catch (error) {
      console.error('删除预算失败:', error);
    }
  }

  // 获取分类预算
  static async getBudgetByCategory(category: string): Promise<Budget | null> {
    const budgets = await BudgetUtil.getAllBudgets();
    return budgets.find(b => b.category === category) || null;
  }
}
