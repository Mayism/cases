import * as API from '../api/Index';
import { Constants, RouterModule } from 'common/Index';
import { Goods } from '../models/Index';
import { goodsInfoMapper } from '../mapper/Index';
import { SnackSizedDeal } from 'snack_sized_deal';

@Builder
export function SnackSizedDealPageBuilder() {
  SnackSizedDealPage()
}

@ComponentV2
struct SnackSizedDealPage {
  @Local goodsList: Array<Goods> = []

  aboutToAppear() {
    API.getSnackSizedDeal().then(res => {
      this.goodsList = res.map(item => goodsInfoMapper(item))
    })
  }

  closeDialog(addGoodsList?: Goods[]) {
    RouterModule.pop(addGoodsList)
  }

  build() {
    NavDestination() {
      Column() {
        SnackSizedDeal({
          goodsList: this.goodsList,
          closeDialog: (addGoodsList?: Goods[]) => {
            this.closeDialog(addGoodsList)
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

