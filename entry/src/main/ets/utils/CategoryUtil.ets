import { Category } from '../constants/Constants';
import { StorageUtil } from './StorageUtil';

export class CategoryUtil {
  private static readonly CUSTOM_CATEGORIES_KEY: string = 'customCategories';

  static async getCustomCategories(): Promise<Category[]> {
    try {
      const data = await StorageUtil.get(CategoryUtil.CUSTOM_CATEGORIES_KEY);
      if (data) {
        return JSON.parse(data);
      }
    } catch (e) {
      console.error('Failed to get custom categories:', e);
    }
    return [];
  }

  static async addCustomCategory(category: Category): Promise<void> {
    try {
      const categories = await CategoryUtil.getCustomCategories();
      // 检查是否已存在
      if (!categories.find(c => c.name === category.name)) {
        categories.push(category);
        await StorageUtil.set(CategoryUtil.CUSTOM_CATEGORIES_KEY, JSON.stringify(categories));
      }
    } catch (e) {
      console.error('Failed to add custom category:', e);
    }
  }

  static async deleteCustomCategory(categoryName: string): Promise<void> {
    try {
      const categories = await CategoryUtil.getCustomCategories();
      const filtered = categories.filter(c => c.name !== categoryName);
      await StorageUtil.set(CategoryUtil.CUSTOM_CATEGORIES_KEY, JSON.stringify(filtered));
    } catch (e) {
      console.error('Failed to delete custom category:', e);
    }
  }
}
