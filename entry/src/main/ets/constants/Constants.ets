// 常量定义
export interface Category {
  name: string;
  icon: string;
  color: string;
}

export interface ColorScheme {
  primary: string;
  success: string;
  warning: string;
  danger: string;
  info: string;
  background: string;
  text: string;
  textLight: string;
  border: string;
}

export const EXPENSE_CATEGORIES: Category[] = [
  { name: '食物', icon: '🍔', color: '#FF6B6B' },
  { name: '交通', icon: '🚗', color: '#4ECDC4' },
  { name: '娱乐', icon: '🎮', color: '#FFE66D' },
  { name: '购物', icon: '🛍️', color: '#FF85C0' },
  { name: '医疗', icon: '⚕️', color: '#95E1D3' },
  { name: '教育', icon: '📚', color: '#A8E6CF' },
  { name: '住房', icon: '🏠', color: '#FFD3B6' },
  { name: '其他', icon: '📌', color: '#CCCCCC' }
];

export const INCOME_CATEGORIES: Category[] = [
  { name: '工资', icon: '💼', color: '#6BCB77' },
  { name: '奖金', icon: '🎁', color: '#4D96FF' },
  { name: '投资', icon: '📈', color: '#FFB84D' },
  { name: '兼职', icon: '💻', color: '#9D84B7' },
  { name: '其他', icon: '📌', color: '#CCCCCC' }
];

export const COLORS: ColorScheme = {
  primary: '#FF6B6B',
  success: '#6BCB77',
  warning: '#FFE66D',
  danger: '#FF6B6B',
  info: '#4ECDC4',
  background: '#F7F7F7',
  text: '#333333',
  textLight: '#999999',
  border: '#EEEEEE'
};
