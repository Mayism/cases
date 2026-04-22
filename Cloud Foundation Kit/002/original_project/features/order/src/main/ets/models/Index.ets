import { GoodsResp, SpecCatalogResp } from 'network';

export class Goods implements GoodsResp {
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


export class PreorderLabel {
  id: number
  label: string
  check: boolean

  constructor(id: number, label: string, check: boolean) {
    this.id = id
    this.label = label
    this.check = check
  }
}

