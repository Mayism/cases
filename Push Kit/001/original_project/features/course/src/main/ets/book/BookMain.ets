import {
  BookingInfo,
  CoachCourseInfo,
  CourseBookingInfo,
  CourseDetailModel,
  DateUtil,
  MockService,
  SportType,
  TeachType,
  UserCard
} from 'external_interactions';
import { promptAction, SymbolGlyphModifier } from '@kit.ArkUI';
import { ScreenPropStorage , BookingRestQuotaUpdate, JumpLogin, LoginState, BookJumpSearch} from 'external_interactions'
import { AppStorageV2 } from '@kit.ArkUI';
import { emitter } from '@kit.BasicServicesKit';
import { EmitterConstant } from 'external_interactions'
import  EventData  from '@ohos.events.emitter';

@ComponentV2
export struct BookMain {
  @Local screenPropStorage : ScreenPropStorage = AppStorageV2.connect(ScreenPropStorage, 'ScreenPropStorage', () =>new ScreenPropStorage())!
  @Local bookingRestQuotaUpdateStorage : BookingRestQuotaUpdate = AppStorageV2.connect(BookingRestQuotaUpdate, 'BookingRestQuotaUpdate', () =>new BookingRestQuotaUpdate())!
  @Local bookJumpSearchStorage : BookJumpSearch = AppStorageV2.connect(BookJumpSearch, 'BookJumpSearch', () =>new BookJumpSearch())!

  teachTypeList: string[] = ['团课', '私教'];
  @Local teachTypeIndex: number = 0;
  @Local sportTypeList: SportType[] = [];
  @Local sportTypeIndex: number = 0;
  private weekNameList: string[] = ['周日', '周一', '周二', '周三', '周四', '周五', '周六'];
  @Local dateList: Date[] = [];
  @Local dateSelectIndex: number = 0;
  private listScroller: ListScroller = new ListScroller();
  @Local courseBookingInfoList: CourseBookingInfo[] = [];
  @Local coachCourseInfoList: CoachCourseInfo[] = [];
  @Param @Once pathStack: NavPathStack = new NavPathStack();
  @Local searchWord: string = ''
  @Local cardIndex: number = 0
  @Local bookingRestQuotaUpdate: boolean = this.bookingRestQuotaUpdateStorage.bookingRestQuotaUpdate
  @Param mainTabIndex: number = 0;
  @Local update: boolean = false
  @Local currentCity: string = AppStorage.get('currentCity') ?? '北京'
  @Local currentStore: string = AppStorage.get('currentStore') ?? '全市门店'

  aboutToAppear(): void {
    AppStorage.setOrCreate<string>('currentCity', '北京')
    this.initData()
    try {
      emitter.on(EmitterConstant.REFRESH_DATA, () =>{
        this.initData()
      })
    } catch (e) {
      console.error(`emitter on failed. error: ${JSON.stringify(e)}`)
    }
    try {
      emitter.on('currentCity', (data: EventData.EventData) => {
        if(data.data){
          let currentCity: string = data.data.currentCity
          this.currentCity = currentCity
          this.currentStore = '全市门店'
        }
      })
    } catch (e) {
      console.error(`emitter on failed. error: ${JSON.stringify(e)}`)
    }
    this.getUIContext().getHostContext()?.eventHub.on('currentStore', (currentStore: string) => {
      this.currentStore = currentStore
    })
  }

  aboutToDisappear(): void {
    try {
      emitter.off('currentCity')
    } catch (e) {
      console.error(`emitter off failed. error: ${JSON.stringify(e)}`)
    }
    this.getUIContext().getHostContext()?.eventHub.off('currentStore')
  }

  private initData(){
    this.dateList = this.buildDateList();
    this.getSportsType();
    this.getCourseList();
  }
  private buildDateList(): Date[] {
    let dateSelectList: Date[] = [];
    let newDate: Date = new Date();
    for (let index = 0; index < 7; index++) {
      dateSelectList.push(new Date(newDate));
      newDate.setTime(newDate.getTime() + 24 * 60 * 60 * 1000);
    }
    return dateSelectList;
  }
  @Monitor('bookingRestQuotaUpdateStorage.bookingRestQuotaUpdate')
  getCourseList() {
    if (this.teachTypeIndex === 0) {
      this.courseBookingInfoList =
        MockService.getCourseBookingInfoListBySearch(this.searchWord, this.sportTypeList[this.sportTypeIndex],
          this.dateList[this.dateSelectIndex])
    } else {
      this.coachCourseInfoList =
        MockService.getCoachCourseInfoListBySearch(this.searchWord, this.sportTypeList[this.sportTypeIndex],
          this.dateList[this.dateSelectIndex])
    }
  }

