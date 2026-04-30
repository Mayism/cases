import { hilog } from '@kit.PerformanceAnalysisKit';
import { MyCoupons } from '../pages/MyCouponsPage';

@Entry
@ComponentV2
struct Sample1 {
  build() {
    NavDestination() {
      Column() {
        MyCoupons({
          clickUseNow: () => {
            try {
              this.getUIContext().getPromptAction().showToast({ message: '点击了立即使用' });
            } catch {
              hilog.error(0, 'test', 'showToast fail');
            }
          },
        })
      }
      .width('100%')
    }
    .height('100%')
    .width('100%')
    .title('我的券包')
  }
}