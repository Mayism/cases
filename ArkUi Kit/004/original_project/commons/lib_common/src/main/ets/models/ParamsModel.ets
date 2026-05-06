@ObservedV2
export class StoreLocation {
  @Trace storeId: string = ''
  storeName: string = ''
  @Trace latitude: number = 0
  @Trace longitude: number = 0
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

export class DiamondZone {
  icon:ResourceStr = ''
  title:ResourceStr = ''
  url:string = ''

  constructor(icon: ResourceStr, title: ResourceStr, url: string) {
    this.icon = icon
    this.title = title
    this.url = url
  }

}