  getSportsType() {
    let typeList: SportType[] = [{
      name: '全部',
      typeEnum: 0,
      icon: '',
      advImage: []
    }];
    this.sportTypeList = typeList.concat(MockService.sportTypeList)
  }
  build() {
    Column() {
      // 标题
      Column() {
        Row() {
          Text(this.currentCity)
            .fontSize(16)
            .width(16 * this.currentCity.length)
            .fontWeight(FontWeight.Medium)
            .margin({ right: 2 })

          Image($r('app.media.Arrow_bottom_filled'))
            .width(24)
        }
        .borderRadius(20)
        .backgroundColor($r('sys.color.background_tertiary'))
        .margin({ left: 16, right: 16 })
        .padding({
          top: 8,
          bottom: 8,
          left: 16,
          right: 8
        })
        .onClick(() => {
          this.pathStack.pushPath({ name: 'CitySelect' })
        })
      }
      .margin({
        top: 8,
        bottom: 8
      })
      .height(40)
      .width('100%')
      .alignItems(HorizontalAlign.Start)

      // 搜索框
      Search({ placeholder: '请输入预约课程名称', value: $$this.searchWord })
        .borderRadius(20)
        .backgroundColor('#E5E7E8')
        .placeholderColor($r('sys.color.font_tertiary'))
        .placeholderFont({ size: $r('sys.float.Body_M'), weight: FontWeight.Regular })
        .cancelButton({
          style: CancelButtonStyle.INPUT,
          icon: new SymbolGlyphModifier($r('sys.symbol.xmark_circle')).fontColor([Color.Gray]).outlineColor(Color.Gray)
        })
        .margin({ bottom: 15, left: 16, right: 16 })
        .onChange(() => {
          this.getCourseList()
        })

      // 课程运动类型标签
      List({ space: 16 }) {
        ForEach(this.sportTypeList, (item: SportType, index: number) => {
          ListItem() {
            Button(item.name, { type: ButtonType.Capsule, stateEffect: true })
              .backgroundColor(this.sportTypeIndex === index ? '#FF9019' : '#E5E7E8')
              .fontSize($r('sys.float.Body_M'))
              .fontColor(this.sportTypeIndex === index ? Color.White : Color.Black)
              .width(75)
              .height(40)
              .onClick(() => {
                this.sportTypeIndex = index;
                this.getCourseList()
              })
          }
        }, (item: SportType) => JSON.stringify(item))
      }
      .listDirection(Axis.Horizontal)
      .scrollBar(BarState.Off)
      .height(40)
      .margin({ bottom: 15, left: 16, right: 16 })

      Column() {
        Column() {
          Row() {
            Text(this.currentCity !== '北京' && this.currentCity !== '北京市' && this.currentCity !== '南京' &&
              this.currentCity !== '南京市' ? '全市门店' : this.currentStore)
              .fontSize(14)
              .width(this.currentStore.length * 16)
              .fontWeight(FontWeight.Medium)

            Image($r('app.media.Arrow_bottom_filled'))
              .width(24)
          }
          .borderRadius(20)
          .backgroundColor($r('sys.color.background_tertiary'))
          .padding({
            top: 2,
            bottom: 2,
            left: 8
          })
        }
        .margin({
          top: 8,
          bottom: 8
        })
        .height(28)
        .width('95%')
        .alignItems(HorizontalAlign.Start)
        .justifyContent(FlexAlign.Start)
        .onClick(() => {
          this.pathStack.pushPath({ name: 'course/StoreSelect', param: this.currentCity })
        })
        // 授课类型
        Row({ space: 20 }) {
          ForEach(this.teachTypeList, (teachType: string, index: number) => {
            Text(teachType)
              .height('100%')
              .fontSize(14)
              .fontWeight(this.teachTypeIndex === index ? FontWeight.Bold : FontWeight.Regular)
              .border({
                width: { bottom: this.teachTypeIndex === index ? 3 : 0 },
                color: '#000000'
              })
              .onClick(() => {
                if (this.teachTypeIndex !== index) {
                  this.teachTypeIndex = index;
                  this.getCourseList();
                }
              })
          }, (item: string) => item)
        }
        .justifyContent(FlexAlign.Start)
        .alignItems(VerticalAlign.Center)
        .height(40)
        .width('100%')
        .padding({ left: 16 })

        Divider()

        // 日期选择
        Row() {
          List({ space: 10, scroller: this.listScroller }) {
            ForEach(this.dateList, (item: Date, index: number) => {
              ListItem() {
                Column() {
                  Text(this.weekNameList[item.getDay()])
                    .fontSize(14)
                    .fontColor(index === this.dateSelectIndex ? '#FFFFFF' :
                      '#333333')
                  Text((item.getMonth() + 1 < 10 ? '0' + (item.getMonth() + 1) :
                    item.getMonth() + 1 + '') + '.' +
                    (item.getDate() < 10 ? '0' + item.getDate() : item.getDate() + ''))
                    .fontSize(12)
                    .fontColor(index === this.dateSelectIndex ? '#FFFFFF' :
                      '#333333')
                }
                .backgroundColor(index === this.dateSelectIndex ? '#FF9019' :
                  '#FFFFFF')
                .height(40)
                .width(40)
                .padding(2)
                .justifyContent(FlexAlign.SpaceAround)
                .borderRadius(8)
                .onClick(() => {
                  this.dateSelectIndex = index;
                  this.getCourseList()
                })
              }
            }, (item: Date) => DateUtil.formatDate(item))
          }
          .listDirection(Axis.Horizontal)
          .alignListItem(ListItemAlign.Center)
          .scrollBar(BarState.Off)
          .width('100%')
          .height('100%')
        }.justifyContent(FlexAlign.SpaceBetween)
        .height(60)
        .margin({ left: 16, right: 16 })
      }
      .height(140)
      .width('100%')
      .backgroundColor($r('sys.color.comp_background_list_card'))
      // 课程列表
      List({ space: 16 }) {
        if (this.teachTypeIndex === 0) {
          if (this.courseBookingInfoList.length === 0) {
            NoCourse()
          } else {
            ForEach(this.courseBookingInfoList, (item: CourseBookingInfo, index: number) => {
              ListItem() {
                CourseInfoItem({ item: item, cardIndex: this.cardIndex, pathStack: this.pathStack,
                  handleItemQuotaChange: (remaining: number)=>{
                  item.restQuota = remaining
                  this.update = !this.update
                }})
              }
            }, (item: CourseBookingInfo) => JSON.stringify(item))
          }
        } else {
          if (this.coachCourseInfoList.length === 0) {
            NoCourse()
          } else {
            ForEach(this.coachCourseInfoList, (item: CoachCourseInfo) => {
              ListItem() {
                coachListCollapse({ coachCourseInfo: item, cardIndex: this.cardIndex, pathStack: this.pathStack })
              }
            }, (item: CoachCourseInfo) => JSON.stringify(item))
          }
        }
      }
      .scrollBar(BarState.Off)
      .height('60%')
      .margin({ top: 12, left: 16, right: 16 })
      .layoutWeight(1)
    }
    .justifyContent(FlexAlign.Start)
    .backgroundColor($r('app.color.main_background_color'))
    .padding({ top: this.getUIContext().px2vp(this.screenPropStorage.topRectHeight) })
    .height('100%')
    .width('100%')
  }

