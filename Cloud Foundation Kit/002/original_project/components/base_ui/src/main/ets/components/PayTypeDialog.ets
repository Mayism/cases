import { BIND_SHEET_STYLE } from '../constants/Styles'

@Builder
export function paySheetBuilder(totalMoney: number, close: (flag: boolean) => void) {
  Column() {
    Row() {
      Text($r('app.string.yuan_params', `${totalMoney}`))
        .fontSize($r('sys.float.Body_M'))
        .fontColor($r('sys.color.font_secondary'))
    }.width($r('app.string.full_size')).justifyContent(FlexAlign.Center).margin({ top: 12 })

    Divider().margin({ top: 12, bottom: 12 })
    Column() {
      Row() {
        Row() {
          Image($r('app.media.ic_huawei_pay')).width(24)
          Text($r('app.string.huawei_pay'))
            .fontSize($r('sys.float.Body_L'))
            .fontColor($r('sys.color.font_primary'))
            .lineHeight(20)
            .margin({ left: 8 })
        }

        Radio({ value: '', group: 'radioGroup' })
          .checked(true)
          .radioStyle({
            checkedBackgroundColor: $r('sys.color.multi_color_09'),
          })
          .height(20)
          .width(20)
      }
      .width($r('app.string.full_size'))
      .height(48)
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({
        left: 16,
        right: 16,
        top: 14,
        bottom: 14,
      })
      Blank().layoutWeight(1)
      Row() {
        Button($r('app.string.pay_now'))
          .fontSize($r('sys.float.Body_M'))
          .fontWeight(FontWeight.Medium)
          .fontColor($r('sys.color.font_on_primary'))
          .width($r('app.string.full_size'))
          .constraintSize({ maxWidth: $r('app.string.full_size') })
          .padding({
            top: 6,
            bottom: 6,
          })
          .margin(2)
          .backgroundColor($r('sys.color.multi_color_09'))
          .onClick(() => {
            close(true)
          })
      }.margin({ bottom: 32 })
    }.layoutWeight(1).justifyContent(FlexAlign.SpaceBetween)

  }
  .padding({left: 12, right: 12 })
  .attributeModifier(BIND_SHEET_STYLE)
}