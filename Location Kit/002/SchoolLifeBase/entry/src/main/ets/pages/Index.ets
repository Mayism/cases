/**
 * 课程助手 - 入口页面
 * 集成首页、课程中心、签到、我的等模块
 * 支持从服务卡片跳转
 * 隐私协议未同意时阻塞UI交互
 */

import { HomeTab } from '../home/pages/HomeTab';
import { MineTab } from '../mine/pages/MineTab';
import { TimetablePage } from '../course/pages/TimetablePage';
import { CourseFormPage } from '../course/pages/CourseFormPage';
import { CourseDetailPage } from '../course/pages/CourseDetailPage';
import { CheckinPage } from '../checkin/pages/CheckinPage';
import { FormMode, IntentTask } from '../common/models/Models';
import { AppStore } from '../common/store/Store';

@Entry
@ComponentV2
struct Index {
  @Local currentTabIndex: number = 0;
  @Local currentPage: string = 'main';
  @Local privacyAgreed: boolean = false;
  @Local courseFormMode: FormMode = FormMode.Create;
  @Local courseFormCourseId: string = '';
  @Local courseDetailCourseId: string = '';
  @Local showPrivacyDialog: boolean = false;

  private appStore: AppStore = AppStore.getInstance();

  build() {
    Stack() {
      Column() {
        if (this.currentPage === 'main') {
          Column() {
            Stack() {
              if (this.currentTabIndex === 0) {
                HomeTab({
                  onNavigateToTimetable: () => {
                    this.currentPage = 'timetable';
                  },
                  onNavigateToCourseDetail: (courseId: string) => {
                    this.courseDetailCourseId = courseId;
                    this.currentPage = 'courseDetail';
                  },
                  onNavigateToCheckin: () => {
                    this.currentPage = 'checkin';
                  }
                })
              } else {
                MineTab()
              }
            }
            .layoutWeight(1)

            this.TabBar()
          }
          .width('100%')
          .height('100%')
        } else if (this.currentPage === 'timetable') {
          TimetablePage({
            onNavigateBack: () => {
              this.currentPage = 'main';
            },
            onNavigateToCourseForm: (mode: string) => {
              this.courseFormMode = mode === 'EDIT' ? FormMode.Edit : FormMode.Create;
              this.currentPage = 'courseForm';
            },
            onNavigateToCourseDetail: (courseId: string) => {
              this.courseDetailCourseId = courseId;
              this.currentPage = 'courseDetail';
            },
            onNavigateToSetAnchorDate: () => {
            }
          })
        } else if (this.currentPage === 'courseForm') {
          CourseFormPage({
            onNavigateBack: () => {
              this.currentPage = 'timetable';
            }
          })
        } else if (this.currentPage === 'courseDetail') {
          CourseDetailPage({
            onNavigateBack: () => {
              this.currentPage = 'timetable';
            },
            onNavigateToEdit: (courseId: string) => {
              this.courseFormMode = FormMode.Edit;
              this.courseFormCourseId = courseId;
              this.currentPage = 'courseForm';
            }
          })
        } else if (this.currentPage === 'checkin') {
          CheckinPage({
            onNavigateBack: () => {
              this.currentPage = 'main';
            }
          })
        }
      }
      .width('100%')
      .height('100%')

      // 隐私协议遮罩层 - 未同意时阻塞UI交互
      if (!this.privacyAgreed) {
        Column()
          .width('100%')
          .height('100%')
          .backgroundColor('rgba(0,0,0,0.5)')
          .hitTestBehavior(HitTestMode.Block)
          .onClick(() => {
            // 阻止穿透点击
          })
      }
    }
    .width('100%')
    .height('100%')
    .bindContentCover(!this.privacyAgreed, this.PrivacyCoverBuilder(), {
      modalTransition: ModalTransition.NONE,
      backgroundColor: Color.Transparent
    })
  }

