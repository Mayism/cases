import { UtilLog } from '@hw-agconnect/util-log';
import window from '@ohos.window';
import { CommonUrl, Constants, ImageRouter, RouterMap, RouterModule } from 'common/Index';

@Builder
export function PreviewImagePageBuilder() {
  PreviewImagePage()
}

@ComponentV2
struct PreviewImagePage {
  @Local imageSrc: string = ''
  @Local screenWidth: number = 0;
  @Local op: number = 0

  aboutToAppear() {
    this.getParams()
    try {
      window.getLastWindow(this.getUIContext().getHostContext()).then(currentWindow => {
        let property = currentWindow.getWindowProperties();
        this.screenWidth = property.windowRect.width;
      })
    } catch (e) {
      UtilLog.error(`Get currentWindow failed.`, e)
    }
  }

  getParams() {
    let params = RouterModule.getNavParam<ImageRouter>(RouterMap.PREVIEW_IMAGE_PAGE)
    if (params) {
      this.imageSrc = params.imageSrc ?? ''
    }
  }

  closeDialog() {
    RouterModule.pop()
  }

  build() {
    NavDestination() {
      Column() {
        ImageComponent({
          image: this.imageSrc,
          viewWidth: this.screenWidth,
          closeDialog: () => {
            this.closeDialog()
          },
        })
      }
      .width(Constants.FULL_SIZE)
      .height(Constants.FULL_SIZE)
      .justifyContent(FlexAlign.Center)
      .backgroundColor(`#66000000`)
    }.hideTitleBar(true)
    .systemTransition(NavigationSystemTransitionType.EXPLODE)
    .mode(NavDestinationMode.DIALOG)

  }
}

// 进场过程中会逐帧触发onEnter回调，入参为动效的归一化进度(0% -- 100
@ComponentV2
struct ImageComponent {
  @Param image: string = ''
  @Param viewWidth: number = 0
  @Local geometryScale: number = 1
  @Local geometryOffsetX: number = 0
  @Local geometryOffsetY: number = 0
  @Local imageWidth: number = 0
  @Local imageHeight: number = 0
  private preGeometryScale: number = 1
  @Event closeDialog: () => void = () => {
  }

  reset(): Promise<void> {
    return new Promise((resolve, reject) => {
      this.preGeometryScale = 1
      if (this.geometryScale === 1) {
        reject()
      }
      this.getUIContext()?.animateTo({ duration: 200, onFinish: resolve }, () => {
        this.geometryScale = 1
        this.geometryOffsetX = 0
        this.geometryOffsetY = 0
      })
    })
  }

  build() {
    Column() {
      Image(`${CommonUrl.CLOUD_STORAGE_URL}${this.image}`)
        .onComplete((e) => {
          this.imageWidth = (e?.width || 0)
          this.imageHeight = (e?.height || 0)
        })
        .objectFit(ImageFit.Cover)
        .width(this.imageWidth + 'px')
        .height(this.imageHeight + 'px')
        .scale({
          x: this.geometryScale,
          y: this.geometryScale,
        })
        .offset({
          x: this.geometryOffsetX,
          y: this.geometryOffsetY,
        })
        .focusable(true)
        .objectFit(ImageFit.Cover)
        .autoResize(false)
        .sharedTransition('sharedImage', {
          duration: 200,
          curve: Curve.Linear,
        })
    }
    .clip(true)
    .width(Constants.FULL_SIZE)
    .height(Constants.FULL_SIZE)
    .justifyContent(FlexAlign.Center)
    .hitTestBehavior(HitTestMode.Default)
    .parallelGesture( // 在组件上绑定二指触发的捏合手势
      GestureGroup(GestureMode.Exclusive,
        PinchGesture({ fingers: 2 })
          .onActionStart((event: GestureEvent) => {
          })// 当捏合手势触发时，可以通过回调函数获取缩放比例，从而修改组件的缩放比例
          .onActionUpdate((event: GestureEvent) => {
            const s = this.preGeometryScale * event.scale;
            this.geometryScale = Math.max(0.6, Math.min(2, s))
          })
          .onActionEnd(async () => {
            this.preGeometryScale = this.geometryScale
            if (this.preGeometryScale < 1) {
              await this.reset()
            }
          }),
        TapGesture({ count: 1 })
          .onAction((event: GestureEvent) => {
            if (event) {
              this.closeDialog()
            }
          }),
      ),
    )
  }
}
