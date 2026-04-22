import { StoreTitleComp } from './StoreTitleComp';

@Component
export struct WidgetMidCard {
  @Prop formDimension: number = 2;
  @Prop storeName: ResourceStr = $r('app.string.storeName');
  @Prop orderType: number = 1;
  @Prop storeTable: string = '';
  @Prop orderId: string = '';
  @Prop orderPickNum: string = '';
  @Prop stateType: number = 0;
  @Prop preorderTime: string = '';
  @Prop preorderRoom: boolean = false;
  @Prop orderTime: string = '';
  @Prop queueTable: string = '';
  @Prop queueWaitTime: string = '';
  @Prop queueWaitNum: string = '';
  readonly ACTION_TYPE: string = 'router';
  readonly ABILITY_NAME: string = 'EntryAbility';
  readonly PREORDER_STATE: number = 1;
  readonly QUEUE_STATE: number = 2;
  readonly ORDER_STATE: number = 3;

  build() {
    Column({ space: 8 }) {
      StoreTitleComp({ storeName: this.storeName })
      Row({ space: 12 }) {
        Image($r('app.media.ic_card_img1')).aspectRatio(5 / 4).borderRadius(8);
        Column({ space: 8 }) {
          if ([this.PREORDER_STATE, this.QUEUE_STATE, this.ORDER_STATE].includes(this.stateType)) {
            this.orderBuilder()
          } else {
            this.initBuilder()
          }
        }.layoutWeight(1)
      }.layoutWeight(1)
    }
    .backgroundImage($r('app.media.card_bg_2_4'))
    .backgroundImageSize(ImageSize.Cover)
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .padding(12)
    .onClick(() => {
      postCardAction(this, {
        action: this.ACTION_TYPE,
        abilityName: this.ABILITY_NAME,
        params: { targetPage: 'funB' },
      });
    });
  }

  @Builder
  initBuilder() {
    Column({ space: 8 }) {
      Row({ space: 8 }) {
        SymbolGlyph($r('sys.symbol.cooking_badge_clock'))
          .fontSize(21)
          .fontColor([$r('sys.color.icon_on_primary'), '#000000'])
          .borderRadius(20)
          .backgroundColor('#99ec710b')
          .padding(3.5)
        Text('立即点餐')
          .fontSize($r('sys.float.Body_L'))
          .fontWeight(FontWeight.Medium)
          .fontColor($r('sys.color.font_primary'))
      }
      .width('100%')
      .constraintSize({ maxHeight: 40 })
      .justifyContent(FlexAlign.Center)
      .borderRadius(12)
      .layoutWeight(1)
      .backgroundColor($r('sys.color.background_primary'))
      .onClick(() => {
        postCardAction(this, {
          action: this.ACTION_TYPE,
          abilityName: this.ABILITY_NAME,
          params: {},
        });
      });

      Row({ space: 8 }) {
        Text('我的预约')
          .fontColor($r('sys.color.font_primary'))
          .fontSize($r('sys.float.Body_M'))
          .fontWeight(FontWeight.Medium)
          .padding({
            top: 8,
            bottom: 8,
            left: 4,
            right: 4,
          })
          .borderRadius(12)
          .height('100%')
          .constraintSize({ maxHeight: 40 })
          .textAlign(TextAlign.Center)
          .backgroundColor($r('sys.color.background_primary'))
          .layoutWeight(1)
          .onClick(() => {
            postCardAction(this, {
              action: this.ACTION_TYPE,
              abilityName: this.ABILITY_NAME,
              params: { url: 'OrderPage', params: { index: 0 } },
            });
          });
        Text('我的排号')
          .fontColor($r('sys.color.font_primary'))
          .fontSize($r('sys.float.Body_M'))
          .fontWeight(FontWeight.Medium)
          .textAlign(TextAlign.Center)
          .height('100%')
          .constraintSize({ maxHeight: 40 })
          .padding({
            top: 8,
            bottom: 8,
            left: 4,
            right: 4,
          })
          .borderRadius(12)
          .backgroundColor($r('sys.color.background_primary'))
          .layoutWeight(1)
          .onClick(() => {
            postCardAction(this, {
              action: this.ACTION_TYPE,
              abilityName: this.ABILITY_NAME,
              params: { url: 'OrderPage', params: { index: 1 } },
            });
          });
      }.layoutWeight(1).alignItems(VerticalAlign.Bottom)
    }.justifyContent(FlexAlign.SpaceBetween).height('100%')

  }

