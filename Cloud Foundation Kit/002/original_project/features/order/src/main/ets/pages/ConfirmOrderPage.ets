import { ToastDialog as promptAction } from '@hw-agconnect/ui-toast';
import { autoFillManager } from '@kit.AbilityKit';
import { UtilLog } from '@hw-agconnect/util-log';
import { Decimal } from '@kit.ArkTS';
import { AppStorageV2, componentUtils, PersistenceV2 } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { callTelSheetBuilder, CarGoodsInfo, CustomSelectSheetBuilder, GoodsComp } from 'base_ui';
import {
  AppInfoModel,
  BreakpointNameEnum,
  BreakpointType,
  CommonUrl,
  Constants,
  CouponRouter,
  GoodsSpecEnum,
  GridRowColSetting,
  MustGoodsController,
  MyCarModel,
  NavHeaderBar,
  OrderDetailRouter,
  OrderTypeEnum,
  PayType,
  RechargeTier,
  RemarksRouter,
  RouterMap,
  RouterModule,
  StoreInfoModel,
  UserInfoModel,
  WindowModel,
} from 'common/Index';
import { AddDnOrderReq } from 'network';
import * as API from '../api/Index';
import { Goods, PreorderLabel } from '../models/Index';


const TAG = '[ConfirmOrderPage]'

@Builder
export function ConfirmOrderPageBuilder() {
  ConfirmOrderPage()
}

@ComponentV2
struct ConfirmOrderPage {
  @Local breakpoint: string = '';
  @Local mustGoodsCtrl: MustGoodsController =
    AppStorageV2.connect(MustGoodsController, () => new MustGoodsController())!
  @Local appInfoModel: AppInfoModel = AppStorageV2.connect(AppInfoModel, () => new AppInfoModel())!;
  @Local myCarModel: MyCarModel = AppStorageV2.connect(MyCarModel)!
  @Local storeModel: StoreInfoModel = AppStorageV2.connect(StoreInfoModel, () => new StoreInfoModel())!;
  @Local windowModel: WindowModel = AppStorageV2.connect(WindowModel, () => new WindowModel())!
  @Local userInfoModel: UserInfoModel = PersistenceV2.connect(UserInfoModel, () => new UserInfoModel())!
  @Local remarks: string = ''
  // 预约号码
  @Local preorderPhone: string = ''
  @Local preorderPhoneTemp: string = ''
  // 订单总金额
  @Local totalMoney: number = 0
  @Local pkgDiscountMoney: number = 0
  @Local selectArray: Array<string> = []
  @Local isNew: boolean = false
  // 店铺优惠金额
  @Local reduction: number = 0
  // 已选优惠券Id
  @Local selectCouponId: string = ''
  // 已选优惠券金额
  @Local selectCouponMoney: number = 0
  // 下单id
  @Local orderId: string = ''
  @Local paySheetFlag: boolean = false
  @Local tableSheetShow: boolean = false;
  @Local dinerSheetShow: boolean = false;
  @Local preorderSheetShow: boolean = false;
  @Local showPreorderSheet: boolean = false;
  @Local snackSizedDealShow: boolean = true;
  @Local callTelSheet: boolean = false
  @Local addGoods: CarGoodsInfo[] = [];
  @Local selectWallet: boolean = false;
  @Local selectHWPay: boolean = false;
  @Local rechargeMoney?: RechargeTier
  @Local preorderLabelList: Array<PreorderLabel> = []
  @Local preorderLeftLabel: string = ''
  // 积分兑换
  @Local redeemedPoint: boolean = false;
  private weekDays = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
  private scroller: Scroller = new Scroller()

  @Computed
  get orderSumMoney() {
    // 订单总金额
    let sum = new Decimal(this.totalMoney).sub(this.reduction).sub(this.selectCouponMoney).toNumber()
    if (this.storeModel.orderType === OrderTypeEnum.TAKEOUT) {
      sum = new Decimal(sum).add(this.boxMoney).toNumber()
    }
    if (this.redeemedPoint) {
      sum = new Decimal(sum).sub(Constants.POINT_REDEEMED_MONEY).toNumber()
    }
    if (this.addGoods.length) {
      this.addGoods.forEach(item => {
        sum = new Decimal(item.money).mul(item.num).add(sum).toNumber()
      })
    }
    return sum > 0 ? sum : 0
  }

  @Computed
  get payMoney() {
    // 支付总金额
    if (this.selectWallet) {
      if (this.canUseWallet > this.orderSumMoney) {
        if (this.rechargeMoney) {
          return this.rechargeMoney.payMoney
        }
        return 0
      } else {
        return new Decimal(this.orderSumMoney).sub(this.canUseWallet).add(this.rechargeMoney?.payMoney || 0).toNumber()
      }
    }
    return this.orderSumMoney
  }

  // 打包盒费用
  @Computed
  get boxMoney() {
    let boxMoney = 0
    this.goodsList.forEach(item => {
      boxMoney = new Decimal(boxMoney).add(item.boxMoney).toNumber()
    })
    return boxMoney
  }

  @Computed
  get reductionMoney() {
    // 优惠总金额
    let money = new Decimal(this.reduction).add(this.selectCouponMoney).add(this.pkgDiscountMoney).toNumber()
    if (this.redeemedPoint) {
      money = new Decimal(money).add(Constants.POINT_REDEEMED_MONEY).toNumber()
    }
    return money
  }

