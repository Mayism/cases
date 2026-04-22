export class VipRechargeItem {
  private payNumber: number = 0;
  private discounts: number = 0;

  constructor(payNumber: number, discounts: number) {
    this.payNumber = payNumber
    this.discounts = discounts
  }

  getPayNumber(): number {
    return this.payNumber
  }

  getDiscounts(): number {
    return this.discounts
  }

  setPayNumber(payNumber: number) {
    this.payNumber = payNumber;
  }

  setDiscounts(discounts: number) {
    this.discounts = discounts;
  }
}