/**
 * 课程助手 - 课程表单页 (添加/编辑课程)
 */

import { CourseViewModel } from '../viewmodels/CourseViewModel';
import { CourseArrangement, FormMode } from '../../common/models/Models';
import { FunctionalRow } from '../components/FunctionalRow';
import { generateId, getWeekMaskDescription, getPeriodDescription, checkTimeConflict } from '../../common/utils/Utils';
import { MAX_COURSE_NAME_LENGTH, PAGE_PADDING, CARD_RADIUS } from '../../common/constants/Constants';

@ComponentV2
export struct CourseFormPage {
  @Local vm: CourseViewModel = new CourseViewModel();
  @Local formMode: FormMode = FormMode.Create;
  @Local courseId: string = '';
  @Local courseName: string = '';
  @Local arrangements: CourseArrangement[] = [];
  @Local showWeekPicker: boolean = false;
  @Local editingArrangementIndex: number = 0;
  @Local selectedWeekMask: number = 0;
  @Event onNavigateBack: () => void = () => {};

  aboutToAppear(): void {
    this.vm.loadData();
    if (this.arrangements.length === 0) {
      this.arrangements = [this.createEmptyArrangement()];
    }
  }

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

        Text(this.formMode === FormMode.Create ? '添加课程' : '编辑课程')
          .fontSize(18)
          .fontWeight(600)
          .fontColor('#1A1A1A')
          .layoutWeight(1)
      }
      .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
      .alignItems(VerticalAlign.Center)

      Scroll() {
        Column() {
          this.SemesterBanner()

          Column() {
            FunctionalRow({
              label: '课程名称',
              value: this.courseName,
              placeholder: '请输入添加的课程名称',
              isInput: true,
              showArrow: false,
              onInputChange: (value: string) => {
                if (value.length <= MAX_COURSE_NAME_LENGTH) {
                  this.courseName = value;
                }
              }
            })
          }
          .backgroundColor(Color.White)
          .borderRadius(CARD_RADIUS)
          .margin({ bottom: 8 })

          ForEach(this.arrangements, (arr: CourseArrangement, index: number) => {
            this.ArrangementSection(arr, index)
          }, (arr: CourseArrangement) => arr.id)

          Row() {
            Text('+ 添加更多时间段')
              .fontSize(13)
              .fontWeight(600)
              .fontColor('#ED6F21')
          }
          .width('100%')
          .justifyContent(FlexAlign.End)
          .padding({ top: 8, bottom: 8 })
          .onClick(() => {
            this.arrangements.push(this.createEmptyArrangement());
          })
        }
        .padding({ left: PAGE_PADDING, right: PAGE_PADDING, top: 8 })
      }
      .scrollBar(BarState.Off)
      .layoutWeight(1)

      Button('保存')
        .width('100%')
        .height(40)
        .fontSize(16)
        .fontWeight(500)
        .fontColor(Color.White)
        .backgroundColor('#ED6F21')
        .borderRadius(24)
        .margin({ left: 16, right: 16, top: 8, bottom: 16 })
        .onClick(() => {
          this.handleSave();
        })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F1F3F5')
  }

  @Builder
  SemesterBanner() {
    Row() {
      Column() {
        Text('当前学期')
          .fontSize(14)
          .fontWeight(700)
          .fontColor(Color.White)
          .margin({ bottom: 12 })
        Text(this.vm.timetable.semester.label)
          .fontSize(14)
          .fontWeight(700)
          .fontColor(Color.White)
      }
      .alignItems(HorizontalAlign.Start)

      Blank()

      Text('\uD83D\uDC65')
        .fontSize(80)
        .fontColor(Color.White)
        .opacity(0.15)
    }
    .width('100%')
    .height(104)
    .borderRadius(CARD_RADIUS)
    .linearGradient({
      direction: GradientDirection.Right,
      colors: [['#ED6F21', 0], ['#FFC39F', 1]]
    })
    .padding(16)
    .margin({ bottom: 8 })
  }

  @Builder
  ArrangementSection(arr: CourseArrangement, index: number) {
    Column() {
      Row() {
        Text(`时段${index + 1}`)
          .fontSize(14)
          .fontWeight(500)
          .fontColor('#666666')

        Blank()

        if (this.arrangements.length > 1) {
          Text('\u2715')
            .fontSize(18)
            .fontColor('#1A1A1A')
            .onClick(() => {
              this.arrangements.splice(index, 1);
            })
        }
      }
      .width('100%')
      .height(36)
      .padding({ left: 12, right: 12 })

      FunctionalRow({
        label: '课程周期',
        value: getWeekMaskDescription(arr.weekMask, this.vm.timetable.semester.weekCount),
        showArrow: true,
        onRowClick: () => {
          this.editingArrangementIndex = index;
          this.selectedWeekMask = arr.weekMask;
          this.showWeekPicker = true;
        }
      })

      FunctionalRow({
        label: '课程节数',
        value: getPeriodDescription(arr),
        showArrow: true,
        onRowClick: () => {
        }
      })

      FunctionalRow({
        label: '教室地点',
        value: arr.location,
        placeholder: '请输入教室地点',
        isInput: true,
        showArrow: false,
        onInputChange: (value: string) => {
          this.arrangements[index].location = value;
        }
      })

      FunctionalRow({
        label: '任课教师',
        value: arr.teacher,
        placeholder: '请输入任课教师',
        isInput: true,
        showArrow: false,
        onInputChange: (value: string) => {
          this.arrangements[index].teacher = value;
        }
      })
    }
    .backgroundColor(Color.White)
    .borderRadius(CARD_RADIUS)
    .margin({ bottom: 8 })
  }

  private createEmptyArrangement(): CourseArrangement {
    return {
      id: generateId(),
      courseId: '',
      dayOfWeek: 1,
      periodStart: 0,
      periodEnd: 1,
      location: '',
      teacher: '',
      weekMask: 0x0000FFFF
    };
  }

  private handleSave(): void {
    if (this.courseName.trim().length === 0) {
      return;
    }

    const errorMsg: string = checkTimeConflict(this.arrangements, this.vm.timetable.courses, this.courseId);
    if (errorMsg.length > 0) {
      return;
    }

    if (this.formMode === FormMode.Create) {
      this.vm.addCourse(this.courseName.trim(), this.arrangements);
    } else {
      this.vm.updateCourse(this.courseId, this.courseName.trim(), this.arrangements);
    }

    this.onNavigateBack();
  }
}