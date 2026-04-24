import { RouterModule, UserInfoModel, Logger } from 'commonlib'
import { BaseTitle, GlobalDialog } from 'componentlib'
import { BusinessError } from '@kit.BasicServicesKit';
import { AppStorageV2, PersistenceV2 } from '@kit.ArkUI';
import { FunctionalButton, functionalButtonComponentManager } from '@kit.ScenarioFusionKit';
import { maskPhone } from '../utils/Util';
import { UserInfoStorage } from '../viewModels/MainPageVM';
import { saveAvatarToSandbox, getAvatarDisplayPath } from '../utils/AvatarUtil';


@Builder
export function userInfoSettingPageBuilder() {
  UserInfoSettingPage()
}

@ComponentV2
export struct UserInfoSettingPage {
  @Local userInfo: UserInfoModel = AppStorageV2.connect(UserInfoModel, () => new UserInfoModel())!;
  private filesDir: string = '';

  aboutToAppear(): void {
    this.filesDir = getContext(this).filesDir;
  }

  build() {
    NavDestination() {
      Column() {
        Column({space: 12}) {
          Column() {
            UserInfoItem({
              text: '头像',
              rightBuilder: () => {
                this.AvatarRightView()
              }
            })
          }
          .width('100%')
          .backgroundColor($r('sys.color.white'))
          .padding({left: 12, right: 12 })
          .borderRadius(16)

          Column({space: 12}) {
            UserInfoItem({
              text: '昵称',
              rightBuilder: () => {
                this.UserNameRightView()
              }
            })

            Divider().strokeWidth(0.5).color($r('sys.color.ohos_id_color_button_divider'))

            UserInfoItem({
              text: '电话',
              rightBuilder: () => {
                this.PhoneRightView()
              }
            })
          }
          .width('100%')
          .backgroundColor($r('sys.color.white'))
          .padding({left: 12, right:12, top:18, bottom: 18})
          .borderRadius(16)
        }
        .padding({left: 16, top: 12, right: 16})
      }
      .width('100%')
      .height('100%')
    }
    .title('个人信息')
    .backgroundColor('#fff5f3f3')
  }

  @Builder
  AvatarRightView() {
    Row({space: 4}) {
      FunctionalButton({
        params: {
          openType: functionalButtonComponentManager.OpenType.CHOOSE_AVATAR,
          label: '',
          styleOption: {
            styleConfig: new functionalButtonComponentManager.ButtonConfig()
              .type(ButtonType.Normal)
              .backgroundImage(getAvatarDisplayPath(this.userInfo.avatar))
              .backgroundImageSize(ImageSize.Cover)
              .width(40)
              .height(40)
              .borderRadius(20)
              .backgroundColor('#E5E5E5')
          },
        },
        controller: new functionalButtonComponentManager.FunctionalButtonController().onChooseAvatar((err, data) => {
          if (err) {
            Logger.error('[UserInfoSettingPage]', 'Choose avatar error: ' + err.message);
            return;
          }
          const avatarUri = data.avatarUri;
          if (avatarUri) {
            const sandboxPath = saveAvatarToSandbox(avatarUri, this.filesDir);
            if (sandboxPath) {
              this.userInfo.avatar = sandboxPath;
            }
          }
        })
      })
      Image($r('app.media.right_arrow'))
        .width(24)
        .height(24)
        .fillColor($r('sys.color.ohos_id_color_text_tertiary'))
    }
  }
  @Builder
  UserNameRightView() {
    Row({space: 4}) {
      Text(this.userInfo.name)
        .fontSize(14).fontWeight(FontWeight.Regular)
        .fontColor('#99000000')
      Image($r('app.media.right_arrow'))
        .width(24)
        .height(24)
        .fillColor($r('sys.color.ohos_id_color_text_tertiary'))
    }
    .onClick(() => {
      GlobalDialog.showDialogWithInputBox({
        hint: '修改昵称',
        content: this.userInfo.name,
        textLength: 10,
        placeholder: '请输入昵称',
        but1Name: '取消',
        but2Name: '确定',
        onConfirm: (value?: string) => {
          this.userInfo.name = value ?? ''
          GlobalDialog.close()
        },
        onCancel: () => {
          GlobalDialog.close()
        }
      })
    })
  }
  @Builder
  PhoneRightView() {
    Text(maskPhone(this.userInfo.phoneNumber))
      .fontSize(14).fontWeight(FontWeight.Regular)
      .fontColor('#99000000')
  }
}

@ComponentV2
struct UserInfoItem {
  @Param text: string = ''
  @Builder
  rightViewBuilder() {
  };
  @BuilderParam rightBuilder: () => void = this.rightViewBuilder;

  build() {
    Row() {
      Text(this.text).fontSize(16).fontWeight(FontWeight.Medium)

      this.rightBuilder()
    }
    .width('100%')
    .justifyContent(FlexAlign.SpaceBetween)
    .backgroundColor($r('sys.color.white'))
    .padding({top: 12, bottom: 12 })
  }
}