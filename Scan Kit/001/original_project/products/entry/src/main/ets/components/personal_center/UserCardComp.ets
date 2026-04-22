import { ToastDialog as promptAction } from '@hw-agconnect/ui-toast';
import { UtilLog } from '@hw-agconnect/util-log';
import { authentication } from '@kit.AccountKit';
import { util } from '@kit.ArkTS';
import { PersistenceV2 } from '@kit.ArkUI';
import { BusinessError, emitter } from '@kit.BasicServicesKit';
import { FunctionalButton, functionalButtonComponentManager } from '@kit.ScenarioFusionKit';
import fs from '@ohos.file.fs';
import {
  Constants,
  EmitterEvent,
  LoadingDialogUtil,
  RouterMap,
  RouterModule,
  UserIconModel,
  UserInfoModel,
  WindowUtil,
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
        if (this.userInfoModel.isRelative) {
          Row({ space: 4 }) {
            SymbolGlyph($r('sys.symbol.link_slash'))
              .fontSize(16)
              .fontColor(['#FFFFFF', '#E6FFFFFF'])
            Text($r('app.string.disassociate'))
              .fontSize($r('sys.float.Body_M'))
              .fontSize($r('sys.float.Body_M'))
              .fontWeight(FontWeight.Medium)
              .fontColor($r('sys.color.font_on_primary'))
              .height(20)
          }
          .padding({
            left: 8,
            right: 8,
            top: 4,
            bottom: 4,
          })
          .borderRadius(14)
          .backgroundColor(this.userInfoModel.isRelative ? $r('sys.color.multi_color_09') :
            $r('sys.color.background_secondary'))
          .onClick(() => {
            RouterModule.push<Record<string, string>>(RouterMap.CONFIRM_DIALOG,
              { 'title': '账号解除关联', 'message': '请确认是否解除账号关联？' },
              async (value) => {
                const result = value.result as Record<string, boolean>;
                if (result.param) {
                  this.cancelRelative()
                }
              });
          })
        } else {
          Stack() {
            SymbolGlyph($r('sys.symbol.link'))
              .fontSize(16)
              .fontColor([$r('sys.color.icon_secondary'), '#000000'])
            FunctionalButton({
              params: {
                // OpenType.GET_PHONE_NUMBER表示该按钮用于快速验证手机号码。
                openType: functionalButtonComponentManager.OpenType.GET_PHONE_NUMBER,
                label: $r('app.string.associate_account'),
                // 调整按钮样式。
                styleOption: {
                  styleConfig: new functionalButtonComponentManager.ButtonConfig()
                    .fontSize($r('sys.float.Body_M'))
                    .fontColor($r('sys.color.font_primary'))
                    .backgroundColor('#00000000')
                    .height(20)
                    .padding(0)
                    .align(Alignment.End),
                },
              },
              // 当OpenType为GET_PHONE_NUMBER时，回调必须为onGetPhoneNumber。
              controller: new functionalButtonComponentManager.FunctionalButtonController()
                .onGetPhoneNumber((err, data) => {
                  if (err) {
                    // 错误日志处理。
                    UtilLog.error(TAG, 'error: %{public}d %{public}s', err.code, err.message);
                    // todo 未获取权限时模拟登录成功
                    this.bindPhoneMock()
                    return;
                  }
                  // 成功日志处理。
                  UtilLog.info(TAG, 'succeeded in authenticating');
                  // 授权码处理。
                  let authorizationCode = data.code;
                  LoadingDialogUtil.openLoadingDialog()
                  if (authorizationCode) {
                    this.login(authorizationCode)
                  } else {
                    promptAction.showToast({ message: '账号关联失败' })
                    LoadingDialogUtil.close()
                  }
                }),
            })
              .margin({ left: 20 })
              .zIndex(1)
          }
          .alignContent(Alignment.Start)
          .padding({
            left: 8,
            right: 8,
            top: 4,
            bottom: 4,
          })
          .borderRadius(14)
          .backgroundColor($r('sys.color.background_secondary'))
        }
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

  cancelRelative() {
    // 创建取消授权请求，并设置参数
    const cancelRequest = new authentication.HuaweiIDProvider().createCancelAuthorizationRequest();
    cancelRequest.state = util.generateRandomUUID(); // 建议使用generateRandomUUID生成state

    // 执行取消授权请求，并处理结果
    try {
      const controller = new authentication.AuthenticationController(this.getUIContext().getHostContext());
      controller.executeRequest(cancelRequest, (error: BusinessError<Object>, data) => {
        // todo 这里可以补充关联失败异常场景，模板为了体验流程暂未处理
        UtilLog.info(TAG, 'Succeeded in canceling.');
        API.getCancelLogin().then(() => {
          this.userInfoModel.isRelative = false
          this.userInfoModel.userInfo.userTel = ''
        })
      });
    } catch (error) {
      this.dealAllError(error);
    }
  }

  // 错误处理
  dealAllError(error: BusinessError<Object>): void {
    UtilLog.error(TAG, `Failed to login, errorCode is ${error.code}, errorMessage is ${error.message}`);
    promptAction.showToast({ message: '账号关联失败' })
  }

  login(code: string) {
    API.getOpenLoginHm(encodeURIComponent(code)).then((res) => {
      let tel = res.userTel ?? ''
      this.userInfoModel.userInfo.userTel =
        `${tel.substring(0, tel.length - 8)}****${tel.substring(tel.length - 4)}`
      this.userInfoModel.isRelative = true
      if (!code) {
        promptAction.showToast({ message: '手机号绑定成功！当前手机号为mock数据，非华为账号真实手机号' });
      }
    }).catch(() => {
      promptAction.showToast({ message: '账号关联失败' })
    }).finally(() => {
      LoadingDialogUtil.close()
    })
  }

  async bindPhoneMock() {
    RouterModule.push<Record<string, string>>(RouterMap.CONFIRM_DIALOG,
      { 'title': '提示', 'message': '元服务未获取phone权限或用户授权，点击确定将根据openId创建一个mock账号。' },
      async (value) => {
        const result = value.result as Record<string, boolean>;
        if (result.param) {
          this.login('')
        }
      });
  }

  getUserInfo() {
    API.getUserInfo().then((resp: UserInfoResp) => {
      this.userInfoModel.userInfo.totalScore = resp.totalScore;
      this.userInfoModel.userInfo.wallet = resp.wallet;
    })
  }
}
