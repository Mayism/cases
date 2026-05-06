import { AppStorageV2 } from '@kit.ArkUI';
import {
  CallTelSheetBuilder,
  Constants,
  NavHeaderBar,
  Point,
  Utils,
  WindowModel
} from '../libcommon/Index';
import { PointConstants, PointItem, PointStatus } from '../constants/PointConstants';
import { SelfPointRecordViewModel } from '../viewmodels/SelfPointRecordViewModel';
import { ContextUtils } from '../libcommon/ContextUtils';

@Builder
export function SelfPointRecordPageBuilder() {
  SelfPointRecordPage()
}

@ComponentV2
struct SelfPointRecordPage {
  @Local vm: SelfPointRecordViewModel = new SelfPointRecordViewModel();
  windowModel: WindowModel = AppStorageV2.connect(WindowModel, () => new WindowModel())!;
  @Provider() pathStack: NavPathStack = new NavPathStack();

  aboutToAppear(): void {
    ContextUtils.setUIContext(this.getUIContext());
  }

  build() {
    NavDestination() {
      NavHeaderBar({ title: '我的积分', hasBgColor: false })
      Column({ space: 12 }) {
        Row() {
          Column() {
            Text(this.vm.globalPointInfo.myPoints.toString())
              .fontSize(24)
              .fontWeight(FontWeight.Medium)
              .fontColor($r('sys.color.font_primary'))
            Text('积分余额').fontSize(12).fontColor($r('sys.color.font_secondary')).margin({ top: 4 })
          }.alignItems(HorizontalAlign.Start)

          Image($r('app.media.bg_self_point_title_right')).width(133).height(78)
        }
        .width(Constants.FULL_SIZE)
        .height(96)
        .justifyContent(FlexAlign.SpaceBetween)
        .padding({ left: 24, right: 2 })
        .borderRadius(16)
        .clip(true)
        .backgroundImage($r('app.media.bg_self_point_title'))
        .backgroundImageSize({ width: Constants.FULL_SIZE, height: 96 })

        Row() {
          Text('自助积分')
            .fontSize(14)
            .fontWeight(FontWeight.Medium)
            .fontColor(this.vm.pointType === 1 ? Color.White : $r('sys.color.font_secondary'))
            .backgroundColor(this.vm.pointType === 1 ? $r('app.color.app_theme') :
              '#00000000')
            .borderRadius(18)
            .textAlign(TextAlign.Center)
            .padding({
              top: 8,
              bottom: 8,
            })
            .layoutWeight(1)
            .onClick(() => {
              this.vm.pointType = 1
            })
          Text('消费记录')
            .fontSize(14)
            .fontWeight(FontWeight.Medium)
            .fontColor(this.vm.pointType === 2 ? Color.White : $r('sys.color.font_secondary'))
            .backgroundColor(this.vm.pointType === 2 ? $r('app.color.app_theme') : '#00000000')
            .borderRadius(18)
            .textAlign(TextAlign.Center)
            .padding({
              top: 8,
              bottom: 8,
            })
            .layoutWeight(1)
            .onClick(() => {
              this.vm.pointType = 2
            })
        }
        .width(Constants.FULL_SIZE)
        .padding(2)
        .backgroundColor($r('sys.color.comp_background_tertiary'))
        .borderRadius(20)

        Column() {
          if (this.vm.pointType === 1) {
            this.selfPointComp()
          } else {
            this.consumptionRecordsComp()
          }
        }.layoutWeight(1)
      }
      .width(Constants.FULL_SIZE)
      .layoutWeight(1)
      .padding({
        left: Constants.BORDER_WIDTH,
        right: Constants.BORDER_WIDTH,
        bottom: this.windowModel.getWindowBottomHeight()
      })
    }
    .backgroundColor($r('sys.color.background_secondary'))
    .hideTitleBar(true)
    .onReady((context) => {
      this.pathStack = context.pathStack;
      this.vm.setStack(context.pathStack)
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

  @Builder
  consumptionRecordsComp() {
    Row({ space: 8 }) {
      Text('变动明细')
        .fontSize(16)
        .fontWeight(FontWeight.Medium)
        .fontColor($r('sys.color.font_primary'))
      Row() {
        Text(this.vm.searchMonth.join(''))
          .fontSize(14)
          .fontColor($r('sys.color.font_secondary'))
        Image($r('app.media.ic_arrow_down_fill')).width(24)
      }
      .onClick(() => {
        this.vm.datePickerSheet = true
      })
    }
    .width(Constants.FULL_SIZE)
    .padding({ top: 12, bottom: 12 })
    .justifyContent(FlexAlign.SpaceBetween)
    .bindSheet($$this.vm.datePickerSheet,
      this.DatePickerSheet(), {
        height: 336,
        preferType: SheetType.CENTER,
        showClose: false,
      })

    if (this.vm.consumerList.length) {
      List({ space: 12 }) {
        ForEach(this.vm.consumerList, (point: Point) => {
          ListItem() {
            Row() {
              Column() {
                Text(point.action === 1 ? '购物积分' : '停车抵扣')
                  .fontSize(14)
                  .fontWeight(FontWeight.Medium)
                  .fontColor($r('sys.color.font_primary'))
                Text(Utils.getFullDate(new Date(point.time)))
                  .fontSize(12)
                  .fontColor($r('sys.color.font_tertiary'))
                  .margin({ top: 2 })
              }.alignItems(HorizontalAlign.Start)

              Text(`${point.action === 1 ? '+' : '-'}${point.point}`)
                .fontSize(14)
                .fontWeight(FontWeight.Medium)
                .fontColor(point.action === 1 ? $r('app.color.app_theme') : $r('sys.color.font_primary'))
            }.width(Constants.FULL_SIZE).justifyContent(FlexAlign.SpaceBetween).padding({ top: 8, bottom: 8 })
          }
        }, (point: Point) => JSON.stringify(point))
      }
      .scrollBar(BarState.Off)
      .divider({ strokeWidth: 1 })
      .layoutWeight(1)
    } else {
      this.emptyList('暂无消费记录')
    }
  }

  @Builder
  selfPointComp() {
    Row({ space: 8 }) {
      ForEach(PointConstants.SELF_POINT_RECORD_TABS, (v: PointItem) => {
        Text(v.title)
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
          .fontColor(this.vm.pointApproveType === v.value ? $r('sys.color.font_on_primary') :
          $r('sys.color.font_primary'))
          .padding({
            top: 4,
            bottom: 4,
            left: 8,
            right: 8,
          })
          .backgroundColor(this.vm.pointApproveType === v.value ? $r('app.color.app_theme') :
          $r('sys.color.comp_background_tertiary'))
          .borderRadius(14)
          .onClick(() => {
            this.vm.filterList(v.value);
          })
      }, (v: PointItem) => v.title)
    }.width(Constants.FULL_SIZE).margin({ bottom: 12 })

    if (this.vm.pointList.length) {
      List({ space: 12 }) {
        ForEach(this.vm.pointList, (point: Point) => {
          ListItem() {
            Column() {
              Row() {
                Row() {
                  Text('申请时间：').fontSize(12).fontColor($r('sys.color.font_primary'))
                  Text(Utils.getFullDate(new Date(point.time))).fontSize(12).fontColor($r('sys.color.font_primary'))
                }

                Text(this.vm.getCardStatusLabel(point))
                  .fontSize(10)
                  .fontColor($r('sys.color.font_on_primary'))
                  .backgroundColor(this.vm.getBtnBgColor(point))
                  .borderRadius(8)
                  .padding({
                    top: 1,
                    bottom: 1,
                    left: 6,
                    right: 6,
                  })
              }
              .width(Constants.FULL_SIZE)
              .justifyContent(FlexAlign.SpaceBetween)
              .backgroundColor(this.vm.getCardBgColor(point))
              .padding(12)

              Row() {
                Row() {
                  if (point.type === 0) {
                    QRCode(point.qrcode).width(100).height(80).borderRadius(16)
                  } else {
                    Image(this.vm.getImgUrl(point)).width(100).height(80).borderRadius(16)
                  }

                  Column({ space: 8 }) {
                    Text('兑换积分申请').fontSize(14).fontColor($r('sys.color.font_primary'))
                    Text('类型：' + this.vm.getPointType(point)).fontSize(14).fontColor($r('sys.color.font_primary'))
                    Row() {
                      Text('状态：').fontSize(14)
                      Text(this.vm.getCardStatusContent(point))
                        .fontSize(14)
                        .fontColor(this.vm.getCardStatusFgColor(point))
                      if (point.status === 1) {
                        Text('+500积分').fontSize(14).fontColor('#64BB5C').layoutWeight(1).textAlign(TextAlign.End)
                      }
                    }

                  }
                  .alignItems(HorizontalAlign.Start)
                  .margin({ left: 12 })
                  .layoutWeight(1)
                }
                .layoutWeight(1)

                Image(point.showReason ? $r('app.media.ic_up_fill') : $r('app.media.ic_down_fill'))
                  .visibility(point.status === 2 ? Visibility.Visible : Visibility.None)
                  .width(24)
                  .onClick(() => {
                    point.showReason = !point.showReason;
                  })
              }
              .justifyContent(FlexAlign.SpaceBetween)
              .padding({
                top: 8,
                bottom: 8,
                left: 12,
                right: 12,
              })
              .alignItems(VerticalAlign.Bottom)

              if (point.showReason) {
                Row() {
                  Column() {
                    Text('原因：').fontSize(10)
                    Text(point.rejectReason).fontSize(10)
                  }
                  .width('100%')
                  .alignItems(HorizontalAlign.Start)
                  .padding(8)
                  .borderRadius(8)
                  .backgroundColor($r('sys.color.background_secondary'))
                }
                .width('100%')
                .padding({
                  top: 8,
                  bottom: 8,
                  left: 12,
                  right: 12
                })
              }

              if (point.status === PointStatus.UN_APPROVED) {
                Row({ space: 8 }) {
                  Button('重新提交', { controlSize: ControlSize.SMALL })
                    .fontSize($r('sys.float.Body_M'))
                    .fontColor($r('sys.color.font_primary'))
                    .backgroundColor($r('sys.color.comp_background_tertiary'))
                    .padding({
                      top: 4,
                      bottom: 4,
                      left: 8,
                      right: 8,
                    })
                    .onClick(() => {
                      this.vm.reSubmit(point.id);
                    })
                  Button('联系客服', { controlSize: ControlSize.SMALL })
                    .fontSize($r('sys.float.Body_M'))
                    .fontColor($r('sys.color.font_on_primary'))
                    .backgroundColor($r('app.color.app_theme'))
                    .padding({
                      top: 4,
                      bottom: 4,
                      left: 8,
                      right: 8,
                    })
                    .onClick(() => {
                      this.vm.showCallSheet = true;
                    })
                }
                .width(Constants.FULL_SIZE)
                .justifyContent(FlexAlign.End)
                .padding(12)
                .borderWidth({ top: 0.5 })
                .borderColor($r('sys.color.comp_divider'))
              }
            }
            .backgroundColor($r('sys.color.background_primary'))
            .borderRadius(16)
            .clip(true)
          }
        }, (point: Point) => JSON.stringify(point))
      }
      .scrollBar(BarState.Off)
      .layoutWeight(1)
      .bindSheet($$this.vm.showCallSheet, CallTelSheetBuilder('00000000000', () => {
        this.vm.showCallSheet = false;
      }), {
        height: SheetSize.FIT_CONTENT,
        showClose: false,
        preferType: SheetType.CENTER,
      })
    } else {
      this.emptyList('暂无积分记录')
    }
  }

  @Builder
  DatePickerSheet() {
    Column() {
      TextPicker({ range: this.vm.multi, value: $$this.vm.selectMonth })
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
          color: $r('app.color.app_theme'),
        })
        .margin({ top: 8, bottom: 12 })
        .padding({ top: 16, bottom: 16 })
        .canLoop(false)
        .divider(null)
      Row({ space: 12 }) {
        Button('取消')
          .fontSize($r('sys.float.Body_L'))
          .fontWeight(FontWeight.Medium)
          .fontColor($r('sys.color.font_primary'))
          .backgroundColor($r('sys.color.comp_background_tertiary'))
          .layoutWeight(1)
          .onClick(() => {
            this.vm.selectMonth = this.vm.searchMonth
            this.vm.datePickerSheet = false
          })
        Button('确认')
          .fontSize($r('sys.float.Body_L'))
          .fontWeight(FontWeight.Medium)
          .fontColor($r('sys.color.font_on_primary'))
          .layoutWeight(1)
          .backgroundColor($r('app.color.app_theme'))
          .onClick(() => {
            this.vm.searchMonth = this.vm.selectMonth
            this.vm.filterConsumeList();
            this.vm.datePickerSheet = false
          })
      }
    }
    .width(Constants.FULL_SIZE)
    .constraintSize({ maxWidth: Constants.FULL_SIZE })
    .margin({ left: Constants.BORDER_WIDTH, right: Constants.BORDER_WIDTH })
  }
}
