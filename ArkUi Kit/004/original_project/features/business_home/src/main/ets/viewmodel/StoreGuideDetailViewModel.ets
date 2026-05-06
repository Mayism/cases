import { GuideRouter, RouterMap, RouterUtil, StoreGuide, WindowModel } from 'lib_common';

@ObservedV2
export class StoreGuideDetailViewModel extends WindowModel {
  @Trace storeGuide: StoreGuide = new StoreGuide();
  @Trace showCallSheet: boolean = false;

  getParams() {
    let paramsArr: GuideRouter[] = RouterUtil.getParamByName(RouterMap.STORE_GUIDE_DETAIL_PAGE) as GuideRouter[];
    if (paramsArr.length) {
      let routerParam = paramsArr[paramsArr.length - 1];
      this.storeGuide.id = routerParam?.guide.id ?? '';
      this.storeGuide.logo = routerParam?.guide.logo ?? '';
      this.storeGuide.name = routerParam?.guide.name ?? '';
      this.storeGuide.bigImage = routerParam?.guide.bigImage ?? '';
      this.storeGuide.location = routerParam?.guide.location ?? '';
      this.storeGuide.floor = routerParam?.guide.floor ?? '';
      this.storeGuide.tag = routerParam?.guide.tag ?? '';
      this.storeGuide.tel = routerParam?.guide.tel ?? '';
      this.storeGuide.introduce = routerParam?.guide.introduce ?? '';
    }
  }
}