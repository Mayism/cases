import { AsWebRichText, Constants, NavHeaderBar, RouterMap, RouterUtil, WebRouter } from 'lib_common';

@Builder
export function WebPageBuilder() {
  WebPage()
}

@ComponentV2
struct WebPage {
  @Local title: ResourceStr = ''
  @Local content: string = ''

  aboutToAppear(): void {
    this.getParams()
  }

  getParams() {
    let paramsArr: WebRouter[] = RouterUtil.getParamByName(RouterMap.WEB_PAGE) as WebRouter[];
    if (paramsArr.length) {
      let routerParam = paramsArr[paramsArr.length - 1];
      this.title = routerParam?.title ?? '';
      this.content = routerParam?.content ?? '';
    }
  }

  build() {
    NavDestination() {
      NavHeaderBar({ title: this.title, hasBgColor: false })
      Column() {
        AsWebRichText({
          url: 'resource://rawfile/richtext.html',
          richTextStr: this.content,
        })
      }
      .width(Constants.FULL_SIZE)
      .layoutWeight(1)
      .constraintSize({ maxWidth: Constants.FULL_SIZE })
      .alignItems(HorizontalAlign.Start)
      .margin({ left: Constants.BORDER_WIDTH, right: Constants.BORDER_WIDTH })
    }
    .backgroundColor($r('sys.color.background_secondary')).hideTitleBar(true)
  }
}
