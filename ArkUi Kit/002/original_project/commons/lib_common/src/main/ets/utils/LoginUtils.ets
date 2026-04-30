import { authentication } from '@kit.AccountKit';
import { util } from '@kit.ArkTS';
import { AppStorageV2 } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { LoadingDialogUtil } from '../components/LoadingDialog';
import { HttpCode } from '../constants/Common';
import * as HttpRequestApi from '../httprequest/HttpRequestApi';
import { UserInfoModel } from '../models/StorageModel';
import * as HttpRequest from '../httprequest/HttpRequest';
import { Logger } from './Logger';
import { ContextUtils } from './ContextUtils';

const TAG = '[LoginUtils]';

export class LoginUtils {
  /**
   * 关联成功
   * @param code
   * @param callback
   */
  static onBindSuccess(code: string, callback?: () => void) {
    HttpRequestApi.getOpenLoginHm(encodeURIComponent(code)).then((res) => {
      if (res.code === HttpCode.SUCCESS) {
        let tel = res.data.userTel ?? ''
        let userInfo: UserInfoModel = AppStorageV2.connect(UserInfoModel, () => new UserInfoModel())!;
        userInfo.userInfo.userTel = `${tel.substring(0, tel.length - 8)}****${tel.substring(tel.length - 4)}`
        userInfo.isRelative = true
        if (callback) {
          callback();
        }
      } else {
        ContextUtils.showToast({ message: '账号关联失败，请重试~' })
      }
    }).catch(() => {
      ContextUtils.showToast({ message: '账号关联失败' })
    }).finally(() => {
      LoadingDialogUtil.close()
    })
  };

  /**
   * 关联失败
   * @param callback
   */
  static onBindFail(callback?: () => void) {
    try {
      ContextUtils.globalUIContext.getPromptAction().showDialog({
        title: '提示',
        message: '元服务未获取phone权限或用户授权，点击确定创建一个mock账号。',
        buttons: [
          {
            text: '取消',
            color: '#0A59F7',
          },
          {
            text: '确定',
            color: '#0A59F7',
          },
        ],
      }, (err, data) => {
        if (err) {
          return;
        }
        if (data.index === 1) {
          LoginUtils.onBindSuccess('123', callback);
        } else {
          LoadingDialogUtil.close();
        }
      });
    } catch (e) {
      Logger.error(TAG, `showDialog fail. Code: ${e.code}, message: ${e.message}`);
    }
  };

  /**
   * 取消关联
   */
  static cancelRelative() {
    LoadingDialogUtil.openLoadingDialog()
    // 创建取消授权请求，并设置参数
    const cancelRequest = new authentication.HuaweiIDProvider().createCancelAuthorizationRequest();
    cancelRequest.state = util.generateRandomUUID(); // 建议使用generateRandomUUID生成state

    // 执行取消授权请求，并处理结果
    try {
      const controller = new authentication.AuthenticationController(ContextUtils.globalContext);
      controller.executeRequest(cancelRequest, (error: BusinessError<Object>, data) => {
        if (error) {
          LoginUtils.onCancelSuccess();
          return;
        }
        const cancelAuthorizationResponse = data as authentication.CancelAuthorizationResponse;
        const state = cancelAuthorizationResponse.state;
        if (state && cancelRequest.state !== state) {
          Logger.error(TAG, `Failed to cancel. The state is different, response state: ${state}`);
          LoadingDialogUtil.close()
          return;
        }
        Logger.info(TAG, 'Succeeded in canceling.');
        LoginUtils.onCancelSuccess();
      });
    } catch (error) {
      LoadingDialogUtil.close()
    }
  }

  /**
   * 取消关联成功
   */
  static onCancelSuccess() {
    HttpRequest.getCancelLogin().then(() => {
      let userInfo: UserInfoModel = AppStorageV2.connect(UserInfoModel, () => new UserInfoModel())!;
      userInfo.isRelative = false
      userInfo.userInfo.userTel = ''
    }).finally(() => {
      LoadingDialogUtil.close()
    })
  };
}
