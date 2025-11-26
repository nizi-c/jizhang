// 本地存储工具
import { AccountRecord } from '../models/AccountRecord';
import { preferences } from '@kit.ArkData';
import { AccountBookUtil } from './AccountBookUtil';

const STORAGE_KEY = 'account_records';

export class StorageUtil {
  private static context: Context;

  static setContext(context: Context) {
    StorageUtil.context = context;
    console.log('StorageUtil: Context 已设置');
  }

  // 获取当前账本的存储key
  private static getCurrentBookKey(): string {
    const bookId = AccountBookUtil.getCurrentBookId();
    const key = bookId ? `${STORAGE_KEY}_${bookId}` : STORAGE_KEY;
    console.log('StorageUtil: 当前账本 ID:', bookId, '存储 key:', key);
    return key;
  }

  static async saveRecords(records: AccountRecord[]): Promise<void> {
    try {
      if (!StorageUtil.context) {
        console.error('StorageUtil: Context 未初始化！');
        throw new Error('Context is not initialized');
      }
      
      console.log('StorageUtil: 开始保存记录，数量:', records.length);
      const pref = await preferences.getPreferences(StorageUtil.context, 'account_app');
      const key = StorageUtil.getCurrentBookKey();
      const jsonStr = JSON.stringify(records);
      console.log('StorageUtil: 保存数据到 key:', key, '数据长度:', jsonStr.length);
      
      await pref.put(key, jsonStr);
      await pref.flush();
      console.log('StorageUtil: 记录保存成功');
    } catch (error) {
      const errorMsg = error instanceof Error ? error.message : String(error);
      console.error('StorageUtil: 保存记录失败:', errorMsg);
      throw new Error(`保存记录失败: ${errorMsg}`);
    }
  }

  static async getRecords(): Promise<AccountRecord[]> {
    try {
      if (!StorageUtil.context) {
        console.error('StorageUtil: Context 未初始化！');
        return [];
      }
      
      const pref = await preferences.getPreferences(StorageUtil.context, 'account_app');
      const key = StorageUtil.getCurrentBookKey();
      const data = await pref.get(key, '[]');
      const dataStr: string = typeof data === 'string' ? data : '[]';
      const records: AccountRecord[] = JSON.parse(dataStr) as AccountRecord[];
      console.log('StorageUtil: 读取记录成功，数量:', records.length);
      return records;
    } catch (error) {
      const errorMsg = error instanceof Error ? error.message : String(error);
      console.error('StorageUtil: 读取记录失败:', errorMsg);
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
      const errorMsg = error instanceof Error ? error.message : String(error);
      console.error('保存数据失败:', errorMsg);
    }
  }

  static async get(key: string): Promise<string> {
    try {
      const pref = await preferences.getPreferences(StorageUtil.context, 'account_app');
      const data = await pref.get(key, '');
      return typeof data === 'string' ? data : '';
    } catch (error) {
      const errorMsg = error instanceof Error ? error.message : String(error);
      console.error('读取数据失败:', errorMsg);
      return '';
    }
  }
}