  @Computed
  get goodsList() {
    return [...this.myCarModel.myCar.goodsList, ...this.addGoods]
  }

  @Computed
  get canUseWallet() {
    if (this.userInfoModel.isRelative) {
      return new Decimal(this.userInfoModel.userInfo.wallet).add(this.rechargeMoney?.realMoney || 0).toNumber()
    } else {
      return 0
    }
  }

  @Computed
  get balanceWallet() {
    return new Decimal(this.canUseWallet).sub(this.orderSumMoney)
  }

  @Computed
  get maxCarGoodsId() {
    let maxId: number = 0
    this.myCarModel.myCar.goodsList.forEach(item => {
      if (maxId < Number(item.id)) {
        maxId = Number(item.id)
      }
    })
    return maxId
  }

  @Computed
  get rechargeTierList() {
    return this.storeModel.storeInfo.rechargeTier.filter(item => item.type === 2)
  }

  async aboutToAppear(): Promise<void> {
    this.getIsNew()
    if (this.storeModel.orderType === OrderTypeEnum.DINE_IN) {
      this.initTableInfo()
    }
    this.initPkgDiscountMoney()
    this.myCarModel.myCar.goodsList.forEach(item => {
      this.totalMoney = new Decimal(item.money || 0).mul(item.num || 0).add(this.totalMoney).toNumber()
    })
    this.getPreorderTimeList()
  }

  build() {
    NavDestination() {
      GridRow(GridRowColSetting.DEFAULT_GRID_ROW_OPTIONS) {
        GridCol({ span: GridRowColSetting.GRID_ROW_OPTIONS_COLUMNS }) {
          Column() {
            NavHeaderBar({ title: $r('app.string.confirm_order') })
            Scroll(this.scroller) {
              Column({ space: 12 }) {
                // 店铺信息
                this.storeInfoCard()
                // 就餐方式
                this.orderTypeCard()
                // 订单商品
                GoodsComp({ goodsList: this.goodsList }).margin({
                  left: 12,
                  right: 12,
                })
                // 优惠
                this.reductionCard()
                //支付方式
                this.payTypeCard()
                // 其他信息
                this.otherCard()
              }.margin({ top: 12, bottom: 12 })
            }
            .backgroundColor($r('sys.color.background_secondary'))
            .layoutWeight(1)
            .align(Alignment.Top)
            .scrollBar(BarState.Off)

            Row() {
              if (this.breakpoint === BreakpointNameEnum.SM) {
                Column() {
                  Text() {
                    Span($r('app.string.total_pay'))
                      .fontSize($r('sys.float.Caption_L'))
                      .fontColor($r('sys.color.font_secondary'))
                      .lineHeight(14)
                    Span($r('app.string.currency_symbol'))
                      .fontSize(8)
                      .fontWeight(FontWeight.Medium)
                      .fontColor($r('sys.color.font_primary'))
                      .lineHeight(12)
                      .margin({ left: 1 })
                    Span(`${this.payMoney}`)
                      .fontSize($r('sys.float.Body_L'))
                      .fontWeight(FontWeight.Medium)
                      .fontColor($r('sys.color.font_primary'))
                      .lineHeight(18)
                  }

                  Text(``) {
                    Span($r('app.string.discount_money')).fontSize(8).lineHeight(12)
                    Span($r('app.string.currency_symbol')).fontSize(8).fontWeight(FontWeight.Medium).lineHeight(12)
                    Span(this.reductionMoney.toString())
                      .fontSize($r('sys.float.Caption_M'))
                      .lineHeight(14)
                  }.fontColor('#E84026').margin({ top: 8 })
                }.alignItems(HorizontalAlign.End)
              } else {
                Row({ space: 8 }) {
                  Text() {
                    Span($r('app.string.total_pay'))
                      .fontSize($r('sys.float.Caption_L'))
                      .fontColor($r('sys.color.font_secondary'))
                      .lineHeight(14)
                    Span($r('app.string.currency_symbol'))
                      .fontSize(8)
                      .fontWeight(FontWeight.Medium)
                      .fontColor($r('sys.color.font_primary'))
                      .lineHeight(12)
                      .margin({ left: 1 })
                    Span(`${this.payMoney}`)
                      .fontSize($r('sys.float.Body_L'))
                      .fontWeight(FontWeight.Medium)
                      .fontColor($r('sys.color.font_primary'))
                      .lineHeight(18)
                  }

                  Text(``) {
                    Span($r('app.string.discount_money')).fontSize(8).lineHeight(12)
                    Span($r('app.string.currency_symbol')).fontSize(8).fontWeight(FontWeight.Medium).lineHeight(12)
                    Span(this.reductionMoney.toString())
                      .fontSize($r('sys.float.Caption_M'))
                      .lineHeight(14)
                  }.fontColor('#E84026')
                }.alignItems(VerticalAlign.Bottom)
              }


              Button('提交支付')
                .fontSize($r('sys.float.Body_L'))
                .fontWeight(700)
                .fontColor($r('sys.color.comp_background_list_card'))
                .width(this.breakpoint === BreakpointNameEnum.SM ? 120 : 448)
                .padding({
                  left: 21,
                  right: 21,
                  top: 8,
                  bottom: 8,
                })
                .margin({ left: 16 })
                .backgroundColor($r('sys.color.multi_color_09'))
                .onClick(() => {
                  this.commitOrder()
                })
            }.width(Constants.FULL_SIZE).height(56).padding({
              top: 8,
              bottom: 8,
              left: new BreakpointType<number>({
                [BreakpointNameEnum.SM]: 12,
                [BreakpointNameEnum.MD]: 24,
                [BreakpointNameEnum.LG]: 24,
                [BreakpointNameEnum.XL]: 24,
              }).getValue(this.breakpoint),
              right: new BreakpointType<number>({
                [BreakpointNameEnum.SM]: 12,
                [BreakpointNameEnum.MD]: 24,
                [BreakpointNameEnum.LG]: 24,
                [BreakpointNameEnum.XL]: 24,
              }).getValue(this.breakpoint),
            }).justifyContent(this.breakpoint === BreakpointNameEnum.SM ? FlexAlign.End : FlexAlign.SpaceBetween)
          }.height(Constants.FULL_SIZE)
        }
      }
      .onBreakpointChange((bp) => {
        this.breakpoint = bp;
      })
    }.hideTitleBar(true).padding({ bottom: this.windowModel.getWindowBottomHeight() })
  }