  @Builder
  orderBuilder() {
    Column() {
      Column({ space: 4 }) {
        Text() {
          Span(this.getTitle()).fontWeight(FontWeight.Bold)
          Span(this.getTitleValue()).fontWeight(FontWeight.Medium)
        }.fontSize($r('sys.float.Subtitle_M')).fontColor($r('sys.color.font_on_primary'))

        Row() {
          if (this.stateType === this.PREORDER_STATE) {
            SymbolGlyph($r('sys.symbol.bell_fill'))
              .fontSize(16)
              .fontColor([$r('sys.color.icon_on_primary'), '#000000']).margin({ right: 4 })
            Text(`${this.preorderTime}`).fontSize($r('sys.float.Caption_L')).fontColor($r('sys.color.font_on_primary'))
          }
          if (this.stateType === this.QUEUE_STATE) {
            Text(`预计等待 ${this.queueWaitTime} 分钟`)
              .fontSize($r('sys.float.Caption_L'))
              .fontColor($r('sys.color.font_on_primary'))
            Text(`需等待`)
              .fontSize($r('sys.float.Caption_L'))
              .fontColor($r('sys.color.font_on_primary'))
              .margin({ left: 2 })
            Text(`${this.queueWaitNum}桌`)
              .fontSize($r('sys.float.Caption_L'))
              .fontColor($r('sys.color.font_on_primary'))
              .fontWeight(FontWeight.Medium)
              .margin({ left: 4 })
          }
          if (this.stateType === this.ORDER_STATE && this.orderType === 1) {
            SymbolGlyph($r('sys.symbol.bell_fill'))
              .fontSize(16)
              .fontColor([$r('sys.color.icon_on_primary'), '#000000']).margin({ right: 4 })
            Text(`${this.orderTime}`).fontSize($r('sys.float.Caption_L')).fontColor($r('sys.color.font_on_primary'))
          }
          if (this.stateType === this.ORDER_STATE && this.orderType === 2) {
            SymbolGlyph($r('sys.symbol.bell_fill'))
              .fontSize(16)
              .fontColor([$r('sys.color.icon_on_primary'), '#000000']).margin({ right: 4 })
            Text(`${this.orderTime}`).fontSize($r('sys.float.Caption_L')).fontColor($r('sys.color.font_on_primary'))
          }
        }
      }.alignItems(HorizontalAlign.Start)

      Row({ space: 8 }) {
        Button('点餐', { controlSize: ControlSize.SMALL })
          .fontColor($r('sys.color.font_primary'))
          .fontSize($r('sys.float.Body_M'))
          .fontWeight(FontWeight.Medium)
          .backgroundColor($r('sys.color.background_primary'))
          .layoutWeight(1)
          .onClick(() => {
            postCardAction(this, {
              action: this.ACTION_TYPE,
              abilityName: this.ABILITY_NAME,
              params: { url: 'MainIndex', params: { index: 1 } },
            });
          });
        Button(this.getBtnText(), { controlSize: ControlSize.SMALL })
          .fontColor($r('sys.color.font_primary'))
          .fontSize($r('sys.float.Body_M'))
          .fontWeight(FontWeight.Medium)
          .backgroundColor($r('sys.color.background_primary'))
          .layoutWeight(1)
          .onClick(() => {
            this.btnClick()
          });
      }
    }.justifyContent(FlexAlign.SpaceBetween).height(88).alignItems(HorizontalAlign.Start)
  }

  btnClick() {
    if (this.stateType === this.PREORDER_STATE) {
      postCardAction(this, {
        action: this.ACTION_TYPE,
        abilityName: this.ABILITY_NAME,
        params: { url: 'BookResPage', params: { orderId: this.orderId } },
      });
    } else if (this.stateType === this.QUEUE_STATE) {
      postCardAction(this, {
        action: this.ACTION_TYPE,
        abilityName: this.ABILITY_NAME,
        params: { url: 'QueueResPage', params: { orderId: this.orderId } },
      });
    } else if (this.stateType === this.ORDER_STATE) {
      postCardAction(this, {
        action: this.ACTION_TYPE,
        abilityName: this.ABILITY_NAME,
        params: { url: 'OrderDetailPage', params: { orderId: this.orderId } },
      });
    }
    return ''
  }

  getTitle() {
    if (this.stateType === this.PREORDER_STATE) {
      return '预约中'
    } else if (this.stateType === this.QUEUE_STATE) {
      return '排队中'
    } else if (this.stateType === this.ORDER_STATE) {
      if (this.orderType === 1) {
        return this.storeTable
      } else {
        return '取餐码'
      }
    }
    return ''
  }

  getTitleValue() {
    if (this.stateType === this.PREORDER_STATE && this.preorderRoom) {
      return ' | 包间'
    } else if (this.stateType === this.QUEUE_STATE) {
      return ` | ${this.queueTable}`
    } else if (this.stateType === this.ORDER_STATE) {
      return ` ${this.orderPickNum}`
    }
    return ''
  }

  getBtnText() {
    if (this.stateType === this.PREORDER_STATE) {
      return '取消预约'
    } else if (this.stateType === this.QUEUE_STATE) {
      return '取消排号'
    } else if (this.stateType === this.ORDER_STATE) {
      return '查看订单'
    }
    return ''
  }
}