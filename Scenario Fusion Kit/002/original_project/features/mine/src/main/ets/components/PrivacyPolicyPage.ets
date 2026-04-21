import { AtomicServiceWeb, AtomicServiceWebController } from '@kit.ArkUI';
import { MainPageVM } from '../viewModels/MainPageVM';

@Builder
export function privacyPolicyPageBuilder() {
  PrivacyPolicyPage()
}

@Component
export struct PrivacyPolicyPage {
  @State controller: AtomicServiceWebController = new AtomicServiceWebController()
  vm: MainPageVM = MainPageVM.instance;

  build() {
    NavDestination() {
      Column() {
        AtomicServiceWeb({ src: $rawfile('privacy_policy.html'), controller: this.controller })
      }
      .padding(8)
      .layoutWeight(1)
    }
    .width('100%')
    .padding({
      left: 8,
    })
    .backgroundColor($r('app.color.bgc'))
    .height('100%')
    .hideTitleBar(false)
    .title('隐私协议')
  }
}