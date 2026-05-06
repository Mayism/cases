import { GuideRouter, GuideTag, HttpRequest, RouterMap, RouterUtil, StoreGuide } from 'lib_common';

export class Floor {
  text: string = '';
  img: ResourceStr = '';
  floor: string = '';

  constructor(text: string, img: ResourceStr, floor: string) {
    this.text = text;
    this.img = img;
    this.floor = floor;
  }
}

@ObservedV2
export class StoreGuideViewModel {
  @Trace storeGuideList: Array<StoreGuide> = []
  @Trace floorImages: Floor[] = [
    new Floor('L5-502', $r('app.media.img_floor1'), '5F'), new Floor('L4-402', $r('app.media.img_floor1'), '4F'),
    new Floor('L3-302', $r('app.media.img_floor1'), '3F'),
    new Floor('L2-202', $r('app.media.img_floor1'), '2F'), new Floor('L1-102', $r('app.media.img_floor1'), '1F'),
    new Floor('B1-102', $r('app.media.img_floor1'), 'B1')
  ];
  @Trace searchText: string = ''
  @Trace searchTag: string = '全部'
  @Trace searchFloor: string = '全部楼层'
  @Trace swiperIndex: number = 0
  tagList: GuideTag[] = [
    new GuideTag('1', '全部'), new GuideTag('2', '餐饮'), new GuideTag('3', '服装'), new GuideTag('4', '儿童'),
    new GuideTag('5', '精品'), new GuideTag('6', '娱乐'), new GuideTag('7', '母婴'), new GuideTag('8', '运动')
  ]
  floorList: string[] = ['全部楼层', '5F', '4F', '3F', '2F', '1F', 'B1']

  getService() {
    HttpRequest.getStoreGuide().then(res => {
      this.storeGuideList = res
    })
  }

  getFloorGuideInfo(item: Floor) {
    return this.storeGuideList.find(v => v.location.includes(item.text.slice(3)) && v.floor === item.floor);
  }

  goStore(item: Floor) {
    const storeInfo = this.getFloorGuideInfo(item);
    if (storeInfo) {
      RouterUtil.pushPathByName(RouterMap.STORE_GUIDE_DETAIL_PAGE, { guide: storeInfo } as GuideRouter);
    }
  }
}