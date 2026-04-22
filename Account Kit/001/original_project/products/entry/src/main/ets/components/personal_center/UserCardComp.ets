import { UtilLog } from '@hw-agconnect/util-log';
import { util } from '@kit.ArkTS';
import { PersistenceV2 } from '@kit.ArkUI';
import { BusinessError, emitter } from '@kit.BasicServicesKit';
import { FunctionalButton, functionalButtonComponentManager } from '@kit.ScenarioFusionKit';
import fs from '@ohos.file.fs';
import {
  Constants, EmitterEvent, UserIconModel, UserInfoModel, WindowUtil
} from 'common/Index';
import { UserInfoResp } from 'network';
import * as API from '../../api/Index';

const TAG = '[UserCardComp]'

@ComponentV2
export struct UserCardComp {
  @Local userInfoModel: UserInfoModel = PersistenceV2.connect(UserInfoModel, () => new UserInfoModel())!;
  @Local userIconInfo: UserIconModel = PersistenceV2.connect(UserIconModel, () => new UserIconModel())!;

  @Computed
  get avatarUri(): ResourceStr {
    return this.userIconInfo.isSaved ?
      `file://${WindowUtil.globalUIAbilityContext.filesDir}/${this.userIconInfo.userIconPath}` :
      $r('app.media.ic_default_relative')
  }

  aboutToAppear(): void {
    try {
      emitter.on(EmitterEvent.REFRESH_MINE, () => {
        this.getUserInfo()
      })
    } catch (e) {
      UtilLog.error(TAG, `emitter on failed.`, e)
    }
  }

  build() {
    Row() {
      Row() {
        if (this.userInfoModel.isRelative) {
          FunctionalButton({
            params: {
              // OpenType.CHOOSE_AVATAR表示Button为选择头像类型
              openType: functionalButtonComponentManager.OpenType.CHOOSE_AVATAR,
              label: '',
              // 调整Button样式
              styleOption: {
                styleConfig: new functionalButtonComponentManager.ButtonConfig()
                  .type(ButtonType.Normal)
                  .backgroundImage(this.avatarUri)
                  .backgroundImageSize(ImageSize.Cover)
                  .width(48)
                  .height(48)
                  .borderRadius(24)
                  .backgroundColor('#E5E5E5'),
              },
            },
            // OpenType为“CHOOSE_AVATAR”时，回调必须选择“onChooseAvatar”
            controller: new functionalButtonComponentManager.FunctionalButtonController().onChooseAvatar((err,
              data) => {
              if (err) {
                // 错误日志处理
                UtilLog.error(TAG, 'error： %{public}d %{public}s', err.code, err.message);
                return;
              }
              // 成功日志处理
              UtilLog.info(TAG, 'succeeded in choosing avatar');
              let file: fs.File = null!;
              try {
                file = fs.openSync(data.avatarUri, fs.OpenMode.READ_ONLY)
                if (!file) {
                  this.getUIContext().getPromptAction().showToast({ message: $r('app.string.replace_header_failed') })
                  return
                }
                this.userIconInfo.userIconPath = `${util.generateRandomUUID(false)}.jpg`
                let imagePath = `${WindowUtil.globalUIAbilityContext.filesDir}/${this.userIconInfo.userIconPath}`
                fs.copyFileSync(file.fd, imagePath)
                this.userIconInfo.isSaved = true
              } catch (error) {
                let err: BusinessError = error as BusinessError;
                UtilLog.error(TAG, `PhotoViewPicker failed with err: ${err.code}, ${err.message}`);
              } finally {
                if (file) {
                  fs.closeSync(file);
                }
              }
            }),
          })
        } else {
          Image($r('app.media.ic_default_hd'))
            .width(48)
            .height(48)
            .borderRadius(24)
        }

        Column() {
          if (this.userInfoModel.isRelative) {
            Text(this.userInfoModel.userInfo.name)
              .fontSize($r('sys.float.Subtitle_L'))
              .fontWeight(FontWeight.Medium)
              .fontColor($r('sys.color.font_primary'))

            Row() {
              Image($r('app.media.icon_phone')).width(16)
              Text(this.userInfoModel.getTel())
                .fontSize($r('sys.float.Body_M'))
                .fontColor($r('sys.color.font_secondary'))
                .margin({ left: 2 })
            }.margin({ top: 12, left: 1 })
          } else {
            Text($r('app.string.no_relative')).fontSize($r('sys.float.Subtitle_L'))
              .fontWeight(FontWeight.Medium)
              .fontColor($r('sys.color.font_primary'))
          }
        }
        .alignItems(HorizontalAlign.Start)
        .margin({ left: 12 })
      }

      Column() {
        // todo 关联账号和取消关联
      }
      .height(Constants.FULL_SIZE)
      .justifyContent(FlexAlign.End)
    }
    .width(Constants.FULL_SIZE)
    .justifyContent(FlexAlign.SpaceBetween)
    .height(72)
    .backgroundColor($r('sys.color.background_primary'))
    .borderRadius(16)
    .padding(12)
  }

  getUserInfo() {
    API.getUserInfo().then((resp: UserInfoResp) => {
      this.userInfoModel.userInfo.totalScore = resp.totalScore;
      this.userInfoModel.userInfo.wallet = resp.wallet;
    })
  }
}
