/**
 * 课程助手 - 课程详情页
 */

import { Course, CourseArrangement } from '../../common/models/Models';
import { CourseViewModel } from '../viewmodels/CourseViewModel';
import { minutesToTimeStr, getWeekMaskDescription, getPeriodDescription } from '../../common/utils/Utils';
import { PAGE_PADDING, CARD_RADIUS, DEFAULT_PERIODS } from '../../common/constants/Constants';

@ComponentV2
export struct CourseDetailPage {
  @Local vm: CourseViewModel = new CourseViewModel();
  @Local courseId: string = '';
  @Local course: Course | null = null;
  @Local showDeleteDialog: boolean = false;
  @Event onNavigateBack: () => void = () => {};
  @Event onNavigateToEdit: (courseId: string) => void = () => {};

  aboutToAppear(): void {
    this.vm.loadData();
    if (this.courseId.length > 0) {
      this.course = this.vm.getCourseById(this.courseId);
    }
  }

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

          Text('课程详情')
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
          .height(160)
          .linearGradient({
            direction: GradientDirection.Bottom,
            colors: [['rgba(237,111,33,0.4)', 0], ['#F1F3F5', 1]]
          })
          .position({ x: 0, y: 0 })
          .zIndex(0)

        Scroll() {
          Column() {
            if (this.course !== null) {
              Text(this.course!.name)
                .fontSize(17)
                .fontWeight(700)
                .fontColor('#1A1A1A')
                .margin({ top: 8, bottom: 8 })

              ForEach(this.course!.arrangements, (arr: CourseArrangement, index: number) => {
                this.ArrangementCard(arr, index)
              }, (arr: CourseArrangement) => arr.id)
            }
          }
          .padding({ left: PAGE_PADDING, right: PAGE_PADDING, top: 8 })
        }
        .scrollBar(BarState.Off)
        .layoutWeight(1)

        Row() {
          Column() {
            Text('\u270E')
              .fontSize(24)
              .fontColor('#1A1A1A')
            Text('编辑')
              .fontSize(11)
              .fontColor('#1A1A1A')
          }
          .layoutWeight(1)
          .alignItems(HorizontalAlign.Center)
          .justifyContent(FlexAlign.Center)
          .height(52)
          .onClick(() => {
            if (this.courseId.length > 0) {
              this.onNavigateToEdit(this.courseId);
            }
          })

          Column() {
            Text('\uD83D\uDDD1')
              .fontSize(24)
              .fontColor('#1A1A1A')
            Text('删除')
              .fontSize(11)
              .fontColor('#1A1A1A')
          }
          .layoutWeight(1)
          .alignItems(HorizontalAlign.Center)
          .justifyContent(FlexAlign.Center)
          .height(52)
          .onClick(() => {
            this.showDeleteDialog = true;
          })
        }
        .width('100%')
        .backgroundColor(Color.White)
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#F1F3F5')
    }
    .width('100%')
    .height('100%')
    .bindContentCover(this.showDeleteDialog, this.DeleteDialog(), {
      modalTransition: ModalTransition.NONE,
      onDisappear: () => {
        this.showDeleteDialog = false;
      }
    })
  }

  @Builder
  ArrangementCard(arr: CourseArrangement, index: number) {
    Column() {
      if (this.course!.arrangements.length > 1) {
        Text(`时间段${index + 1}`)
          .fontSize(13)
          .fontWeight(500)
          .fontColor('#666666')
          .margin({ bottom: 8 })
      }

      Row() {
        Text('\uD83D\uDCC5')
          .fontSize(16)
          .fontColor('#999999')
          .margin({ right: 8 })
        Text(getWeekMaskDescription(arr.weekMask, this.vm.timetable.semester.weekCount))
          .fontSize(13)
          .fontColor('#666666')
      }
      .margin({ bottom: 8 })

      Divider().color('#E8EAED')

      Row() {
        Text('\uD83D\uDD52')
          .fontSize(16)
          .fontColor('#999999')
          .margin({ right: 8 })
        Text(`${getPeriodDescription(arr)} ${this.getTimeRange(arr)}`)
          .fontSize(13)
          .fontColor('#666666')
      }
      .margin({ top: 8, bottom: 8 })

      Divider().color('#E8EAED')

      Row() {
        Text('\uD83D\uDCCD')
          .fontSize(16)
          .fontColor('#999999')
          .margin({ right: 8 })
        Text(arr.location.length > 0 ? arr.location : '暂无教室信息')
          .fontSize(13)
          .fontColor('#666666')
      }
      .margin({ top: 8, bottom: 8 })

      if (arr.teacher.length > 0) {
        Divider().color('#E8EAED')
        Row() {
          Text('\uD83D\uDC64')
            .fontSize(16)
            .fontColor('#999999')
            .margin({ right: 8 })
          Text(arr.teacher)
            .fontSize(13)
            .fontColor('#666666')
        }
        .margin({ top: 8 })
      }
    }
    .width('100%')
    .backgroundColor(Color.White)
    .borderRadius(CARD_RADIUS)
    .padding(16)
    .margin({ top: 8 })
  }

  @Builder
  DeleteDialog() {
    Column() {
      Text('课程删除后将会从课程中心移除且无法恢复，是否删除？')
        .fontSize(15)
        .fontColor('#1A1A1A')
        .textAlign(TextAlign.Center)
        .margin({ bottom: 24 })

      Row() {
        Button('取消')
          .fontSize(14)
          .fontColor('#1A1A1A')
          .backgroundColor('#E8EAED')
          .borderRadius(24)
          .layoutWeight(1)
          .onClick(() => {
            this.showDeleteDialog = false;
          })

        Blank().width(16)

        Button('删除')
          .fontSize(14)
          .fontColor(Color.White)
          .backgroundColor('#E84026')
          .borderRadius(24)
          .layoutWeight(1)
          .onClick(() => {
            this.vm.deleteCourse(this.courseId);
            this.showDeleteDialog = false;
            this.onNavigateBack();
          })
      }
      .width('100%')
    }
    .padding(24)
    .backgroundColor(Color.White)
    .borderRadius(16)
    .margin({ left: 40, right: 40 })
  }

  private getTimeRange(arr: CourseArrangement): string {
    if (arr.periodStart < DEFAULT_PERIODS.length && arr.periodEnd < DEFAULT_PERIODS.length) {
      const start: number[] = DEFAULT_PERIODS[arr.periodStart];
      const end: number[] = DEFAULT_PERIODS[arr.periodEnd];
      return `${minutesToTimeStr(start[0])}-${minutesToTimeStr(end[1])}`;
    }
    return '';
  }
}