  @Builder
  storeInfoCard() {
    Column({ space: 4 }) {
      Row() {
        Row() {
          Image(`${CommonUrl.CLOUD_STORAGE_URL}${this.storeModel.storeInfo?.logo}`)
            .width(40)
            .height(40)
            .borderRadius(20)
          Text(this.storeModel.storeInfo.name)
            .fontSize(18)
            .fontColor($r('sys.color.font_primary'))
            .fontWeight(FontWeight.Medium)
            .margin({ left: 4 })
            .maxLines(1)
            .constraintSize({ maxWidth: '75%' })
            .textOverflow({ overflow: TextOverflow.Ellipsis })
          Image($r('app.media.right_arrow')).width(16).margin({ left: 8 })
        }.layoutWeight(1).onClick(() => {
          RouterModule.push(RouterMap.MERCHANT_DETAIL_PAGE)
        })

        Image($r('app.media.phone_icon')).width(24).height(24)
          .onClick(() => {
            // 拨打商家电话
            this.callTelSheet = true
          })
          .bindSheet($$this.callTelSheet, callTelSheetBuilder(this.storeModel.storeInfo.tel, () => {
            this.callTelSheet = false
          }), {
            detents: [309, 310],
            backgroundColor: $r('sys.color.background_fourth'),
            blurStyle: BlurStyle.Thick,
            preferType: SheetType.CENTER,
            title: { title: $r('app.string.contact_us') },
          });
      }.width(Constants.FULL_SIZE).constraintSize({ maxWidth: Constants.FULL_SIZE })

      Row() {
        Image($r('app.media.ic_position')).width(12).height(12)
        Text(this.storeModel.storeInfo.address)
          .fontSize(10)
          .fontColor($r('sys.color.font_secondary'))
          .margin({ left: 2 })
      }.width('100%')
    }.cardStyle()
  }

