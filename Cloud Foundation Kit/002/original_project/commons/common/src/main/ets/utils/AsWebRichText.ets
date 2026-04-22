import { AtomicServiceWeb, AtomicServiceWebController } from '@kit.ArkUI';

// 封装AsWebRichText
@Component
export default struct AsWebRichText {
  @Prop url: string;
  @Prop richTextStr?: string;
  @State controllerWeb: AtomicServiceWebController = new AtomicServiceWebController();

  getUrl(): string {
    if (this.richTextStr != null) {
      return `${this.url}?richText=${this.richTextStr}`;
    }
    return this.url;
  }

  build() {
    AtomicServiceWeb({ controller: this.controllerWeb, src: this.getUrl() })
      .width('100%')
  }
}
