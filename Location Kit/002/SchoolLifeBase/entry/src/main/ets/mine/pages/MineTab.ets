/**
 * 课程助手 - 我的页面
 */

import { MineViewModel } from '../viewmodels/MineViewModel';
import { PAGE_PADDING } from '../../common/constants/Constants';

@ComponentV2
export struct MineTab {
  @Local vm: MineViewModel = new MineViewModel();

  build() {
    Column() {
      Row() {
        Text('我的')
          .fontSize(18)
          .fontWeight(600)
          .fontColor('#1A1A1A')
      }
      .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
      .alignItems(VerticalAlign.Center)

      Scroll() {
        Column() {
          this.UserInfoCard()
        }
        .padding({ left: PAGE_PADDING, right: PAGE_PADDING })
      }
      .scrollBar(BarState.Off)
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F1F3F5')
    .bindContentCover(this.vm.showUnbindDialog, this.UnbindDialog(), {
      modalTransition: ModalTransition.NONE,
      onDisappear: () => {
        this.vm.showUnbindDialog = false;
      }
    })
  }

  @Builder
  UserInfoCard() {
    Stack() {
      Column()
        .width('100%')
        .height('100%')
        .linearGradient({
          direction: GradientDirection.Bottom,
          colors: [['#ED6F21', 0], ['#FFC39F', 0.7], ['#FFFFFF', 1]]
        })
        .borderRadius({ bottomLeft: 32, bottomRight: 32 })

      Row() {
        Stack() {
          Text('\uD83D\uDC64')
            .fontSize(24)
            .fontColor('#999999')
        }
        .width(48)
        .height(48)
        .borderRadius(24)
        .backgroundColor('#E8EAED')
        .alignContent(Alignment.Center)

        Column() {
          Text(this.vm.nickname)
            .fontSize(17)
            .fontWeight(600)
            .fontColor('#1A1A1A')
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .constraintSize({ maxWidth: 140 })

          if (this.vm.isBound) {
            Row() {
              Text('\uD83D\uDCF1')
                .fontSize(14)
                .fontColor('#666666')
                .margin({ right: 4 })
              Text(this.vm.getDisplayPhone())
                .fontSize(14)
                .fontColor('#666666')
            }
            .margin({ top: 6 })
          }
        }
        .alignItems(HorizontalAlign.Start)
        .margin({ left: 12 })

        Blank()

        if (this.vm.isBound) {
          Button('取消关联')
            .fontSize(14)
            .fontWeight(500)
            .fontColor(Color.White)
            .backgroundColor('#ED6F21')
            .borderRadius(24)
            .padding({ left: 12, right: 12, top: 6, bottom: 6 })
            .onClick(() => {
              this.vm.showUnbindDialog = true;
            })
        } else {
          Button('\uD83D\uDD17 关联账号')
            .fontSize(14)
            .fontWeight(500)
            .fontColor('#ED6F21')
            .backgroundColor('#E8EAED')
            .borderRadius(24)
            .padding({ left: 12, right: 12, top: 6, bottom: 6 })
            .onClick(() => {
              this.vm.bindAccount();
            })
        }
      }
      .width('100%')
      .padding({ left: 24, right: 24, top: 20, bottom: 20 })
      .alignItems(VerticalAlign.Center)
    }
    .width('100%')
    .height(120)
    .borderRadius({ bottomLeft: 32, bottomRight: 32 })
    .backgroundColor(Color.White)
  }

  @Builder
  UnbindDialog() {
    Column() {
      Text('账号解除关联')
        .fontSize(17)
        .fontWeight(600)
        .fontColor('#1A1A1A')
        .margin({ bottom: 8 })

      Text('请确认是否解除账号关联？')
        .fontSize(13)
        .fontColor('#666666')
        .margin({ bottom: 24 })

      Row() {
        Button('取消')
          .fontSize(14)
          .fontColor('#1A1A1A')
          .backgroundColor('#E8EAED')
          .borderRadius(24)
          .layoutWeight(1)
          .onClick(() => {
            this.vm.showUnbindDialog = false;
          })

        Blank().width(16)

        Button('确认')
          .fontSize(14)
          .fontColor(Color.White)
          .backgroundColor('#ED6F21')
          .borderRadius(24)
          .layoutWeight(1)
          .onClick(() => {
            this.vm.unbindAccount();
            this.vm.showUnbindDialog = false;
          })
      }
      .width('100%')
    }
    .padding(24)
    .backgroundColor(Color.White)
    .borderRadius(16)
    .margin({ left: 40, right: 40 })
  }
}