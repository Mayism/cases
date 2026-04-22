import { ToastDialog as promptAction } from '@hw-agconnect/ui-toast';
import { AppStorageV2, PersistenceV2 } from '@kit.ArkUI';
import { paySheetBuilder } from 'base_ui';
import {
  GridRowColSetting,
  NavHeaderBar,
  RechargeTier,
  RouterMap,
  RouterModule,
  StoreInfoModel,
  UserInfoModel,
  WindowModel,
} from 'common/Index';
import { MyWallet } from 'my_wallet';
import * as API from '../api/Index';

@Builder
export function MyWalletPageBuilder() {
  MyWalletPage()
}

@ComponentV2
struct MyWalletPage {
  @Local breakpoint: string = '';
  @Local windowModel: WindowModel = AppStorageV2.connect(WindowModel, () => new WindowModel())!
  @Local storeModel: StoreInfoModel = AppStorageV2.connect(StoreInfoModel, () => new StoreInfoModel())!
  @Local userInfoModel: UserInfoModel = PersistenceV2.connect(UserInfoModel, () => new UserInfoModel())!
  @Local selectTier: RechargeTier = new RechargeTier()
  @Local showPaySheet: boolean = false

  @Computed
  get rechargeTierList() {
    return this.storeModel.storeInfo.rechargeTier.filter(item => item.type === 1)
  }

  build() {
    NavDestination() {
      NavHeaderBar({ title: '我的钱包' })
      GridRow(GridRowColSetting.DEFAULT_GRID_ROW_OPTIONS) {
        GridCol({ span: GridRowColSetting.GRID_ROW_OPTIONS_COLUMNS }) {
          MyWallet({
            wallet: this.userInfoModel.userInfo.wallet,
            rechargeTierList: this.rechargeTierList,
            selectTier: this.selectTier,
            goRechargeCb: (): void => RouterModule.push(RouterMap.RECHARGE_RECORD_PAGE),
            changeSelectCb: (selectTier: RechargeTier) => {
              this.selectTier = selectTier
            },
            goWalletTermsCb: () => {
              RouterModule.push(RouterMap.WALLET_TERMS_PAGE)
            },
            goPayCb: () => {
              this.showPaySheet = true
            },
          })

            .backgroundColor($r('sys.color.background_secondary'))
            .padding({
              top: 12,
              bottom: 16 + this.windowModel.getWindowBottomHeight(),
              left: GridRowColSetting.getPageMargin(this.breakpoint),
              right: GridRowColSetting.getPageMargin(this.breakpoint),
            })
            .bindSheet(this.showPaySheet, paySheetBuilder(this.selectTier.payMoney, (flag: boolean) => {
              if (flag) {
                this.payRechargeMoney()
              }
              this.showPaySheet = false
            }), {
              detents: [397, 398],
              backgroundColor: $r('sys.color.background_fourth'),
              title: { title: $r('app.string.select_pay_type') },
              blurStyle: BlurStyle.Thick,
              preferType: SheetType.CENTER,
            })
        }
      }.layoutWeight(1)
      .onBreakpointChange((bp) => {
        this.breakpoint = bp;
      })
    }.hideTitleBar(true)
  }

  payRechargeMoney() {
    // 拉华为支付
    API.purchase().then(() => {
      API.rechargeMoney(this.selectTier.id).then((res) => {
        promptAction.showToast({ message: '充值成功' })
        RouterModule.pop(res)
      })
    }).catch(() => {
      promptAction.showToast({ message: '充值失败~' })
    })
  }
}
