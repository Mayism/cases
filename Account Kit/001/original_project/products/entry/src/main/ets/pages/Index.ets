import { UtilLog } from '@hw-agconnect/util-log';
import { authentication } from '@kit.AccountKit';
import { AppStorageV2, PersistenceV2 } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import dataPreferences from '@ohos.data.preferences';
import { BusinessTimeDialog } from 'base_ui';
import {
  AppInfoModel,
  AppPrivacyUtils,
  CardManager,
  Constants,
  FormDataClass,
  HuaweiIDResp,
  MustGoodsController,
  MyCarModel,
  OrderTypeEnum,
  RouterMap,
  RouterModule,
  StoreInfoModel,
  UserInfoModel,
  WindowUtil,
} from 'common/Index';
import { OrderUtil } from 'network';
import * as API from '../api/Index';

const TAG = '[Index]'

@Entry
@ComponentV2
struct Index {
  @Local appInfoModel: AppInfoModel = AppStorageV2.connect(AppInfoModel, () => new AppInfoModel())!;
  @Local storeModel: StoreInfoModel = AppStorageV2.connect(StoreInfoModel, () => new StoreInfoModel())!;
  @Local userInfoModel: UserInfoModel = PersistenceV2.connect(UserInfoModel, () => new UserInfoModel())!;
  @Local myCarModel: MyCarModel = AppStorageV2.connect(MyCarModel, () => new MyCarModel())!
  @Local privacyImpl: AppPrivacyUtils = AppPrivacyUtils.instance;
  @Local mustGoodsCtrl: MustGoodsController =
    AppStorageV2.connect(MustGoodsController, () => new MustGoodsController())!
  @Provider('orderId') orderId?: string = undefined;
  @Local openId: string = '';
  @Local unionId: string = '';
  businessController: CustomDialogController = new CustomDialogController({
    builder: BusinessTimeDialog(),
    width: 296,
    height: 348,
  });

  aboutToAppear() {
    this.privacyImpl.subscribe();
    const uiContext = this.getUIContext()
    WindowUtil.setUIContext('EntryAbility', uiContext)
    OrderUtil.setContext(WindowUtil.globalContext)
    if (!this.privacyImpl.agreeFlag) {
      // 未同意隐私协议，不进入首页
      return;
    }
    this.funcCore();
  }

  aboutToDisappear(): void {
    this.privacyImpl.unSubscribe();
  }

  // 监听协议签署结果
  @Monitor('privacyImpl.agreeFlag')
  agreeFlagChange() {
    if (this.privacyImpl.agreeFlag) {
      // 签署协议后，执行静默登录
      this.funcCore();
    }
  }

  @Monitor('appInfoModel.preloadFinished')
  async initQuery() {
    if (this.privacyImpl.agreeFlag && this.appInfoModel.preloadFinished) {
      if (!this.appInfoModel.bannerList.length) {
        await this.getPreloadData()
      }
      // 查询用户信息
      Promise.all([API.getUserInfo(this.storeModel.storeId, this.unionId, this.userInfoModel.isRelative),
        API.getStoreInfo(this.storeModel.storeId)]).then(res => {
        this.userInfoModel.userInfo.id = res[0].id;
        this.userInfoModel.userInfo.wallet = res[0].wallet;
        this.userInfoModel.userInfo.totalScore = res[0].totalScore;
        this.userInfoModel.userInfo.userTel = res[0].userTel ?? '';
        this.userInfoModel.isRelative = !!res[0].userTel
        this.userInfoModel.userInfo.name = res[0].name;
        if (this.storeModel.qrCodeFlag) {
          API.clearCar();
        } else {
          API.getMyCar().then((res) => {
            res.goodsList?.forEach(item => {
              if (item.isMust === Constants.GOODS_MUST) {
                this.mustGoodsCtrl.addIsMust(Number(item.num));
              }
            });
          });
        }
        this.storeModel.storeInfo = res[1];
        this.updateFormCard();
        this.storeModel.storeInfo.reductionList = res[1].reductionList;
        if (this.storeModel.orderType === OrderTypeEnum.DINE_IN && this.storeModel.tableId) {
          this.storeModel.tableInfo = this.storeModel.tableList.find(item => item.id === this.storeModel.tableId)!;
        }
        RouterModule.replace(RouterMap.MAIN_INDEX);
      });
    }
  }

