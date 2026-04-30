import { AppStorageV2 } from '@kit.ArkUI';
import {
  Constants,
  MenuModel,
  NavHeaderBar,
  PageHeaderComp,
  RouterMap,
  RouterUtil,
  UserInfoModel,
} from 'lib_common';
import { GlobalPointUtils } from 'module_points';
import { GlobalCouponUtils } from 'module_coupon';

@Builder
export function ParkingPaymentPageBuilder() {
  ParkingPaymentPage()
}

@ComponentV2
struct ParkingPaymentPage {
  @Local userInfo: UserInfoModel = AppStorageV2.connect(UserInfoModel, () => new UserInfoModel())!;
  @Local globalPointInfo: GlobalPointUtils = AppStorageV2.connect(GlobalPointUtils, () => new GlobalPointUtils())!;
  @Local globalCouponInfo: GlobalCouponUtils = AppStorageV2.connect(GlobalCouponUtils, () => new GlobalCouponUtils())!;
  @Local menuList: Array<MenuModel> =
    [new MenuModel($r('app.media.ic_car'), '停车缴费', RouterMap.PLATE_NUMBER_PAGE),
      new MenuModel($r('app.media.ic_car_manage'), '管理车辆', RouterMap.PLATE_NUMBER_MGT_PAGE),
      new MenuModel($r('app.media.ic_car_position'), '找车服务', RouterMap.FIND_CAR_PAGE),
      new MenuModel($r('app.media.ic_car_payment'), '缴费记录', RouterMap.PAY_RECORD_PAGE)]

  build() {
    NavDestination() {
      NavHeaderBar({ title: '停车缴费', hasBgColor: false })
      Scroll() {
        Column({ space: 12 }) {
          Image($r('app.media.parking_banner'))
            .width('100%')
            .borderRadius(12)
            .margin({ top: 12 })
            .constraintSize({
              maxHeight: '35%',
            })
          PageHeaderComp()

          Row({ space: 80 }) {
            Column() {
              Text(this.globalPointInfo.myPoints.toString())
                .fontSize(18)
                .fontColor($r('sys.color.font_primary'))
                .fontWeight(FontWeight.Medium)
              Text('积分').fontSize(12).fontColor($r('sys.color.font_secondary')).margin({ top: 8 })
            }
            .width(164)
            .padding({ top: 12, bottom: 12 })
            .onClick(() => {
              RouterUtil.pushPathByName(RouterMap.SELF_POINT_RECORD_PAGE);
            })

            Column() {
              Text(this.globalCouponInfo.validCouponListCount.toString())
                .fontSize(18)
                .fontColor($r('sys.color.font_primary'))
                .fontWeight(FontWeight.Medium)
              Text('停车券').fontSize(12).fontColor($r('sys.color.font_secondary')).margin({ top: 8 })
            }
            .width(164)
            .padding({ top: 12, bottom: 12 })
            .onClick(() => {
              RouterUtil.pushPathByName(RouterMap.MY_COUPONS_PAGE);
            })
          }
          .width(Constants.FULL_SIZE)
          .justifyContent(FlexAlign.SpaceBetween)
          .borderRadius(16)
          .backgroundColor($r('sys.color.background_primary'))
          .padding({ left: Constants.BORDER_WIDTH, right: Constants.BORDER_WIDTH })

          List() {
            ForEach(this.menuList, (item: MenuModel) => {
              ListItem() {
                Row() {
                  Row() {
                    Image(item.icon).width(24)
                    Text(item.title)
                      .fontSize(16)
                      .fontWeight(FontWeight.Medium)
                      .fontColor($r('sys.color.font_primary'))
                      .margin({ left: 8 })
                  }.height(32)

                  Image($r('app.media.ic_right')).width(16).fillColor('#999999')
                }.width(Constants.FULL_SIZE).justifyContent(FlexAlign.SpaceBetween).padding({ top: 8, bottom: 8 })
                .onClick(() => {
                  if (item.url) {
                    RouterUtil.pushPathByName(item.url)
                  }
                })
              }
            }, (item: MenuModel) => JSON.stringify(item))
          }
          .borderRadius(16)
          .padding({
            left: 8,
            right: 8,
            top: 12,
            bottom: 12,
          })
          .divider({ strokeWidth: 1, startMargin: 40 })
          .constraintSize({ maxWidth: Constants.FULL_SIZE })
          .backgroundColor(Color.White)
        }
        .width(Constants.FULL_SIZE)
        .padding({ left: Constants.BORDER_WIDTH, right: Constants.BORDER_WIDTH })
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)
      .align(Alignment.Top)
      .edgeEffect(EdgeEffect.Spring)
    }
    .hideTitleBar(true)
    .backgroundColor($r('sys.color.background_secondary'))
  }
}