  @Monitor('mainTabIndex')
  searchCourseBooking() {
    if (this.mainTabIndex === 1) {
      let jumpSearch: string | undefined = this.bookJumpSearchStorage.bookJumpSearch
      if (jumpSearch) {
        this.searchWord = jumpSearch
        this.cardIndex = AppStorage.get('selectedCardIndex') ?? 0
        let courseBookingInfo = MockService.searchCourseBooking(jumpSearch)
        if (courseBookingInfo) {
          let courseDetail = MockService.getCourseById(courseBookingInfo.courseId)
          this.teachTypeIndex = courseDetail.teachType === TeachType.GROUP ? 0 : 1
          this.dateList.forEach((item: Date, index: number) => {
            if (DateUtil.formatDate(item, '-') === courseBookingInfo?.date) {
              this.dateSelectIndex = index;
            }
          })
          this.getCourseList()
        }
        AppStorage.setOrCreate('bookJumpSearch', '')
      }
    } else {
      // 切换tab页时清空搜索条件
      this.searchWord = ''
      this.bookJumpSearchStorage.bookJumpSearch = ''
      this.sportTypeIndex = 0
      this.dateSelectIndex = 0
    }
  }
}

@ComponentV2
struct coachListCollapse {
  @Local collapse: boolean = true; // 是否折叠列表
  @Local rotateAngle: number = 90; // 折叠控制图标旋转度数
  @Require @Param coachCourseInfo: CoachCourseInfo; // 教练课程信息
  @Require @Param cardIndex: number; // 课程卡项索引
  @Event handleQuotaChange: (remaining : number)=> void
  @Param @Once pathStack: NavPathStack = new NavPathStack();
  build() {
    Column() {
      Row() {
        Image($r(this.coachCourseInfo.photo))
          .width(56)
          .height(56)
          .borderRadius(28)
        Column() {
          Text(this.coachCourseInfo.name)
            .fontSize(14)
            .fontWeight(FontWeight.Regular)
          Text(this.coachCourseInfo.introduction)
            .fontSize(10)
            .fontWeight(FontWeight.Regular)
            .opacity(0.6)
        }
        .justifyContent(FlexAlign.SpaceAround)
        .alignItems(HorizontalAlign.Start)
        .height('100%')
        .margin({ left: 16 })
        .layoutWeight(1)

        Row() {
          Text('所授课程')
            .fontSize(12)
            .fontWeight(FontWeight.Bold)
            .fontColor('#FF9019')
          Image($r('app.media.chevron_right'))
            .width(16)
            .height(16)
            .colorBlend('#FF9019')
            .rotate({ angle: this.rotateAngle })
            .margin({ left: 10 })
        }
        .onClick(() => {
          // 折叠与展开态切换动画
          this.getUIContext().animateTo({
            duration: 300
          }, () => {
            this.collapse = !this.collapse;
            this.rotateAngle = (this.rotateAngle + 180) % 360;
          })
        })
      }
      .height(88)
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .alignItems(VerticalAlign.Center)
      .padding(16)

      Column() {
        Divider()
          .width('100%')
        ForEach(this.coachCourseInfo.courseInfos, (item: CourseBookingInfo) => {
          CourseInfoItem({ item: item, cardIndex: this.cardIndex, pathStack: this.pathStack,
            handleItemQuotaChange: this.handleQuotaChange })
        }, (item: CourseBookingInfo) => JSON.stringify(item))
      }
      .visibility(this.collapse ? Visibility.None : Visibility.Visible)
    }
    .width('100%')
    .backgroundColor(Color.White)
    .borderRadius(16)
  }
}

