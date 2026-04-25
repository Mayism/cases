import { AppStorageV2 } from '@kit.ArkUI';
import { BusinessError, emitter } from '@kit.BasicServicesKit';
import { authentication } from '@kit.AccountKit';
import { MyWalletViewModel } from 'business_mine';
import {
  AppInfoModel,
  AppPrivacyUtils,
  ContextUtils,
  EmitUtils,
  HttpRequest,
  HuaweiIDResp,
  Logger,
  MallModel,
  RouterMap,
  RouterUtil,
  UserInfoModel,
} from 'lib_common';
import { WidgetUtil } from '../utils/WidgetUtil';

const TAG = '[IndexViewModel]';

@ObservedV2
export class IndexViewModel {
  @Trace pageStack: NavPathStack = RouterUtil.navPathStack
  @Trace appInfo: AppInfoModel = AppStorageV2.connect(AppInfoModel, () => new AppInfoModel())!;
  @Trace userInfo: UserInfoModel = AppStorageV2.connect(UserInfoModel, () => new UserInfoModel())!;
  @Trace mallModel: MallModel = AppStorageV2.connect(MallModel, () => new MallModel()) as MallModel;
  @Trace walletVM: MyWalletViewModel = MyWalletViewModel.instance
  @Trace privacyImpl: AppPrivacyUtils = AppPrivacyUtils.instance;

  // 监听协议签署结果
  @Monitor('privacyImpl.agreeFlag')
  agreeFlagChange() {
    if (this.privacyImpl.agreeFlag) {
      // 签署协议后，执行静默登录
      this.silentLogin();
    }
  }

  init() {
    this.agreeFlagChange();
    Promise.all([HttpRequest.getShoppingMallInfo()]).then(resp => {
      if (resp[0]) {
        this.mallModel.shoppingMall = resp[0]
      }
      this.pageStack.replacePathByName(RouterMap.INDEX_PAGE, null);
      WidgetUtil.updateWidgetsWhenChange(ContextUtils.globalContext);
    })
    this.onPrivacyChange();
    this.onConsumeWallet();
    WidgetUtil.subscribeFormId(ContextUtils.globalContext);
    WidgetUtil.subscribeFormClick();
  }

  onPrivacyChange() {
    this.privacyImpl.subscribe();
  }

  offPrivacyChange() {
    this.privacyImpl.unSubscribe();
  }

  onConsumeWallet() {
    EmitUtils.onEmit('onConsumeWallet', (data: emitter.EventData) => {
      this.walletVM.consumeWallet(data?.data?.money);
    })
  }

  offConsumeWallet() {
    EmitUtils.offEmit('onConsumeWallet');
  }

  private silentLogin() {
    this.loginWithHuaweiID().then((resp) => {
      this.userInfo.openId = resp.openId
      this.userInfo.unionId = resp.unionId
      // 查询用户信息
      HttpRequest.getUserInfo(resp.openId, resp.unionId).then((resp) => {
        this.userInfo.userInfo = resp;
      });
    })
  }

  private loginWithHuaweiID(): Promise<HuaweiIDResp> {
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
        Logger.info(TAG, 'loginWithHuaweiID result: ' + JSON.stringify(data));
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
}