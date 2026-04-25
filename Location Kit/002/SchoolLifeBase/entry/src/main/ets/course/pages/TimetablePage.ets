/**
 * 课程助手 - 课程中心页
 */

import { CourseViewModel } from '../viewmodels/CourseViewModel';
import { CourseSchedulePanel } from '../components/CourseSchedulePanel';
import { WeekPicker } from '../components/WeekPicker';
import { PAGE_PADDING, CARD_RADIUS, DEFAULT_TOTAL_WEEKS } from '../../common/constants/Constants';

@ComponentV2
export struct TimetablePage {
  @Local vm: CourseViewModel = new CourseViewModel();
  @Local showWeekPicker: boolean = false;
  @Local showMenuOverlay: boolean = false;
  @Event onNavigateBack: () => void = () => {};
  @Event onNavigateToCourseForm: (mode: string) => void = () => {};
  @Event onNavigateToCourseDetail: (courseId: string) => void = () => {};
  @Event onNavigateToSetAnchorDate: () => void = () => {};

  build() {
    Column() {
      Row() {
        Text('\u276E')
          .fontSize(20)
          .fontColor('#1A1A1A')
          .margin({ right: 8 })
          .onClick(() => {
            this.onNavigateBack();
          })

        Text('课程中心')
          .fontSize(18)
          .fontWeight(600)
          .fontColor('#1A1A1A')
          .layoutWeight(1)
      }
      .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
      .alignItems(VerticalAlign.Center)

      Row() {
        Column() {
          Text(this.vm.getWeekLabel())
            .fontSize(18)
            .fontWeight(600)
            .fontColor('#ED6F21')
          Text(this.vm.getWeekRange())
            .fontSize(13)
            .fontColor('#666666')
            .margin({ top: 4 })
        }
        .alignItems(HorizontalAlign.Start)

        Blank()

        Stack() {
          Text('\uD83D\uDCC5')
            .fontSize(16)
        }
        .width(24)
        .height(24)
        .alignContent(Alignment.Center)
        .backgroundColor('#ED6F21')
        .borderRadius(12)
        .margin({ right: 16 })
        .onClick(() => {
          this.showWeekPicker = true;
        })

        Stack() {
          Text('+')
            .fontSize(14)
            .fontWeight(700)
            .fontColor(Color.White)
        }
        .width(24)
        .height(24)
        .alignContent(Alignment.Center)
        .backgroundColor('#ED6F21')
        .borderRadius(12)
        .onClick(() => {
          this.showMenuOverlay = true;
        })
      }
      .width('100%')
      .height(72)
      .padding({ left: 16, right: 16 })
      .backgroundColor(Color.White)
      .alignItems(VerticalAlign.Center)

      Scroll() {
        Column() {
          CourseSchedulePanel({
            timetable: this.vm.timetable,
            currentWeek: this.vm.currentWeek,
            scheduleData: this.vm.scheduleData,
            onCourseClick: (courseId: string) => {
              this.onNavigateToCourseDetail(courseId);
            }
          })
        }
        .padding({ left: 16, right: 16, bottom: 16 })
      }
      .scrollBar(BarState.Off)
      .layoutWeight(1)
      .backgroundColor(Color.White)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F1F3F5')
    .bindSheet(this.showWeekPicker, this.WeekPickerSheet(), {
      height: '60%',
      dragBar: true,
      backgroundColor: Color.White,
      onDisappear: () => {
        this.showWeekPicker = false;
      }
    })
    .bindContentCover(this.showMenuOverlay, this.MenuOverlay(), {
      modalTransition: ModalTransition.NONE,
      onDisappear: () => {
        this.showMenuOverlay = false;
      }
    })
  }

  @Builder
  WeekPickerSheet() {
    WeekPicker({
      currentWeek: this.vm.currentWeek,
      totalWeeks: this.vm.timetable.semester.weekCount,
      initialWeekMask: 1 << (this.vm.currentWeek - 1),
      onConfirm: (weekMask: number) => {
        for (let i = 0; i < this.vm.timetable.semester.weekCount; i++) {
          if ((weekMask & (1 << i)) !== 0) {
            this.vm.setWeek(i + 1);
            break;
          }
        }
        this.showWeekPicker = false;
      },
      onCancel: () => {
        this.showWeekPicker = false;
      }
    })
  }

  @Builder
  MenuOverlay() {
    Stack() {
      Column() {
        Text('设置开学日期')
          .fontSize(15)
          .fontWeight(500)
          .fontColor('#1A1A1A')
          .width('100%')
          .padding({ left: 16, top: 14, bottom: 14 })
          .onClick(() => {
            this.showMenuOverlay = false;
            this.onNavigateToSetAnchorDate();
          })

        Divider().color('#E8EAED')

        Text('添加课程')
          .fontSize(15)
          .fontWeight(500)
          .fontColor('#1A1A1A')
          .width('100%')
          .padding({ left: 16, top: 14, bottom: 14 })
          .onClick(() => {
            this.showMenuOverlay = false;
            this.onNavigateToCourseForm('CREATE');
          })
      }
      .width(140)
      .borderRadius(16)
      .backgroundColor(Color.White)
      .position({ x: '70%', y: '8%' })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('rgba(0,0,0,0.4)')
    .onClick(() => {
      this.showMenuOverlay = false;
    })
  }

  aboutToAppear(): void {
    this.vm.loadData();
  }
}