  @Builder
  TabBar() {
    Row() {
      Column() {
        Text('\uD83C\uDFE0')
          .fontSize(24)
        Text('首页')
          .fontSize(10)
          .fontColor(this.currentTabIndex === 0 ? '#ED6F21' : '#999999')
          .fontWeight(this.currentTabIndex === 0 ? 600 : 400)
          .margin({ top: 4 })
      }
      .layoutWeight(1)
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
      .height(48)
      .onClick(() => {
        this.currentTabIndex = 0;
      })

      Column() {
        Text('\uD83D\uDC64')
          .fontSize(24)
        Text('我的')
          .fontSize(10)
          .fontColor(this.currentTabIndex === 1 ? '#ED6F21' : '#999999')
          .fontWeight(this.currentTabIndex === 1 ? 600 : 400)
          .margin({ top: 4 })
      }
      .layoutWeight(1)
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
      .height(48)
      .onClick(() => {
        this.currentTabIndex = 1;
      })
    }
    .width('100%')
    .height(48)
    .backgroundColor(Color.White)
    .border({ width: { top: 0.5 }, color: '#E8EAED' })
  }

  private handleIntentTask(): void {
    const intentTaskStr: string = AppStorage.get('intentTask') as string;
    if (intentTaskStr !== undefined && intentTaskStr !== null && intentTaskStr.length > 0) {
      if (intentTaskStr === IntentTask.GO_TO_HOME_PAGE) {
        this.currentTabIndex = 0;
        this.currentPage = 'main';
      } else if (intentTaskStr === IntentTask.GO_TO_CHECKIN_PAGE) {
        this.currentPage = 'checkin';
      }
      AppStorage.setOrCreate('intentTask', '');
    }
  }

  private onPrivacyAgreed(): void {
    this.privacyAgreed = true;
    this.handleIntentTask();
  }

  @Builder
  PrivacyCoverBuilder() {
    Column() {
      Column() {
        // 标题
        Text('隐私协议')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1A1A1A')
          .margin({ bottom: 16 })

        // 协议内容
        Scroll() {
          Column() {
            Text('欢迎使用课程助手！\n\n')
              .fontSize(14)
              .fontColor('#666666')
              .lineHeight(22)

            Text('在使用本应用前，请您仔细阅读并同意以下协议：\n\n')
              .fontSize(14)
              .fontColor('#666666')
              .lineHeight(22)

            Text('1. 《课程助手隐私政策》\n')
              .fontSize(14)
              .fontColor('#ED6F21')
              .lineHeight(22)

            Text('2. 《课程助手用户服务协议》\n\n')
              .fontSize(14)
              .fontColor('#ED6F21')
              .lineHeight(22)

            Text('我们重视您的隐私保护和个人信息保护，在您使用本应用服务之前，请仔细阅读以上协议。\n\n')
              .fontSize(14)
              .fontColor('#666666')
              .lineHeight(22)

            Text('您可以通过同意以下协议来使用本应用。如果您不同意协议内容，将无法使用本应用的服务。')
              .fontSize(14)
              .fontColor('#666666')
              .lineHeight(22)
          }
          .width('100%')
        }
        .layoutWeight(1)
        .width('100%')

        // 按钮区域
        Row() {
          Button('不同意')
            .fontSize(16)
            .fontColor('#666666')
            .backgroundColor('#F5F5F5')
            .borderRadius(24)
            .layoutWeight(1)
            .height(44)
            .onClick(() => {
              // 不同意则不关闭，用户必须同意才能使用
            })

          Blank().width(16)

          Button('同意并继续')
            .fontSize(16)
            .fontColor(Color.White)
            .backgroundColor('#ED6F21')
            .borderRadius(24)
            .layoutWeight(1)
            .height(44)
            .onClick(async () => {
              await this.appStore.setPrivacyAgreed(true);
              this.onPrivacyAgreed();
            })
        }
        .width('100%')
        .margin({ top: 16 })
      }
      .width('100%')
      .padding(24)
      .backgroundColor(Color.White)
      .borderRadius(16)
      .constraintSize({ maxHeight: '80%' })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .padding({ left: 24, right: 24 })
  }

  async aboutToAppear(): Promise<void> {
    await this.appStore.init(getContext(this));
    this.privacyAgreed = await this.appStore.isPrivacyAgreed();
    if (this.privacyAgreed) {
      this.handleIntentTask();
    }
  }
}