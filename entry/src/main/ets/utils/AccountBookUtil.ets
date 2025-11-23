// 账本管理工具类
import preferences from '@ohos.data.preferences';
import { AccountBook } from '../models/AccountBook';
import common from '@ohos.app.ability.common';

export class AccountBookUtil {
  private static context: common.UIAbilityContext;
  private static preferences: preferences.Preferences | null = null;
  private static readonly BOOKS_KEY = 'account_books';
  private static readonly CURRENT_BOOK_KEY = 'current_book_id';
  private static currentBookId: string = '';

  // 初始化
  static async init(context: common.UIAbilityContext) {
    AccountBookUtil.context = context;
    try {
      AccountBookUtil.preferences = await preferences.getPreferences(context, 'account_books_store');
      
      // 获取当前账本ID
      AccountBookUtil.currentBookId = await AccountBookUtil.preferences.get(AccountBookUtil.CURRENT_BOOK_KEY, '') as string;
      
      // 如果没有账本，创建默认账本
      const books = await AccountBookUtil.getAllBooks();
      if (books.length === 0) {
        await AccountBookUtil.createDefaultBook();
      }
      
      // 如果没有当前账本，设置第一个为当前账本
      if (!AccountBookUtil.currentBookId) {
        const allBooks = await AccountBookUtil.getAllBooks();
        if (allBooks.length > 0) {
          await AccountBookUtil.setCurrentBook(allBooks[0].id);
        }
      }
    } catch (error) {
      console.error('初始化账本管理失败:', error);
    }
  }

  // 创建默认账本
  private static async createDefaultBook(): Promise<void> {
    const defaultBook: AccountBook = {
      id: AccountBookUtil.generateId(),
      name: '默认账本',
      icon: '📒',
      createTime: new Date().toISOString(),
      isDefault: true
    };
    
    await AccountBookUtil.saveBook(defaultBook);
    await AccountBookUtil.setCurrentBook(defaultBook.id);
  }

  // 生成唯一ID
  private static generateId(): string {
    return `book_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;
  }

  // 获取所有账本
  static async getAllBooks(): Promise<AccountBook[]> {
    try {
      if (!AccountBookUtil.preferences) return [];
      
      const booksJson = await AccountBookUtil.preferences.get(AccountBookUtil.BOOKS_KEY, '[]') as string;
      return JSON.parse(booksJson) as AccountBook[];
    } catch (error) {
      console.error('获取账本列表失败:', error);
      return [];
    }
  }

  // 保存账本
  static async saveBook(book: AccountBook): Promise<void> {
    try {
      if (!AccountBookUtil.preferences) return;
      
      const books = await AccountBookUtil.getAllBooks();
      const index = books.findIndex(b => b.id === book.id);
      
      if (index >= 0) {
        books[index] = book;
      } else {
        books.push(book);
      }
      
      await AccountBookUtil.preferences.put(AccountBookUtil.BOOKS_KEY, JSON.stringify(books));
      await AccountBookUtil.preferences.flush();
    } catch (error) {
      console.error('保存账本失败:', error);
    }
  }

  // 删除账本
  static async deleteBook(bookId: string): Promise<boolean> {
    try {
      if (!AccountBookUtil.preferences) return false;
      
      const books = await AccountBookUtil.getAllBooks();
      const book = books.find(b => b.id === bookId);
      
      // 不能删除默认账本
      if (book?.isDefault) {
        return false;
      }
      
      // 不能删除当前账本
      if (bookId === AccountBookUtil.currentBookId) {
        return false;
      }
      
      const newBooks = books.filter(b => b.id !== bookId);
      await AccountBookUtil.preferences.put(AccountBookUtil.BOOKS_KEY, JSON.stringify(newBooks));
      await AccountBookUtil.preferences.flush();
      
      return true;
    } catch (error) {
      console.error('删除账本失败:', error);
      return false;
    }
  }

  // 获取当前账本ID
  static getCurrentBookId(): string {
    return AccountBookUtil.currentBookId;
  }

  // 获取当前账本
  static async getCurrentBook(): Promise<AccountBook | null> {
    const books = await AccountBookUtil.getAllBooks();
    return books.find(b => b.id === AccountBookUtil.currentBookId) || null;
  }

  // 设置当前账本
  static async setCurrentBook(bookId: string): Promise<void> {
    try {
      if (!AccountBookUtil.preferences) return;
      
      AccountBookUtil.currentBookId = bookId;
      await AccountBookUtil.preferences.put(AccountBookUtil.CURRENT_BOOK_KEY, bookId);
      await AccountBookUtil.preferences.flush();
    } catch (error) {
      console.error('设置当前账本失败:', error);
    }
  }

  // 创建新账本
  static async createBook(name: string, icon: string = '📒'): Promise<AccountBook> {
    const newBook: AccountBook = {
      id: AccountBookUtil.generateId(),
      name: name,
      icon: icon,
      createTime: new Date().toISOString(),
      isDefault: false
    };
    
    await AccountBookUtil.saveBook(newBook);
    return newBook;
  }
}
