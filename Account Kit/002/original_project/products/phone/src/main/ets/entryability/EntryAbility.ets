import { AbilityConstant, bundleManager, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import { AppStorageV2, ThemeControl, window } from '@kit.ArkUI';
import { AppInfoModel, ContextUtils, FormCardJump, Logger, WindowModel } from 'lib_common';
import { gAppTheme } from '../common/AppTheme';

const TAG: string = '[EntryAbility]';

export default class EntryAbility extends UIAbility {
  async onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): Promise<void> {
    Logger.info(TAG, 'Ability onCreate');
    this.getAppInfo();
    this.resolvePagePath(want);
  }

  onDestroy(): void {
    Logger.info(TAG, 'Ability onDestroy');
    this.offAvoidAreaChange();
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    Logger.info(TAG, 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/Index', async (err) => {
      if (err.code) {
        Logger.error(TAG, 'Failed to load the content. Cause: ' + JSON.stringify(err));
        return;
      }
      Logger.info(TAG, 'Succeeded in loading the content.');
      this.setUIContext(windowStage);
      this.setWinConfig(windowStage);
      this.onAvoidAreaChange(windowStage);
      this.setAppTheme();
      this.setColorMode();
    });
  }

  onNewWant(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    this.resolvePagePath(want);
  }

  onAvoidAreaChange(windowStage: window.WindowStage) {
    try {
      let windowClass: window.Window = windowStage.getMainWindowSync();
      windowClass.on('avoidAreaChange', () => {
        this.setAvoidArea(windowClass);
      });
    } catch (e) {
      Logger.error(TAG, 'Failed to onAvoidAreaChange. Cause: ' + JSON.stringify(e));
    }

  }

  offAvoidAreaChange() {
    try {
      let windowStage = AppStorage.get('windowStage') as window.WindowStage;
      if (windowStage) {
        windowStage.getMainWindowSync().off('avoidAreaChange');
      }
    } catch (e) {
      Logger.error(TAG, 'Failed to offAvoidAreaChange. Cause: ' + JSON.stringify(e));
    }
  }

  setUIContext(windowStage: window.WindowStage) {
    try {
      ContextUtils.setUIContext(windowStage.getMainWindowSync().getUIContext())
    } catch (e) {
      Logger.error(TAG, 'setUIContext fail. Cause: ' + JSON.stringify(e));
    }
  }

  async setWinConfig(windowStage: window.WindowStage) {
    try {
      AppStorage.setOrCreate('windowStage', windowStage);
      let windowClass: window.Window = windowStage.getMainWindowSync();
      await windowClass.setWindowLayoutFullScreen(true);
      this.setAvoidArea(windowClass);
    } catch (e) {
      Logger.error(TAG, `setWinConfig fail. Code: ${e.code}, message: ${e.message}`);
    }
  }

  setAppTheme() {
    ThemeControl.setDefaultTheme(gAppTheme);
  }

  setColorMode() {
    try {
      this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT);
    } catch (e) {
      Logger.error(TAG, `setColorMode fail. Code: ${e.code}, message: ${e.message}`);
    }
  }

  setAvoidArea(windowClass: window.Window) {
    try {
      let windowModel: WindowModel = AppStorageV2.connect(WindowModel, () => new WindowModel())!;
      let type = window.AvoidAreaType.TYPE_SYSTEM;
      let avoidArea = windowClass.getWindowAvoidArea(type);
      windowModel.windowTopHeight = ContextUtils.globalUIContext.px2vp(avoidArea.topRect.height);
      type = window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR;
      avoidArea = windowClass.getWindowAvoidArea(type);
      windowModel.windowBottomHeight = ContextUtils.globalUIContext.px2vp(avoidArea.bottomRect.height);
    } catch (e) {
      Logger.error(TAG, `setAvoidArea fail. Code: ${e.code}, message: ${e.message}`);
    }
  }

  resolvePagePath(want: Want) {
    let parameters = want?.parameters;
    if (parameters?.url) {
      let formCardJump: FormCardJump = AppStorageV2.connect(FormCardJump, () => new FormCardJump())!;
      formCardJump.form = JSON.parse(parameters?.params.toString() || '');
      formCardJump.form.id = new Date().getTime()
    }
  }

  getAppInfo() {
    try {
      // 获取应用信息
      let bundleInfo = bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_HAP_MODULE |
      bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_ABILITY |
      bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_REQUESTED_PERMISSION);
      let appInfo: AppInfoModel = AppStorageV2.connect(AppInfoModel, () => new AppInfoModel())!;
      appInfo.packageName = bundleInfo.name;
      Logger.info(TAG, `packageName: ${JSON.stringify(bundleInfo.name)}.`);
    } catch (e) {
      Logger.error(TAG, `getBundleInfoForSelfSync fail. Code: ${e.code}, message: ${e.message}`);
    }
  }
};
