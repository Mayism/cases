import { StoreTitleComp } from './StoreTitleComp';

@Component
export struct WidgetSmallCard {
  @Prop formDimension: number = 3;
  @Prop storeName: ResourceStr = $r('app.string.storeName');
  @Prop orderState: boolean = false;
  @Prop orderId: string = '';
  @Prop orderType: number = 1;
  @Prop storeTable: string = '';
  @Prop orderPickNum: string = '';
  /*
   * The width or height full percentage setting.
   */
  readonly FULL_PERCENT: string = '100%';
  /*
   * The action type.
   */
  readonly ACTION_TYPE: string = 'router';
  /*
   * The ability name.
  */
  readonly ABILITY_NAME: string = 'EntryAbility';
  /*
   * The order type dine-in.
   */
  readonly ORDER_TYPE_SCAN: number = 1;

  build() {
    if (this.orderState) {
      this.orderCard();
    } else {
      this.normalCard();
    }
  }

  @Builder
  orderCard() {
    Column() {
      StoreTitleComp({ storeName: this.storeName })
      Column() {
        if (this.orderType === this.ORDER_TYPE_SCAN) {
          Image($r('app.media.card_store_table')).width(16).height(16);
          Text(this.storeTable)
            .fontColor($r('sys.color.font_on_primary'))
            .fontSize($r('sys.float.Title_S'))
            .fontWeight(FontWeight.Medium)
            .margin({ top: 6 })
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis });
        } else {
          Text($r('app.string.order_pick_num'))
            .fontColor($r('sys.color.font_on_secondary'))
            .fontSize($r('sys.float.Body_M'))
            .fontWeight(FontWeight.Medium);
          Text(this.orderPickNum)
            .fontColor($r('sys.color.font_on_primary'))
            .fontSize($r('sys.float.Title_S'))
            .fontWeight(FontWeight.Medium)
            .margin({ top: 4 })
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis });
        }
      }.margin({ top: 8 }).alignItems(HorizontalAlign.Start).width(this.FULL_PERCENT).layoutWeight(1);

      Button($r('app.string.goOrderDetail'), { controlSize: ControlSize.SMALL })
        .fontSize($r('sys.float.Body_S'))
        .fontWeight(FontWeight.Medium)
        .fontColor($r('sys.color.font_primary'))
        .width(this.FULL_PERCENT)
        .backgroundColor($r('sys.color.comp_background_primary'))
        .onClick(() => {
          postCardAction(this, {
            action: this.ACTION_TYPE,
            abilityName: this.ABILITY_NAME,
            params: { url: 'OrderDetailPage', params: { orderId: this.orderId } },
          });
        });
    }
    .backgroundImage($r('app.media.card_bg'))
    .backgroundImageSize(ImageSize.Cover)
    .width(this.FULL_PERCENT)
    .height(this.FULL_PERCENT)
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
  normalCard() {
    Column({ space: 8 }) {
      StoreTitleComp({ storeName: this.storeName })
      List({ space: 8 }) {
        ListItem() {
          Image($r('app.media.ic_card_img1')).layoutWeight(1).borderRadius(8);
        };

        ListItem() {
          Image($r('app.media.ic_card_img2')).layoutWeight(1).borderRadius(8);
        };

        ListItem() {
          Image($r('app.media.ic_card_img3')).layoutWeight(1).borderRadius(8);
        };

        ListItem() {
          Image($r('app.media.ic_card_img4')).layoutWeight(1).borderRadius(8);
        };
      }.listDirection(Axis.Horizontal).layoutWeight(1).scrollBar(BarState.Off);

      Button($r('app.string.order'), { controlSize: ControlSize.SMALL })
        .fontSize($r('sys.float.Body_S'))
        .fontWeight(FontWeight.Medium)
        .fontColor($r('sys.color.font_on_primary'))
        .width(this.FULL_PERCENT)
        .linearGradient({
          direction: GradientDirection.Bottom, // 渐变方向,从上向下
          colors: [['#FFBB81', 0], ['#EC710B', 1]], //渐变颜色
        })
        .onClick(() => {
          postCardAction(this, {
            action: this.ACTION_TYPE,
            abilityName: this.ABILITY_NAME,
            params: { targetPage: 'funB' },
          });
        });
    }
    .width(this.FULL_PERCENT)
    .height(this.FULL_PERCENT)
    .padding(12)
    .onClick(() => {
      postCardAction(this, {
        action: this.ACTION_TYPE,
        abilityName: this.ABILITY_NAME,
        params: { targetPage: 'funB' },
      });
    });
  }
}