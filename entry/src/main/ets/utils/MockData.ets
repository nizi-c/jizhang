// 模拟数据生成工具（用于测试）
import { AccountRecord } from '../models/AccountRecord';
import { DateUtil } from './DateUtil';

export class MockData {
  static generateMockRecords(): AccountRecord[] {
    const today = new Date();
    const records: AccountRecord[] = [];

    // 生成过去30天的模拟数据
    for (let i = 0; i < 30; i++) {
      const date = new Date(today);
      date.setDate(date.getDate() - i);

      // 修复：直接使用Date对象，或者使用时间戳但确保DateUtil能处理
      const dateStr = DateUtil.formatDate(date); // 传递Date对象而不是时间戳

      // 随机生成支出记录
      if (Math.random() > 0.3) {
        records.push({
          id: `mock_${i}_1`,
          type: 'expense',
          category: MockData.getRandomExpenseCategory(),
          amount: Math.round(Math.random() * 200 * 100) / 100,
          description: '日常消费',
          date: date.getTime(),
          dateStr: dateStr
        });
      }

      // 随机生成收入记录
      if (Math.random() > 0.7) {
        records.push({
          id: `mock_${i}_2`,
          type: 'income',
          category: MockData.getRandomIncomeCategory(),
          amount: Math.round(Math.random() * 5000 * 100) / 100,
          description: '工资收入',
          date: date.getTime(),
          dateStr: dateStr
        });
      }
    }

    return records.sort((a, b) => b.date - a.date);
  }

  private static getRandomExpenseCategory(): string {
    const categories = ['食物', '交通', '娱乐', '购物', '医疗', '教育', '住房', '其他'];
    return categories[Math.floor(Math.random() * categories.length)];
  }

  private static getRandomIncomeCategory(): string {
    const categories = ['工资', '奖金', '投资', '兼职', '其他'];
    return categories[Math.floor(Math.random() * categories.length)];
  }
}