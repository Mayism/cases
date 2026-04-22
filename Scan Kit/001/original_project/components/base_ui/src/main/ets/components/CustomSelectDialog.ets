import { BIND_SHEET_STYLE } from '../constants/Styles'

@Builder
export function CustomSelectSheetBuilder(list: Array<string> | Resource, confirm: (select: ResourceStr) => void,
  selected: ResourceStr = '') {
  CustomSelectSheet({
    list, confirm: (select: ResourceStr) => {
      confirm(select)
    }, selected,
  })
}

@ComponentV2
struct CustomSelectSheet {
  @Param list: Array<string> | Resource = []
  @Param selected: ResourceStr = ''
  @Local select: ResourceStr = ''
  @Event confirm: (select: ResourceStr) => void = () => {
  }

  aboutToAppear(): void {
    this.select = this.selected || this.list[0]
  }

  build() {
    Column() {
      TextPicker({ range: this.list, value: $$this.select })
        .width('100%')
        .disappearTextStyle({
          font: { size: $r('sys.float.Body_M') },
        })// 设置所有选项中除了最上、最下及选中项以外的文本颜色、字号、字体粗细。
        .textStyle({
          font: {
            size: $r('sys.float.Body_L'),
          },
        })// 设置选中项的文本颜色、字号、字体粗细。
        .selectedTextStyle({
          color: $r('sys.color.multi_color_09'), font: { size: $r('sys.float.Title_S'), weight: FontWeight.Medium },
        })
        .canLoop(false)
        .divider(null)
      Blank().layoutWeight(1)
      Row() {
        Text($r('app.string.confirm'))
          .fontSize($r('sys.float.Body_M'))
          .fontWeight(FontWeight.Medium)
          .fontColor($r('sys.color.background_primary'))
          .textAlign(TextAlign.Center)
          .width('100%')
          .constraintSize({ maxWidth: '100%' })
          .padding({
            top: 8, bottom: 8,
          })
          .margin({
            top: 2,
            left: 12,
            right: 12,
            bottom: 2,
          })
      }
      .justifyContent(FlexAlign.Center)
      .width('100%')
      .constraintSize({ maxWidth: '100%' })
      .borderRadius(18)
      .margin({ top: 40, bottom: 20 })
      .backgroundColor($r('sys.color.multi_color_09'))
      .onClick(() => {
        this.confirm(this.select)
      })

    }
    .padding({ top: 32, left: 32, right: 32 })
    .attributeModifier(BIND_SHEET_STYLE)
  }
}