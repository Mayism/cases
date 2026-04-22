import { AppStorageV2 } from '@kit.ArkUI';
import {
  AsWebRichText,
  Constants,
  GridRowColSetting,
  NavHeaderBar,
  RouterMap,
  RouterModule,
  WindowModel,
} from 'common/Index';

@Builder
export function AnswerPageBuilder() {
  AnswerPage()
}

@ComponentV2
struct AnswerPage {
  @Local answerDetail: string = ''
  @Local windowModel: WindowModel = AppStorageV2.connect(WindowModel, () => new WindowModel())!
  @Local breakpoint: string = '';
  private scroller: Scroller = new Scroller()

  getAnswerDetail() {
    let params = RouterModule.getNavParam<string>(RouterMap.ANSWER_PAGE)
    if (params) {
      this.answerDetail =
        `<meta name="viewport" content="width=device-width, initial-scale=1.0">${params}`
    }
  }

  aboutToAppear(): void {
    this.getAnswerDetail()
  }

  build() {
    NavDestination() {
      GridRow(GridRowColSetting.DEFAULT_GRID_ROW_OPTIONS) {
        GridCol({ span: GridRowColSetting.GRID_ROW_OPTIONS_COLUMNS }) {
          Column() {
            NavHeaderBar({ title: '' })
            Scroll(this.scroller) {
              AsWebRichText({ url: Constants.RICH_TEXT_URI, richTextStr: this.answerDetail }).layoutWeight(1)
            }
            .edgeEffect(EdgeEffect.Spring)
            .width(Constants.FULL_SIZE)
            .height(Constants.FULL_SIZE)
            .padding({
              left: GridRowColSetting.getPageMargin(this.breakpoint),
              right: GridRowColSetting.getPageMargin(this.breakpoint),
            })
            .align(Alignment.Top)
          }
        }
      }.onBreakpointChange((bp) => {
        this.breakpoint = bp;
      })
    }
    .hideTitleBar(true)
    .padding({ bottom: this.windowModel.getWindowBottomHeight() })
  }
}