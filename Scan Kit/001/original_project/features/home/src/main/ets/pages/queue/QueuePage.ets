import { CommonPage, PermissionUtil } from 'common';
import { QueueFilterListCom } from '../../components/queue/QueueFilterListCom';
import { QueueStoreListCom } from '../../components/queue/QueueStoreListCom';
import { QueueVM } from '../../viewmodels/QueueVM';

@ComponentV2
export struct QueuePage {
  vm: QueueVM = QueueVM.instance;

  async aboutToAppear() {
    this.vm.resetQueueParams();
    PermissionUtil.getLocation().then(res => {
      this.vm.myLocation = res
    }).finally(async () => {
      await this.vm.getQueueStoreList();
    })
  }

  build() {
    CommonPage({
      title: '取号排队',
      mainUi: () => {
        this.queueMainUiBuilder();
      },
    })
  }

  @Builder
  queueMainUiBuilder() {
    /** 搜索框 **/
    Search({ value: $$this.vm.query, placeholder: '搜索门店' }).margin(0)

    /** 筛选栏 **/
    QueueFilterListCom()

    /** 门店列表 **/
    QueueStoreListCom().constraintSize({ minHeight: '48%' }).layoutWeight(1)
  }
}

@Builder
export function queuePageBuilder() {
  QueuePage()
}