  @Builder
  orderTypeCard() {
    Column({ space: 12 }) {
      if (this.storeModel.orderType === OrderTypeEnum.TAKEOUT) {
        Row() {
          Text('预约时间')
          Row() {
            Text(this.storeModel.preorderTime)
              .fontSize(14)
              .fontColor($r('sys.color.font_primary'))
              .fontWeight(FontWeight.Medium)
            Image($r('app.media.right_arrow')).width(16).margin({ left: 12 })
          }
        }.width('100%').justifyContent(FlexAlign.SpaceBetween).onClick(() => {
          this.showPreorderSheet = true
        }).bindSheet($$this.showPreorderSheet, this.preorderSheet(), {
          detents: [322, 323],
          blurStyle: BlurStyle.Thick,
          preferType: SheetType.CENTER,
          showClose: true,
          title: { title: $r('app.string.preorder_sheet_title') },
        })
      }

      Row({ space: this.breakpoint === BreakpointNameEnum.SM ? 8 : 24 }) {
        Row() {
          Image($r('app.media.store_dining')).width(40)
          Column() {
            Text($r('app.string.store_dining'))
              .fontSize($r('sys.float.Body_M'))
              .fontWeight(FontWeight.Medium)
              .fontColor($r('sys.color.font_primary'))
              .lineHeight(16)
            Text($r('app.string.store_dining_desc'))
              .fontSize($r('sys.float.Caption_M'))
              .fontColor($r('sys.color.font_secondary'))
              .lineHeight(12)
              .margin({ top: 4 })
          }.margin({ left: 8 }).alignItems(HorizontalAlign.Start)
        }
        .layoutWeight(1)
        .height(64)
        .padding(12)
        .borderWidth(1)
        .borderRadius(12)
        .borderColor(this.storeModel.orderType === OrderTypeEnum.DINE_IN ? $r('app.color.mainColor') :
          '#CCCCCC')
        .backgroundColor(this.storeModel.orderType === OrderTypeEnum.DINE_IN ? '#0DED6F21' : '#ffffff')
        .onClick(() => {
          if (this.storeModel.orderType !== OrderTypeEnum.DINE_IN) {
            this.storeModel.orderType = OrderTypeEnum.DINE_IN
          }
        })

        Row() {
          Image($r('app.media.packing')).width(40)
          Column() {
            Text($r('app.string.picking'))
              .fontSize($r('sys.float.Body_M'))
              .fontWeight(FontWeight.Medium)
              .fontColor($r('sys.color.font_primary'))
              .lineHeight(16)
            Text($r('app.string.picking_desc'))
              .fontSize($r('sys.float.Caption_M'))
              .fontColor($r('sys.color.font_secondary'))
              .lineHeight(12)
              .margin({ top: 4 })
          }.margin({ left: 8 }).alignItems(HorizontalAlign.Start)
        }
        .layoutWeight(1)
        .height(64)
        .padding(12)
        .borderWidth(1)
        .borderRadius(12)
        .borderColor(this.storeModel.orderType === OrderTypeEnum.TAKEOUT ? $r('app.color.mainColor') :
          '#CCCCCC')
        .backgroundColor(this.storeModel.orderType === OrderTypeEnum.TAKEOUT ? '#0DED6F21' :
          '#ffffff')
        .onClick(() => {
          if (this.storeModel.orderType !== OrderTypeEnum.TAKEOUT) {
            this.storeModel.orderType = OrderTypeEnum.TAKEOUT
          }
        })
      }.width(Constants.FULL_SIZE).justifyContent(FlexAlign.SpaceBetween).margin({ bottom: 4 })

      if (this.storeModel.orderType === OrderTypeEnum.DINE_IN) {
        Row() {
          Text('就餐人数')
            .fontSize($r('sys.float.Subtitle_L'))
            .fontWeight(FontWeight.Medium)
            .fontColor($r('sys.color.font_primary'))
          Row() {
            Text(`${this.storeModel.dinerNum}`)
              .fontSize($r('sys.float.Body_M'))
              .fontColor($r('sys.color.font_primary'))
              .margin({ left: 8 })
          }
        }
        .width(Constants.FULL_SIZE)
        .margin({
          left: 12,
          right: 12,
          top: 4,
        })
        .constraintSize({ maxWidth: Constants.FULL_SIZE })
        .justifyContent(FlexAlign.SpaceBetween)
        .onClick(() => {
          this.dinerSheetShow = true
        })
        .bindSheet($$this.dinerSheetShow,
          CustomSelectSheetBuilder($r('app.strarray.diner_num'),
            (select: ResourceStr) => {
              this.confirmDiner(select);
            }, this.storeModel.dinerNum), {
            detents: [408, 409],
            backgroundColor: $r('sys.color.background_fourth'),
            blurStyle: BlurStyle.Thick,
            preferType: SheetType.CENTER,
            title: { title: $r('app.string.pick_dinner_num') },
          });

        Row() {
          Text('我的桌号')
            .fontSize($r('sys.float.Subtitle_L'))
            .fontWeight(FontWeight.Medium)
            .fontColor($r('sys.color.font_primary'))
          Row() {
            Text(`${this.storeModel.tableInfo?.typeName}${this.storeModel.tableInfo?.tableName}`)
              .fontSize($r('sys.float.Body_M'))
              .fontColor($r('sys.color.font_primary'))
          }
        }
        .width(Constants.FULL_SIZE)
        .margin({
          left: 12,
          right: 12,
          top: 4,
        })
        .constraintSize({ maxWidth: Constants.FULL_SIZE })
        .justifyContent(FlexAlign.SpaceBetween)
        .onClick(() => {
          this.tableSheetShow = true
        })
        .bindSheet($$this.tableSheetShow,
          CustomSelectSheetBuilder(this.storeModel.tableList.map((item) => item.tableName ?? ''),
            (select: ResourceStr) => {
              this.confirmTable(select);
            }, this.storeModel.tableInfo.tableName), {
            detents: [408, 409],
            backgroundColor: $r('sys.color.background_fourth'),
            blurStyle: BlurStyle.Thick,
            preferType: SheetType.CENTER,
            title: { title: $r('app.string.pick_table') },
          });
      }
    }.cardStyle()
  }

