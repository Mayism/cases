/**
 * 课程助手 - 签到页
 */

import { CheckinViewModel } from '../viewmodels/CheckinViewModel';
import { CHECKIN_CODE_LENGTH } from '../../common/constants/Constants';

@ComponentV2
export struct CheckinPage {
  @Local vm: CheckinViewModel = new CheckinViewModel();
  @Event onNavigateBack: () => void = () => {};

  build() {
    Stack() {
      Column() {
        Row() {
          Text('\u276E')
            .fontSize(20)
            .fontColor('#1A1A1A')
            .margin({ right: 8 })
            .onClick(() => {
              this.onNavigateBack();
            })

          Text('课堂签到')
            .fontSize(18)
            .fontWeight(600)
            .fontColor('#1A1A1A')
            .layoutWeight(1)
        }
        .width('100%')
        .height(56)
        .padding({ left: 16, right: 16 })
        .alignItems(VerticalAlign.Center)
        .zIndex(2)

        Column()
          .width('100%')
          .height('25%')
          .linearGradient({
            direction: GradientDirection.Bottom,
            colors: [['#ED6F21', 0], ['#F1F3F5', 1]]
          })
          .position({ x: 0, y: 0 })
          .zIndex(0)

        Scroll() {
          Column() {
            if (this.vm.isCheckedIn) {
              this.CheckinSuccessView()
            } else {
              this.CheckinInputView()
            }
          }
          .padding({ left: 16, right: 16 })
        }
        .scrollBar(BarState.Off)
        .layoutWeight(1)
        .margin({ top: 56 })
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#F1F3F5')

      if (this.vm.isLoading) {
        Column() {
          LoadingProgress()
            .width(32)
            .height(32)
            .color('#ED6F21')
        }
        .width('100%')
        .height('100%')
        .backgroundColor('rgba(255,255,255,0.8)')
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
      }
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  CheckinInputView() {
    Column() {
      Column()
        .width('100%')
        .height(80)
        .linearGradient({
          direction: GradientDirection.Right,
          colors: [['#FFE0B2', 0], ['#FFCC80', 1]]
        })
        .borderRadius({ topLeft: 16, topRight: 16 })

      Column() {
        Text('点击输入四位数签到码')
          .fontSize(16)
          .fontWeight(700)
          .fontColor('#1A1A1A')
          .margin({ bottom: 16 })

        Row() {
          ForEach([0, 1, 2, 3], (index: number) => {
            TextInput({ text: this.vm.codeDigits[index] })
              .type(InputType.Number)
              .maxLength(1)
              .width(40)
              .height(48)
              .fontSize(24)
              .fontWeight(700)
              .textAlign(TextAlign.Center)
              .borderRadius(8)
              .border({
                width: 2,
                color: this.vm.showError ? '#E84026' :
                  (this.vm.codeDigits[index].length > 0 ? '#ED6F21' : '#E8EAED')
              })
              .backgroundColor(Color.White)
              .margin({ left: index > 0 ? 12 : 0 })
              .onChange((value: string) => {
                this.vm.setDigit(index, value);
              })
          }, (index: number) => `${index}`)
        }
        .justifyContent(FlexAlign.Center)

        if (this.vm.showError) {
          Row() {
            Text('\u26A0')
              .fontSize(12)
              .fontColor('#E84026')
              .margin({ right: 4 })
            Text('请输入正确的签到码')
              .fontSize(12)
              .fontColor('#E84026')
          }
          .margin({ top: 12 })
          .justifyContent(FlexAlign.Center)
        }
      }
      .width('100%')
      .backgroundColor(Color.White)
      .borderRadius({ bottomLeft: 16, bottomRight: 16 })
      .padding({ left: 16, right: 16, top: 16, bottom: 24 })
      .margin({ top: -10 })
    }
    .margin({ left: 28, right: 28 })

    Column() {
      Text('说明：')
        .fontSize(16)
        .fontWeight(700)
        .fontColor('#1A1A1A')

      Column() {
        Text('1、正确输入任课老师公布的四位数签到码')
          .fontSize(12)
          .fontColor('#666666')
          .lineHeight(22)
        Text('2、未签到成功的同学，请找老师补签')
          .fontSize(12)
          .fontColor('#666666')
          .lineHeight(22)
        Text('3、当前为开发模式，签到码默认为: 1111')
          .fontSize(12)
          .fontColor('#666666')
          .lineHeight(22)
      }
      .margin({ top: 12 })
    }
    .margin({ left: 28, right: 28, top: 24 })

    Button('确定')
      .width('100%')
      .height(40)
      .fontSize(15)
      .fontWeight(500)
      .fontColor(Color.White)
      .backgroundColor('#ED6F21')
      .borderRadius(24)
      .margin({ left: 28, right: 28, top: 38 })
      .enabled(this.vm.isCodeComplete())
      .opacity(this.vm.isCodeComplete() ? 1 : 0.4)
      .onClick(() => {
        this.vm.submitCheckin();
      })
  }

  @Builder
  CheckinSuccessView() {
    Column() {
      Text(this.vm.checkinCourseName)
        .fontSize(16)
        .fontWeight(700)
        .fontColor('#1A1A1A')
        .margin({ bottom: 16 })

      Text('\u2705')
        .fontSize(64)
        .fontColor('#64BB5C')
        .margin({ bottom: 16 })

      Text('签到成功')
        .fontSize(16)
        .fontWeight(700)
        .fontColor('#1A1A1A')
    }
    .width('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .padding(16)
    .margin({ top: 80 })
  }
}