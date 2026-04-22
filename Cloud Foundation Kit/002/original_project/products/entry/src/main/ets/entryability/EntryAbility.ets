import { UtilLog } from '@hw-agconnect/util-log';
import { AbilityConstant, bundleManager, UIAbility, Want } from '@kit.AbilityKit';
import { AppStorageV2, window } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { pushService } from '@kit.PushKit';
import {
  AppInfoModel,
  Constants,
  CustomShareParams,
  FormCard,
  FormCardJump,
  RouterModule,
  StoreInfoModel,
  WindowModel,
} from 'common';
import { LinkScanModel, ShareInfo } from '../models/Index';

const TAG = '[EntryAbility]'

export default class EntryAbility extends UIAbility {
  async onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): Promise<void> {
    hilog.info(0x0000, TAG, '%{public}s', 'Ability onCreate');
    UtilLog.setGlobalConfig({
      tag: 'CateringOrders', // 指定日志标识
      domain: 0xff00, // 日志对应的领域标识
      open: true,
      showStack: false,
    })
    // 获取应用包名
    try {
      let bundleInfo =
        await bundleManager.getBundleInfoForSelf(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_HAP_MODULE |
        bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_ABILITY |
        bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_REQUESTED_PERMISSION);
      let packageName = bundleInfo.name;
      let appInfo: AppInfoModel = AppStorageV2.connect(AppInfoModel, () => new AppInfoModel())!;
      appInfo.packageName = bundleInfo.name;
      UtilLog.info(`packageName: ${JSON.stringify(packageName)}.`);
    } catch (e) {
      UtilLog.error(`getBundleInfoForSelf failed. e: ${JSON.stringify(e)}.`);
    }

    this.resolvePagePath(want);
    this.handleAppLink(want);
    this.handleShare(want);
    // 获取Push Token
    try {
      const pushToken: string = await pushService.getToken();
      hilog.info(0x0000, TAG, 'Succeeded in getting push token');
    } catch (err) {
      let e: BusinessError = err as BusinessError;
      hilog.error(0x0000, TAG, 'Failed to get push token: %{public}d %{public}s', e.code, e.message);
    }
  }

  onDestroy(): void {
    hilog.info(0x0000, TAG, '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, TAG, '%{public}s', 'Ability onWindowStageCreate');
    let windowModel: WindowModel = AppStorageV2.connect(WindowModel, () => new WindowModel())!;
    windowStage.loadContent('pages/Index', async (err) => {
      if (err.code) {
        hilog.error(0x0000, TAG, 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, TAG, 'Succeeded in loading the content.');
      let windowClass: window.Window = windowStage.getMainWindowSync(); // 获取应用主窗口
      // 设置窗口全屏
      await windowClass.setWindowLayoutFullScreen(true);
      windowModel.fullScreen = true
      let type = window.AvoidAreaType.TYPE_SYSTEM; // 以状态栏避让为例
      let avoidArea = windowClass.getWindowAvoidArea(type);
      windowModel.windowTopHeight = windowClass.getUIContext().px2vp(avoidArea.topRect.height);
      type = window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR; // 以导航条避让为例
      avoidArea = windowClass.getWindowAvoidArea(type);
      windowModel.windowBottomHeight = windowClass.getUIContext().px2vp(avoidArea.bottomRect.height);
    });
    windowModel.windowStage = windowStage
  }

  onNewWant(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    this.resolvePagePath(want);
    this.handleShare(want);
    this.handleAppLink(want);
  }

  onShare(wantParams: Record<string, Object>) {
    // 指定页面支持分享按钮点击事件
    let currentName: string[] = RouterModule.getStack().getAllPathName()
    let showShareMenu = false
    if (currentName.length && Constants.SHARE_PAGES.includes(currentName[currentName.length-1])) {
      showShareMenu = true
    }
    const shareParams: ShareInfo = {
      showShareMenu,
      title: '点餐元服务分享',
      description: '点餐元服务分享',
      parameters: {} as CustomShareParams,
    };
    // 分享方：从临时缓存中获取自定义参数来设置want
    const instance = AppStorageV2.connect(CustomShareParams, () => new CustomShareParams())!;
    if (instance.goodsId) {
      const pageParams: CustomShareParams = {
        id: instance.id,
        pageName: instance.pageName,
        goodsId: instance.goodsId,
        goodsName: instance.goodsName,
      }
      shareParams.parameters = pageParams;
    }
    wantParams['atomicservice.param.key.shareInfo'] = shareParams;
  }

  handleShare(want: Want) {
    // 接收方：从want中获取自定义参数，用于后续实现页面的路由跳转
    const custShareParam = want?.parameters?.custShareParam as string;
    UtilLog.info(TAG, `shareParams: ${custShareParam}`);
    const shareParams: CustomShareParams = JSON.parse(custShareParam || '{}');
    if (shareParams?.goodsId) {
      const shareRouter: CustomShareParams = AppStorageV2.connect(CustomShareParams, () => new CustomShareParams())!;
      shareRouter.pageName = shareParams.pageName;
      shareRouter.goodsId = shareParams.goodsId;
      shareRouter.id = new Date().getTime();
    }
  }

  resolvePagePath(want: Want) {
    // 从want中获取传入的链接信息
    let uri = want?.uri;
    let parameters = want?.parameters;
    UtilLog.info(`uri is: ${uri}`);
    if (uri) {
      //解析通过router跳转的页面
      let storeInfoModel: StoreInfoModel = AppStorageV2.connect(StoreInfoModel, () => new StoreInfoModel())!
      storeInfoModel.storeId = want.parameters?.sid as string;
      UtilLog.info(`storeId is: ${storeInfoModel.storeId}`);
      // 桌号
      storeInfoModel.tableId = want.parameters?.tid as string;
      UtilLog.info(`tableId is: ${storeInfoModel.tableId}`);
      // 扫码进入清空购物车
      storeInfoModel.qrCodeFlag = true
    } else if (parameters?.url) {
      let formCardJump: FormCardJump = JSON.parse(parameters?.params.toString() || '');
      let formCard: FormCard = AppStorageV2.connect(FormCard, () => new FormCard())!
      if (formCardJump?.params) {
        formCard.id = new Date().getTime()
        formCard.orderId = formCardJump.params.orderId
        formCard.index = formCardJump.params.index
        formCard.url = parameters?.url as string
      }
    }
  }

  handleAppLink(want: Want) {
    let uri = want?.uri
    if (uri) {
      // 从链接中解析query参数，拿到参数后，开发者可根据自己的业务需求进行后续的处理。
      try {
       let pageUrl =  want.parameters?.action as string;
        const linkScanRouter: LinkScanModel = AppStorageV2.connect(LinkScanModel, () => new LinkScanModel())!;
        linkScanRouter.id = new Date().getTime().toString();
        linkScanRouter.pageUrl = pageUrl;
      } catch (error) {
        UtilLog.error(TAG, 'Failed to parse url. error: ' + JSON.stringify(error));
      }
    }
  }
};
