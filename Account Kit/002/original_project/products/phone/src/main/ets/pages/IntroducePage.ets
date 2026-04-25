import { NavHeaderBar } from 'lib_common'

@Builder
export function IntroducePageBuilder() {
  IntroducePage()
}

@ComponentV2
struct IntroducePage {
  private advanceImgList: ResourceStr[] = [$r('app.media.intro_1'), $r('app.media.intro_2'), $r('app.media.intro_3')];
  private serviceImgList: ResourceStr[] = [$r('app.media.intro_4'), $r('app.media.intro_5'), $r('app.media.intro_6')];

  build() {
    NavDestination() {
      NavHeaderBar({ title: '商场介绍', hasBgColor: false })
      Scroll() {
        Column({ space: 16 }) {
          Image($r('app.media.banner_1'))
            .width('100%')
            .borderRadius(16)
            .constraintSize({
              maxHeight: '35%',
            })
          Column({ space: 16 }) {
            Row({ space: 8 }) {
              Text('开盒山').fontSize($r('sys.float.Subtitle_M')).fontWeight(FontWeight.Medium)
              Text('世纪广场店').fontSize($r('sys.float.Body_S')).fontColor($r('sys.color.font_secondary'))
            }
            .alignItems(VerticalAlign.Bottom)

            Text('作为本市首个"城市生活综合体"，开盒山以"一站式品质生活"为核心理念，集国际零售、主题餐饮、文化娱乐、亲子体验于一体，总建筑面积28万平方米，涵盖地下2层至地上5层立体商业空间。')
              .fontSize($r('sys.float.Body_M'))
          }
          .alignItems(HorizontalAlign.Start)

          Column() {
            Text('核心优势').fontSize($r('sys.float.Body_L')).fontWeight(FontWeight.Medium)
            Text('· 入驻国际一线品牌32家（含3家首店品牌）\n' +
              '· 本土原创设计师集合区"新锐工坊"\n' +
              '· 亚洲最大室内主题乐园分店').fontSize($r('sys.float.Caption_L')).margin({ top: 12, bottom: 8 })
            Row({ space: 4 }) {
              ForEach(this.advanceImgList, (item: ResourceStr) => {
                Image(item).layoutWeight(1).borderRadius(12)
              }, (v: ResourceStr) => JSON.stringify(v))
            }
            .width('100%')
            .padding({
              top: 10,
              bottom: 10,
              left: 12,
              right: 12,
            })
            .backgroundColor(Color.White)
            .borderRadius(12)
          }
          .alignItems(HorizontalAlign.Start)

          Column() {
            Text('特色服务').fontSize($r('sys.float.Body_L')).fontWeight(FontWeight.Medium)
            Text('· VIP会员专属贴心服务\n' +
              '· 无人值守智能停车系统\n' +
              '· 跨楼层儿童托管中心').fontSize($r('sys.float.Caption_L')).margin({ top: 12, bottom: 8 })
            Row({ space: 4 }) {
              ForEach(this.serviceImgList, (item: ResourceStr) => {
                Image(item).layoutWeight(1).borderRadius(12)
              }, (v: ResourceStr) => JSON.stringify(v))
            }
            .width('100%')
            .padding(8)
            .backgroundColor(Color.White)
            .borderRadius(8)
          }
          .alignItems(HorizontalAlign.Start)

          Text('商场地址：南京市雨花区光华路99号 \n' +
            '营业时间：10:00-22:00（周五/六至23:00） \n' +
            '客服热线：400-888-XXXX').fontSize($r('sys.float.Caption_L'))
        }
        .alignItems(HorizontalAlign.Start)
      }
      .layoutWeight(1)
      .align(Alignment.Top)
      .scrollBar(BarState.Off)
      .edgeEffect(EdgeEffect.Spring)
      .padding({
        left: 16,
        right: 16,
        top: 12,
        bottom: 40,
      })
    }
    .hideTitleBar(true)
    .backgroundColor($r('sys.color.background_secondary'))
  }
}
