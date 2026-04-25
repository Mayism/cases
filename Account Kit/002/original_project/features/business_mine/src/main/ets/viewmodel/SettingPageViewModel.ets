import { AppStorageV2 } from '@kit.ArkUI';
import { FileUtils, Logger, UserInfoModel, WindowModel } from 'lib_common';

const TAG = '[SettingPageViewModel]';

@ObservedV2
export class SettingPageViewModel {
  @Trace userInfo: UserInfoModel = AppStorageV2.connect(UserInfoModel, () => new UserInfoModel())!;
  @Trace windowModel: WindowModel = AppStorageV2.connect(WindowModel, () => new WindowModel())!;
  @Trace cacheSize: number = 100;

  clearCache(context: UIContext) {
    try {
      context.getPromptAction().showDialog({
        title: '温馨提示',
        message: '缓存清除后不可恢复！',
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
          let cacheDir = context.getHostContext()!.cacheDir;
          FileUtils.clearCache(cacheDir);
          context.getPromptAction().showToast({ message: '缓存已清除' });
        }
      });
    } catch (e) {
      Logger.error(TAG, `clearCache fail. Code: ${e.code}, message: ${e.message}`);
    }
  }
}