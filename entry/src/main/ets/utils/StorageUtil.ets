// 本地存储工具
import { AccountRecord } from '../models/AccountRecord';
import { preferences } from '@kit.ArkData';
import { AccountBookUtil } from './AccountBookUtil';

const STORAGE_KEY = 'account_records';

export class StorageUtil {
  private static context: Context;

  static setContext(context: Context) {
    StorageUtil.context = context;
  }

  // 获取当前账本的存储key
  private static getCurrentBookKey(): string {
    const bookId = AccountBookUtil.getCurrentBookId();
    return bookId ? `${STORAGE_KEY}_${bookId}` : STORAGE_KEY;
  }

  static async saveRecords(records: AccountRecord[]): Promise<void> {
    try {
      const pref = await preferences.getPreferences(StorageUtil.context, 'account_app');
      const key = StorageUtil.getCurrentBookKey();
      await pref.put(key, JSON.stringify(records));
      await pref.flush();
    } catch (error) {
      console.error('保存记录失败:', error);
    }
  }

  static async getRecords(): Promise<AccountRecord[]> {
    try {
      const pref = await preferences.getPreferences(StorageUtil.context, 'account_app');
      const key = StorageUtil.getCurrentBookKey();
      const data = await pref.get(key, '[]');
      return JSON.parse(data as string);
    } catch (error) {
      console.error('读取记录失败:', error);
      return [];
    }
  }

  static generateId(): string {
    return Date.now().toString() + Math.random().toString(36).substr(2, 9);
  }

  static async set(key: string, value: string): Promise<void> {
    try {
      const pref = await preferences.getPreferences(StorageUtil.context, 'account_app');
      await pref.put(key, value);
      await pref.flush();
    } catch (error) {
      console.error('保存数据失败:', error);
    }
  }

  static async get(key: string): Promise<string> {
    try {
      const pref = await preferences.getPreferences(StorageUtil.context, 'account_app');
      const data = await pref.get(key, '');
      return data as string;
    } catch (error) {
      console.error('读取数据失败:', error);
      return '';
    }
  }
}
