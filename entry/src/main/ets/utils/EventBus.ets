// 全局事件总线 - 用于页面间通信

type EventCallback = (data?: Object) => void;

interface EventsInterface {
  RECORD_ADDED: string;
  RECORD_UPDATED: string;
  RECORD_DELETED: string;
  RECORDS_CHANGED: string;
  BOOK_CREATED: string;
  BOOK_UPDATED: string;
  BOOK_DELETED: string;
  BOOK_SWITCHED: string;
  BUDGET_CREATED: string;
  BUDGET_UPDATED: string;
  BUDGET_DELETED: string;
  THEME_CHANGED: string;
  DATA_SYNCED: string;
}

export class EventBus {
  private static listeners: Map<string, EventCallback[]> = new Map();

  /**
   * 监听事件
   * @param event 事件名称
   * @param callback 回调函数
   */
  static on(event: string, callback: EventCallback): void {
    if (!EventBus.listeners.has(event)) {
      EventBus.listeners.set(event, []);
    }
    const callbacks = EventBus.listeners.get(event);
    if (callbacks) {
      callbacks.push(callback);
    }
  }

  /**
   * 取消监听事件
   * @param event 事件名称
   * @param callback 回调函数
   */
  static off(event: string, callback: EventCallback): void {
    const callbacks = EventBus.listeners.get(event);
    if (callbacks) {
      const index = callbacks.indexOf(callback);
      if (index > -1) {
        callbacks.splice(index, 1);
      }
    }
  }

  /**
   * 发送事件
   * @param event 事件名称
   * @param data 事件数据
   */
  static emit(event: string, data?: Object): void {
    const callbacks = EventBus.listeners.get(event);
    if (callbacks) {
      callbacks.forEach((callback: EventCallback) => {
        try {
          callback(data);
        } catch (error) {
          console.error(`EventBus error in event ${event}:`, error);
        }
      });
    }
  }

  /**
   * 清除所有监听器
   * @param event 事件名称，如果不指定则清除所有
   */
  static clear(event?: string): void {
    if (event) {
      EventBus.listeners.delete(event);
    } else {
      EventBus.listeners.clear();
    }
  }

  /**
   * 获取监听器数量
   * @param event 事件名称
   */
  static getListenerCount(event: string): number {
    const count = EventBus.listeners.get(event)?.length;
    return count ? count : 0;
  }
}

// 预定义的事件常量
export const Events: EventsInterface = {
  // 记录相关事件
  RECORD_ADDED: 'recordAdded',
  RECORD_UPDATED: 'recordUpdated',
  RECORD_DELETED: 'recordDeleted',
  RECORDS_CHANGED: 'recordsChanged',

  // 账本相关事件
  BOOK_CREATED: 'bookCreated',
  BOOK_UPDATED: 'bookUpdated',
  BOOK_DELETED: 'bookDeleted',
  BOOK_SWITCHED: 'bookSwitched',

  // 预算相关事件
  BUDGET_CREATED: 'budgetCreated',
  BUDGET_UPDATED: 'budgetUpdated',
  BUDGET_DELETED: 'budgetDeleted',

  // 主题相关事件
  THEME_CHANGED: 'themeChanged',

  // 数据同步事件
  DATA_SYNCED: 'dataSynced'
};
