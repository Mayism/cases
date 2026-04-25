import { AtomicServiceWeb, AtomicServiceWebController } from '@kit.ArkUI';

@Component
export struct AsWebRichText {
  @Prop url: string;
  @Prop richTextStr: string = '';
  @State controllerWeb: AtomicServiceWebController = new AtomicServiceWebController();

  getUrl(): string {
    if (this.richTextStr !== null) {
      return `${this.url}?richText=${this.richTextStr}`;
    }
    return this.url;
  }

  build() {
    AtomicServiceWeb({ controller: this.controllerWeb, src: this.getUrl() })
  }
}