  build() {
    Column() {
      Navigation(RouterModule.getStack()) {
      }
      .hideTitleBar(true)
      .hideNavBar(true)
      .mode(NavigationMode.Stack)
      .height(Constants.FULL_SIZE)
      .width(Constants.FULL_SIZE);
    }
    .height(Constants.FULL_SIZE)
    .width(Constants.FULL_SIZE);

  }

  funcCore() {
    Promise.all([API.getStoreList(), this.loginWithHuaweiID()]).then(res => {
      this.storeModel.storeList = res[0];
      this.storeModel.storeId = res[0][0].id;
      this.openId = res[1].openId;
      this.unionId = res[1].unionId;
      this.userInfoModel.authCode = res[1].authCode;
      if (this.appInfoModel.preloadFinished) {
        this.initQuery()
      }
    });
  }

  getPreloadData(): Promise<void> {
    return new Promise((resolve, reject) => {
      Promise.all([API.getAppInfo(), API.getTableList()]).then(res => {
        if (res[0]) {
          this.appInfoModel.bannerList = res[0].bannerList;
          this.appInfoModel.imgBaseUrl = res[0].imgBaseUrl;
          this.appInfoModel.telephone = res[0].telephone;
        }
        if (res[1]?.length) {
          this.storeModel.tableList = res[1];
        }
        resolve()
      }).catch(() => {
        reject()
      });
    })
  }

  updateFormCard() {
    try {
      dataPreferences.removePreferencesFromCacheSync(this.getUIContext().getHostContext(),
        { name: CardManager.KEY_CARD_ID })
    } catch (e) {
      UtilLog.error(TAG, `removePreferencesFromCacheSync failed.`, e)
    }

    let pref =
      dataPreferences.getPreferencesSync(this.getUIContext().getHostContext(), { name: CardManager.KEY_CARD_INFO });
    let dataClass = new FormDataClass();
    dataClass.storeName = this.storeModel.storeInfo.name || '';
    pref.putSync(CardManager.KEY_CARD_INFO, dataClass);
    pref.flush();
    CardManager.get().updateCard(dataClass);
  }

  getTimeByHour(time: string = '') {
    let date = new Date(`${new Date().toLocaleDateString()} ${time}`)
    return date.getTime()
  }

  /**
   * Sample code for using HUAWEI ID to log in to atomic service.
   * According to the Atomic Service Review Guide, when a atomic service has an account system,
   * the option to log in with a HUAWEI ID must be provided.
   * The following presets the atomic service to use the HUAWEI ID silent login function.
   * To enable the atomic service to log in successfully using the HUAWEI ID, please refer
   * to the HarmonyOS HUAWEI ID Access Guide to configure the client ID and fingerprint certificate.
   */
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
        resolve({ openId, unionId, authCode } as HuaweiIDResp);
        // Send authCode to the backend in exchange for unionID, session

      }).catch((error: BusinessError) => {
        UtilLog.error(TAG, 'error: %{public}s', JSON.stringify(error));
        if (error.code === authentication.AuthenticationErrorCode.ACCOUNT_NOT_LOGGED_IN) {
          // HUAWEI ID is not logged in, it is recommended to jump to the login guide page
        }
        // todo 模板适配无法登录华为账号场景下可以正常访问，正常开发需要根据实际场景选择  reject(error);
        resolve({ openId: '1', unionId: '1', authCode: '1' } as HuaweiIDResp);
      });
    });
  }
}