  @Builder
  reductionCard() {
    Column() {
      // 优惠
      Column() {
        Row() {
          Row() {
            Image($r('app.media.full_reduction')).width(16)
            Text(this.isNew ? $r('app.string.new_user_discount_label') : $r('app.string.store_discount_label'))
              .fontSize($r('sys.float.Body_M'))
              .fontColor($r('sys.color.font_primary'))
              .lineHeight(20)
              .margin({ left: 8 })
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
          }.layoutWeight(1)

          Text() {
            Span($r('app.string.currency_symbol_pre_params', '-'))
              .fontSize(8)
              .fontWeight(FontWeight.Medium)
              .lineHeight(14)
            Span(`${Number(this.reduction)}`)
              .fontSize($r('sys.float.Body_M'))
              .fontWeight(FontWeight.Medium)
              .lineHeight(20)
          }.fontColor('#E84026')
        }
        .width(Constants.FULL_SIZE)
        .height(40)
        .padding({ top: 10, bottom: 10 })
        .justifyContent(FlexAlign.SpaceBetween)

        // 红包
        Row() {
          Row() {
            Image($r('app.media.ic_red_packet')).width(16)
            Text('红包').fontSize($r('sys.float.Body_M')).fontColor($r('sys.color.font_primary')).margin({ left: 8 })
          }

          Row() {
            Text('150积分抵扣5元').fontSize($r('sys.float.Caption_L')).fontColor('#E84026')
            Checkbox({ name: '' })
              .select($$this.redeemedPoint)
              .selectedColor($r('sys.color.multi_color_09'))
              .shape(CheckBoxShape.CIRCLE)
              .enabled(this.userInfoModel.userInfo.totalScore > 150)
              .height(24)
              .width(24)
              .padding(2)
              .margin(0)
              .onChange((value: boolean) => {
                if (value) {
                  API.checkPoint().then(res => {
                    if (!res) {
                      this.getUIContext().getPromptAction().showToast({ message: '积分不足，已有其他订单锁定积分兑换~' })
                      this.redeemedPoint = false
                    }
                  })
                }
              })
          }.justifyContent(FlexAlign.End)
        }
        .width(Constants.FULL_SIZE)
        .height(40)
        .padding({ top: 10, bottom: 10 })
        .justifyContent(FlexAlign.SpaceBetween)

        Row() {
          Row() {
            Image($r('app.media.vouchers')).width(16)
            Text($r('app.string.coupon_label'))
              .fontSize($r('sys.float.Body_M'))
              .fontColor($r('sys.color.font_primary'))
              .lineHeight(20)
              .margin({ left: 8 })
          }

          Row() {
            if (!this.selectCouponMoney || this.selectCouponMoney === 0) {
              Text($r('app.string.select_coupon'))
                .fontSize($r('sys.float.Body_S'))
                .fontColor($r('sys.color.font_secondary'))
            } else {
              Text() {
                Span($r('app.string.currency_symbol_pre_params', '-'))
                  .fontSize(8)
                  .fontWeight(FontWeight.Medium)
                  .lineHeight(14)
                Span(`${Number(this.selectCouponMoney)}`)
                  .fontSize($r('sys.float.Body_M'))
                  .fontWeight(FontWeight.Medium)
                  .lineHeight(20)
              }.fontColor('#E84026')
            }
            Image($r('app.media.right_arrow')).width(16)
          }.onClick(() => {
            RouterModule.push(RouterMap.SELECT_COUPON_PAGE,
              { totalMoney: (this.myCarModel.myCar.money ?? 0), selectId: this.selectCouponId } as CouponRouter,
              (popInfo: PopInfo) => {
                let result = popInfo.result as CouponRouter
                this.selectCouponId = result.selectId
                this.selectCouponMoney = result.reduce
              },
            )
          })
        }
        .width(Constants.FULL_SIZE)
        .height(40)
        .padding({ top: 10, bottom: 10 })
        .justifyContent(FlexAlign.SpaceBetween)

        if (this.storeModel.orderType === OrderTypeEnum.TAKEOUT) {
          Row() {
            Row() {
              Image($r('app.media.ic_packet')).width(16)
              Text($r('app.string.packing_box'))
                .fontSize($r('sys.float.Body_M'))
                .fontColor($r('sys.color.font_primary'))
                .lineHeight(20)
                .margin({ left: 8 })
            }

            Row() {
              Text() {
                Span($r('app.string.currency_symbol_pre_params', '+'))
                  .fontSize(8)
                  .fontWeight(FontWeight.Medium)
                  .lineHeight(14)
                Span(`${this.boxMoney}`)
                  .fontSize($r('sys.float.Body_S'))
                  .lineHeight(20)
                  .fontColor('#E84026')
              }.fontColor('#E84026')
            }
          }
          .width(Constants.FULL_SIZE)
          .height(40)
          .padding({ top: 10, bottom: 10 })
          .justifyContent(FlexAlign.SpaceBetween)
        }

      }

      Divider().margin({ top: 8 })
      // 实付金额
      Row() {
        Text() {
          Span($r('app.string.discount_money')).fontSize($r('sys.float.Body_M')).lineHeight(20)
          Span($r('app.string.currency_symbol'))
            .fontSize(8)
            .fontWeight(FontWeight.Medium)
            .lineHeight(14)
            .margin({ left: 4 })
          Span(this.reductionMoney.toString())
            .fontSize($r('sys.float.Body_M'))
            .fontWeight(FontWeight.Medium)
            .lineHeight(20)
        }.fontColor('#E84026')

        Text() {
          Span($r('app.string.should_pay')).fontSize($r('sys.float.Body_M')).lineHeight(20)
          Span($r('app.string.currency_symbol'))
            .fontSize(8)
            .fontWeight(FontWeight.Medium)
            .lineHeight(14)
            .margin({ left: 4 })
          Span(`${this.orderSumMoney}`)
            .fontSize($r('sys.float.Body_M'))
            .fontWeight(FontWeight.Medium)
            .lineHeight(20)
        }.fontColor($r('sys.color.font_primary')).margin({ left: 20 })
      }
      .width(Constants.FULL_SIZE)
      .padding({ top: 16 })
      .justifyContent(FlexAlign.End)
      .constraintSize({ maxWidth: Constants.FULL_SIZE })

    }.cardStyle().alignItems(HorizontalAlign.Start)
  }

