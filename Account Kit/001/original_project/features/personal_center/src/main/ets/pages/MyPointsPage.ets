import { AppStorageV2, PersistenceV2 } from '@kit.ArkUI';
import { Constants, getFullDate, GridRowColSetting, NavHeaderBar, UserInfoModel, WindowModel } from 'common/Index';
import { PointRecord } from 'network';
import * as API from '../api/Index';

@Builder
export function MyPointsPageBuilder() {
  MyPointsPage()
}

@ComponentV2
struct MyPointsPage {
  @Local windowModel: WindowModel = AppStorageV2.connect(WindowModel, () => new WindowModel())!
  @Local userInfoModel: UserInfoModel = PersistenceV2.connect(UserInfoModel, () => new UserInfoModel())!
  @Local datePickerSheet: boolean = false
  @Local allPointList: PointRecord[] = [];
  @Local searchMonth: string[] = ['2025年', '6月']
  @Local selectMonth: string[] = ['2025年', '6月']
  @Local breakpoint: string = '';
  private years: string[] = Constants.YEAR_PICKER
  private months: string[] = Constants.MONTH_PICKER
  multi: string[][] = [this.years, this.months];

  @Computed
  get consumerList() {
    return this.allPointList.filter(v => {
      const year = new Date(v.time).getFullYear();
      const month = new Date(v.time).getMonth() + 1;
      if (this.searchMonth[0].slice(0, -1) === year.toString() &&
        this.searchMonth[1].slice(0, -1) === month.toString()) {
        return true;
      }
      return false;
    })
  }

  aboutToAppear(): void {
    let year = new Date().getFullYear()
    let month = new Date().getMonth() + 1
    this.searchMonth = [`${year}年`, `${month}月`]
    this.selectMonth = [`${year}年`, `${month}月`]
    API.getPointList().then(res => {
      this.allPointList = res.sort((a: PointRecord, b: PointRecord) => b.time - a.time)
    })
  }

  build() {
    NavDestination() {
      GridRow(GridRowColSetting.DEFAULT_GRID_ROW_OPTIONS) {
        GridCol({ span: GridRowColSetting.GRID_ROW_OPTIONS_COLUMNS }) {
          Column() {
            NavHeaderBar({ title: '我的积分' })
            Column() {
              Column() {
                Row({ space: 8 }) {
                  Image($r('app.media.ic_wallet1')).width(24)
                  Text('我的积分').fontSize(16).fontColor($r('sys.color.font_primary')).fontWeight(FontWeight.Medium)
                }

                Text(`${this.userInfoModel.userInfo.totalScore}`)
                  .fontSize(24)
                  .fontColor($r('sys.color.font_primary'))
                  .fontWeight(FontWeight.Medium)
                  .margin({ top: 12 })
                Text('积分余额')
                  .fontSize($r('sys.float.Caption_L'))
                  .fontColor($r('sys.color.font_secondary'))
                  .margin({ top: 2 })
              }
              .width(Constants.FULL_SIZE)
              .height(120)
              .alignItems(HorizontalAlign.Start)
              .backgroundImage($r('app.media.bg_wallet_card'))
              .backgroundImageSize({ width: '100%', height: 120 })
              .padding(12)
              .borderRadius(16)

              this.consumptionRecordsComp()
            }
            .layoutWeight(1)
            .backgroundColor($r('sys.color.background_secondary'))
            .padding({
              top: 12,
              bottom: 16 + this.windowModel.getWindowBottomHeight(),
              left: 16,
              right: 16,
            })
          }
          .width(Constants.FULL_SIZE)
          .height(Constants.FULL_SIZE)
        }
      }
      .onBreakpointChange((bp) => {
        this.breakpoint = bp;
      })
    }.hideTitleBar(true)
  }

