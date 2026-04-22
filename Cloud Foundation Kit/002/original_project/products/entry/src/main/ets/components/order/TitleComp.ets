import { ToastDialog as promptAction } from '@hw-agconnect/ui-toast';
import { AppStorageV2, PersistenceV2 } from '@kit.ArkUI';
import { CouponCard, CouponItem } from 'base_ui';
import {
  AppInfoModel,
  CommonUrl,
  Constants,
  MyCarModel,
  OrderTypeEnum,
  RouterMap,
  RouterModule,
  StoreInfoModel,
  UserInfoModel,
  WindowModel,
} from 'common/Index';
import * as API from '../../api/Index';
import { DiscountModel, PreorderLabel } from '../../models/Index';

@Preview
@ComponentV2
export struct TitleComp {
  @Local appInfoModel: AppInfoModel = AppStorageV2.connect(AppInfoModel, () => new AppInfoModel())!;
  @Local storeModel: StoreInfoModel = AppStorageV2.connect(StoreInfoModel, () => new StoreInfoModel())!;
  @Local userInfoModel: UserInfoModel = PersistenceV2.connect(UserInfoModel, () => new UserInfoModel())!
  @Local myCarModel: MyCarModel = AppStorageV2.connect(MyCarModel, () => new MyCarModel())!
  @Local windowModel: WindowModel = AppStorageV2.connect(WindowModel, () => new WindowModel())!;
  @Local showShopDiscount: boolean = false
  @Local myCouponList: Array<CouponItem> = []
  @Local showCouponList: Array<CouponItem> = []
  @Local discountList: Array<DiscountModel> = []
  // swiper组件当前索引值
  @Local swiperIndex: number = 0;
  @Local preorderLabelList: Array<PreorderLabel> = []
  @Local preorderLeftLabel: string = ''
  @Local showPreorderSheet: boolean = false
  private weekDays = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];

  aboutToAppear(): void {
    this.getPreorderTimeList()
    this.initCouponList()

  }

  initCouponList() {
    Promise.all([API.getCouponList(), API.getMyCoupons()]).then(res => {
      this.myCouponList = res[1]
      // 状态正常，非使用，非
      this.showCouponList = res[0].filter(item => item.status === '2' &&
        new Date(item.endTime + ' 23:59:59').getTime() > new Date().getTime())
    })
  }

  getPreorderTimeList() {
    this.preorderLabelList.push(new PreorderLabel(0, '立即就餐', false))
    const date = new Date()
    for (let i = date.getHours() + 1; i < 24; i++) {
      this.preorderLabelList.push(new PreorderLabel(i, `${i.toString().padStart(2, '0')}:00`, false))
    }
    this.preorderLeftLabel = `今天（${this.weekDays[date.getDay()-1]}）`
  }

  @Monitor('storeModel.storeInfo.reductionList')
  storeUpdate(monitor: IMonitor) {
    if (monitor.value()?.now) {
      this.discountList = []
      this.discountList.push(new DiscountModel('',
        $r('app.string.new_user_discount', this.storeModel.storeInfo.xyhMoney)))
      this.storeModel.storeInfo.reductionList.forEach(item => {
        this.discountList.push(new DiscountModel('', item.name ?? ''))
      })
    }
  }

  build() {
    Column() {
      Row() {
        Row() {
          Row() {
            Row() {
              Image($r('app.media.store_dining')).width(24)
              Text($r('app.string.order_title_store_dining'))
                .fontSize(14)
                .fontWeight(FontWeight.Medium)
                .fontColor(this.storeModel.orderType === OrderTypeEnum.DINE_IN ? $r('sys.color.font_primary') :
                  $r('sys.color.font_secondary'))
                .textAlign(TextAlign.Center)
                .margin({ left: 4 })
            }
            .backgroundColor(this.storeModel.orderType === OrderTypeEnum.DINE_IN ?
              $r('sys.color.background_primary') :
              '#00000000')
            .borderRadius(18)
            .padding({
              left: 8,
              right: 8,
              top: 4,
              bottom: 4,
            })
            .onClick(() => {
              this.storeModel.orderType = OrderTypeEnum.DINE_IN;
            });

            Row() {
              Image($r('app.media.packing')).width(24)
              Text($r('app.string.order_title_packing'))
                .fontSize(14)
                .fontWeight(FontWeight.Medium)
                .fontColor(this.storeModel.orderType === OrderTypeEnum.TAKEOUT ?
                  $r('sys.color.font_primary') :
                  $r('sys.color.font_secondary'))
                .textAlign(TextAlign.Center)
                .margin({ left: 4 })
            }
            .backgroundColor(this.storeModel.orderType === OrderTypeEnum.TAKEOUT ?
              $r('sys.color.background_primary') :
              '#00000000')
            .borderRadius(18)
            .padding({
              left: 8,
              right: 8,
              top: 4,
              bottom: 4,
            })
            .onClick(() => {
              this.storeModel.orderType = OrderTypeEnum.TAKEOUT;
            });
          }
          .padding(2)
          .backgroundColor($r('sys.color.font_on_tertiary'))
          .borderRadius(20);
        }.width(192).padding({ top: 10, bottom: 10 })
        .margin({ top: this.windowModel.getWindowTopHeight(), left: 16 })
      }
      .width(Constants.FULL_SIZE)
      .height(92)
      .backgroundColor($r('sys.color.multi_color_09'))

      Column({ space: 8 }) {
        Column({ space: 4 }) {
          Row({ space: 4 }) {
            Row() {
              Image(`${CommonUrl.CLOUD_STORAGE_URL}${this.storeModel.storeInfo.logo}`)
                .width(40)
                .height(40)
                .borderRadius(20)
              Row() {
                Text(this.storeModel.storeInfo.name)
                  .fontSize(18)
                  .fontWeight(FontWeight.Medium)
                  .fontColor($r('sys.color.font_primary'))
                  .maxLines(1)
                  .constraintSize({ maxWidth: '85%' })
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .margin({ left: 4 })
                Image($r('app.media.right_arrow')).width(16).margin({ left: 8 })
              }.layoutWeight(1)
            }.layoutWeight(1).onClick(() => {
              RouterModule.push(RouterMap.SELECT_STORE_PAGE)
            })

            if (this.storeModel.orderType === OrderTypeEnum.TAKEOUT) {
              Column() {
                Image($r('app.media.ic_preorder')).width(24)
                Text(this.storeModel.preorderTime === '立即就餐' ? $r('app.string.preorder') : '预约中')
                  .fontSize(10)
                  .fontColor(this.storeModel.preorderTime === '立即就餐' ? $r('sys.color.font_secondary') :
                    $r('sys.color.multi_color_09'))
                  .fontWeight(FontWeight.Medium)
                  .margin({ top: 2 })
              }.onClick(() => {
                if (!this.userInfoModel.isRelative) {
                  promptAction.showToast({ message: '请先关联账号~' })
                  return
                }
                this.showPreorderSheet = true
              }).bindSheet($$this.showPreorderSheet, this.preorderSheet(), {
                detents: [322, 323],
                blurStyle: BlurStyle.Thick,
                preferType: SheetType.CENTER,
                showClose: true,
                title: { title: $r('app.string.preorder_sheet_title') },
              })
            } else {
              Blank()
            }

          }.width(Constants.FULL_SIZE).justifyContent(FlexAlign.SpaceBetween)

          Row() {
            if (this.storeModel.orderType === OrderTypeEnum.TAKEOUT) {
              Row() {
                Text(this.storeModel.preorderTime)
                  .fontSize(14)
                  .fontColor($r('sys.color.font_primary'))
                  .fontWeight(FontWeight.Medium)
                Image($r('app.media.ic_arrow_right')).width(24)
              }
              .padding({ top: 4, bottom: 4, left: 8 })
              .borderRadius(20)
              .backgroundColor($r('sys.color.comp_background_tertiary'))
              .onClick(() => {
                if (!this.userInfoModel.isRelative) {
                  promptAction.showToast({ message: '请先关联账号~' })
                  return
                }
                this.showPreorderSheet = true
              })
            } else {
              Text(this.storeModel.storeInfo.address)
                .fontSize($r('sys.float.Caption_L'))
                .fontColor($r('sys.color.font_secondary'))
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .constraintSize({ maxWidth: '80%' })
            }

            if (this.storeModel.storeInfo.distanceStr) {
              Row() {
                Text($r('app.string.distance_me')).fontSize(12).fontColor($r('sys.color.font_secondary'))
                Text(this.storeModel.storeInfo.distanceStr).fontSize(12).fontColor($r('sys.color.multi_color_09'))
              }.margin({ left: 12 })
            }
          }.width(Constants.FULL_SIZE)

        }
        .width(Constants.FULL_SIZE)
        .justifyContent(FlexAlign.Start)
        .padding(12)
        .margin({ left: 16, right: 16 })
        .constraintSize({ maxWidth: Constants.FULL_SIZE })

        Column({ space: 8 }) {
          Row() {
            List({ space: 4 }) {
              ForEach(this.showCouponList, (item: CouponItem) => {
                ListItem() {
                  Row() {
                    Image($r('app.media.ic_red_package')).width(16)
                    Row() {
                      Text($r('app.string.currency_symbol')).fontSize($r('sys.float.Caption_M'))
                        .fontColor($r('sys.color.multi_color_08'))
                        .fontWeight(FontWeight.Medium)
                      Text(item.amountRule.discountAmount).fontSize($r('sys.float.Caption_M'))
                        .fontColor($r('sys.color.multi_color_08'))
                        .fontWeight(FontWeight.Medium)
                    }.margin({ left: 4 })

                    Column()
                      .width(0)
                      .border({ width: 0.5, color: $r('sys.color.multi_color_09'), style: BorderStyle.Dashed })
                      .height(20)
                      .margin({ left: 4, right: 4 })
                    Text(this.isPickUp(item) ? $r('app.string.collected') : $r('app.string.claim_now'))
                      .fontColor($r('sys.color.multi_color_08'))
                      .fontSize($r('sys.float.Caption_S'))
                  }
                  .visibility(Number(item.distributionQuantity) !== 0 ? Visibility.Visible : Visibility.None)
                  .padding({
                    top: 4,
                    bottom: 4,
                    left: 8,
                    right: 8,
                  })
                  .backgroundColor('#FFF1EF')
                  .border({ width: 1, color: '#E84026', radius: 4 })
                }
              }, (item: string) => JSON.stringify(item))
            }
            .listDirection(Axis.Horizontal)
            .scrollBar(BarState.Off)
            .height(28)
            .edgeEffect(EdgeEffect.Spring, { alwaysEnabled: true })
          }
          .margin({ left: 16 })
          .constraintSize({ maxWidth: Constants.FULL_SIZE })
          .justifyContent(FlexAlign.Start)
          .width(Constants.FULL_SIZE)
          .visibility(this.showCouponList.length ? Visibility.Visible : Visibility.None)

          Row() {
            Swiper() {
              ForEach(this.discountList, (item: DiscountModel) => {
                Row() {
                  Image($r('app.media.ic_notice')).width(14).height(14)
                  Text(item.content)
                    .fontColor($r('sys.color.multi_color_09'))
                    .fontSize($r('sys.float.Caption_M'))
                    .textAlign(TextAlign.Start)
                    .margin({ left: 4 })
                    .maxLines(1)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                    .layoutWeight(1)
                }.layoutWeight(1)

              }, (item: DiscountModel) => (JSON.stringify(item)))
            }
            .displayMode(SwiperDisplayMode.STRETCH)
            .loop(true)
            .autoPlay(true)
            .vertical(true)
            .indicator(false)
            .interval(2000)
            .layoutWeight(1)
            .onChange((index) => {
              this.swiperIndex = index;
            })

            Image($r('app.media.ic_down_color')).width(16)
          }
          .width(Constants.FULL_SIZE)
          .margin({ left: 16, right: 16 })
          .padding({
            top: 4,
            bottom: 4,
            left: 8,
            right: 8,
          })
          .constraintSize({ maxWidth: Constants.FULL_SIZE })
          .justifyContent(FlexAlign.SpaceBetween)
          .borderRadius(4)
          .backgroundColor('#1ADB6B42')
        }.onClick(() => {
          this.showShopDiscount = true
        })
        .bindSheet($$this.showShopDiscount, this.ShopDiscountSheet(), {
          detents: [600, '90%'],
          showClose: true,
          preferType: SheetType.CENTER,
          title: { title: '' },
        })

      }
    }
    .alignItems(HorizontalAlign.Start)
    .justifyContent(FlexAlign.End)
    .constraintSize({ maxWidth: Constants.FULL_SIZE })
  }

  @Builder
  preorderSheet() {
    Row() {
      Column() {
        Row() {
          Text(this.preorderLeftLabel)
            .fontSize(16)
            .fontColor($r('sys.color.font_primary'))
            .fontWeight(FontWeight.Medium)
        }
        .width(Constants.FULL_SIZE)
        .height(56)
        .backgroundColor($r('sys.color.background_primary'))
        .justifyContent(FlexAlign.Center)
      }.width(137).height(Constants.FULL_SIZE).backgroundColor($r('sys.color.background_secondary'))

      List() {
        ForEach(this.preorderLabelList, (item: PreorderLabel) => {
          ListItem() {
            Row() {
              Text(item.label).fontSize(16).fontColor($r('sys.color.font_primary')).fontWeight(FontWeight.Medium)
              Radio({ value: '', group: 'radioGroup' })
                .checked(item.check)
                .radioStyle({
                  checkedBackgroundColor: $r('sys.color.multi_color_09'),
                })
                .height(20)
                .width(20)
                .onChange((isChecked: boolean) => {
                  if (isChecked) {
                    this.storeModel.preorderTime = item.id === 0 ? item.label :
                      `今天（${this.weekDays[new Date().getDay()-1]}） ${item.label}`
                  }
                  item.check = isChecked
                })
            }.width(Constants.FULL_SIZE).justifyContent(FlexAlign.SpaceBetween)
          }
          .padding({
            left: 12,
            right: 14,
            top: 14,
            bottom: 14,
          })
          .height(56)
        }, (item: PreorderLabel) => item.id.toString())
      }
      .backgroundColor($r('sys.color.background_primary'))
      .layoutWeight(1)
      .divider({ strokeWidth: 1, startMargin: 15, endMargin: 15 })
      .edgeEffect(EdgeEffect.Spring)
    }
    .width(Constants.FULL_SIZE)
    .margin({
      left: Constants.BORDER_WIDTH,
      right: Constants.BORDER_WIDTH,
      bottom: this.windowModel.getWindowBottomHeight(),
    })
    .alignItems(VerticalAlign.Top)
    .constraintSize({ maxWidth: Constants.FULL_SIZE })
    .backgroundColor($r('sys.color.background_secondary'))
  }

  @Builder
  ShopDiscountSheet() {
    Column({ space: 12 }) {
      Column({ space: 12 }) {
        Text($r('app.string.coupon_label'))
          .fontSize(16)
          .fontColor($r('sys.color.font_primary'))
          .fontWeight(FontWeight.Medium)
        Column() {
          List({ space: 8 }) {
            ForEach(this.showCouponList, (coupon: CouponItem) => {
              ListItem() {
                CouponCard({
                  coupon: coupon,
                  isPickUpPage: true,
                  isPickUp: this.isPickUp(coupon),
                  claimNow: () => {
                    if (!this.userInfoModel.isRelative) {
                      promptAction.showToast({ message: '请先关联账号~' })
                      return
                    }
                    API.getLqCoupons(coupon.couponID).then(res => {
                      this.initCouponList()
                    })
                  },
                })
              }.backgroundColor($r('sys.color.background_primary')).borderRadius(16)
            }, (coupon: CouponItem) => coupon.couponID + coupon.status)
          }
          .edgeEffect(EdgeEffect.Spring, { alwaysEnabled: true })
          .nestedScroll({ scrollForward: NestedScrollMode.PARENT_FIRST, scrollBackward: NestedScrollMode.PARENT_FIRST })
        }
        .width(Constants.FULL_SIZE)
        .justifyContent(FlexAlign.Center)
      }.alignItems(HorizontalAlign.Start)

      Column({ space: 12 }) {
        Text($r('app.string.store_activity'))
          .fontSize(16)
          .fontColor($r('sys.color.font_primary'))
          .fontWeight(FontWeight.Medium)
        ForEach(this.discountList, (item: DiscountModel) => {
          Row() {
            Image($r('app.media.ic_notice')).width(16).height(16).borderRadius(4)
            Text(item.content)
              .fontColor($r('sys.color.font_secondary'))
              .fontSize(12)
              .margin({ left: 8 })
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .layoutWeight(1)
          }
        }, (item: DiscountModel) => (JSON.stringify(item)))
      }.alignItems(HorizontalAlign.Start).width(Constants.FULL_SIZE)
    }
    .width(Constants.FULL_SIZE)
    .margin({
      left: Constants.BORDER_WIDTH,
      right: Constants.BORDER_WIDTH,
      bottom: this.windowModel.getWindowBottomHeight(),
    })
    .padding({ bottom: 40 })
    .constraintSize({ maxWidth: Constants.FULL_SIZE })
    .backgroundColor($r('sys.color.background_secondary'))
  }

  isPickUp(coupon: CouponItem) {
    return this.myCouponList.some(item => item.couponID === coupon.couponID)
  }
}