  @Builder
  payTypeCard() {
    Column({ space: 12 }) {
      Text('支付方式')
      Row() {
        Row() {
          Image($r('app.media.ic_wallet')).width(24)
          Text('会员余额').fontSize(12).fontColor($r('sys.color.font_primary')).margin({ left: 8 })
          Text('（可用').fontSize(12).fontColor($r('sys.color.font_primary')).margin({ left: 2 })
          Text(`￥${this.canUseWallet}`)
            .fontSize(12)
            .fontColor($r('sys.color.multi_color_09'))
            .margin({ left: 2 })
          if (this.selectWallet) {
            Text(`，`).fontSize(12).fontColor($r('sys.color.font_primary')).margin({ left: 2 })
            Text(`剩余`).fontSize(12).fontColor($r('sys.color.font_primary')).margin({ left: 2 })
            Text(`￥${this.balanceWallet}`)
              .fontSize(12)
              .fontColor($r('sys.color.multi_color_09'))
              .margin({ left: 2 })
          }
          Text(`）`).fontSize(12).fontColor($r('sys.color.font_primary')).margin({ left: 2 })
        }

        Row() {
          if (this.userInfoModel.userInfo.wallet < this.orderSumMoney) {
            Text(`余额不足`).fontSize(12).fontColor($r('sys.color.font_secondary'))
          } else if (this.selectWallet) {
            Text(`-￥${this.orderSumMoney}`).fontSize(12).fontColor($r('sys.color.multi_color_09'))
          }
          Checkbox({ name: '' })
            .select($$this.selectWallet)
            .selectedColor($r('sys.color.multi_color_09'))
            .shape(CheckBoxShape.CIRCLE)
            .enabled(this.userInfoModel.isRelative)
            .height(24)
            .width(24)
            .padding(2)
            .margin(0)
            .onChange(() => {
              if (this.selectWallet) {
                if (this.userInfoModel.userInfo.wallet < this.orderSumMoney) {
                  this.rechargeMoney = this.rechargeTierList[0]
                  this.selectHWPay = true
                }
              } else {
                this.rechargeMoney = undefined
              }
            })
        }
      }.width('100%').justifyContent(FlexAlign.SpaceBetween)

      List({ space: 8 }) {
        ForEach(this.rechargeTierList, (item: RechargeTier) => {
          ListItem() {
            Column({ space: 6 }) {
              Text(item.name).fontSize(10).fontColor($r('sys.color.font_primary'))
              Text(`￥${item.payMoney}`)
                .fontSize(14)
                .fontColor($r('sys.color.multi_color_09'))
                .fontWeight(FontWeight.Medium)
              Text(item.desc).fontSize(10).fontColor($r('sys.color.font_primary'))
            }
            .padding(8)
            .backgroundColor('#33ED6F21')
            .borderRadius(8)
            .border(this.rechargeMoney?.id === item.id ? { width: 1, color: $r('sys.color.multi_color_09') } :
              { width: 0 })
            .alignItems(HorizontalAlign.Start)
            .onClick(() => {
              if (this.selectWallet) {
                this.rechargeMoney = item
                this.selectHWPay = true
              }
            })
          }
        }, (item: RechargeTier) => item.id)
      }.listDirection(Axis.Horizontal).scrollBar(BarState.Off)

      Divider()
      Row() {
        Row() {
          Image($r('app.media.ic_huawei_pay')).width(24).borderRadius(8)
          Text('华为支付').fontSize(12).fontColor($r('sys.color.font_primary')).margin({ left: 8 })
        }

        Checkbox({ name: '' })
          .select($$this.selectHWPay)
          .selectedColor($r('sys.color.multi_color_09'))
          .shape(CheckBoxShape.CIRCLE)
          .height(24)
          .width(24)
          .padding(2)
          .margin(0)
          .onClick(() => {
            // 已选择充值金额，不允许取消华为支付
            if (this.selectHWPay || this.rechargeMoney) {
              this.selectHWPay = true
            } else {
              this.selectHWPay = false
            }
            // 未选择钱包使用华为支付
            if (!this.selectWallet) {
            }
          })
      }.width('100%').justifyContent(FlexAlign.SpaceBetween)
    }.cardStyle().alignItems(HorizontalAlign.Start).id('payType')
  }

  @Builder
  otherCard() {
    Column() {
      Row() {
        Text('预留电话')
          .fontSize($r('sys.float.Body_M'))
          .fontWeight(FontWeight.Medium)
          .fontColor($r('sys.color.font_primary'))
        Row() {
          Text(this.preorderPhone || '请填写号码')
            .fontSize($r('sys.float.Body_S'))
            .fontColor($r('sys.color.font_secondary'))
            .textAlign(TextAlign.End)
            .width(200)
          Image($r('app.media.right_arrow')).width(16)
        }.justifyContent(FlexAlign.End).layoutWeight(1)
      }
      .width(Constants.FULL_SIZE)
      .padding({ top: 12, bottom: 12 })
      .justifyContent(FlexAlign.SpaceBetween)
      .onClick(() => {
        this.preorderPhoneTemp = this.preorderPhone
        this.preorderSheetShow = true
      })
      .bindSheet($$this.preorderSheetShow, this.preorderPhoneBuilder(), {
        height: 420,
        preferType: SheetType.CENTER,
        title: { title: '预留电话' },
      });

      Row() {
        Text($r('app.string.remark'))
          .fontSize($r('sys.float.Body_M'))
          .fontWeight(FontWeight.Medium)
          .fontColor($r('sys.color.font_primary'))
          .lineHeight(20)
        Row() {
          Text(this.remarks || $r('app.string.fill_remarks'))
            .fontSize($r('sys.float.Body_S'))
            .fontColor($r('sys.color.font_secondary'))
            .textAlign(TextAlign.End)
            .width(200)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
          Image($r('app.media.right_arrow')).width(16)
        }.justifyContent(FlexAlign.End).layoutWeight(1)
      }
      .width(Constants.FULL_SIZE)
      .padding({ top: 12, bottom: 12 })
      .justifyContent(FlexAlign.SpaceBetween)
      .onClick(() => {
        RouterModule.push(RouterMap.REMARKS_PAGE,
          { remarks: this.remarks ? this.remarks : '' } as RemarksRouter, // 清除默认备注
          (popInfo: PopInfo) => {
            // 先还原总价格后再减去优惠券金额
            let result = popInfo.result as RemarksRouter
            this.remarks = result.remarks
          },
        )
      })
    }.cardStyle()
  }

