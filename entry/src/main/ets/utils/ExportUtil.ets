import { AccountRecord } from '../models/AccountRecord';
import fs from '@ohos.file.fs';
import { Context } from '@ohos.abilityAccessCtrl';
import { BusinessError } from '@ohos.base';
import common from '@ohos.app.ability.common';
import { picker } from '@kit.CoreFileKit';

export class ExportUtil {
  /**
   * 导出记录为CSV格式
   */
  static exportToCSV(records: AccountRecord[]): string {
    // CSV 表头
    const headers = ['日期', '类型', '分类', '金额', '描述', '心情'];
    let csv = headers.join(',') + '\n';

    // 添加数据行
    records.forEach(record => {
      const row = [
        record.dateStr,
        record.type === 'income' ? '收入' : '支出',
        record.category,
        record.amount.toFixed(2),
        `"${record.description.replace(/"/g, '""')}"`, // 转义引号
        record.mood || ''
      ];
      csv += row.join(',') + '\n';
    });

    return csv;
  }

  /**
   * 保存CSV文件到应用缓存目录
   */
  static async saveCSVFile(csvContent: string, fileName: string, context: Context): Promise<string> {
    try {
      // 使用缓存目录
      const cacheDir = context.cacheDir;
      const filePath = `${cacheDir}/${fileName}`;

      // 创建文件
      const file = fs.openSync(filePath, fs.OpenMode.CREATE | fs.OpenMode.WRITE_ONLY | fs.OpenMode.TRUNC);
      
      // 写入内容
      fs.writeSync(file.fd, csvContent);
      
      // 关闭文件
      fs.closeSync(file);
      
      return filePath;
    } catch (err) {
      console.error(`保存CSV文件失败: ${JSON.stringify(err)}`);
      throw new Error('保存文件失败');
    }
  }

  /**
   * 使用DocumentPicker保存CSV文件到用户选择的位置
   */
  static async saveToPublicDirectory(csvContent: string, fileName: string, context: common.UIAbilityContext): Promise<string> {
    try {
      // 创建DocumentPicker保存选项
      const documentSaveOptions = new picker.DocumentSaveOptions();
      documentSaveOptions.newFileNames = [fileName];
      
      // 创建DocumentPicker
      const documentPicker = new picker.DocumentViewPicker();
      
      // 打开保存对话框，让用户选择保存位置
      const documentSaveResult: Array<string> = await documentPicker.save(documentSaveOptions);
      
      if (documentSaveResult && documentSaveResult.length > 0) {
        const uri = documentSaveResult[0];
        console.log('用户选择的保存位置: ' + uri);
        
        // 打开文件并写入内容
        const file = fs.openSync(uri, fs.OpenMode.READ_WRITE);
        fs.writeSync(file.fd, csvContent);
        fs.closeSync(file);
        
        console.log('文件已成功保存');
        return uri;
      } else {
        throw new Error('用户取消了保存');
      }
    } catch (err) {
      const error = err as BusinessError;
      console.error(`保存文件失败: ${error.code}, ${error.message}`);
      throw new Error(`保存文件失败: ${error.message}`);
    }
  }

  /**
   * 格式化文件名
   */
  static generateFileName(): string {
    const now = new Date();
    const year = now.getFullYear();
    const month = String(now.getMonth() + 1).padStart(2, '0');
    const day = String(now.getDate()).padStart(2, '0');
    const hour = String(now.getHours()).padStart(2, '0');
    const minute = String(now.getMinutes()).padStart(2, '0');
    const second = String(now.getSeconds()).padStart(2, '0');
    
    return `账单记录_${year}${month}${day}_${hour}${minute}${second}.csv`;
  }
}
