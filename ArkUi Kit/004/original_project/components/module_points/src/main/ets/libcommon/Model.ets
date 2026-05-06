export interface IPoint {
  id?: string
  type: number
  time?: number
  action: number
  point: number
  qrcode?: string
  photo?: string
  status?: number
  rejectReason?: string
}

@ObservedV2
export class Point implements IPoint {
  @Trace id: string = ''
  // 扫码积分0、拍照积分1
  type: number = 1
  time: number = 0
  // 停车抵扣0、购物积分1
  action: number = 1
  point: number = 100
  qrcode?: string = ''
  photo?: string = ''
  // 审核中0、已通过1、未通过2
  @Trace status: number = 0
  @Trace rejectReason?: string = ''
  @Trace showReason: boolean = false;

  constructor(item: IPoint) {
    this.id = item.id || new Date().getTime().toString()
    this.type = item.type
    this.time = item.time ?? new Date().getTime()
    this.action = item.action
    this.point = item.point ?? 100
    this.qrcode = item.qrcode ?? ''
    this.photo = item.photo ?? ''
    this.status = item.status ?? 0
    this.rejectReason = item.rejectReason ?? ''
  }
}

// 窗口持久化
@ObservedV2
export class WindowModel {
  @Trace windowTopHeight: number = 38.77;
  @Trace windowBottomHeight: number = 28;

  getWindowTopHeight() {
    return this.windowTopHeight || 38.77;
  }

  getWindowBottomHeight() {
    return this.windowBottomHeight || 28;
  }
}

export class MenuModel {
  icon: ResourceStr = ''
  title: ResourceStr = ''
  value: ResourceStr = ''
  url: string = ''

  constructor(icon: ResourceStr, title: ResourceStr, url: string, value:string='') {
    this.icon = icon
    this.title = title
    this.url = url
    this.value = value
  }
}