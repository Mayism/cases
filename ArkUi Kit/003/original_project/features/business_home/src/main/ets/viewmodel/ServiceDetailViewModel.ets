import { HttpRequest, RouterMap, RouterUtil, WebRouter, WindowModel } from 'lib_common';

interface IMemberService {
  title: string;
  value: number;
}

const SERVICE_LIST: IMemberService[] = [
  {
    title: '母婴室',
    value: 1,
  },
  {
    title: '寄存/招领',
    value: 2,
  },
  {
    title: '租借服务',
    value: 3,
  },
  {
    title: '急救药箱',
    value: 4,
  },
  {
    title: '礼品包装',
    value: 5,
  },
  {
    title: '停车优惠',
    value: 6,
  },
];

@ObservedV2
export class ServiceDetailViewModel extends WindowModel {
  @Trace pageTitle: string = '';
  @Trace lostType: number = 0;
  @Trace webData: string = ''
  @Trace index: number = 1
  @Trace type: number = 1
  @Trace showCallSheet: boolean = false;

  getParams() {
    let paramsArr: WebRouter[] = RouterUtil.getParamByName(RouterMap.SERVICE_DETAIL_PAGE) as WebRouter[];
    if (paramsArr.length) {
      let routerParam = paramsArr[paramsArr.length - 1];
      this.index = routerParam?.index ?? 1;
      const item = SERVICE_LIST.find(v => v.value === this.index);
      if (item) {
        this.pageTitle = item.title;
      }
      this.getService()
    }
  }

  getService() {
    HttpRequest.getService(this.index, this.type).then(res => {
      this.webData = `<meta name="viewport" content="width=device-width, initial-scale=1.0">${res ?? ''}`;
    })
  }
}