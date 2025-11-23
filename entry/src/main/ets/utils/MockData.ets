import { AccountRecord } from '../models/AccountRecord';
import { StorageUtil } from './StorageUtil';

interface CategoryInfo {
  name: string;
  descriptions: string[];
}

interface IncomeCategoryInfo {
  name: string;
  amount: number[];
}

export class MockData {
  // 生成模拟数据
  static async generateMockData(): Promise<void> {
    const mockRecords: AccountRecord[] = [];
    const today = new Date();
    
    // 生成最近30天的数据
    for (let i = 0; i < 30; i++) {
      const date = new Date(today);
      date.setDate(date.getDate() - i);
      const dateStr = MockData.formatDate(date);
      
      // 每天生成2-5条记录
      const recordCount = Math.floor(Math.random() * 4) + 2;
      
      for (let j = 0; j < recordCount; j++) {
        const isExpense = Math.random() > 0.3; // 70%概率是支出
        
        if (isExpense) {
          mockRecords.push(MockData.generateExpenseRecord(dateStr));
        } else {
          mockRecords.push(MockData.generateIncomeRecord(dateStr));
        }
      }
    }
    
    // 保存到存储
    await StorageUtil.saveRecords(mockRecords);
  }
  
  // 生成支出记录
  private static generateExpenseRecord(dateStr: string): AccountRecord {
    const categories: CategoryInfo[] = [
      { name: '食物', descriptions: ['早餐', '午餐', '晚餐', '零食', '水果', '饮料'] },
      { name: '交通', descriptions: ['地铁', '公交', '打车', '加油', '停车费'] },
      { name: '娱乐', descriptions: ['电影', '游戏', 'KTV', '旅游', '运动'] },
      { name: '购物', descriptions: ['衣服', '鞋子', '化妆品', '日用品', '电子产品'] },
      { name: '医疗', descriptions: ['看病', '买药', '体检', '保健品'] },
      { name: '教育', descriptions: ['书籍', '课程', '培训', '学费'] },
      { name: '住房', descriptions: ['房租', '水电费', '物业费', '网费'] },
      { name: '其他', descriptions: ['礼物', '捐赠', '维修', '其他支出'] }
    ];
    
    const category = categories[Math.floor(Math.random() * categories.length)];
    const description = category.descriptions[Math.floor(Math.random() * category.descriptions.length)];
    
    // 根据分类生成合理的金额范围
    let amount = 0;
    switch (category.name) {
      case '食物':
        amount = Math.random() * 80 + 10; // 10-90
        break;
      case '交通':
        amount = Math.random() * 50 + 5; // 5-55
        break;
      case '娱乐':
        amount = Math.random() * 200 + 50; // 50-250
        break;
      case '购物':
        amount = Math.random() * 500 + 100; // 100-600
        break;
      case '医疗':
        amount = Math.random() * 300 + 50; // 50-350
        break;
      case '教育':
        amount = Math.random() * 400 + 100; // 100-500
        break;
      case '住房':
        amount = Math.random() * 2000 + 1000; // 1000-3000
        break;
      default:
        amount = Math.random() * 200 + 20; // 20-220
    }
    
    const moods: string[] = ['😊满意', '😟后悔', '🎉惊喜'];
    const mood = moods[Math.floor(Math.random() * moods.length)];
    
    return {
      id: MockData.generateId(),
      type: 'expense',
      category: category.name,
      amount: Math.round(amount * 100) / 100,
      description: description,
      date: new Date(dateStr).getTime(),
      dateStr: dateStr,
      mood: mood
    };
  }
  
  // 生成收入记录
  private static generateIncomeRecord(dateStr: string): AccountRecord {
    const categories: IncomeCategoryInfo[] = [
      { name: '工资', amount: [5000, 15000] },
      { name: '奖金', amount: [1000, 5000] },
      { name: '投资', amount: [500, 3000] },
      { name: '兼职', amount: [500, 2000] },
      { name: '其他', amount: [100, 1000] }
    ];
    
    const category = categories[Math.floor(Math.random() * categories.length)];
    const amount = Math.random() * (category.amount[1] - category.amount[0]) + category.amount[0];
    
    const moods: string[] = ['😊满意', '🎉惊喜'];
    const mood = moods[Math.floor(Math.random() * moods.length)];
    
    return {
      id: MockData.generateId(),
      type: 'income',
      category: category.name,
      amount: Math.round(amount * 100) / 100,
      description: category.name,
      date: new Date(dateStr).getTime(),
      dateStr: dateStr,
      mood: mood
    };
  }
  
  // 格式化日期
  private static formatDate(date: Date): string {
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    return `${year}-${month}-${day}`;
  }
  
  // 生成ID
  private static generateId(): string {
    return Date.now().toString() + Math.random().toString(36).substr(2, 9);
  }
  
  // 清除所有数据
  static async clearAllData(): Promise<void> {
    await StorageUtil.saveRecords([]);
  }
}
