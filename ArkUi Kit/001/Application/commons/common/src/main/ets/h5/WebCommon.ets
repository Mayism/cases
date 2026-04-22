import { AtomicServiceWeb, AtomicServiceWebController } from '@kit.ArkUI';
import { imagePreview } from '../imagePreview/imagePreview';

class NativeShare {
  constructor() {
  }

  share(): string {
    /*
     * 可能需要跳转到应用中进行分享操作
     * */
    return 'ArkUI Web Component';
  }

  preview(srcList: string[], index: number) {
    /*
     * 调用原生组件查看图片
     * */
    imagePreview.show(srcList, {
      startIndex: index,
    })
  }
}

@Component
export struct WebCommon {
  @State controller: AtomicServiceWebController = new AtomicServiceWebController();
  @Prop loadUrl: string = ''
  @State nativeShareObj: NativeShare = new NativeShare();
  @Require @Prop title: string

  build() {
    NavDestination() {
      Column() {
        AtomicServiceWeb({ src: '', controller: this.controller,
          onControllerAttached:() => {
            this.controller.loadUrl($rawfile(this.loadUrl));
          },
        })
      }
    }.padding({ top: Number(AppStorage.get('topRectHeight')) }).title(this.title)
  }
}