  @Builder
  consumptionRecordsComp() {
    Row({ space: 8 }) {
      Text('变动明细')
        .fontSize(16)
        .fontWeight(FontWeight.Medium)
        .fontColor($r('sys.color.font_primary'))
      Row() {
        Text(this.searchMonth.join(''))
          .fontSize(14)
          .fontColor($r('sys.color.font_secondary'))
        Image($r('app.media.ic_arrow_bottom')).width(24)
      }
      .onClick(() => {
        this.datePickerSheet = true
      })
    }
    .width(Constants.FULL_SIZE)
    .padding({ top: 12, bottom: 12 })
    .justifyContent(FlexAlign.SpaceBetween)
    .bindSheet($$this.datePickerSheet,
      this.DatePickerSheet(), {
        height: 336,
        preferType: SheetType.CENTER,
        showClose: false,
      })

    if (this.consumerList.length) {
      List() {
        ForEach(this.consumerList, (point: PointRecord) => {
          ListItem() {
            Row() {
              Column() {
                Text(point.action === 1 ? '下单' : '兑换')
                  .fontSize($r('sys.float.Subtitle_S'))
                  .fontWeight(FontWeight.Medium)
                  .fontColor($r('sys.color.font_primary'))
                Text(getFullDate(new Date(point.time)))
                  .fontSize($r('sys.float.Body_S'))
                  .fontColor($r('sys.color.font_tertiary'))
                  .margin({ top: 2 })
              }.alignItems(HorizontalAlign.Start)

              Text(`${point.action === 1 ? '+' : '-'}${point.changePoint}`)
                .fontSize($r('sys.float.Body_M'))
                .fontColor(point.action === 1 ? '#62B42E' : $r('sys.color.font_primary'))
            }.width(Constants.FULL_SIZE).justifyContent(FlexAlign.SpaceBetween).height(56)
          }
        }, (point: PointRecord) => JSON.stringify(point))
      }
      .edgeEffect(EdgeEffect.Spring, { alwaysEnabled: true })
      .padding({ left: 12, right: 12 })
      .borderRadius(16)
      .scrollBar(BarState.Off)
      .divider({ strokeWidth: 1 })
      .backgroundColor($r('sys.color.background_primary'))
      .layoutWeight(1)
    } else {
      this.emptyList('暂无历史纪录')
    }
  }

  @Builder
  DatePickerSheet() {
    Column() {
      TextPicker({ range: this.multi, value: $$this.selectMonth })
        .width(Constants.FULL_SIZE)
        .disappearTextStyle({
          font: { size: 14 },
          color: $r('sys.color.font_primary'),
        })
        .textStyle({
          font: { size: 16 },
          color: $r('sys.color.font_primary'),
        })
        .selectedTextStyle({
          font: { size: 20, weight: FontWeight.Medium },
          color: $r('sys.color.multi_color_09'),
        })
        .margin({ top: 8, bottom: 12 })
        .padding({ top: 16, bottom: 16 })
        .canLoop(false)
        .divider(null)
      Row({ space: 8 }) {
        Row() {
          Text('取消')
            .fontSize($r('sys.float.Body_L'))
            .fontWeight(FontWeight.Medium)
            .fontColor($r('sys.color.multi_color_09'))
        }
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
        .padding({
          top: 10,
          bottom: 10,
          left: 8,
          right: 8,
        })
        .onClick(() => {
          this.selectMonth = this.searchMonth
          this.datePickerSheet = false
        })

        Column().width(0.5).height(24).backgroundColor('#0d000000')

        Row() {
          Text('确认')
            .fontSize($r('sys.float.Body_L'))
            .fontWeight(FontWeight.Medium)
            .fontColor($r('sys.color.multi_color_09'))
        }
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
        .padding({
          top: 10,
          bottom: 10,
          left: 8,
          right: 8,
        })
        .onClick(() => {
          this.searchMonth = this.selectMonth
          this.datePickerSheet = false
        })
      }.margin({ top: 16 })
    }
    .width(Constants.FULL_SIZE)
    .constraintSize({ maxWidth: Constants.FULL_SIZE })
    .margin({
      left: GridRowColSetting.getPageMargin(this.breakpoint),
      right: GridRowColSetting.getPageMargin(this.breakpoint),
    })
  }

  @Builder
  emptyList(text: string) {
    Column() {
      Column() {
        Image($r('app.media.ic_no_record')).width(160)
        Text(text).fontSize(12).fontColor($r('sys.color.font_secondary')).margin({ top: 12 })
      }.width(Constants.FULL_SIZE)
    }
    .justifyContent(FlexAlign.Center)
    .layoutWeight(1)
    .backgroundColor($r('sys.color.background_primary'))
    .borderRadius(16)
  }
}
