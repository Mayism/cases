import { MockService } from 'external_interactions';
import { window } from '@kit.ArkUI';
import { TitleBar } from 'module_recharge/src/main/ets/components/TitleBar';
import { ScreenPropStorage, AccountUpdate } from 'external_interactions'
import { AppStorageV2 } from '@kit.ArkUI';

@ComponentV2
export struct ClubEnvironmentDetail {
  @Local screenPropStorage: ScreenPropStorage =
    AppStorageV2.connect(ScreenPropStorage, 'ScreenPropStorage', () => new ScreenPropStorage())!
  @Local topRectHeight: number = this.screenPropStorage.topRectHeight;
  @Local bottomRectHeight: number = this.screenPropStorage.bottomRectHeight;
  @Param @Once pathStack: NavPathStack = new NavPathStack();
  controller: VideoController = new VideoController()

  @Builder
  videoBuilder() {
    Column() {
      Video({
        src: $r('app.media.club'),
        previewUri: $r('app.media.material9'),
        controller: this.controller,
        currentProgressRate: PlaybackSpeed.Speed_Forward_1_00_X
      })
        .width('100%')
        .height(148)
        .borderRadius({ topLeft: 16, topRight: 16 })
        .onFullscreenChange(async (event) => {
          // 改变设备横竖屏状态
          try {
            let lastWindow = await window.getLastWindow(this.getUIContext().getHostContext()!)
            lastWindow.setPreferredOrientation(event.fullscreen ? window.Orientation.LANDSCAPE :
              window.Orientation.PORTRAIT)
          } catch (e) {
            console.error(`Failed to get last window. error: ${JSON.stringify(e)}`)
          }
        })
      Text('力健健身房配备齐全的器械设备，其中包括力量训练器械、有氧运动器械、功能性训练器械以及高科技健身设备等，满足不同健身需求。')
        .width('100%')
        .fontSize(12)
        .borderRadius({ bottomLeft: 16, bottomRight: 16 })
        .backgroundColor(Color.White)
        .padding({
          top: 8,
          right: 12,
          bottom: 16,
          left: 12
        })
    }
    .width('100%')
    .margin({ bottom: 12 })
  }

  @Builder
  imageBuilder(imageStr: string, text: string) {
    Column() {
      Image($r(imageStr))
        .width('100%')
        .height(148)
        .borderRadius({ topLeft: 16, topRight: 16 })
      Text(text)
        .width('100%')
        .fontSize(12)
        .borderRadius({ bottomLeft: 16, bottomRight: 16 })
        .backgroundColor(Color.White)
        .padding({
          top: 8,
          right: 12,
          bottom: 16,
          left: 12
        })
    }
    .width('100%')
    .margin({ bottom: 12 })
  }

  build() {
    NavDestination() {
      Column() {
        TitleBar({
          title: '俱乐部环境', onBackClick: () => {
            this.pathStack.pop()
          }
        })
          .margin({ left: 16, right: 16 })
        Scroll() {
          Column() {
            this.videoBuilder()
            this.imageBuilder('app.media.material5',
              '有氧训练；专业的有氧训练器材，宽敞的有氧训练场地，可以让你安全放松的完成一场有益身心的有氧训练。')
            this.imageBuilder('app.media.material11',
              '力量训练；适当的力量训练，可以增强身体肌肉含量，保证身体足够蛋白质，提高免疫力，我们的力量区有优秀的教练，专业的器材。')
            this.imageBuilder('app.media.material8',
              '力量训练；适当的力量训练，可以增强身体肌肉含量，保证身体足够蛋白质，提高免疫力，我们的力量区有优秀的教练，专业的器材。')
          }
        }
        .margin({ left: 16, right: 16 })
        .scrollBar(BarState.Off)
        .layoutWeight(1)
      }.height('100%')
    }
    .onReady((ctx: NavDestinationContext) => {
      this.pathStack = ctx?.pathStack
    })
    .hideTitleBar(true)
    .backgroundColor($r('app.color.main_background_color'))
    .padding({ top: this.getUIContext().px2vp(this.topRectHeight),
      bottom: this.getUIContext().px2vp(this.bottomRectHeight) })
  }
}