import { SelfPointRecordModel } from '../models/SelfPointRecordModel';

/**
 * 全局变量
 */
@ObservedV2
export class GlobalPointUtils {
  // 我的积分数量
  @Trace myPoints: number = SelfPointRecordModel.totalPoints;
  // 是否已签到
  @Trace isCheckIn: boolean = false;

  /**
   * 消费积分
   */
  public consumePoint(point: number): void {
    SelfPointRecordModel.consumePoint(point);
    this.changePoint(-point);
  }

  /**
   * 签到
   */
  public checkIn(): void {
    this.isCheckIn = true;
    this.changePoint(10);
  }

  private changePoint(point: number) {
    SelfPointRecordModel.changePoint(point);
    this.myPoints = SelfPointRecordModel.totalPoints;
  }
}