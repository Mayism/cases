import { AppStorageV2 } from '@kit.ArkUI';
import { CallTelSheetBuilder, CommonUrl, Constants, MallModel, NavHeaderBar, TabBarData } from 'lib_common';
import { ConstantsHome } from '../constants/Constants';
import { ServiceDetailViewModel } from '../viewmodel/ServiceDetailViewModel';

@Builder
export function ServiceDetailPageBuilder() {
  ServiceDetailPage()
}

@ComponentV2
struct TextDescComp {
  @Param text: string = '';

  build() {
    Row({ space: 4 }) {
      Text('·').fontSize(12)
      Text(this.text)
        .fontSize(12)
        .layoutWeight(1)
        .textAlign(TextAlign.Start)
    }
    .width('100%')
    .alignItems(VerticalAlign.Top)
  }
}

@ComponentV2
struct ServiceDetailPage {
  @Local vm: ServiceDetailViewModel = new ServiceDetailViewModel()
  @Local mallModel: MallModel = AppStorageV2.connect(MallModel, () => new MallModel()) as MallModel;

  aboutToAppear(): void {
    this.vm.getParams()
  }

  build() {
    NavDestination() {
      NavHeaderBar({ title: this.vm.pageTitle, hasBgColor: false })
      Scroll() {
        Column() {
          this.buildContent()
        }
        .width(Constants.FULL_SIZE)
        .padding({
          top: 12,
          left: Constants.BORDER_WIDTH,
          right: Constants.BORDER_WIDTH,
          bottom: this.vm.getWindowBottomHeight()
        })
        .bindSheet($$this.vm.showCallSheet, CallTelSheetBuilder(this.mallModel.shoppingMall.tel, () => {
          this.vm.showCallSheet = false;
        }), {
          height: SheetSize.FIT_CONTENT,
          showClose: false,
          preferType: SheetType.CENTER,
        })
      }
      .align(Alignment.Top)
      .scrollBar(BarState.Off)
      .edgeEffect(EdgeEffect.Spring)
      .layoutWeight(1)
    }
    .hideTitleBar(true)
    .backgroundImage($r('app.media.member_service_bg'))
    .backgroundImageSize(ImageSize.Cover)
  }

  @Builder
  buildContent() {
    if (this.vm.index === 1) {
      this.babyCareBuilder()
    } else if (this.vm.index === 2) {
      this.lostBuilder()
    } else if (this.vm.index === 3) {
      this.borrowBuilder()
    } else if (this.vm.index === 4) {
      this.medicalBuilder()
    } else if (this.vm.index === 5) {
      this.giftBuilder()
    } else if (this.vm.index === 6) {
      this.parkBuilder()
    }
  }

