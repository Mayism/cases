import { Constants, NavHeaderBar, RemarksRouter, RouterMap, RouterModule, StoreInfoModel } from 'common/Index';
import { AppStorageV2 } from '@kit.ArkUI';

@Builder
export function RemarksPageBuilder() {
  RemarksPage()
}

@ComponentV2
struct RemarksPage {
  @Local storeModel: StoreInfoModel = AppStorageV2.connect(StoreInfoModel, () => new StoreInfoModel())!;
  @Local tastes: Array<string> = []
  @Local remarks: string = ''

  aboutToAppear(): void {
    this.getParams()
    let tasteArr = this.storeModel.storeInfo.taste?.split(/[;；]/)
    if (tasteArr?.length) {
      this.tastes = tasteArr
    }
  }

  getParams() {
    let params = RouterModule.getNavParam<RemarksRouter>(RouterMap.REMARKS_PAGE)
    if (params) {
      this.remarks = params.remarks ?? ''
    }
  }

  build() {
    NavDestination() {
      NavHeaderBar({ title: $r('app.string.order_remark') })
      Column() {
        Column() {
          Column() {
            TextArea({ text: $$this.remarks, placeholder: $r('app.string.input_remark_info') })
              .height(98)
              .placeholderFont({ size: $r('sys.float.Body_S') })
              .placeholderColor($r('sys.color.font_tertiary'))
              .width(Constants.FULL_SIZE)
              .maxLength(100)
            Text($r('app.string.remark_count_show', this.remarks.length))
              .fontSize($r('sys.float.Caption_M'))
              .fontColor($r('sys.color.font_secondary'))
              .margin({ top: 8, right: 4 })
          }
          .alignItems(HorizontalAlign.End)
          .backgroundColor($r('sys.color.background_primary'))
          .padding(12)
          .borderRadius(12)

          if (this.tastes.length) {
            Text($r('app.string.quick_input'))
              .fontSize($r('sys.float.Body_M'))
              .fontColor($r('sys.color.font_primary'))
              .fontWeight(FontWeight.Medium)
              .margin({ top: 12 })
            Flex({ wrap: FlexWrap.Wrap }) {
              ForEach(this.tastes, (item: string) => {
                Row() {
                  Text(item).fontSize($r('sys.float.Caption_M')).fontColor($r('sys.color.font_primary'))
                }
                .padding({
                  left: 12,
                  right: 12,
                  top: 8,
                  bottom: 8,
                })
                .margin({ right: 8, bottom: 8 })
                .borderRadius(16)
                .backgroundColor($r('sys.color.comp_background_tertiary'))
                .onClick(() => {
                  if (this.remarks.length < 100) {
                    this.remarks = `${this.remarks} ${item}`
                  }
                })
              }, (item: string) => item)
            }.margin({ top: 14 })
          }
        }.alignItems(HorizontalAlign.Start).layoutWeight(1)

        Button($r('app.string.save'))
          .fontSize($r('sys.float.Body_M'))
          .fontWeight(FontWeight.Medium)
          .width(Constants.FULL_SIZE)
          .fontColor($r('sys.color.font_on_primary'))
          .padding({
            top: 8,
            bottom: 8,
          })
          .margin({ left: 2, right: 2 })
          .constraintSize({ maxWidth: Constants.FULL_SIZE })
          .backgroundColor($r('sys.color.multi_color_09'))
          .onClick(() => {
            RouterModule.pop({ 'remarks': this.remarks } as Record<string, string>)
          })
      }
      .width(Constants.FULL_SIZE)
      .layoutWeight(1)
      .backgroundColor('#F1F3F5')
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({
        left: 12,
        right: 12,
        top: 12,
        bottom: 34,
      })
      .constraintSize({ maxWidth: Constants.FULL_SIZE })

    }.hideTitleBar(true)
  }
}
