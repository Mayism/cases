import { AlertDialog } from '@kit.ArkUI';
import { Constants, ContextUtils, Logger, LoginButtonText, LoginUtils, RouterMap, RouterUtil } from 'lib_common';
import { MinePageViewModel } from '../viewmodel/MinePageViewModel';

const TAG = '[UserInfoComp]';

@ComponentV2
export struct UserInfoComp {
  @Param @Require vm: MinePageViewModel;
  dialogControllerConfirm: CustomDialogController = new CustomDialogController({
    builder: AlertDialog({
      primaryTitle: '账号解除关联',
      secondaryTitle: '',
      content: '请确认是否解除账号关联？',
      primaryButton: {
        value: '取消',
        action: () => {
        },
      },
      secondaryButton: {
        value: '确定',
        action: () => {
          Logger.info(TAG, 'Callback when the second button is clicked');
          LoginUtils.cancelRelative();
        }
      },
    }),
  })

  @Computed
  get avatarUri(): string {
    return `file://${ContextUtils.globalContext.filesDir}/${this.vm.userIconInfo.userIconPath}`
  }

  build() {
    Row({ space: 8 }) {
      Row() {
        if (this.vm.userInfo.isRelative) {
          Image(this.vm.userIconInfo.isSaved ? this.avatarUri : $r('app.media.ic_user_img'))
            .width(48)
            .height(48)
            .borderRadius(50)
          Column({ space: 8 }) {
            Text(this.vm.userInfo.userInfo.name)
              .fontSize(16)
              .fontWeight(500)
              .fontColor($r('sys.color.font_primary'))
              .textAlign(TextAlign.Start)
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
            Row() {
              Image($r('app.media.ic_phone')).width(16)
              Text(this.vm.userInfo.getTel())
                .fontSize(12)
                .fontColor($r('sys.color.font_secondary'))
                .margin({ left: 8 })
            }
          }
          .alignItems(HorizontalAlign.Start)
          .margin({ left: 8 })
        } else {
          Image($r('app.media.default_hd'))
            .width(48)
            .height(48)
            .borderRadius(50)
          Column() {
            Text('华为用户')
              .fontSize(16)
              .fontWeight(500)
              .fontColor($r('sys.color.font_secondary'))
          }
          .alignItems(HorizontalAlign.Start)
          .margin({ left: 8 })
        }
      }
      .constraintSize({ maxWidth: 'calc(100% - 150vp)' })
      .onClick(() => {
        if (this.vm.userInfo.isRelative) {
          RouterUtil.pushPathByName(RouterMap.USER_INFO_PAGE)
        } else {
          ContextUtils.showToast({ message: $r('app.string.no_relative_account_msg') });
        }
      })

      Row({ space: 4 }) {
        Image(this.vm.userInfo.isRelative ? $r('app.media.ic_connect') : $r('app.media.ic_no_connect'))
          .width(16)
          .height(16)
        if (this.vm.userInfo.isRelative) {
          Text($r('app.string.disassociate'))
            .fontSize($r('sys.float.Body_M'))
            .fontColor($r('sys.color.font_on_primary'))
        } else {
          LoginButtonText({ label: $r('app.string.associate_account') })
        }
      }
      .padding({
        top: 4,
        bottom: 4,
        right: 8,
        left: 8,
      })
      .borderRadius(14)
      .backgroundColor(this.vm.userInfo.isRelative ? '#64BB5C' : $r('sys.color.background_tertiary'))
      .onClick(() => {
        if (this.vm.userInfo.isRelative) {
          this.dialogControllerConfirm.open();
        }
      })
    }
    .width(Constants.FULL_SIZE)
    .justifyContent(FlexAlign.SpaceBetween)
    .alignItems(VerticalAlign.Bottom)
    .borderRadius(16)
    .backgroundColor($r('sys.color.background_primary'))
    .padding({
      left: 12,
      right: 12,
      top: 16,
      bottom: 16
    })
  }
}