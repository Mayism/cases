import { abilityAccessCtrl, Permissions, PermissionRequestResult } from '@kit.AbilityKit';
import { Logger } from './Logger';
import { NormalizedError } from './NormalizedError';

const LOCATION_PERMISSIONS_LIST: Permissions[] = [
  'ohos.permission.LOCATION',
  'ohos.permission.APPROXIMATELY_LOCATION'
];

enum PermissionAuthResult {
  DENIED = -1,
  GRANTED = 0,
  INVALID_REQUEST = 2
}

enum AccessControlErrorCode {
  ALL_PERMISSIONS_ALREADY_GRANTED = 12100011
}

enum ErrorReasonType {
  UNKNOWN = -1,                   // 未知异常
  NO_ERROR = 0,                   // 本次申请合法
  ILLEGAL_PERMISSION_NAME = 1,    // 权限名非法
  PERMISSION_NOT_DECLARED = 2,    // 权限未声明
  CONDITION_NOT_MET = 3,          // 不满足申请条件（如位置权限等）
  PRIVACY_DECLARATION_DENIED = 4, // 用户未同意隐私声明
  UNSUPPORTED_PERMISSION = 5,     // 权限不支持通过弹窗申请
  MANUAL_SETTINGS_REQUIRED = 6,   // 需手动设置授权（manual_settings）
  SERVICE_EXCEPTION = 12          // 服务异常
}

export class PermissionUtils {

  public static async requestLocationPermissions(
    context: Context,
    allowSecondaryPrompt: boolean = true
  ): Promise<boolean> {
    return PermissionUtils.requestPermissionsByList(context, LOCATION_PERMISSIONS_LIST, allowSecondaryPrompt);
  }

  private static async requestPermissionsByList(
    context: Context,
    permissionsList: Permissions[],
    allowSecondaryPrompt: boolean
  ): Promise<boolean> {
    try {
      const atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
      const result: PermissionRequestResult =
        await atManager.requestPermissionsFromUser(context, permissionsList);
      const permissions: string[] = result.permissions;
      const authResults: number[] = result.authResults;
      const deniedPermissionIndices: number[] = [];
      for (let i: number = 0; i < authResults.length; i++) {
        if (authResults[i] === PermissionAuthResult.DENIED) {
          deniedPermissionIndices.push(i);
        } else if (authResults[i] !== PermissionAuthResult.GRANTED) {
          throw new Error(PermissionUtils.getErrorReasonMsg(result.errorReasons?.[i] ?? -1));
        }
      }
      if (deniedPermissionIndices.length > 0) {
        if (!allowSecondaryPrompt) {
          return false;
        }
        const dialogShownResults: boolean[] | undefined = result.dialogShownResults;
        if (!dialogShownResults) {
          throw new Error('Permission dialog status missing: dialogShownResults is undefined');
        }
        if (dialogShownResults.length !== permissions.length || dialogShownResults.length !== authResults.length) {
          throw new Error(PermissionUtils.getErrorReasonMsg(ErrorReasonType.UNKNOWN));
        }
        const permissionsForSecondConfirm: Permissions[] = [];
        for (const index of deniedPermissionIndices) {
          const isShown: boolean = dialogShownResults[index];
          if (isShown) {
            return false;
          }
          permissionsForSecondConfirm.push(permissions[index] as Permissions);
        }
        const statusList: abilityAccessCtrl.GrantStatus[] =
          await atManager.requestPermissionOnSetting(context, permissionsForSecondConfirm);
        for (const status of statusList) {
          if (status === abilityAccessCtrl.GrantStatus.PERMISSION_DENIED) {
            return false;
          }
        }
      }
    } catch (e) {
      const err: NormalizedError = NormalizedError.from(e);
      if (err.code !== AccessControlErrorCode.ALL_PERMISSIONS_ALREADY_GRANTED) {
        Logger.error(err.toLogLine());
        return false;
      }
    }
    return true;
  }

  private static getErrorReasonMsg(type: number): string {
    switch (type) {
      case ErrorReasonType.NO_ERROR:
        return 'Permission request succeeded';
      case ErrorReasonType.ILLEGAL_PERMISSION_NAME:
        return 'Illegal permission name';
      case ErrorReasonType.PERMISSION_NOT_DECLARED:
        return 'Permission not declared in config';
      case ErrorReasonType.CONDITION_NOT_MET:
        return 'Preconditions not met (e.g., location service not enabled)';
      case ErrorReasonType.PRIVACY_DECLARATION_DENIED:
        return 'User did not accept privacy declaration';
      case ErrorReasonType.UNSUPPORTED_PERMISSION:
        return 'Permission request not supported or restricted by system policy';
      case ErrorReasonType.MANUAL_SETTINGS_REQUIRED:
        return 'Permission requires manual settings grant';
      case ErrorReasonType.SERVICE_EXCEPTION:
        return 'Internal service exception';
      default:
        return `Unknown type: ${type}`;
    }
  }
}