  @Builder
  preorderPhoneBuilder() {
    Column() {
      Row() {
        TextInput({ text: $$this.preorderPhoneTemp, placeholder: '请填写号码' })
          .backgroundColor('#FFFFFF')
          .contentType(ContentType.PHONE_NUMBER)
          .selectionMenuHidden(true)
          .maxLength(11)
          .cancelButton({
            style: CancelButtonStyle.CONSTANT,
            icon: {
              size: 16,
              src: $r('app.media.clear'),
              color: '#000000',
            },
          });
      };

      Button('确定')
        .fontColor($r('sys.color.font_on_primary'))
        .backgroundColor($r('sys.color.multi_color_09'))
        .width('100%')
        .margin({ left: 28, right: 28, bottom: 20 })
        .onClick(() => {
          this.preorderPhone = this.preorderPhoneTemp;
          this.preorderSheetShow = false;
          try {
            autoFillManager.requestAutoSave(this.getUIContext())
          } catch (err) {
            let e: BusinessError = err as BusinessError;
            UtilLog.error(0x0000, 'DemoTest', 'error: %{public}d %{public}s', e.code, e.message);
          }
        });
    }.padding(16).height('100%')
    .justifyContent(FlexAlign.SpaceBetween);
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
                    this.storeModel.preorderTime =
                      item.id === 0 ? item.label : `今天（${this.weekDays[new Date().getDay()-1]}） ${item.label}`
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
    }
    .width(Constants.FULL_SIZE)
    .margin({
      left: GridRowColSetting.getPageMargin(this.breakpoint),
      right: GridRowColSetting.getPageMargin(this.breakpoint),
      bottom: this.windowModel.getWindowBottomHeight(),
    })
    .alignItems(VerticalAlign.Top)
    .constraintSize({ maxWidth: Constants.FULL_SIZE })
    .backgroundColor($r('sys.color.background_secondary'))
  }

  @Styles
  cardStyle(){
    .width(Constants.FULL_SIZE)
    .constraintSize({ maxWidth: Constants.FULL_SIZE })
    .backgroundColor($r('sys.color.background_primary'))
    .borderRadius(16)
    .padding({
      left: 12,
      right: 12,
      top: 16,
      bottom: 16,
    })
    .margin({
      left: 12,
      right: 12,
    })
  }

  initPkgDiscountMoney() {
    this.myCarModel.myCar.goodsList?.forEach(item => {
      if (item.specType === GoodsSpecEnum.PACKAGE_TYPE) {
        let discount = new Decimal(item.money2 || 0).sub(item.money || 0).mul(item.num!)
        this.pkgDiscountMoney = new Decimal(this.pkgDiscountMoney).add(discount).toNumber()
      }
    })
  }

  getIsNew() {
    API.getIsNew().then((resp: number) => {
      this.isNew = resp === 1
    }).finally(() => {
      this.getReduction()
    })
  }

  initTableInfo() {
    this.selectArray = this.storeModel.tableList.map((item) => item.tableName ?? '')
    // 校验餐桌和用餐人数选择
    if (!this.storeModel.tableId) {
      this.tableSheetShow = true
    }
  }

  getPreorderTimeList() {
    this.preorderLabelList.push(new PreorderLabel(0, '立即就餐', false))
    const date = new Date()
    for (let i = date.getHours() + 1; i < 24; i++) {
      this.preorderLabelList.push(new PreorderLabel(i, `${i.toString().padStart(2, '0')}:00`, false))
    }
    this.preorderLeftLabel = `今天（${this.weekDays[date.getDay()-1]}）`
  }

  getReduction() {
    let maxFullIndex = -1
    let maxFull = 0
    this.storeModel.storeInfo.reductionList.forEach((item, index) => {
      let full = Number(item.full)
      if ((this.myCarModel.myCar.money ?? 0) > full && full > maxFull) {
        maxFull = full
        maxFullIndex = index
      }
    })
    let reduction = 0
    if (maxFullIndex >= 0) {
      reduction = Number(this.storeModel.storeInfo.reductionList[maxFullIndex]?.reduction ?? 0)
    }
    if (this.isNew) {
      this.reduction = Number(this.storeModel.storeInfo.xyhMoney) ?? 0
    } else {
      this.reduction = reduction
    }
  }

  commitOrder() {
    if (this.storeModel.orderType === OrderTypeEnum.DINE_IN) {
      if (!this.storeModel.tableId) {
        this.tableSheetShow = true
        return
      }
    }
    if (!this.storeModel.dinerNum) {
      this.dinerSheetShow = true
      return
    }
    if (!this.selectWallet && !this.selectHWPay) {
      promptAction.showToast({ message: '请选择支付方式~' })
      let modePosition: componentUtils.ComponentInfo =
        this.getUIContext().getComponentUtils().getRectangleById('payType')
      this.scroller.scrollBy(0, modePosition.screenOffset.y)
      return
    }
    if (this.snackSizedDealShow) {
      RouterModule.push(RouterMap.SNACK_SIZED_DEAL_PAGE, null, (onPop: PopInfo) => {
        if (onPop?.result) {
          let addGoods: Goods[] = onPop.result as Goods[]
          addGoods.forEach((item, index) => {
            let goods: CarGoodsInfo = new CarGoodsInfo()
            goods.id = `${this.maxCarGoodsId + index + 1}`
            goods.goodsId = item.id
            goods.name = item.name
            goods.logo = item.logo
            goods.num = 1
            goods.specType = item.specType
            goods.spec = ''
            goods.combination = []
            goods.discount = item.discount
            goods.money = item.money
            goods.money2 = item.money2
            goods.boxMoney = item.boxMoney
            goods.isMust = item.isMust
            this.addGoods.push(goods)
          })
        }
      })
      this.snackSizedDealShow = false
    } else {
      this.confirmOrder()
    }
  }

  confirmTable(select: ResourceStr) {
    if (select) {
      let table = this.storeModel.tableList.find(item => item.tableName === select)
      this.storeModel.tableId = table?.id ?? '1';
      this.storeModel.tableInfo = this.storeModel.tableList.find(item => item.id === this.storeModel.tableId)!;
    }
    this.tableSheetShow = false
  }

  confirmDiner(select: ResourceStr) {
    if (select) {
      this.storeModel.dinerNum = select;
    } else {
      this.storeModel.dinerNum = this.storeModel.dinerNum || `1人`;
    }
    this.dinerSheetShow = false
  }

  updateOrder() {
    API.getHuaweiPayInfo(this.orderId).then((resp: number) => {
      this.updateUserInfo()
      RouterModule.replace(RouterMap.ORDER_DETAIL_PAGE,
        { orderId: `${this.orderId}`, isOrderJump: true } as OrderDetailRouter)
    }).catch((e: BusinessError) => {
      UtilLog.error(TAG, `getHuaweiPayInfo error: ${JSON.stringify(e)}.`);
      promptAction.showToast({ message: '订单更新失败' })
    })
  }

  confirmOrder() {
    if (!this.myCarModel.myCar.goodsList?.length) {
      promptAction.showToast({ message: '购物车商品为空，请选择商品后结算' })
      return
    }

    let req: AddDnOrderReq = {
      money: this.orderSumMoney,
      reductionMoney: new Decimal(this.reduction).add(this.selectCouponMoney).add(this.pkgDiscountMoney).toNumber(),
      yhqMoney: this.selectCouponMoney,
      couponId: this.selectCouponId,
      orderType: this.storeModel.orderType,
      mjMoney: this.isNew ? 0 : this.reduction,
      xyhMoney: this.isNew ? this.reduction : 0,
      redeemedPoint: this.redeemedPoint,
      note: this.remarks ? this.remarks : '',
      boxMoney: this.storeModel.orderType === OrderTypeEnum.TAKEOUT ? (this.boxMoney || 0) : 0,
      tableId: '',
      discount: '',
      payType: this.selectWallet ? PayType.WALLET : PayType.HUAWEI_PAY,
      rechargeId: this.rechargeMoney?.id,
      sz: '',
      tableware: '0',
      preorderTime: this.storeModel.preorderTime.toString(),
      preorderPhone: this.preorderPhone,
    }
    API.addDnOrder(this.goodsList, req).then(async (resp: number) => {
      this.orderId = `${resp}`
      this.mustGoodsCtrl.cleanCar()
      // 钱包支付，状态直接改为已支付
      if (!this.selectWallet || this.rechargeMoney) {
        API.purchase(Boolean(this.rechargeMoney?.id)).then(() => {
          // todo 支付回调处理
          //  支付成功更新订单信息
          this.updateOrder()
        }).catch(() => {
          // 支付失败跳转详情页
          RouterModule.replace(RouterMap.ORDER_DETAIL_PAGE,
            { orderId: `${resp}`, isOrderJump: true } as OrderDetailRouter)
        })
      } else {
        // 更新钱包信息
        API.getUserInfo().then((res) => {
          this.userInfoModel.userInfo.wallet = res.wallet
        })
        RouterModule.replace(RouterMap.ORDER_DETAIL_PAGE,
          { orderId: `${this.orderId}`, isOrderJump: true } as OrderDetailRouter)
      }
    }).catch((e: BusinessError) => {
      UtilLog.error(TAG, `confirmOrder error: ${JSON.stringify(e)}.`);
      promptAction.showToast({ message: `下单失败！错误码：${JSON.stringify(e)}` })
    })
  }

  updateUserInfo() {
    // 更新用户信息
    API.getUserInfo().then((res) => {
      this.userInfoModel.userInfo.wallet = res.wallet
      this.userInfoModel.userInfo.totalScore = res.totalScore
    })
  }
}