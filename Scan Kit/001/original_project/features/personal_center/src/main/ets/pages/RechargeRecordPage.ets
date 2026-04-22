import { NavHeaderBar, WindowModel } from 'common/Index';
import { AppStorageV2 } from '@kit.ArkUI';
import * as API from '../api/Index';
import { RechargeRecord, RechargeRecordComp } from 'my_wallet';

@Builder
export function RechargeRecordPageBuilder() {
  RechargeRecordPage()
}

@ComponentV2
struct RechargeRecordPage {
  @Local windowModel: WindowModel = AppStorageV2.connect(WindowModel, () => new WindowModel())!
  @Local rechargeRecordList: RechargeRecord[] = []

  aboutToAppear(): void {
    this.getRechargeRecord()
  }

  build() {
    NavDestination() {
      NavHeaderBar({ title: '账单明细' })
      RechargeRecordComp({ rechargeRecordList: this.rechargeRecordList })
        .layoutWeight(1)
        .backgroundColor($r('sys.color.background_secondary'))
        .padding({
          top: 12,
          bottom: this.windowModel.getWindowBottomHeight(),
          left: 16,
          right: 16,
        })

    }.hideTitleBar(true)
  }

  getRechargeRecord() {
    API.getRechargeRecord().then((res) => {
      this.rechargeRecordList = res.sort((a, b) => b.time - a.time)
    })
  }
}
