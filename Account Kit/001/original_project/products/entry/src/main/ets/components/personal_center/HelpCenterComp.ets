import { AppStorageV2 } from '@kit.ArkUI';
import { callTelSheetBuilder } from 'base_ui';
import { BreakpointNameEnum, BreakpointType, Constants, RouterMap, RouterModule, StoreInfoModel } from 'common/Index';

@ComponentV2
export struct HelpCenterComp {
  @Param breakpoint: string = ''
  @Local storeModel: StoreInfoModel = AppStorageV2.connect(StoreInfoModel, () => new StoreInfoModel())!;
  @Local callTelSheet: boolean = false

  build() {
    Column() {
      Text('常用服务')
        .fontSize($r('sys.float.Subtitle_L'))
        .fontColor($r('sys.color.font_primary'))
        .fontWeight(FontWeight.Medium)
        .margin({ left: 12 })
      List() {
        ListItem() {
          Row() {
            Row() {
              SymbolGlyph($r('sys.symbol.info_circle'))
                .fontSize(24)
                .fontColor([$r('sys.color.icon_primary'), '#000000'])
              Text($r('app.string.faqs'))
                .fontSize($r('sys.float.Subtitle_M'))
                .fontWeight(FontWeight.Medium)
                .fontColor($r('sys.color.font_primary'))
                .margin({ left: 16 })
            }

            SymbolGlyph($r('sys.symbol.chevron_right')).fontSize(24).fontColor([$r('sys.color.icon_fourth'), '#000000'])
          }
          .width(Constants.FULL_SIZE)
          .padding({ top: 16, bottom: 16 })
          .justifyContent(FlexAlign.SpaceBetween)
          .onClick(() => {
            RouterModule.push(RouterMap.FREQUENT_QUESTION_PAGE)
          })
        }

        ListItem() {
          Row() {
            Row() {
              SymbolGlyph($r('sys.symbol.service')).fontSize(24).fontColor([$r('sys.color.icon_primary'), '#000000'])
              Text($r('app.string.customer_phone'))
                .fontSize($r('sys.float.Subtitle_M'))
                .fontWeight(FontWeight.Medium)
                .fontColor($r('sys.color.font_primary'))
                .margin({ left: 16 })
            }

            SymbolGlyph($r('sys.symbol.chevron_right')).fontSize(24).fontColor([$r('sys.color.icon_fourth'), '#000000'])
          }
          .width(Constants.FULL_SIZE)
          .padding({ top: 16, bottom: 16 })
          .justifyContent(FlexAlign.SpaceBetween)
          .onClick(() => {
            // 拨打商家电话
            this.callTelSheet = true
          })
          .bindSheet($$this.callTelSheet, callTelSheetBuilder(this.storeModel.storeInfo.tel || '', () => {
            this.callTelSheet = false
          }), {
            detents: [309, 310],
            backgroundColor: $r('sys.color.background_fourth'),
            blurStyle: BlurStyle.Thick,
            preferType: SheetType.CENTER,
            title: { title: $r('app.string.contact_us') },
          });
        }

      }
      .padding({
        left: 12,
        right: 12,
        top: 4,
        bottom: 4,
      })
      .margin({ top: 8 })
      .width(Constants.FULL_SIZE)
      .backgroundColor($r('sys.color.comp_background_list_card'))
      .borderRadius(20)
      .divider({ strokeWidth: 1, startMargin: 40 })
      .lanes(new BreakpointType<number>({
        [BreakpointNameEnum.SM]: 1,
        [BreakpointNameEnum.MD]: 2,
        [BreakpointNameEnum.LG]: 2,
        [BreakpointNameEnum.XL]: 2,
      }).getValue(this.breakpoint), 12)
      .edgeEffect(EdgeEffect.Spring, { alwaysEnabled: true })
      .enableScrollInteraction(false)
    }.margin({ top: 24 }).alignItems(HorizontalAlign.Start)
  }
}