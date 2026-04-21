import { AppStorageV2, promptAction, window } from '@kit.ArkUI';
import {
  LoginModel,
  RouterMap,
  RouterModule,
  WindowModel
} from 'commonlib';
import { HomePageVM } from '../viewModels/HomePageVM';

class NewsData {
  title: string = ''
  content: string = ''
  image?: Resource
  comment: string = ''
  good: boolean = false
  collect: boolean = false
  share: number = 0
}

@Builder
export function newsDetailBuilder() {
  NewsDetail();
}

@ComponentV2
export struct NewsDetail {
  vm: HomePageVM = HomePageVM.instance;
  @Local isShowSheet: boolean = false;
  @Local customHeight: number = 300;
  @Local heartFlag: boolean = false;
  @Local collectFlag: boolean = false;
  @Local firstComment: string = ''
  @Local isStateEffect: boolean = false
  @Local num: number = 0.4
  @Local newsData: NewsData = new NewsData();
  textAreaController: TextAreaController = new TextAreaController();

  windowModel: WindowModel = AppStorageV2.connect(WindowModel, () => new WindowModel())!;
  loginInfo: LoginModel = AppStorageV2.connect(LoginModel, () => new LoginModel())!

  aboutToDisappear(): void {
    window.getLastWindow(getContext(this)).then((windowClass) => {
      windowClass.setPreferredOrientation(window.Orientation.PORTRAIT)
    })
  }

  @Builder
  ContentTitle() {
    Column() {
      Text('华为鸿蒙智家持续进化，做未来空间智能化的领导者')
        .fontSize(`${16 + this.windowModel.fontSize}`)
        .fontFamily('鸿蒙黑体')
        .fontWeight('bold')
        .fontColor($r('app.color.news_title_fontColor'))

      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween }) {
        Row() {
          Text('xx新闻')
            .fontSize(`${12 + this.windowModel.fontSize}`)
            .fontWeight('regular')
            .fontFamily('鸿蒙黑体')
            .fontColor($r('app.color.news_time_fontColor'))
          Text('2025-04-06 21.00.00')
            .fontSize(`${12 + this.windowModel.fontSize}`)
            .fontWeight('regular')
            .margin({ left: 8 })
            .fontFamily('鸿蒙黑体')
            .fontColor($r('app.color.news_time_fontColor'))
        }
        .margin({ left: 6 })
      }
      .width('100%')
      .align(Alignment.Start)
      .margin({ top: 12 })