  @Builder
  babyCareBuilder() {
    Column() {
      Image(`${CommonUrl.CLOUD_STORAGE_URL}ShoppingMall/service_babycare.png`)
        .width('100%')
        .borderRadius(16)
        .constraintSize({
          maxHeight: '35%',
        })
      Text('母婴室使用说明：').fontSize(16).fontWeight(500).margin({ top: 16 })
      Text('母婴室提供妈妈哺乳及日常婴幼儿护理\n' +
        '提供温奶器、湿巾加热器、直饮机、纸尿裤等服务\n' +
        '室内请保持安静，随身物品请妥善保管\n' +
        '请不要在室内吸烟、拍照及摄像、男士请止步').fontSize(12).margin({ top: 12 })
      Text('如需帮助请致电客服中心：').fontSize(16).fontWeight(500).margin({ top: 16 })
      Row({ space: 8 }) {
        Image($r('app.media.ic_call')).fillColor($r('app.color.app_theme')).width(16)
        Text(this.mallModel.shoppingMall.tel).fontSize(12)
      }
      .margin({ top: 12 })
      .onClick(() => {
        this.vm.showCallSheet = true;
      })
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  lostBuilder() {
    Column() {
      Row({ space: 8 }) {
        ForEach(ConstantsHome.SERVICE_LOST_TABS, (v: TabBarData) => {
          Button(v.title)
            .width(96)
            .height(40)
            .backgroundColor(this.vm.lostType === v.id ? '#7BB201' : $r('sys.color.comp_background_tertiary'))
            .fontSize($r('sys.float.Body_M'))
            .fontColor(this.vm.lostType === v.id ? $r('sys.color.font_on_primary') : $r('sys.color.font_primary'))
            .onClick(() => {
              this.vm.lostType = v.id;
            })
        }, (v: TabBarData) => JSON.stringify(v))
      }
      .padding({
        top: 10,
        bottom: 10,
        left: 16,
        right: 16
      })

      Scroll() {
        Column() {
          Image(`${CommonUrl.CLOUD_STORAGE_URL}ShoppingMall/service_lost.png`)
            .width('100%')
            .borderRadius(16)
            .constraintSize({
              maxHeight: '35%',
            })
          if (this.vm.lostType === 0) {
            Column({ space: 12 }) {
              Text('位置').fontSize(16).fontWeight(500).margin({ top: 16 })
              Text('自助存包柜位于商场北区B1F“格瑞思”和“屈臣氏”店铺之间。').fontSize(12)
              Text('自助存包柜使用说明：').fontSize(16).fontWeight(500).margin({ top: 4 })
              Column() {
                TextDescComp({
                  text: '存包柜由顾客自助使用，仅用于顾客存放个人物品。'
                })
                TextDescComp({
                  text: '为确保个人物品安全，请勿将个人证件、现金、电子数码产品及其他贵重物品存放在包柜中。如违反规定，发生被盗事件，本商场概不负责。'
                })
                TextDescComp({
                  text: '顾客离开商场时务必取走存包柜内的个人物品，以便于其他顾客使用。本商场无保管义务。因此如有物品遗失，责任自负。'
                })
                TextDescComp({
                  text: '顾客存储物品前，务必按照存包柜操作步骤存储物品。顾客存储物品时请记清自己的存包位置，若出现特殊情况，无法开箱，顾客拨打存包柜客服热线进行处理。'
                })
                TextDescComp({
                  text: '严禁携带易燃、易爆及其它违禁、危险物品，顾客存放物品必须严格遵守相关规章制度，否则将追究存包人的责任。'
                })
                TextDescComp({
                  text: '顾客使用存包柜时请爱护公共财物，因敲击、刻画、撬损等行为损坏存包柜者须照价赔偿。'
                })
              }

              Text('自助存包柜使用时间：').fontSize(16).fontWeight(500).margin({ top: 4 })
              Row({ space: 8 }) {
                Image($r('app.media.ic_clock')).width(16)
                Text('早10:00——晚21:30').fontSize(12)
              }
            }
            .alignItems(HorizontalAlign.Start)

          } else {
            Text('失物招领服务说明：').fontSize(16).fontWeight(500).margin({ top: 16 })
            TextDescComp({
              text: '凡交由本商场的遗失物品，顾客服务中心播音招领，并根据遗失物品相关信息与失主联系，顾客遗失物品本商场代为保管1个月。'
            })
              .margin({ top: 12 })
          }
        }
        .alignItems(HorizontalAlign.Start)
      }
      .layoutWeight(1)
      .align(Alignment.Top)
      .scrollBar(BarState.Off)

    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)

  }

  @Builder
  borrowBuilder() {
    Column({ space: 12 }) {
      Text('雨伞租借说明：').fontSize(16).fontWeight(500)
      TextDescComp({
        text: '本商场在雨天免费为客户提供出借雨伞的服务，凡需要借用雨伞的客户，须在顾客服务中心进行相应个人资料的登记，收取50元押金，便可免费获得借用雨伞。顾客凭押金收据归还雨伞，退还押金。'
      })
      Text('轮椅/童车租借说明：').fontSize(16).fontWeight(500).margin({ top: 4 })
      TextDescComp({
        text: '本商场为带孩子的客户及残疾人提供免费出借童车、轮椅的服务。凡需要借童车、轮椅的客户，须在顾客服务中心进行相应个人资料的登记，收取押金400元，便可免费获得借用童车、轮椅。顾客凭押金收据还车，退还押金。'
      })
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  medicalBuilder() {
    Column() {
      Image(`${CommonUrl.CLOUD_STORAGE_URL}ShoppingMall/service_medical.png`)
        .width('100%')
        .borderRadius(16)
        .constraintSize({
          maxHeight: '35%',
        })
      Text('急救药箱提供：').fontSize(16).fontWeight(500).margin({ top: 16 })
      TextDescComp({
        text: '商场顾客服务中心配备急救药品，供顾客应急之用。'
      })
        .margin({ top: 12 })
      Text('如需帮助请致电客服中心：').fontSize(16).fontWeight(500).margin({ top: 16 })
      Row({ space: 8 }) {
        Image($r('app.media.ic_call')).fillColor($r('app.color.app_theme')).width(16)
        Text(this.mallModel.shoppingMall.tel).fontSize(12)
      }
      .margin({ top: 12 })
      .onClick(() => {
        this.vm.showCallSheet = true;
      })
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  giftBuilder() {
    Column({ space: 12 }) {
      Image(`${CommonUrl.CLOUD_STORAGE_URL}ShoppingMall/service_gift.png`)
        .width('100%')
        .borderRadius(16)
        .constraintSize({
          maxHeight: '35%',
        })
      Text('礼品包装：').fontSize(16).fontWeight(500).margin({ top: 4 })
      TextDescComp({
        text: '为客户提供礼品包装，收取工本费'
      })
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  parkBuilder() {
    Column({ space: 12 }) {
      Image(`${CommonUrl.CLOUD_STORAGE_URL}ShoppingMall/service_park.png`)
        .width('100%')
        .borderRadius(16)
        .constraintSize({
          maxHeight: '35%',
        })
      Text('停车优惠：').fontSize(16).fontWeight(500).margin({ top: 4 })
      TextDescComp({
        text: '会员消费积分享受优惠停车服务'
      })
      TextDescComp({
        text: '积分兑换停车券标准'
      })
      TextDescComp({
        text: '800积分兑换2小时停车券(每天最高可兑换2小时停车券)'
      })
      Text('如需帮助请致电客服中心：').fontSize(16).fontWeight(500).margin({ top: 4 })
      Row({ space: 8 }) {
        Image($r('app.media.ic_call')).fillColor($r('app.color.app_theme')).width(16)
        Text(this.mallModel.shoppingMall.tel).fontSize(12)
      }
      .onClick(() => {
        this.vm.showCallSheet = true;
      })
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
  }
}
