import { RouterMap } from '../libcommon/Constant';

@Entry
@ComponentV2
struct Sample1 {
  stack: NavPathStack = new NavPathStack()

  build() {
    Navigation(this.stack) {
      Column({ space: 10 }) {
        Text('自助积分').fontSize(20).fontWeight(FontWeight.Bold)
        Button('跳转').width('100%').onClick(() => {
          this.stack.pushPath({
            name: RouterMap.SELF_SERVICE_POINT_PAGE,
          })
        })
      }
      .padding({
        left: 10,
        right: 10,
        top: 40,
      })
    }
    .hideTitleBar(true)
  }
}