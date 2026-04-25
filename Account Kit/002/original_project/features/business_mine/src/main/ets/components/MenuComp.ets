import { CallTelSheetBuilder, Constants, RouterMap, RouterUtil } from 'lib_common';
import { MinePageViewModel } from '../viewmodel/MinePageViewModel';

@ComponentV2
export struct MenuComp {
  @Param @Require vm: MinePageViewModel

  build() {
    Column() {
      Row() {
        Row() {
          Image($r('app.media.ic_setting')).width(24).height(24)
          Text($r('app.string.setting'))
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .fontColor($r('sys.color.font_primary'))
            .margin({ left: 8 })
        }

        Image($r('app.media.ic_right')).width(16).fillColor('#999999')
      }
      .width(Constants.FULL_SIZE)
      .height(40)
      .justifyContent(FlexAlign.SpaceBetween)
      .onClick(() => {
        RouterUtil.pushPathByName(RouterMap.SETTING_PAGE)
      })

      Divider().margin({ left: 32, bottom: 12 })
      Row() {
        Row() {
          Image($r('app.media.ic_contact_us')).width(24).height(24)
          Text($r('app.string.contact_us'))
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .fontColor($r('sys.color.font_primary'))
            .margin({ left: 8 })
        }

        Image($r('app.media.ic_right')).width(16).fillColor('#999999')
      }
      .width(Constants.FULL_SIZE)
      .height(40)
      .justifyContent(FlexAlign.SpaceBetween)
      .onClick(() => {
        // 拨打商家电话
        this.vm.callTelSheet = true
      })

      Divider().margin({ left: 32 })
    }
    .width(Constants.FULL_SIZE)
    .constraintSize({ maxWidth: Constants.FULL_SIZE })
    .borderRadius(12)
    .padding({
      top: 12,
      bottom: 12,
      left: 8,
      right: 8,
    })
    .backgroundColor($r('sys.color.background_primary'))
    .bindSheet($$this.vm.callTelSheet, CallTelSheetBuilder(this.vm.mallModel.shoppingMall.tel, () => {
      this.vm.closeTelSheet()
    }), {
      height: SheetSize.FIT_CONTENT,
      showClose: false,
      preferType: SheetType.CENTER,
    });
  }
}