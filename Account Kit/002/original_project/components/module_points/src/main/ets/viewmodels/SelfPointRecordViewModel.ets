import { AppStorageV2 } from '@kit.ArkUI';
import { Constants, Point, PopViewUtils, RouterMap } from '../libcommon/Index';
import {
  photoPointConfirmBuilder,
  PointConfirmParam,
  scanPointConfirmBuilder
} from '../components/SubmitPointConfirm';
import { PointRouteParam, PointStatus } from '../constants/PointConstants';
import { GlobalPointUtils } from '../utils/GlobalPointUtils'
import { SelfPointRecordModel } from '../models/SelfPointRecordModel';
import { ContextUtils } from '../libcommon/ContextUtils';

@ObservedV2
export class SelfPointRecordViewModel {
  @Trace pointType: number = 1
  @Trace pointApproveType: number = 0
  @Trace pointList: Array<Point> = []
  @Trace allPointList: Point[] = [];
  @Trace searchMonth: string[] = ['2025年', '6月']
  @Trace selectMonth: string[] = ['2025年', '6月']
  @Trace consumerList: Point[] = [];
  @Trace allConsumerList: Point[] = [];
  @Trace datePickerSheet: boolean = false
  @Trace showCallSheet: boolean = false
  private years: string[] = Constants.YEAR_PICKER
  private months: string[] = Constants.MONTH_PICKER
  multi: string[][] = [this.years, this.months];
  @Trace globalPointInfo: GlobalPointUtils = AppStorageV2.connect(GlobalPointUtils, () => new GlobalPointUtils())!;
  @Trace resubmitId: string = '';
  @Trace pathStack: NavPathStack = new NavPathStack();
  @Trace dataModel: SelfPointRecordModel = new SelfPointRecordModel();

  constructor() {
    this.getApprovePoint();
    this.getConsumeList();
  }

  getParam() {
    let paramsArr: PointRouteParam[] =
      this.pathStack.getParamByName(RouterMap.SELF_SERVICE_POINT_PAGE) as PointRouteParam[];
    if (paramsArr.length) {
      let routerParam = paramsArr[paramsArr.length - 1];
      this.resubmitId = routerParam?.id ?? '';
    }
  }

  setStack(pathStack: NavPathStack) {
    this.pathStack = pathStack;
  }

  // 查询列表
  getApprovePoint() {
    const list = SelfPointRecordModel.queryApproveList();
    this.allPointList = list.map(v => new Point(v));
    this.filterList(this.pointApproveType);
  }

  filterList(status: PointStatus) {
    this.pointApproveType = status;
    this.pointList = this.allPointList.filter(v => v.status === status);
  }

  getConsumeList() {
    const list = SelfPointRecordModel.queryConsumeList();
    this.allConsumerList = list.map(v => new Point(v));
    this.filterConsumeList();
  }

  filterConsumeList() {
    this.consumerList = this.allConsumerList.filter(v => {
      const year = new Date(v.time).getFullYear();
      const month = new Date(v.time).getMonth() + 1;
      if (this.searchMonth[0].slice(0, -1) === year.toString() &&
        this.searchMonth[1].slice(0, -1) === month.toString()) {
        return true;
      }
      return false;
    })
  }

  // 签到
  checkIn() {
    this.globalPointInfo.checkIn();
  }

  // 扫码、拍照积分提交
  showPointSubmitConfirm(type: number, content: string) {
    const param = new PointConfirmParam();
    param.type = type;
    param.content = content;
    param.close = () => {
      PopViewUtils.closePopView();
    }
    param.confirm = () => {
      SelfPointRecordModel.submitPoint(type, content, this.resubmitId);
      ContextUtils.showToast({ message: '已提交审核' });
      PopViewUtils.closePopView();
      this.pathStack.pushPathByName(RouterMap.SELF_POINT_RECORD_PAGE, null);
    }
    if (type === 0) {
      PopViewUtils.showPopView<PointConfirmParam>(wrapBuilder(scanPointConfirmBuilder), param);
    } else {
      PopViewUtils.showPopView<PointConfirmParam>(wrapBuilder(photoPointConfirmBuilder), param);
    }
  }

  // 重新提交
  reSubmit(id: string) {
    this.pathStack.pushPathByName(RouterMap.SELF_SERVICE_POINT_PAGE, { id } as PointRouteParam);
  }

  getCardStatusLabel(point: Point): string {
    if (point.status === 0) {
      return '审核中';
    } else if (point.status === 1) {
      return '已通过';
    } else {
      return '未通过';
    }
  }

  getCardStatusFgColor(point: Point) {
    if (point.status === 0) {
      return $r('sys.color.multi_color_09');
    }
    if (point.status === 1) {
      return $r('sys.color.multi_color_04');
    }
    return $r('sys.color.font_primary');
  }

  getCardStatusContent(point: Point): string {
    if (point.status === 0) {
      return '待确认';
    } else if (point.status === 1) {
      return '已入账';
    } else {
      return '已驳回';
    }
  }

  getImgUrl(point: Point) {
    if (point.photo?.includes('file://')) {
      return point.photo;
    }
    return `${Constants.CLOUD_STORAGE_URL}${point.photo}`;
  }

  getPointType(point: Point) {
    if (point.type === 0) {
      return '扫码积分';
    }
    return '拍照积分';
  }

  getBtnBgColor(point: Point): ResourceColor {
    if (point.status === 0) {
      return $r('sys.color.multi_color_09');
    } else if (point.status === 1) {
      return $r('sys.color.multi_color_04');
    } else {
      return '#606060';
    }
  }

  getCardBgColor(point: Point): ResourceColor {
    if (point.status === 0) {
      return '#F7C5A6';
    } else if (point.status === 1) {
      return '#C0E1AB';
    } else {
      return '#999999';
    }
  }
}
