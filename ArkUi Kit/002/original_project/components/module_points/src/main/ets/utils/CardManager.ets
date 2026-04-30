import { PointConstants } from '../constants/PointConstants';

export class FormDataClass {
  remParkingSpc: string = ''
  score: string = ''

  constructor(remParkingSpc: string = '', score: string = '') {
    this.remParkingSpc = remParkingSpc;
    this.score = score;
  }
}

export class CardManager {
  private static instance: CardManager = new CardManager()
  static LEFT_CAR: number = PointConstants.DEFAULT_CAR_PARKING;
  static MY_POINTS: number = PointConstants.DEFAULT_POINT;

  static get(): CardManager {
    return CardManager.instance;
  }

  /**
   * 设置我的积分
   * @param point
   */
  public setPoint(point: number) {
    CardManager.MY_POINTS = point;
  }

  /**
   * 获取卡片数据
   * @param refresh
   * @returns
   */
  public getCardData(refresh: boolean = false): FormDataClass {
    if (refresh) {
      CardManager.LEFT_CAR--;
    }
    let leftParkingVal = CardManager.LEFT_CAR.toString();
    let pointVal = CardManager.MY_POINTS.toString();
    const data = new FormDataClass(leftParkingVal, pointVal);
    return data;
  }
}