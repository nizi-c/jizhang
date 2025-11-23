import abilityAccessCtrl, { Permissions } from '@ohos.abilityAccessCtrl';
import { BusinessError } from '@ohos.base';
import common from '@ohos.app.ability.common';

export class PermissionUtil {
  /**
   * 请求存储权限
   */
  static async requestStoragePermissions(context: common.UIAbilityContext): Promise<boolean> {
    const permissions: Array<Permissions> = [
      'ohos.permission.WRITE_MEDIA',
      'ohos.permission.READ_MEDIA'
    ];

    try {
      const atManager = abilityAccessCtrl.createAtManager();
      
      // 检查权限是否已授予
      const writeGranted = await atManager.checkAccessToken(
        context.applicationInfo.accessTokenId,
        'ohos.permission.WRITE_MEDIA'
      );
      
      const readGranted = await atManager.checkAccessToken(
        context.applicationInfo.accessTokenId,
        'ohos.permission.READ_MEDIA'
      );

      if (writeGranted === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED &&
          readGranted === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED) {
        console.log('存储权限已授予');
        return true;
      }

      // 请求权限
      console.log('请求存储权限');
      const result = await atManager.requestPermissionsFromUser(context, permissions);
      
      const allGranted = result.authResults.every(status => 
        status === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED
      );

      if (allGranted) {
        console.log('用户授予了存储权限');
        return true;
      } else {
        console.log('用户拒绝了存储权限');
        return false;
      }
    } catch (err) {
      const error = err as BusinessError;
      console.error(`请求权限失败: ${error.code}, ${error.message}`);
      return false;
    }
  }

  /**
   * 检查是否有存储权限
   */
  static async hasStoragePermissions(context: common.UIAbilityContext): Promise<boolean> {
    try {
      const atManager = abilityAccessCtrl.createAtManager();
      
      const writeGranted = await atManager.checkAccessToken(
        context.applicationInfo.accessTokenId,
        'ohos.permission.WRITE_MEDIA'
      );
      
      const readGranted = await atManager.checkAccessToken(
        context.applicationInfo.accessTokenId,
        'ohos.permission.READ_MEDIA'
      );

      return writeGranted === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED &&
             readGranted === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED;
    } catch (err) {
      console.error('检查权限失败:', err);
      return false;
    }
  }
}
