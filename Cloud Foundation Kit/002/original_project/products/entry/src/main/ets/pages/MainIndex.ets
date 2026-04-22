import { UtilLog } from '@hw-agconnect/util-log';
import { AppStorageV2 } from '@kit.ArkUI';
import { emitter } from '@kit.BasicServicesKit';
import {
  Constants,
  CustomShareParams,
  EmitterEvent,
  FormCard,
  FullLoading,
  HomePageRouter,
  RouterMap,
  RouterModule,
  TabBarType,
  WindowModel,
} from 'common';
import { CustomTabBar } from '../components/CustomTabBar';
import { HomePage } from '../components/home/HomePage';
import { OrderPage } from '../components/order/OrderPage';
import { OrderListPage } from '../components/order_list/OrderListPage';
import { PersonalCenterPage } from '../components/personal_center/PersonalCenterPage';
import { LinkScanModel } from '../models/Index';

const TAG = '[MainIndex]'

@Builder
export function MainIndexBuilder() {
  MainIndex()
}

@ComponentV2
struct MainIndex {
  @Provider('currentIndex') currentIndex: number = 0;
  @Local formCard: FormCard = AppStorageV2.connect(FormCard, () => new FormCard())!
  @Local windowModel: WindowModel = AppStorageV2.connect(WindowModel, () => new WindowModel())!;
  @Local shareRouter: CustomShareParams = AppStorageV2.connect(CustomShareParams, () => new CustomShareParams())!;
  @Local linkScanRouter: LinkScanModel = AppStorageV2.connect(LinkScanModel, () => new LinkScanModel())!;
  tabController: TabsController = new TabsController();

  @Monitor('linkScanRouter.id')
  agreeFlagChange() {
    if (this.linkScanRouter.pageUrl === 'order') {
      this.formAppLinkJumpPage()
    }
  }

  aboutToAppear(): void {
    this.getParams();
    this.formAppLinkJumpPage()
    FullLoading.init(this.getUIContext());
    if (this.formCard.id) {
      this.jumpPage(this.formCard.url, { index: this.formCard.index, orderId: this.formCard.orderId } as HomePageRouter)
    }
    if (this.shareRouter.id) {
      this.formShareChange()
    }
  }

  // 扫码直达跳转
  async formAppLinkJumpPage() {
    if (this.linkScanRouter.pageUrl === 'order') {
      let pathNames: string[] = RouterModule.getStack().getAllPathName();
      for (let i = pathNames.length - 1; i > 0; i--) {
        RouterModule.getStack().removeByName(pathNames[i])
      }
      this.currentIndex = 1;
    }
  }

  @Monitor('shareRouter.id')
  formShareChange() {
    if (this.shareRouter.id) {
      // 通过this.shareRouter.goodsId查询商品详情，并实现页面跳转
      UtilLog.info(TAG, `shareRouter jump, goodsId:${JSON.stringify(this.shareRouter.goodsId)}}`)
      this.jumpPage(RouterMap.GOODS_DETAIL_PAGE, { 'goodsId': this.shareRouter.goodsId } as Record<string, string>)
    }
  }

  @Monitor('formCard.id')
  formCardChange(monitor: IMonitor) {
    if (monitor.value()?.now) {
      if (Constants.CARD_JUMP_PARAMS_PAGES.includes(this.formCard.url)) {
        this.jumpPage(this.formCard.url, Number(this.formCard.orderId))
      } else {
        this.jumpPage(this.formCard.url,
          { index: this.formCard.index, orderId: this.formCard.orderId } as HomePageRouter)
      }
    }
    this.formCard.id = 0
  }

  jumpPage<T>(url: string, params: T) {
    let currentName: string[] = RouterModule.getStack().getAllPathName()
    UtilLog.info(TAG, `jump Page, url:${url}, params:${JSON.stringify(params)}}`)
    // 打开首页
    if (currentName.length && currentName[currentName.length-1] === RouterMap.MAIN_INDEX &&
      url === RouterMap.MAIN_INDEX) {
      RouterModule.popToName(RouterMap.MAIN_INDEX, params);
    } else if (currentName.length && currentName[currentName.length-1] === url) {
      // 当前页
      RouterModule.replace(url, params);
    } else {
      RouterModule.push(url, params);
    }
  }

  getParams() {
    let params = RouterModule.getNavParam<HomePageRouter>(RouterMap.MAIN_INDEX);
    if (params) {
      this.currentIndex = params.index ?? 0;
    }
  }

  build() {
    NavDestination() {
      Stack() {
        Flex({
          direction: FlexDirection.Column,
        }) {
          Tabs({ controller: this.tabController, index: this.currentIndex }) {
            TabContent() {
              HomePage();
            };

            TabContent() {
              OrderPage();
            };

            TabContent() {
              OrderListPage();
            };

            TabContent() {
              PersonalCenterPage();
            };
          }
          .layoutWeight(1)
          .barHeight(0)
          .scrollable(false)
          .onChange((index) => {
            this.currentIndex = index;
          });

          CustomTabBar();
        }
        .width(Constants.FULL_SIZE)
        .height(Constants.FULL_SIZE);
      };
    }.hideTitleBar(true).padding({ bottom: this.windowModel.getWindowBottomHeight() })
    .onShown(() => {
      if (this.currentIndex === TabBarType.ORDER_LIST) {
        try {
          emitter.emit(EmitterEvent.REFRESH_ORDER_LIST)
        } catch (e) {
          UtilLog.info(TAG, `emitter failed:${JSON.stringify(e)}}`)
        }
      }
    })

  }
}