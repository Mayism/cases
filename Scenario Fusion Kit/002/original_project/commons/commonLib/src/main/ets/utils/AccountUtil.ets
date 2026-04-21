import { AppStorageV2, promptAction } from '@kit.ArkUI';
import { authentication } from '@kit.AccountKit';
import { util } from '@kit.ArkTS';
import { BusinessError } from '@kit.BasicServicesKit';
import { Logger } from './Logger';
import { HuaweiIDResp, UserInfo } from '../types/Types';
import { AppStorageMap } from '../constants/CommonEnums';

const TAG = '[AccountUtil]';

@ObservedV2
export class UserInfoModel implements UserInfo {
  @Trace id: number = 0;
  @Trace avatar: string = ''
  @Trace phoneNumber: string = ''
  @Trace name: string = ''
  @Trace isAssociate: boolean = false
}

@ObservedV2
export class LoginModel {
  @Trace isLogin: boolean = false
}

@ObservedV2
export class AccountUtil {
  private static _userInfo: UserInfoModel = AppStorageV2.connect(
    UserInfoModel,
    AppStorageMap.USER_INFO,
    () => new UserInfoModel(),
  )!;

  private static loginInfo: LoginModel = AppStorageV2.connect(LoginModel, () => new LoginModel())!

  // 关联授权
  public static async authenticationLogin(): Promise<Record<string, string | number>> {
    return new Promise((resolve, reject) => {
      // 创建授权请求，并设置参数
      const authRequest = new authentication.HuaweiIDProvider().createAuthorizationWithHuaweiIDRequest();
      // 获取手机号需要传如下scope，传参数之前需要先申请对应scope权限,才能返回对应数据
      authRequest.scopes = ['phone'];
      // 获取code需传如下permission
      authRequest.permissions = ['serviceauthcode'];
      // 用户是否需要登录授权，该值为true且用户未登录或未授权时，会拉起用户登录或授权页面
      authRequest.forceAuthorization = true;
      // 用于防跨站点请求伪造
      authRequest.state = util.generateRandomUUID();

      const controller = new authentication.AuthenticationController(getContext())
      controller.executeRequest(authRequest).then((data) => {
        const authorizationWithHuaweiIDResponse = data as authentication.AuthorizationWithHuaweiIDResponse;
        const state = authorizationWithHuaweiIDResponse.state;
        if (state !== undefined && authRequest.state !== state) {
          Logger.error(TAG, `Failed to authorize. The state is different, response state: ${state}`);
          reject('error state: ' + state)
          return
        }
        const authorizationWithHuaweiIDCredential = authorizationWithHuaweiIDResponse.data!;
        const authCode = authorizationWithHuaweiIDCredential.authorizationCode;
        if (authCode) {
          resolve({
            'code': 200,
            'authCode': authCode
          } as Record<string, string | number>)
        } else {
          reject({
            'code': 20001,
            'authCode': 'error authorization'
          } as Record<string, string | number>)
        }
      }).catch((error: BusinessError) => {
        Logger.error(TAG, `Failed to login. errCode is ${error.code}, errMessage is ${error.message}`)
        reject({
          'code': 20001,
          'authCode': JSON.stringify(error)
        } as Record<string, string | number>)
      })
    });
  }
  // 取消授权
  public static async cancelAuthentication(): Promise<Record<string, string | number>> {
    return new Promise((resolve, reject) => {
      // 创建取消授权请求，并设置参数
      const cancelRequest = new authentication.HuaweiIDProvider().createCancelAuthorizationRequest();
      cancelRequest.state = util.generateRandomUUID();
      const controller = new authentication.AuthenticationController(getContext());
      controller.executeRequest(cancelRequest, (error: BusinessError<Object>, data) => {
        if (error) {
          reject({
            'code': 20001,
            'authCode': JSON.stringify(error)
          } as Record<string, string | number>)
          return;
        }
        const cancelAuthorizationResponse = data as authentication.CancelAuthorizationResponse;
        const state = cancelAuthorizationResponse.state;
        if (state && cancelRequest.state !== state) {
          Logger.error(TAG, `Failed to cancel. The state is different, response state: ${state}`);
          reject({
            'code': 20001,
            'authCode': 'Failed state: ' + state
          } as Record<string, string | number>)
          return;
        }
        Logger.error(TAG, 'Succeeded in canceling.');
        resolve({
          'code': 200,
          'authCode': ''
        } as Record<string, string | number>)
      });
    })
  }

  // 静默登录
  public static silentLogin(): Promise<HuaweiIDResp> {
    return new Promise((resolve, reject) => {
      // Create a login request and set parameters
      let loginRequest = new authentication.HuaweiIDProvider().createLoginWithHuaweiIDRequest();
      // Whether to forcibly launch the HUAWEI ID login page when the user is not logged in with the HUAWEI ID
      loginRequest.forceLogin = false;
      // Execute login request
      let controller = new authentication.AuthenticationController();
      controller.executeRequest(loginRequest).then((data) => {
        let loginWithHuaweiIDResponse = data as authentication.LoginWithHuaweiIDResponse;
        let authCode = loginWithHuaweiIDResponse.data?.authorizationCode;
        let openId = loginWithHuaweiIDResponse.data?.openID;
        let unionId = loginWithHuaweiIDResponse.data?.unionID;
        resolve({ openId, unionId, authCode } as HuaweiIDResp);
      }).catch((error: BusinessError) => {
        Logger.error(TAG, 'loginWithHuaweiID error: ' + JSON.stringify(error));
      }).finally(() => {
        resolve({
          openId: '',
          unionId: '',
          authCode: '',
        } as HuaweiIDResp);
      });
    });
  }

  // 关联手机号
  public static async associatePhoneNumber(callback: (isSuccess: boolean) => void) {
    AccountUtil.authenticationLogin().then((data: Record<string, string | number>) => {
      if (data.code === 200 && data.authCode) {
        AccountUtil._userInfo.isAssociate = true
        AccountUtil._userInfo.phoneNumber = '10000000001'
        callback(true)
      } else {
        callback(false)
      }
    }).catch(() => {
      promptAction.showToast({message:'取消关联手机号'})
      AccountUtil.cancelAuthentication()
      AccountUtil._userInfo.isAssociate = false
      AccountUtil._userInfo.phoneNumber = ''
      callback(false)
    })
  }

  public static updateUserInfo(data: UserInfoModel) {
    AccountUtil._userInfo.name = data.name;
    AccountUtil._userInfo.phoneNumber = data.phoneNumber;
    AccountUtil._userInfo.id = data.id;
    AccountUtil._userInfo.avatar = data.avatar;
  }

  public static getUserInfo(): UserInfoModel {
    return AccountUtil._userInfo;
  }


  /**
   * 获取
   */
  public static onGetPhoneNumberFail(callback: (type: number) => void) {
    promptAction.showDialog({
      title: '提示',
      message: '元服务未获取phone权限或用户授权，点击确定创建一个mock账号。',
      buttons: [
        {
          text: '取消',
          color: '#0A59F7'
        },
        {
          text: '确定',
          color: '#0A59F7'
        }
      ]
    }, (err, data) => {
      if (err) {
        return;
      }
      callback(data.index)
    });
  }

}