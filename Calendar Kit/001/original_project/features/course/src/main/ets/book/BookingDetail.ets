import { BookingInfo, BookState, DateUtil, getCalendarPermission } from 'external_interactions';
import { TitleBar } from 'module_recharge/src/main/ets/components/TitleBar';
import { ScreenPropStorage , AccountUpdate, ClearPath} from 'external_interactions'
import { AppStorageV2 } from '@kit.ArkUI';
import { calendarManager } from '@kit.CalendarKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { serviceNotification } from '@kit.PushKit';
import { SystemSceneUtils } from '../utils/SystemSceneUtils';
import { abilityAccessCtrl, common, PermissionRequestResult, Permissions } from '@kit.AbilityKit';

@ComponentV2
export struct BookingDetail {
  @Param @Once bookingInfo: BookingInfo = {} as BookingInfo;
  @Local screenPropStorage : ScreenPropStorage = AppStorageV2.connect(ScreenPropStorage, 'ScreenPropStorage', () =>new ScreenPropStorage())!
  @Local clearPathStorage : ClearPath = AppStorageV2.connect(ClearPath, 'ClearPath', () =>new ClearPath())!
  @Param @Once pathStack: NavPathStack = new NavPathStack();
  bookingDate: Date = new Date()
  @Local topRectHeight: number = this.screenPropStorage.topRectHeight;
  @Local bottomRectHeight: number = this.screenPropStorage.bottomRectHeight;

  @Local bookingState: BookState = BookState.TO_BE_USE
  @Local clearPath: boolean = this.clearPathStorage.clearPath
  @Local offsetX: number = 0
  @Local isSwiping: boolean = false
  @Local entityIds: string = 'xxx';// todo 推送服务通知模板ID
  @Local calendarMgr: calendarManager.CalendarManager | null = null;

  aboutToAppear(): void {
    // 初始化
    SystemSceneUtils.init(this.getUIContext());
    this.clearPathStorage.clearPath = false
  }

  @Builder
  rowBuilder(key: string, value: string): void {
    Row() {
      Text(key)
        .fontSize(14)
        .fontWeight(FontWeight.Regular)
        .textAlign(TextAlign.Start)
      Text(value)
        .fontSize(14)
        .fontWeight(FontWeight.Regular)
        .textAlign(TextAlign.End)
        .opacity(0.6)
    }
    .width('100%')
    .height(30)
    .justifyContent(FlexAlign.SpaceBetween)
  }

  onSubscribeClick: () => void = async () => {
    const resp = await SystemSceneUtils.requestSubscribeNotification(this.entityIds);
    if (resp && resp?.entityResult?.length &&
      resp.entityResult[0]?.resultCode === serviceNotification.ResultCode.ACCEPTED) {
    }
  };

  build() {
    NavDestination() {
      Stack() {
        Scroll() {
          Column({ space: 16 }) {
            TitleBar({ title: '预约详情', onBackClick: () => {
              if (this.clearPath) {
                this.pathStack.clear()
                this.clearPath = false
              } else {
                this.pathStack.pop()
              }}
            })
            // 预约二维码
            Row() {
              Column() {
                Row() {
                  Text('恭喜！预约成功！')
                    .fontSize(14)
                    .fontWeight(FontWeight.Bold)
                }
                .justifyContent(FlexAlign.Center)
                .width('100%')

                Image($r('app.media.qrCode'))
                  .width(143)
                  .height(143)
                  .margin({ top: 16 })
              }.justifyContent(FlexAlign.SpaceEvenly)
              .width('50%')
            }
            .justifyContent(FlexAlign.Center)
            .width('100%')
            .padding(16)
            .borderRadius(16)
            .backgroundColor($r('sys.color.comp_background_list_card'))
            .visibility(this.bookingInfo.bookState === BookState.TO_BE_USE ? Visibility.Visible : Visibility.None)

            Text('预约信息')
              .textAlign(TextAlign.Start)
              .fontSize(14)
              .width('100%')
              .fontWeight(FontWeight.Bold)
            // 预约信息
            Column() {
              this.rowBuilder('预约课程', this.bookingInfo.courseDetail.courseName)
              Divider()
              this.rowBuilder('预约门店', AppStorage.get('currentStore') ?? '全市门店')
              this.rowBuilder('预约时间', DateUtil.formatDate(this.bookingDate, '.', 'short') +
                ' ' + this.bookingInfo.courseBookingInfo.timeStart + '~' + this.bookingInfo.courseBookingInfo.timeEnd)
              this.rowBuilder('预约人', this.bookingInfo.name)
              this.rowBuilder('预约人数', this.bookingInfo.personNum.toString())
              this.rowBuilder('手机号码', this.bookingInfo.phone)
              this.rowBuilder('备注',
                (this.bookingInfo.remark === undefined || this.bookingInfo.remark.length === 0) ? '无' :
                this.bookingInfo.remark)
            }
            .justifyContent(FlexAlign.Center)
            .width('100%')
            .padding(16)
            .borderRadius(16)
            .backgroundColor($r('sys.color.comp_background_list_card'))

            Row() {
              Button('订阅通知', { type: ButtonType.Capsule, stateEffect: true })
                .width('45%')
                .height(40)
                .fontColor($r('sys.color.comp_background_list_card'))
                .fontWeight(FontWeight.Medium)
                .fontSize($r('sys.float.Body_M'))
                .backgroundColor('#FF9019')
                .borderRadius(8)
                .onClick(() => {
                  this.onSubscribeClick()
                })

              Button('添加至日程', { type: ButtonType.Capsule, stateEffect: true })
                .width('45%')
                .height(40)
                .fontColor($r('sys.color.comp_background_list_card'))
                .fontWeight(FontWeight.Medium)
                .fontSize($r('sys.float.Body_M'))
                .backgroundColor('#FF9019')
                .borderRadius(8)
                .onClick(async () => {
                })
            }
            .visibility(this.bookingInfo.bookState === BookState.TO_BE_USE ? Visibility.Visible : Visibility.None)
            .width('100%')
            .height(40)
            .justifyContent(FlexAlign.SpaceBetween)
          }
        }.margin({ left: 16, right: 16 })
      }
      .layoutWeight(1)
      .alignContent(Alignment.Top)
    }
    .hideTitleBar(true)
    .onReady((ctx: NavDestinationContext) => {
      this.pathStack = ctx?.pathStack
      this.bookingInfo = ctx?.pathInfo?.param as BookingInfo;
      this.bookingDate = DateUtil.parseDateString(this.bookingInfo.courseBookingInfo.date)
    })
    .padding({ top: this.getUIContext().px2vp(this.topRectHeight) })
    .backgroundColor($r('app.color.main_background_color'))
    .onBackPressed(() => {
      if(this.clearPath){
        this.pathStack.clear()
      }else {
        this.pathStack.pop()
      }
      return true;
    })
  }
}
