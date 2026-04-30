import { AppStorageV2 } from '@kit.ArkUI';
import { AsWebRichText, Constants, HttpRequest, NavHeaderBar, WindowModel } from 'lib_common';

@Builder
export function PrivacyPageBuilder() {
  PrivacyPage()
}

@ComponentV2
struct PrivacyPage {
  @Local windowModel: WindowModel = AppStorageV2.connect(WindowModel, () => new WindowModel())!
  @Local privacyInfo: string = '';
  @Local srcPrefix: string = 'resource://rawfile/richtext.html';

  async aboutToAppear() {
    this.getPrivacyInfo()
  }

  getPrivacyInfo() {
    return HttpRequest.getPrivacyInfo().then((res) => {
      this.privacyInfo = `<meta name="viewport" content="width=device-width, initial-scale=1.0">${res ?? ''}`;
    })
  }

  build() {
    NavDestination() {
      NavHeaderBar({ title: $r('app.string.privacy') })
      Scroll() {
        Column() {
          AsWebRichText({
            url: this.srcPrefix,
            richTextStr: this.privacyInfo
          })
        }
        .width(Constants.FULL_SIZE)
        .backgroundColor($r('sys.color.background_primary'))
        .padding({
          top: 12,
          left: Constants.BORDER_WIDTH,
          right: Constants.BORDER_WIDTH,
          bottom: this.windowModel.getWindowBottomHeight(),
        })
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)
      .align(Alignment.Top)
      .edgeEffect(EdgeEffect.Spring)

    }.hideTitleBar(true)
  }
}