let storageUpdateByMsg = new LocalStorage();

@Entry(storageUpdateByMsg)
@Component
struct WidgetCard {
  @LocalStorageProp('remParkingSpc') remParkingSpc: string = '';
  @LocalStorageProp('score') score: string = '';
  @State angle: number = 0;
  /*
   * The action type.
   */
  readonly actionType: string = 'router';
  /*
   * The ability name.
   */
  readonly abilityName: string = 'EntryAbility';
  /*
   * The width percentage setting.
   */
  readonly fullWidthPercent: string = '100%';
  /*
   * The height percentage setting.
   */
  readonly fullHeightPercent: string = '100%';

  rotateIcon() {
    this.angle += 360;
  }

  build() {
    Stack() {
      Column() {
        Image($r('app.media.bg_self_point_title_right')).width(120).height(70)
      }
      .width(this.fullWidthPercent)
      .height(this.fullHeightPercent)
      .justifyContent(FlexAlign.End)
      .alignItems(HorizontalAlign.End)
      .linearGradient({
        direction: GradientDirection.RightBottom, // 渐变方向
        repeating: false, // 渐变颜色是否重复
        colors: [['#FFFFFF', 0.0], ['#E6F9BB', 1]], // 数组末尾元素占比小于1时满足重复着色效果
      })

      Column() {
        Row() {
          Row() {
            Image($r('app.media.ic_logo')).width(20).height(20).borderRadius(4)
            Text('商场模板').fontSize(14).fontColor($r('sys.color.font_primary')).margin({ left: 6 })
          }

          Image($r('app.media.icon_refresh')).width(20).height(20).rotate({ angle: this.angle }).animation({
            curve: Curve.EaseInOut,
            duration: 200,
          })
        }
        .width(this.fullWidthPercent)
        .padding({ top: 12 })
        .justifyContent(FlexAlign.SpaceBetween)
        .onClick(() => {
          this.rotateIcon();
          postCardAction(this, {
            action: 'message',
            params: { msgTest: 'messageEvent' },
          });
        })

        Column() {
          Row() {
            Text('剩余车位').fontSize(10).fontColor($r('sys.color.font_primary'))
            Text(this.remParkingSpc).fontSize(10).fontColor('#486602').margin({ left: 3 })
          }.width(this.fullWidthPercent).height(20)

          Row() {
            Text('积分').fontSize(10).fontColor($r('sys.color.font_primary'))
            Text(this.score).fontSize(10).fontColor('#486602').margin({ left: 3 })
          }.width(this.fullWidthPercent).height(20)
        }.margin({ top: 6 })

        Row({ space: 14 }) {
          Column() {
            Image($r('app.media.ic_home_self_point')).width(32).height(32)
            Text('自助积分')
              .fontSize(12)
              .fontColor($r('sys.color.font_primary'))
              .fontWeight(FontWeight.Medium)
              .margin({ top: 4 })
          }
          .margin({ left: 4, right: 4 })
          .onClick(() => {
            postCardAction(this, {
              action: this.actionType,
              abilityName: this.abilityName,
              params: {
                url: 'SelfServicePointPage',
              },
            })
          })

          Column() {
            Image($r('app.media.ic_home_parking_pay')).width(32).height(32)
            Text('停车缴费')
              .fontSize(12)
              .fontColor($r('sys.color.font_primary'))
              .fontWeight(FontWeight.Medium)
              .margin({ top: 4 })
          }.margin({ left: 4, right: 4 })
          .onClick(() => {
            postCardAction(this, {
              action: this.actionType,
              abilityName: this.abilityName,
              params: {
                url: 'ParkingPaymentPage',
              },
            });
          })

        }.width(this.fullWidthPercent).justifyContent(FlexAlign.SpaceBetween).margin({ top: 8 })
      }
      .width(this.fullWidthPercent)
      .height(this.fullHeightPercent)
      .padding({ bottom: 12, left: 12, right: 12 })
      .onClick(() => {
        postCardAction(this, {
          action: this.actionType,
          abilityName: this.abilityName,
        });
      })

    }.alignContent(Alignment.BottomEnd)

  }
}