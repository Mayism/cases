export class PointConfirmParam {
  type: number = 0;
  content: string = '';
  close: () => void = () => {
  };
  confirm: () => void = () => {
  };
}

@Builder
export function scanPointConfirmBuilder(param: PointConfirmParam) {
  Column() {
    Column() {
      Text('订单条形码').fontSize(20).fontWeight(FontWeight.Medium).height(56)
      Text(param.content).fontSize(14)

      Row({ space: 16 }) {
        Button('取消')
          .height(40)
          .layoutWeight(1)
          .fontSize($r('sys.float.Body_L'))
          .fontColor($r('sys.color.font_tertiary'))
          .backgroundColor($r('sys.color.comp_background_tertiary'))
          .onClick(() => {
            param.close();
          })
        Button('提交')
          .height(40)
          .layoutWeight(1)
          .fontSize($r('sys.float.Body_L'))
          .backgroundColor($r('app.color.app_theme'))
          .onClick(() => {
            param.confirm();
          })
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({
        top: 8,
        bottom: 16,
        left: 12,
        right: 12
      })
    }
    .padding({ left: 24, right: 24 })
    .width('100%')
    .backgroundColor(Color.White)
    .borderRadius(32)
  }
  .width('100%')
  .padding({ left: 16, right: 16 })

}

@Builder
export function photoPointConfirmBuilder(param: PointConfirmParam) {
  Column() {
    Column({ space: 24 }) {
      Text('提交审核').fontSize(20).fontWeight(500)
      Image(param.content).width('100%').constraintSize({ maxHeight: '60%' }).borderRadius(16)

      Row({ space: 16 }) {
        Button('取消')
          .height(40)
          .layoutWeight(1)
          .fontSize($r('sys.float.Body_L'))
          .fontColor($r('sys.color.font_tertiary'))
          .backgroundColor($r('sys.color.comp_background_tertiary'))
          .onClick(() => {
            param.close();
          })
        Button('提交')
          .height(40)
          .layoutWeight(1)
          .fontSize($r('sys.float.Body_L'))
          .backgroundColor($r('app.color.app_theme'))
          .onClick(() => {
            param.confirm();
          })
      }
      .width('100%')
    }
    .padding({
      left: 12,
      right: 12,
      top: 24,
      bottom: 16
    })
    .width('100%')
    .backgroundColor(Color.White)
    .borderRadius(32)
  }
  .width('100%')
  .padding({ left: 16, right: 16 })

}