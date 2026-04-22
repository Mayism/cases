export interface RechargeConfig {
  payNumber: number;
  discounts: number;
}

export interface RechargeRouteParam {
  balance: number;
  rechargeConfigs?: RechargeConfig[];
  handleBack?: (balance: number)=>void
  discount?: number
}