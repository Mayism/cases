import { AppStorageV2 } from '@kit.ArkUI';
import { Constants, GridRowColSetting, NavHeaderBar, RouterMap, RouterModule, WindowModel } from 'common/Index';
import { HelpMsgResp } from 'network';
import * as API from '../api/Index';

@Builder
export function FrequentQuestionPageBuilder() {
  FrequentQuestionPage()
}

@ComponentV2
struct FrequentQuestionPage {
  @Local windowModel: WindowModel = AppStorageV2.connect(WindowModel, () => new WindowModel())!
  @Local questionList?: Array<HelpMsgResp> = undefined
  @Local breakpoint: string = '';
  scroller: Scroller = new Scroller()

  aboutToAppear(): void {
    API.getHelpMsg().then((resp: Array<HelpMsgResp>) => {
      this.questionList = resp
    })
  }

  build() {
    NavDestination() {
      GridRow(GridRowColSetting.DEFAULT_GRID_ROW_OPTIONS) {
        GridCol({ span: GridRowColSetting.GRID_ROW_OPTIONS_COLUMNS }) {
          Column() {
            NavHeaderBar({ title: $r('app.string.faqs') })

            Row() {
              Column() {
                Text($r('app.string.question_title'))
                  .fontSize($r('sys.float.Title_S'))
                  .fontWeight(FontWeight.Medium)
                  .fontColor($r('sys.color.font_primary'))
                Text($r('app.string.question_desc'))
                  .fontSize($r('sys.float.Body_S'))
                  .fontColor($r('sys.color.font_secondary'))
                  .margin({ top: 4 })
              }
              .alignItems(HorizontalAlign.Start)

              Image($r('app.media.report_icon')).width(60).height(60)
            }
            .width(Constants.FULL_SIZE)
            .padding({
              left: 24,
              right: 42,
              top: 14,
              bottom: 12,
            })
            .justifyContent(FlexAlign.SpaceBetween)

            Scroll(this.scroller) {
              Column() {
                ForEach(this.questionList, (item: HelpMsgResp) => {
                  Row() {
                    Text(item.question)
                      .fontSize($r('sys.float.Body_M'))
                      .fontColor($r('sys.color.font_secondary'))
                    Image($r('app.media.right_arrow'))
                      .width(16)
                      .height(16)
                  }
                  .width(Constants.FULL_SIZE)
                  .padding({
                    top: 12,
                    bottom: 12,
                    left: 8,
                    right: 8,
                  })
                  .justifyContent(FlexAlign.SpaceBetween)
                  .border({
                    width: { top: 1 },
                    color: { top: $r('sys.color.comp_divider') },
                  })
                  .onClick(() => {
                    RouterModule.push(RouterMap.ANSWER_PAGE, item.answer)
                  })
                }, (item: HelpMsgResp) => item.question)
              }.alignItems(HorizontalAlign.Start)
            }
            .width(Constants.FULL_SIZE)
            .padding({
              left: GridRowColSetting.getPageMargin(this.breakpoint),
              right: GridRowColSetting.getPageMargin(this.breakpoint),
            })
            .align(Alignment.Top)
          }.backgroundColor($r('sys.color.background_primary'))
        }
      }
      .onBreakpointChange((bp) => {
        this.breakpoint = bp;
      })
    }
    .hideTitleBar(true)
    .padding({ bottom: this.windowModel.getWindowBottomHeight() })
    .backgroundColor($r('sys.color.background_secondary'))
  }
}