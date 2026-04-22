export interface BuyNote {
  icon: Resource;
  noteTitle: Resource;
  noteDesc: Resource[];
}

export class Goods {
  id: string = ''
  name: string = ''
  logo: string = ''
  bigImg: Array<string> = []
  // 现价
  money: number = 0
  // 原价
  money2: number = 0
  // 折扣
  discount: string = ''
  content: string = ''
  sales: number = 0
  // 是否有规格 1 无 2有规格 3套餐
  specType: number = 0
  details: string = ''
  num: number = 0
  isMust: number = 0
  spec: Array<SpecCatalogResp> = []
  // 餐盒费
  boxMoney: number = 0
}

export interface SpecItemResp {
  specValId: string
  specValName: string
  specValLogo: string
  specValNum: string
}

export interface SpecCatalogResp {
  specId: string
  specName: string
  specValId: string
  specVal: Array<SpecItemResp>
}

export interface PackageSpecResp {
  specName: string
  specNum: number
}

/**
 * 规格菜品
 */
export interface GoodsSpecResp {
  id: string
  money: number
  money2: number
  discount: string
  spec: string
  combination: PackageSpecResp[]
  number: number
  goodsId: string
  boxMoney: number
  isMust: number
  specType: number
}