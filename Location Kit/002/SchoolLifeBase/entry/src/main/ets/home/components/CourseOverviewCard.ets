/**
 * 课程助手 - 课程概览卡片组件
 */

import { CourseCardData, RelativeDay } from '../../common/models/Models';
import { PAGE_PADDING, CARD_RADIUS, ITEM_GAP } from '../../common/constants/Constants';

@ComponentV2
export struct CourseOverviewCard {
  @Param todayCards: CourseCardData[] = [];
  @Param tomorrowCards: CourseCardData[] = [];
  @Param currentDay: RelativeDay = RelativeDay.Today;
  @Event onDaySwitch: (day: RelativeDay) => void = () => {};
  @Event onCourseClick: (courseId: string) => void = () => {};
  @Event onViewAllClick: () => void = () => {};

  build() {
    Column() {
      Row() {
        Row() {
          ForEach([RelativeDay.Today, RelativeDay.Tomorrow], (day: RelativeDay) => {
            Text(day === RelativeDay.Today ? '今日课程' : '明日课程')
              .fontSize(13)
              .fontWeight(this.currentDay === day ? 700 : 500)
              .fontColor(this.currentDay === day ? Color.White : '#666666')
              .backgroundColor(this.currentDay === day ? '#ED6F21' : Color.Transparent)
              .borderRadius(24)
              .padding({ left: 12, right: 12, top: 8, bottom: 8 })
              .onClick(() => {
                this.onDaySwitch(day);
              })
          }, (day: RelativeDay) => day)
        }
        .backgroundColor('#E8EAED')
        .borderRadius(24)
        .padding(2)

        Blank()

        Column() {
          Text('\uD83D\uDCC5')
            .fontSize(16)
          Text('全部')
            .fontSize(11)
            .fontColor('#1A1A1A')
            .margin({ top: 3 })
        }
        .alignItems(HorizontalAlign.Center)
        .onClick(() => {
          this.onViewAllClick();
        })
      }
      .width('100%')
      .margin({ bottom: 12 })

      if (this.getCurrentCards().length === 0) {
        Column() {
          Text('\uD83D\uDCC4')
            .fontSize(64)
            .fontColor('#E8EAED')
            .margin({ bottom: 12 })
          Text('暂无预课程安排')
            .fontSize(15)
            .fontColor('#999999')
            .margin({ bottom: 16 })
          Button('全部课程')
            .fontSize(14)
            .fontColor(Color.White)
            .backgroundColor('#ED6F21')
            .borderRadius(24)
            .padding({ left: 16, right: 16, top: 8, bottom: 8 })
            .onClick(() => {
              this.onViewAllClick();
            })
        }
        .width('100%')
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
        .padding({ top: 32, bottom: 32 })
      } else {
        Column() {
          Row() {
            Text(this.currentDay === RelativeDay.Today ? '今日课程' : '明日课程')
              .fontSize(15)
              .fontWeight(700)
              .fontColor('#1A1A1A')
            Text(`${this.getCurrentCards().length}节`)
              .fontSize(13)
              .fontWeight(700)
              .fontColor('#ED6F21')
              .margin({ left: 4 })
          }
          .width('100%')
          .margin({ bottom: 12 })

          ForEach(this.getCurrentCards(), (card: CourseCardData) => {
            Row() {
              Column()
                .width(4)
                .height('100%')
                .backgroundColor(card.color)
                .borderRadius({ topLeft: 2, bottomLeft: 2 })

              Column() {
                Text(card.courseName)
                  .fontSize(15)
                  .fontWeight(600)
                  .fontColor(card.isFinished ? '#999999' : '#1A1A1A')
                  .maxLines(1)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .margin({ bottom: 4 })

                Text(`${card.periodLabel} · ${card.timeRange}`)
                  .fontSize(12)
                  .fontColor(card.isFinished ? '#999999' : '#666666')
                  .margin({ bottom: 2 })

                if (card.location.length > 0 || card.teacher.length > 0) {
                  Text(this.getLocationTeacherText(card))
                    .fontSize(12)
                    .fontColor(card.isFinished ? '#BBBBBB' : '#999999')
                }
              }
              .alignItems(HorizontalAlign.Start)
              .padding(12)
              .layoutWeight(1)
            }
            .width('100%')
            .backgroundColor('#F1F3F5')
            .borderRadius(12)
            .margin({ bottom: ITEM_GAP })
            .opacity(card.isFinished ? 0.5 : 1)
            .onClick(() => {
              this.onCourseClick(card.courseId);
            })
          }, (card: CourseCardData) => card.courseId)
        }
        .width('100%')
      }
    }
    .width('100%')
    .backgroundColor(Color.White)
    .borderRadius(CARD_RADIUS)
    .padding(PAGE_PADDING)
  }

  private getCurrentCards(): CourseCardData[] {
    if (this.currentDay === RelativeDay.Today) {
      return this.todayCards;
    }
    return this.tomorrowCards;
  }

  private getLocationTeacherText(card: CourseCardData): string {
    const parts: string[] = [];
    if (card.location.length > 0) {
      parts.push(card.location);
    }
    if (card.teacher.length > 0) {
      parts.push(card.teacher);
    }
    return parts.join(' · ');
  }
}