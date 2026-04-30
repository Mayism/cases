import { window } from '@kit.ArkUI';
import { FunctionalButton, functionalButtonComponentManager } from '@kit.ScenarioFusionKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { Constants, ContextUtils, Logger, NavHeaderBar, SheetHeaderComp } from 'lib_common';
import { UserInfoViewModel } from '../viewmodel/UserInfoViewModel';

const TAG = '[UserInfoPage]';

@Builder
export function UserInfoPageBuilder() {
  UserInfoPage()
}

@ComponentV2
struct UserInfoPage {
  @Local vm: UserInfoViewModel = new UserInfoViewModel();
  @Local keyHeight: number = 0;

  @Computed
  get avatarUri(): string {
    return `file://${ContextUtils.globalContext.filesDir}/${this.vm.userIconInfo.userIconPath}`
  }

  aboutToAppear(): void {
    window.getLastWindow(ContextUtils.globalContext).then(currentWindow => {
      currentWindow.on('avoidAreaChange', this.cb);
    }).catch((e: BusinessError) => {
      Logger.error(TAG, `getLastWindow fail. Code: ${e.code}, message: ${e.message}`);
    });
  }

  aboutToDisappear(): void {
    window.getLastWindow(ContextUtils.globalContext).then(currentWindow => {
      currentWindow.off('avoidAreaChange', this.cb);
    }).catch((e: BusinessError) => {
      Logger.error(TAG, `getLastWindow fail. Code: ${e.code}, message: ${e.message}`);
    });
  }

  cb: (data: window.AvoidAreaOptions) => void = (data) => {
    if (data.type === window.AvoidAreaType.TYPE_KEYBOARD) {
      this.keyHeight = this.getUIContext().px2vp(data.area.bottomRect.height);
    }
  }

  @Styles
  cardStyle(){
    .width(Constants.FULL_SIZE)
    .borderRadius(16)
    .padding(12)
    .backgroundColor($r('sys.color.background_primary'))
  }

  build() {
    NavDestination() {
      NavHeaderBar({ title: $r('app.string.personal_info') })
      Scroll() {
        Column({ space: 12 }) {
          Row() {
            Text('头像').fontSize(16).fontWeight(FontWeight.Medium).fontColor($r('sys.color.font_primary'))
            Row() {
              FunctionalButton({
                params: {
                  // OpenType.CHOOSE_AVATAR表示Button为选择头像类型
                  openType: functionalButtonComponentManager.OpenType.CHOOSE_AVATAR,
                  label: '',
                  // 调整Button样式
                  styleOption: {
                    styleConfig: new functionalButtonComponentManager.ButtonConfig()
                      .type(ButtonType.Normal)
                      .backgroundImage(this.vm.userIconInfo.isSaved ? this.avatarUri : $r('app.media.ic_user_img'))
                      .backgroundImageSize(ImageSize.Cover)
                      .width(40)
                      .height(40)
                      .borderRadius(50)
                      .backgroundColor('#E5E5E5'),
                  },
                },
                // OpenType为“CHOOSE_AVATAR”时，回调必须选择“onChooseAvatar”
                controller: new functionalButtonComponentManager.FunctionalButtonController().onChooseAvatar((err,
                  data) => {
                  if (err) {
                    Logger.error(TAG, 'onChooseAvatar error: ' + JSON.stringify(err));
                    return;
                  }
                  Logger.info(TAG, 'succeeded in choosing avatar');
                  this.vm.saveIcon(data)
                }),
              })
              Image($r('app.media.ic_right')).width(16).fillColor('#999999')
            }
          }
          .width(Constants.FULL_SIZE)
          .borderRadius(16)
          .padding(12)
          .backgroundColor($r('sys.color.background_primary'))
          .justifyContent(FlexAlign.SpaceBetween)

          Column() {
            Row() {
              Text($r('app.string.nickname')).fontSize(16).fontColor($r('sys.color.font_primary'))
              Row() {
                Text(this.vm.userInfo.userInfo.name)
                  .fontSize(14)
                  .fontColor($r('sys.color.font_secondary'))
                  .constraintSize({ maxWidth: '80%' })
                Image($r('app.media.ic_modify')).width(24).height(24).margin({ left: 4 })
              }.onClick(() => {
                this.vm.nickName = this.vm.userInfo.userInfo.name
                this.vm.showSheet = true
              })
            }
            .width(Constants.FULL_SIZE)
            .height(58)
            .justifyContent(FlexAlign.SpaceBetween)
            .bindSheet($$this.vm.showSheet, this.modifyNameSheet(), {
              height: SheetSize.FIT_CONTENT,
              preferType: SheetType.CENTER,
              backgroundColor: $r('sys.color.background_secondary'),
              showClose: false,
            });

            Divider()
            Row() {
              Text('电话').fontSize(16).fontColor($r('sys.color.font_primary'))
              Text('130****0505').fontSize(14).fontColor($r('sys.color.font_secondary'))
            }.width(Constants.FULL_SIZE).height(58).justifyContent(FlexAlign.SpaceBetween)
          }.width(Constants.FULL_SIZE)
          .borderRadius(16)
          .padding({ left: 12, right: 12 })
          .backgroundColor($r('sys.color.background_primary'))
        }.padding({ top: 12, left: Constants.BORDER_WIDTH, right: Constants.BORDER_WIDTH })
      }
      .align(Alignment.Top)
      .scrollBar(BarState.Off)
      .edgeEffect(EdgeEffect.Spring)
    }.hideTitleBar(true).backgroundColor($r('sys.color.background_secondary'))
  }

  @Builder
  modifyNameSheet() {
    Column() {
      SheetHeaderComp({
        title: '设置昵称', close: () => {
          this.vm.showSheet = false
        },
      })

      Column() {
        TextInput({ text: $$this.vm.nickName })
          .fontSize(16)
          .fontColor($r('sys.color.font_primary'))
          .backgroundColor($r('sys.color.comp_background_primary'))
          .cancelButton({ style: CancelButtonStyle.INPUT, icon: { size: 16 } })
          .maxLength(20)
          .showCounter(true)
          .height(40)
          .margin({ top: 12 })
        Column() {
          Button('确定')
            .fontSize($r('sys.float.Body_L'))
            .fontWeight(FontWeight.Medium)
            .fontColor($r('sys.color.font_on_primary'))
            .backgroundColor($r('app.color.app_theme'))
            .width('100%')
            .onClick(() => {
              if (!this.vm.nickName) {
                ContextUtils.showToast({ message: '昵称不能为空' });
                return
              }
              this.vm.userInfo.userInfo.name = this.vm.nickName
              this.vm.showSheet = false
            })
        }
        .padding({ left: 12, right: 12, bottom: this.keyHeight })
      }
      .layoutWeight(1)
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .width(Constants.FULL_SIZE)
    .height(600)
    .padding({ left: Constants.BORDER_WIDTH, right: Constants.BORDER_WIDTH, bottom: 28 })
    .backgroundColor($r('sys.color.background_secondary'))
  }
}
