import { AbilityConstant, Configuration, UIAbility, Want } from '@kit.AbilityKit';
import { AppStorageV2, uiObserver as observer, window } from '@kit.ArkUI';
import { Logger, PreferencesUtil, GlobalContext, WindowModel } from 'commonlib';

const TAG: string = '[EntryAbility]';

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    Logger.info(TAG, 'onCreate');

    PreferencesUtil.createFontPreferences(this.context);
    // 设置字体默认大小
    PreferencesUtil.saveDefaultFontSize(0);
  }

  onDestroy(): void {
    Logger.info(TAG, 'onDestroy');
  }

  public onWindowStageCreate(windowStage: window.WindowStage): void {
    Logger.info(TAG, '%{public}s', 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/MainEntry', (err) => {
      if (err.code) {
        Logger.error(TAG, 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      Logger.info(TAG, 'Succeeded in loading the content.');
    });
  }

  // 适配深色模式
  onConfigurationUpdate(newConfig: Configuration): void {
    let windowModel: WindowModel = AppStorageV2.connect(WindowModel, () => new WindowModel())!;
    if (windowModel.currentColorMode !== newConfig.colorMode) {
      windowModel.currentColorMode = newConfig.colorMode
    }
  }
}
