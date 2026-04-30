import { AppStorageV2 } from '@kit.ArkUI';
import { NavHeaderBar, PaymentRouter, RouterMap, RouterUtil, Utils, WindowModel } from 'lib_common';

@Builder
export function FindCarResultPageBuilder() {
  FindCarResultPage()
}

@ComponentV2
struct FindCarResultPage {
  @Local plate: string = '';
  windowModel: WindowModel = AppStorageV2.connect(WindowModel, () => new WindowModel())!;

  aboutToAppear(): void {
    this.getParams();
  }

  getParams() {
    let paramsArr: PaymentRouter[] = RouterUtil.getParamByName(RouterMap.FIND_CAR_RESULT_PAGE) as PaymentRouter[];
    if (paramsArr.length) {
      let routerParam = paramsArr[paramsArr.length - 1];
      this.plate = routerParam?.plate ?? '';
    }
  }

  build() {
    NavDestination() {
      NavHeaderBar({ title: '找车服务', hasBgColor: false })
      Scroll() {
        Column() {
          Text('xxx商场')
            .fontSize($r('sys.float.Subtitle_S'))
            .fontColor($r('sys.color.font_secondary'))
            .margin({ top: 12 })
          Text('所属区域：A区').fontSize($r('sys.float.Title_S')).fontWeight(FontWeight.Medium).margin({ top: 4 })
          Image($r('app.media.find_car_result')).width('100%').margin({ top: 28 })
          Row() {
            Column({ space: 8 }) {
              Row({ space: 4 }) {
                Image($r('app.media.ic_clock')).width(16)
                Text(Utils.getCountdown(3890)).fontSize(14).fontColor($r('sys.color.font_primary'))
              }

              Row({ space: 4 }) {
                Image($r('app.media.ic_point')).width(16)
                Text(`入场时间：${Utils.getFullDate(new Date())}`).fontSize(14).fontColor($r('sys.color.font_primary'))
              }
            }
            .width('100%')
            .alignItems(HorizontalAlign.Start)
            .backgroundColor($r('sys.color.background_secondary'))
            .borderRadius(16)
            .padding(12)
          }
          .padding({ top: 12, left: 16, right: 16 })

          Column() {
            Button('缴费')
              .width('100%')
              .backgroundColor($r('app.color.app_theme'))
              .fontColor($r('sys.color.font_on_primary'))
              .fontSize($r('sys.float.Body_L'))
              .height(40)
              .onClick(() => {
                RouterUtil.pushPathByName(RouterMap.PAY_DETAIL_PAGE, { plate: this.plate } as PaymentRouter);
              })
          }
          .padding({ left: 16, right: 16, top: 16, bottom: 24 })
          .layoutWeight(1)
          .justifyContent(FlexAlign.End)
        }
        .padding({ bottom: this.windowModel.getWindowBottomHeight() })
        .width('100%')
      }
      .align(Alignment.Top)
      .scrollBar(BarState.Off)
      .edgeEffect(EdgeEffect.Spring)
      .layoutWeight(1)
    }
    .hideTitleBar(true)
  }
}