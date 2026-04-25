/**
 * 课程助手 - 课表网格面板组件
 */

import { Timetable, ScheduleCellData, DayPart, Period } from '../../common/models/Models';
import { DEFAULT_PERIODS, DAY_PART_PERIODS, WEEKDAY_NAMES } from '../../common/constants/Constants';
import { getWeekDayDate, minutesToTimeStr, createDefaultTimetable } from '../../common/utils/Utils';

@ComponentV2
export struct CourseSchedulePanel {
  @Param timetable: Timetable = createDefaultTimetable();
  @Param currentWeek: number = 1;
  @Param scheduleData: ScheduleCellData[] = [];
  @Event onCourseClick: (courseId: string) => void = () => {};

  build() {
    Scroll() {
      Column() {
        this.HeaderRow()
        this.DayPartSection('上午', [0, 1, 2, 3])
        this.DayPartSection('下午', [4, 5, 6, 7])
        this.DayPartSection('晚上', [8, 9])
      }
    }
    .scrollBar(BarState.Off)
  }

  @Builder
  HeaderRow() {
    Row() {
      Column() {
        Text(this.getMonthLabel())
          .fontSize(14)
          .fontWeight(600)
          .fontColor('#333333')
        Text('月')
          .fontSize(11)
          .fontColor('#333333')
      }
      .width(40)
      .alignItems(HorizontalAlign.Center)

      ForEach([1, 2, 3, 4, 5, 6, 0], (dayOfWeek: number) => {
        Column() {
          Text(WEEKDAY_NAMES[dayOfWeek])
            .fontSize(13)
            .fontColor(this.isToday(dayOfWeek) ? Color.White : '#333333')
          Text(this.getDayDateStr(dayOfWeek))
            .fontSize(11)
            .fontColor(this.isToday(dayOfWeek) ? Color.White : '#333333')
            .margin({ top: 4 })
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Center)
        .padding({ top: 4, bottom: 4 })
        .borderRadius(8)
        .backgroundColor(this.isToday(dayOfWeek) ? '#ED6F21' : Color.Transparent)
      }, (dayOfWeek: number) => `${dayOfWeek}`)
    }
    .width('100%')
    .margin({ bottom: 8 })
  }

  @Builder
  DayPartSection(label: string, periodIndices: number[]) {
    Text(label)
      .fontSize(14)
      .fontWeight(500)
      .fontColor('#333333')
      .margin({ top: 8, bottom: 4 })

    ForEach(periodIndices, (periodIndex: number) => {
      this.PeriodRow(periodIndex)
    }, (periodIndex: number) => `${periodIndex}`)
  }

  @Builder
  PeriodRow(periodIndex: number) {
    Row() {
      Text(`${periodIndex + 1}`)
        .fontSize(13)
        .fontColor('#333333')
        .textAlign(TextAlign.Center)
        .width(40)
        .height(36)
        .backgroundColor('#F1F3F5')
        .borderRadius(12)
        .margin({ right: 8 })

      ForEach([1, 2, 3, 4, 5, 6, 0], (dayOfWeek: number) => {
        this.PeriodCell(periodIndex, dayOfWeek)
      }, (dayOfWeek: number) => `${periodIndex}-${dayOfWeek}`)
    }
    .width('100%')
    .margin({ top: 2, bottom: 2 })
  }

  @Builder
  PeriodCell(periodIndex: number, dayOfWeek: number) {
    Stack() {
      if (this.findCourseForCell(periodIndex, dayOfWeek) !== null) {
        this.CourseBlock(periodIndex, dayOfWeek)
      }
    }
    .layoutWeight(1)
    .height(36)
  }

  @Builder
  CourseBlock(periodIndex: number, dayOfWeek: number) {
    if (this.findCourseForCell(periodIndex, dayOfWeek) !== null) {
      Column() {
        Text(this.findCourseForCell(periodIndex, dayOfWeek)!.courseName)
          .fontSize(10)
          .fontColor(this.findCourseForCell(periodIndex, dayOfWeek)!.color)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
        if (this.findCourseForCell(periodIndex, dayOfWeek)!.location.length > 0) {
          Text(this.findCourseForCell(periodIndex, dayOfWeek)!.location)
            .fontSize(8)
            .fontColor(this.findCourseForCell(periodIndex, dayOfWeek)!.color)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
        }
      }
      .width('100%')
      .height(this.getCellHeight(periodIndex, dayOfWeek))
      .padding({ left: 2, right: 2, top: 2, bottom: 2 })
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
      .borderRadius(8)
      .backgroundColor(this.hexToRgba(this.findCourseForCell(periodIndex, dayOfWeek)!.color, 0.1))
      .border({ width: 1, color: this.hexToRgba(this.findCourseForCell(periodIndex, dayOfWeek)!.color, 0.4) })
      .onClick(() => {
        this.onCourseClick(this.findCourseForCell(periodIndex, dayOfWeek)!.courseId);
      })
    }
  }

  private findCourseForCell(periodIndex: number, dayOfWeek: number): ScheduleCellData | null {
    for (let i = 0; i < this.scheduleData.length; i++) {
      const cell: ScheduleCellData = this.scheduleData[i];
      if (cell.dayOfWeek === dayOfWeek &&
        periodIndex >= cell.periodStart &&
        periodIndex <= cell.periodEnd) {
        if (periodIndex === cell.periodStart) {
          return cell;
        }
        return null;
      }
    }
    return null;
  }

  private getCellHeight(periodIndex: number, dayOfWeek: number): number {
    const cell: ScheduleCellData | null = this.findCourseForCell(periodIndex, dayOfWeek);
    if (cell !== null) {
      const spanCount: number = cell.periodEnd - cell.periodStart + 1;
      return spanCount * 38 - 4;
    }
    return 36;
  }

  private isToday(dayOfWeek: number): boolean {
    const today: Date = new Date();
    return today.getDay() === dayOfWeek;
  }

  private getDayDateStr(dayOfWeek: number): string {
    const date: Date = getWeekDayDate(this.timetable.semester.anchorTimeMs, this.currentWeek, dayOfWeek);
    return `${date.getMonth() + 1}/${date.getDate()}`;
  }

  private getMonthLabel(): string {
    const today: Date = new Date();
    return `${today.getMonth() + 1}`;
  }

  private hexToRgba(hex: string, alpha: number): string {
    if (hex.startsWith('#') && hex.length === 7) {
      const r: number = parseInt(hex.substring(1, 3), 16);
      const g: number = parseInt(hex.substring(3, 5), 16);
      const b: number = parseInt(hex.substring(5, 7), 16);
      return `rgba(${r},${g},${b},${alpha})`;
    }
    return hex;
  }
}