/**
 * 课程助手 - 首页Tab
 */

import { RelativeDay, AuthStatus } from '../../common/models/Models';
import { HomeViewModel } from '../viewmodels/HomeViewModel';
import { BannerSwiper } from '../components/BannerSwiper';
import { CheckinButton } from '../components/CheckinButton';
import { CourseOverviewCard } from '../components/CourseOverviewCard';
import { PAGE_PADDING } from '../../common/constants/Constants';

@ComponentV2
export struct HomeTab {
  @Local vm: HomeViewModel = new HomeViewModel();
  @Local privacyAgreed: boolean = false;
  @Event onNavigateToTimetable: () => void = () => {};
  @Event onNavigateToCourseDetail: (courseId: string) => void = () => {};
  @Event onNavigateToCheckin: () => void = () => {};

  build() {
    Column() {
      Row() {
        Text('首页')
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
          BannerSwiper()

          CheckinButton()
            .margin({ top: 12, bottom: 12 })

          CourseOverviewCard({
            todayCards: this.vm.todayCards,
            tomorrowCards: this.vm.tomorrowCards,
            currentDay: this.vm.currentDay,
            onDaySwitch: (day: RelativeDay) => {
              this.vm.switchDay(day);
            },
            onCourseClick: (courseId: string) => {
              this.onNavigateToCourseDetail(courseId);
            },
            onViewAllClick: () => {
              this.onNavigateToTimetable();
            }
          })
        }
        .padding({ left: PAGE_PADDING, right: PAGE_PADDING, bottom: 16 })
      }
      .scrollBar(BarState.Off)
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F1F3F5')
  }

  aboutToAppear(): void {
    this.vm.loadData();
  }
}