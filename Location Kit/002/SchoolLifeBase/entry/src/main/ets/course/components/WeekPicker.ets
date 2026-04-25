/**
 * 课程助手 - 周选择器组件 (半模态弹窗)
 */

import { DEFAULT_TOTAL_WEEKS } from '../../common/constants/Constants';

@ComponentV2
export struct WeekPicker {
  @Param currentWeek: number = 1;
  @Param totalWeeks: number = DEFAULT_TOTAL_WEEKS;
  @Param initialWeekMask: number = 0;
  @Local selectedWeekMask: number = 0;
  @Event onConfirm: (weekMask: number) => void = () => {};
  @Event onCancel: () => void = () => {};

  aboutToAppear(): void {
    this.selectedWeekMask = this.initialWeekMask;
  }

  build() {
    Column() {
      Text('查看周课表')
        .fontSize(17)
        .fontWeight(600)
        .textAlign(TextAlign.Center)
        .margin({ bottom: 16 })

      Row() {
        this.WeekChip('全选', () => { this.selectAll(); })
        this.WeekChip('单周', () => { this.selectOdd(); })
        this.WeekChip('双周', () => { this.selectEven(); })
      }
      .width('100%')
      .justifyContent(FlexAlign.Start)
      .margin({ bottom: 16 })

      Grid() {
        ForEach(this.getWeekList(), (week: number) => {
          GridItem() {
            Text(`${week}`)
              .fontSize(13)
              .textAlign(TextAlign.Center)
              .fontColor(this.isWeekSelected(week) ? Color.White : '#1A1A1A')
              .backgroundColor(this.isWeekSelected(week) ? '#ED6F21' : '#F1F3F5')
              .borderRadius(8)
              .padding({ top: 10, bottom: 10 })
              .onClick(() => {
                this.toggleWeek(week);
              })
          }
        }, (week: number) => `${week}`)
      }
      .columnsTemplate('1fr 1fr 1fr 1fr 1fr')
      .rowsGap(8)
      .columnsGap(8)
      .width('100%')
      .height(240)

      Button('确认')
        .width('100%')
        .height(40)
        .fontSize(16)
        .fontColor(Color.White)
        .backgroundColor('#ED6F21')
        .borderRadius(24)
        .margin({ top: 16 })
        .onClick(() => {
          this.onConfirm(this.selectedWeekMask);
        })
    }
    .padding(24)
  }

  @Builder
  WeekChip(label: string, onClick: () => void) {
    Text(label)
      .fontSize(13)
      .fontColor('#1A1A1A')
      .backgroundColor('#E8EAED')
      .borderRadius(24)
      .padding({ left: 12, right: 12, top: 6, bottom: 6 })
      .margin({ right: 8 })
      .onClick(onClick)
  }

  private getWeekList(): number[] {
    const weeks: number[] = [];
    for (let i = 1; i <= this.totalWeeks; i++) {
      weeks.push(i);
    }
    return weeks;
  }

  private isWeekSelected(week: number): boolean {
    return (this.selectedWeekMask & (1 << (week - 1))) !== 0;
  }

  private toggleWeek(week: number): void {
    const bit: number = 1 << (week - 1);
    this.selectedWeekMask = this.selectedWeekMask ^ bit;
  }

  private selectAll(): void {
    let mask: number = 0;
    for (let i = 0; i < this.totalWeeks; i++) {
      mask = mask | (1 << i);
    }
    this.selectedWeekMask = mask;
  }

  private selectOdd(): void {
    let mask: number = 0;
    for (let i = 0; i < this.totalWeeks; i += 2) {
      mask = mask | (1 << i);
    }
    this.selectedWeekMask = mask;
  }

  private selectEven(): void {
    let mask: number = 0;
    for (let i = 1; i < this.totalWeeks; i += 2) {
      mask = mask | (1 << i);
    }
    this.selectedWeekMask = mask;
  }
}