      Column() {
        Row() {
          Text('自2021年以来，华为依托连接、交互、生态三大核心竞争力，引领的“空间智能”革命，开创沉浸式、个性化、可成长的全场景智慧体验。' +
            '2024年11月26日，“华为全屋智能”正式宣布品牌升级为“华为鸿蒙智家”。2025年华为鸿蒙智家子系统聚焦用户沉浸体验，推出“健康空气”、' +
            '“主动节能”等多维度场景化方案，为消费者提供更优质、更高级、更专业的多样化智能选择。在冷暖新风领域，华为和生态合作伙伴突破传统' +
            '暖通对接方式，联合发布《华为鸿蒙智家暖通网关新风对接白皮书》，引领行业标准化发展。')
            .fontFamily('鸿蒙黑体')
            .fontSize(`${14 + this.windowModel.fontSize}`)
            .fontColor($r('app.color.news_content_fontColor'))
            .lineHeight(`${21 + this.windowModel.fontSize}`)
        }

        Row() {
          Image($r('app.media.ic_fengjing_01'))
            .borderRadius(8)
        }
        .margin({ top: 24, bottom: 18, left:2 })

        Row() {
          Text('2024年，华为智选势能持续提升，爆品迭出。本次峰会，华为智选与伙伴一起预告了多款新品，致力为消费者提供高品质的纯净用水体验；' +
            '智能安全的家庭看护；高端创新的个护产品。同时，华为智选 生态产品将全面支持接入HarmonyOS 5，打造更强的行业影响力；持续' +
            '深耕“辰龙计划”，助力伙伴全面提升端到端能力；与鲸鸿动能联合发布“鲸选计划”，赋能鸿蒙智联生态伙伴全域营销。鸿蒙智联始持续聚焦' +
            '体验、效率和质量的提升,携手伙伴致力于为消费者打造全场景智慧生活新体验。鸿蒙智联模组从认证模式升级为推荐模式，帮助生态伙伴' +
            '更快、更好、跟高效的做好产品。小艺语音全面开放覆盖全流程，赋能伙伴打造全景式语音交互能力；统一标准构筑场景和语音的一致体验，' +
            '缺省支持鸿蒙智家。持续优化认证流程和套件，平滑支持HarmonyOS 5。')
            .fontFamily('鸿蒙黑体')
            .fontSize(`${14 + this.windowModel.fontSize}`)
            .fontColor($r('app.color.news_content_fontColor'))
            .lineHeight(`${21 + this.windowModel.fontSize}`)
        }
      }
      .margin({ top: 24 })
    }
    .margin(16)
  }

  @Builder
  Comment() {
    Row() {
      TextArea({ placeholder: '发表评论' })
        .height(40)
        .placeholderColor($r('app.color.news_time_fontColor'))
        .backgroundColor($r('app.color.input_bg'))
        .width('60%')
        .focusOnTouch(false)
        .margin({
          left: 16, top: 10, bottom: 30
        })
        .bindSheet(this.isShowSheet, this.CommentSheet(), {
          height: this.customHeight,
          dragBar: false,
          title: { title: '发表评论' },
          onDisappear: () => {
          },
          onWillDismiss: (() => {
            this.isShowSheet = false
          }),
        })
        .onClick(() => {
          this.isShowSheet = true
        })

      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Center }) {
        Image($r('app.media.text_clipboard')).width(24).height(24).margin({ right: 18 })
          .fillColor($r('sys.color.icon_primary'))
          .onClick(() => {
            RouterModule.push({ url: RouterMap.COMMENT_DETAIL, param: null });
          })

        Image(this.collectFlag ? $r('app.media.star_fill') : $r('app.media.star')).width(24).height(24)
          .fillColor(this.collectFlag ? $r('app.color.collect_icon_active') : $r('sys.color.icon_primary'))
          .margin({ right: 18 })
          .onClick(() => {
            this.collectFlag = !this.collectFlag;
            promptAction.showToast({
              message: `${this.collectFlag ? '收藏成功' : '取消收藏'}`,
              alignment: Alignment.Bottom,
              offset: { dx: 0, dy: -vp2px(80) },
            })
          })

        Image($r('app.media.share')).width(24).height(24)
          .fillColor($r('sys.color.icon_primary'))
          .margin({ right: 18 }).onClick(() => {
          promptAction.showToast({
            message: '分享成功',
            alignment: Alignment.Bottom,
            offset: { dx: 0, dy: -vp2px(80) },
          })
        })
      }
      .width('40%')
      .margin({
        top: 8, bottom: 36, right: 16
      })
    }
    .height(88)
    .backgroundColor($r('app.color.comment_view_bg'))
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
  }

  @Builder
  CommentSheet() {
    Column() {
      TextArea({ placeholder: '我来说两句...', text: this.vm.comment, controller: this.textAreaController })
        .backgroundColor($r('app.color.input_bg'))
        .maxLength(300)
        .height(140)
        .margin({ left: 16, right: 16 })
        .showCounter(true,
          { thresholdPercentage: 0, highlightBorder: true })
        .onFocus(() => {
          this.customHeight = 500
        })
        .onBlur(() => {
          this.customHeight = 300
        })
        .onChange((value: string) => {
          this.vm.comment = value
          if (this.firstComment !== value && value !== null && value !== '') {
            this.isStateEffect = true
            this.num = 1
          } else {
            this.num = 0.4
          }
        })

      Button('提交', { type: ButtonType.Capsule, stateEffect: this.isStateEffect })
        .opacity(this.num)
        .width(328)
        .margin({ left: 16, right: 16, top: 16 })
        .fontColor(Color.White)
        .borderRadius(20)
        .backgroundColor(Color.Red)
        .onClick(() => {
          if (this.vm.comment === null || this.vm.comment === '' || this.vm.comment.trim() === '') {
            promptAction.showToast({
              message: '请输入内容再提交',
              offset: {
                dx: 0,
                dy: -200
              }
            });
          } else{
            RouterModule.push({ url: RouterMap.COMMENT_DETAIL, param: null });
          }
          this.isShowSheet = false;
          this.newsData.comment = this.vm.comment
        })
    }
  }

  build() {
    NavDestination() {
      Flex({ direction: FlexDirection.Column }) {
        Scroll() {
          this.ContentTitle()
        }
        .width('100%')
        .scrollBar(BarState.Off)
        .edgeEffect(EdgeEffect.Spring)
        this.Comment()
      }
      .height('100%')
    }
    .title('新闻详情')
  }
}
