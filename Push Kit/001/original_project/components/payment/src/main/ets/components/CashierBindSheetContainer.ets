import { CashierComponent } from './CashierComponent';

@Component
export struct CashierBindSheetContainer {
  @Builder
  cashierBuilder() {
    Column() {
      CashierComponent();
    }
  }

  build() {
    Column() {
      Column() {
      }.bindSheet(true, this.cashierBuilder(), {
        title: () => {},
        height: SheetSize.FIT_CONTENT,
        showClose: true,
        enableOutsideInteractive: false,
        backgroundColor: '#E5FFFFFF',
        blurStyle: BlurStyle.COMPONENT_THICK,
        onWillDismiss: ((action: DismissSheetAction) => {
          // exit event listener
        }),
      });
    }.width('100%');
  }
}