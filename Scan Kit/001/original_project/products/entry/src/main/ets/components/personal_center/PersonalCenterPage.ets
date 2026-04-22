import { Constants, GridRowColSetting, NavHeaderBar } from 'common/Index';
import { HelpCenterComp } from './HelpCenterComp';
import { MyCenterComp } from './MyCenterComp';
import { UserCardComp } from './UserCardComp';

@ComponentV2
export struct PersonalCenterPage {
  @Local breakpoint: string = '';

  build() {
    GridRow(GridRowColSetting.DEFAULT_GRID_ROW_OPTIONS) {
      GridCol({ span: GridRowColSetting.GRID_ROW_OPTIONS_COLUMNS }) {
        Column() {
          NavHeaderBar({
            title: $r('app.string.personal_center'),
            hasBackButton: false,
            hasBgColor: false,
            isMainPage: true,
          })
          Scroll() {
            Column() {
              UserCardComp()
              MyCenterComp()
              HelpCenterComp({ breakpoint: this.breakpoint })
              Blank().layoutWeight(1)
            }
          }
          .margin({
            left: 16,
            right: 16,
          })
          .padding({ top: 12 })
          .scrollBar(BarState.Off)
          .align(Alignment.Top)
          .edgeEffect(EdgeEffect.Spring);

          Blank().layoutWeight(1)
        }
        .alignItems(HorizontalAlign.Start)
        .width(Constants.FULL_SIZE)
        .backgroundColor($r('sys.color.background_secondary'))
      }
    }.onBreakpointChange((bp) => {
      this.breakpoint = bp;
    })
  }
}