@ComponentV2
struct CourseInfoItem {
  @Require @Param item: CourseBookingInfo | undefined = undefined;
  @Require @Param cardIndex: number | undefined = undefined;
  @Param @Once pathStack: NavPathStack = new NavPathStack();
  @Local courseDetail: CourseDetailModel = MockService.getCourseById(this.item ? this.item.courseId : '')
  @Local bookJumpSearchStorage : BookJumpSearch = AppStorageV2.connect(BookJumpSearch, 'BookJumpSearch', () =>new BookJumpSearch())!
  @Local loginStateStorage : LoginState = AppStorageV2.connect(LoginState, 'LoginState', () => new LoginState())!
  @Local jumpLoginStorge : JumpLogin = AppStorageV2.connect(JumpLogin, 'JumpLogin', () =>new JumpLogin())!
  @Local loginState: boolean = this.loginStateStorage.loginState;
  @Local jumpLogin: boolean = this.jumpLoginStorge.jumpLogin
  @Event handleItemQuotaChange: (quota: number) => void
  @Local updateUI: boolean = false
  @Local remain: number = 0
  aboutToAppear(): void {
    if(this.item){
      this.remain = this.item.restQuota;
    }
    try {
      emitter.on(EmitterConstant.CONFIRM_DATA, (data: EventData.EventData) => {
        if(data.data){
          let num: number = data.data.quota
          let date: string = data.data.date
          let courseId: string = data.data.id
          if (date === this.item?.date && courseId === this.item?.courseId) {
            if (num === 0) {
              this.item.restQuota = 0
            }
            this.remain = num
            this.handleItemQuotaChange(num)
          }
        }
      })
    } catch (e) {
      console.error(`emitter on failed. error: ${JSON.stringify(e)}`)
    }
  }

  aboutToDisappear(): void {
    try {
      emitter.off(EmitterConstant.CONFIRM_DATA)
    } catch (e) {
      console.error(`emitter off failed. error: ${JSON.stringify(e)}`)
    }
  }

  hasCardOrOnce(): boolean {
    let hasCard: boolean = false
    MockService.userCardList.forEach((item: UserCard) => {
      if (this.courseDetail && this.courseDetail.avaiCard.includes(item.cardId) && MockService.userCardCanUse(item)) {
        hasCard = true
      } else if (AppStorage.get(this.courseDetail?.id)) {
        hasCard = true
      }
    })
    return hasCard
  }

