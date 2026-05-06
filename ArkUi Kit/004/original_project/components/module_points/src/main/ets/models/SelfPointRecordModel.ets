import { CONSUMER_LIST, PointType, POINT_LIST, PointConstants } from '../constants/PointConstants';
import { IPoint, Point } from '../libcommon/Index';
import { CardManager } from '../utils/CardManager';

export class SelfPointRecordModel {
  // 当前总积分
  static totalPoints: number = PointConstants.DEFAULT_POINT;
  // 积分记录
  private static pointList: IPoint[] = POINT_LIST;
  // 消费记录
  private static consumeList: IPoint[] = CONSUMER_LIST;

  /**
   * 查询审批记录
   * @returns
   */
  static queryApproveList() {
    return SelfPointRecordModel.pointList;
  }

  /**
   * 查询消费记录
   * @returns
   */
  static queryConsumeList() {
    return SelfPointRecordModel.consumeList;
  }

  /**
   * 提交积分申请
   * @param type
   * @param content
   * @param resubmitId
   */
  static submitPoint(type: number, content: string, resubmitId: string) {
    // 如果是重新提交的场景，需要在此id基础上操作
    const index = SelfPointRecordModel.pointList.findIndex(v => v.id === resubmitId);
    if (index !== -1) {
      SelfPointRecordModel.pointList.splice(index, 1);
    }
    let qrcode: string = '';
    let photo: string = '';
    if (type === PointType.SCAN) {
      qrcode = content;
    } else {
      photo = content;
    }

    const point = new Point({
      id: resubmitId,
      type,
      action: 1,
      point: 600,
      qrcode,
      photo,
      status: 0,
    })
    SelfPointRecordModel.pointList.splice(0, 0, point);
  }

  static changePoint(point: number) {
    SelfPointRecordModel.totalPoints += point;
    CardManager.get().setPoint(SelfPointRecordModel.totalPoints);
  }

  /**
   * 消费积分
   */
  static consumePoint(pointCount: number) {
    const point = new Point({
      type: 1,
      time: new Date().getTime(),
      action: 0,
      point: pointCount,
    });
    SelfPointRecordModel.consumeList.splice(0, 0, point);
  }
}