import { CommonButton, CommonListItem, CommonPage, Constants, CONTAINER_STYLE } from 'common';
import { QueueVM } from '../../viewmodels/QueueVM';

@ComponentV2
export struct QueueOrderPage {
  vm: QueueVM = QueueVM.instance;

  async aboutToAppear() {
    this.vm.resetQueueOrderParams();
    this.vm.getQueueStoreInfo();
  }

  build() {
    CommonPage({
      title: '取号排队',
      mainUi: () => {
        this.queueOrderMainUiBuilder();
      },
      bottomUi: () => {
        this.queueOrderBottomUiBuilder();
      },
    })
  }

  @Builder
  queueOrderMainUiBuilder() {
    /** 就餐信息 **/
    this.queueDinnerInfoBuilder()

    /** 排号说明 **/
    this.descBuilder()

    /** 当前排号 **/
    this.queueInfoBuilder();

    Blank().layoutWeight(1)
  }

  @Builder
  queueOrderBottomUiBuilder() {
    CommonButton({
      title: '立即排号',
      handleClick: async () => {
        await this.vm.createQueueOrder();
      },
    })
  }

  @Builder
  queueDinnerInfoBuilder() {
    Column({ space: 12 }) {
      Row() {
        Image(`${this.vm.appInfoModel.imgBaseUrl}${this.vm.storeSelected!.logo}`).width(32).margin({ right: 8 })
        Column({ space: 4 }) {
          Row({ space: 8 }) {
            Text(this.vm.storeSelected!.name)
              .fontSize($r('sys.float.Body_M'))
              .fontColor($r('sys.color.font_primary'))
              .fontWeight(FontWeight.Medium)
              .maxLines(1)
              .constraintSize({ maxWidth: '85%' })
              .textOverflow({ overflow: TextOverflow.Ellipsis })
          }

          Text(this.vm.storeSelected!.address)
            .fontSize($r('sys.float.Caption_M'))
            .fontColor($r('sys.color.font_secondary'))
        }.alignItems(HorizontalAlign.Start).layoutWeight(1).justifyContent(FlexAlign.Center)
      }

      Column() {
        Row() {
          SymbolGlyph($r('sys.symbol.calendar_fill')).fontSize(24).fontColor([$r('sys.color.icon_secondary'), '#000000'])
          Text('就餐时间').primaryTextStyle().layoutWeight(1).margin({ left: $r('app.string.margin_16') })
          Text(this.vm.orderTimeStr).secondaryTextStyle()
        }

        Divider().margin({ left: 40, top: 12, bottom: 12 })

        Row() {
          SymbolGlyph($r('sys.symbol.person_2_fill')).fontSize(24).fontColor([$r('sys.color.icon_secondary'), '#000000'])
          Text('就餐人数').primaryTextStyle().layoutWeight(1).margin({ left: $r('app.string.margin_16') })
          Text(`${this.vm.headCount}人`).secondaryTextStyle()
        }
      }
    }
    .attributeModifier(CONTAINER_STYLE)
  }

  @Builder
  descBuilder() {
    Column() {
      Row() {
        SymbolGlyph($r('sys.symbol.exclamationmark_circle_fill'))
          .fontSize(24)
          .fontColor([$r('sys.color.icon_secondary'), '#000000', '#ffffff'])
        Text('排号说明').titleTextStyle().margin({ left: $r('app.string.margin_16') })
      }.justifyContent(FlexAlign.Start).height(56)

      Column({ space: 12 }) {
        Text('排号自动根据人数匹配餐桌类型：').titleTextStyle()
        Row({ space: 12 }) {
          Text('小桌1-2人').titleTextStyle()
          Text('中桌3-4人').titleTextStyle()
          Text('大桌5-8人').titleTextStyle()
        }

        Column({ space: 8 }) {
          Text('·就餐人数超过8人可致电门店').descTextStyle()
          Text('·同一手机号，在午市，晚市，夜市分别只能生成一个排号').descTextStyle()

          Row() {
            Text('·就餐时段: ').fontSize(12).fontColor($r('sys.color.font_secondary'))
            Column({ space: 8 }) {
              this.textSpanBuilder('午市', '10:00-15:59')
              this.textSpanBuilder('晚市', '16:00-23:59')
              this.textSpanBuilder('夜市', '23:59-次日07:00')
            }.alignItems(HorizontalAlign.Start)
          }.alignItems(VerticalAlign.Top)
        }.alignItems(HorizontalAlign.Start)
      }.alignItems(HorizontalAlign.Start).margin({ top: 8 })

    }
    .alignItems(HorizontalAlign.Start)
    .justifyContent(FlexAlign.Center)
    .width(Constants.FULL_SIZE)
    .padding({
      left: 12,
      right: 12,
      top: 4,
      bottom: 16,
    })
    .borderRadius(20)
    .backgroundColor($r('sys.color.background_primary'))
  }

  @Builder
  queueInfoBuilder() {
    if (this.vm.storeQueueInfo) {
      Column({ space: 12 }) {
        Column() {
          CommonListItem({
            pic: $r('app.media.ic_queue_order_coupons'),
            desc: '我的号码',
            value: this.vm.storeQueueInfo!.used + '',
          })
          Divider().margin({ left: 40, top: 12, bottom: 12 })

          CommonListItem({
            pic: $r('app.media.ic_queue_order_say'),
            desc: '等待桌数',
            value: `${this.vm.storeQueueInfo!.used - this.vm.storeQueueInfo!.now}桌`,
          })
        }
        .width(Constants.FULL_SIZE)
      }
      .alignItems(HorizontalAlign.Start)
      .attributeModifier(CONTAINER_STYLE)
    }
  }

  @Builder
  textSpanBuilder(title: string, value: string) {
    Row({ space: 10 }) {
      Text(title).fontSize(12).fontColor($r('sys.color.font_secondary'))
      Text(value).fontSize(12).fontColor($r('sys.color.font_primary'))
    }
  }
}

@Extend(Text)
function primaryTextStyle() {
  .fontSize($r('sys.float.Body_M'))
  .fontColor($r('sys.color.font_primary'))
  .fontWeight(FontWeight.Medium)
}

@Extend(Text)
function secondaryTextStyle() {
  .fontSize($r('sys.float.Body_M'))
  .fontColor($r('sys.color.font_secondary'))
}


@Extend(Text)
function titleTextStyle() {
  .fontSize(14)
  .fontColor($r('sys.color.font_primary'))
  .fontWeight(FontWeight.Medium)
}

@Extend(Text)
function descTextStyle() {
  .fontSize(12)
  .fontColor($r('sys.color.font_secondary'))
  .width(Constants.FULL_SIZE)
}

@Builder
export function queueOrderPageBuilder() {
  QueueOrderPage()
}