  build() {
    if(this.item){
      Row() {
        Image($r(this.courseDetail.advImage))
          .width(56)
          .height(56)
          .borderRadius(8)
        Column() {
          Text(this.item.timeStart)
            .fontSize(14)
            .fontWeight(FontWeight.Regular)
          Divider()
            .vertical(true)
            .strokeWidth(2)
            .color('#FF9019')
            .height('30%')
          Text(this.item.timeEnd)
            .fontSize(14)
            .fontWeight(FontWeight.Regular)
        }.justifyContent(FlexAlign.SpaceBetween)
        .height('90%')
        .margin({ left: 16 })

        Column() {
          Text(this.courseDetail.courseName)
            .fontSize(14)
            .fontWeight(FontWeight.Bold)
          Text('¥' + this.courseDetail.price)
            .fontSize(14)
            .fontWeight(FontWeight.Medium)
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .alignItems(HorizontalAlign.Start)
        .height('90%')
        .margin({ left: 16 })
        .layoutWeight(1)

        Column() {
          if (this.remain === 9999) {
            Button('无需预约', { type: ButtonType.Capsule, stateEffect: true })
              .fontColor($r('sys.color.font_emphasize'))
              .backgroundColor('#E5E7E8')
              .width(90)
              .height(35)
              .fontSize($r('sys.float.Body_M'))
          } else if (this.remain > 0) {
            Text() {
              Span('空')
                .fontSize(12)
                .fontWeight(FontWeight.Regular)
                .fontColor('#333333')
              Span(this.remain + '')
                .fontSize(12)
                .fontWeight(FontWeight.Regular)
                .fontColor('#FF9019')
              Span('/' + this.item.totalQuota)
                .fontSize(12)
                .fontWeight(FontWeight.Regular)
                .fontColor('#333333')
            }
            Button('预约', { type: ButtonType.Capsule, stateEffect: true })
              .fontSize($r('sys.float.Body_M'))
              .width(90)
              .height(35)
              .fontColor($r('sys.color.comp_background_list_card'))
              .fontWeight(FontWeight.Medium)
              .backgroundColor('#FF9019')
              .enabled(true)
              .onClick(() => {
                if (this.loginStateStorage.loginState) {
                  if(this.item && this.item.restQuota <= 0){
                    this.getUIContext().getPromptAction().showToast({message: '课程余量不足'})
                  } else {
                    if (this.hasCardOrOnce()) {
                      this.pathStack.pushPath({ name: 'course/AddBooking', param: this.item })
                    } else {
                      this.pathStack.pushPath({ name: 'course/CourseDetail', param: this.courseDetail })
                    }
                  }
                } else {
                  this.getUIContext().getPromptAction().showToast({ message: '请先关联账号' })
                  this.jumpLogin = !this.jumpLogin
                  this.pathStack.clear(false)
                  if (this.courseDetail) {
                    try {
                      emitter.emit(EmitterConstant.CLICK_BOOK_DETAIL)
                    } catch (e) {
                      console.error(`emitter emit failed. error: ${JSON.stringify(e)}`)
                    }
                    this.bookJumpSearchStorage.bookJumpSearch = this.courseDetail.courseName
                  }
                }
              })
          } else {
            Button('已满', { type: ButtonType.Capsule, stateEffect: true })
              .fontSize($r('sys.float.Body_M'))
              .fontColor($r('sys.color.font_tertiary'))
              .width(90)
              .height(35)
              .fontWeight(FontWeight.Medium)
              .backgroundColor('#E5E7E8')
              .enabled(false)
          }
        }
        .justifyContent(FlexAlign.SpaceAround)
        .height('100%')
      }
      .justifyContent(FlexAlign.Center)
      .alignItems(VerticalAlign.Center)
      .backgroundColor($r('sys.color.comp_background_list_card'))
      .width('100%')
      .borderRadius(16)
      .padding(16)
      .height(88)
    }

  }
}

@ComponentV2
struct NoCourse {
  build() {
    Column() {
      Image($r('app.media.no_result'))
        .width(144)
        .height(144)
        .margin({ bottom: 12 })
      Text('该日程无排课')
        .fontSize(14)
        .fontWeight(FontWeight.Regular)
        .fontColor('#999999')
      Text('请另选时间预约吧~')
        .fontSize(14)
        .fontWeight(FontWeight.Regular)
        .fontColor('#999999')
    }
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .width('100%')
    .height('80%')
  }
}


