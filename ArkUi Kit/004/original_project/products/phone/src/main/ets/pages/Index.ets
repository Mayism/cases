import { Constants } from 'lib_common';
import { IndexViewModel } from '../viewmodel/IndexViewModel';

@Entry
@ComponentV2
struct Index {
  @Local vm: IndexViewModel = new IndexViewModel();

  aboutToAppear(): void {
    this.vm.init();
  }

  aboutToDisappear(): void {
    this.vm.offConsumeWallet();
    this.vm.offPrivacyChange();
  }

  build() {
    Column() {
      Navigation(this.vm.pageStack) {
      }
      .hideTitleBar(true)
      .hideNavBar(true)
      .mode(NavigationMode.Stack)
      .height(Constants.FULL_SIZE)
      .width(Constants.FULL_SIZE)
    }
    .height(Constants.FULL_SIZE)
    .width(Constants.FULL_SIZE)
  }
}
