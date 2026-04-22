import { WidgetMidCard } from './WidgetMidCard';
import { WidgetSmallCard } from './WidgetSmallCard';

let storageUpdateByMsg = new LocalStorage();

@Entry(storageUpdateByMsg)
@Component
struct WidgetCard {
  @LocalStorageProp('formDimension') formDimension: number = 2;
  @LocalStorageProp('storeName') storeName: ResourceStr = $r('app.string.storeName');
  @LocalStorageProp('orderState') orderState: boolean = false;
  @LocalStorageProp('orderId') orderId: string = '';
  @LocalStorageProp('orderType') orderType: number = 1;
  @LocalStorageProp('storeTable') storeTable: string = '';
  @LocalStorageProp('orderPickNum') orderPickNum: string = '';
  @LocalStorageProp('stateType') stateType: number = 0;
  @LocalStorageProp('preorderTime') preorderTime: string = '';
  @LocalStorageProp('preorderRoom') preorderRoom: boolean = false;
  @LocalStorageProp('queueTable') queueTable: string = '';
  @LocalStorageProp('queueWaitTime') queueWaitTime: string = '';
  @LocalStorageProp('queueWaitNum') queueWaitNum: string = '';
  @LocalStorageProp('orderTime') orderTime: string = '';
  /*
   * The width or height full percentage setting.
   */
  readonly FULL_PERCENT: string = '100%';
  /*
   * The action type.
   */
  readonly ACTION_TYPE: string = 'router';
  /*
   * The ability name.
  */
  readonly ABILITY_NAME: string = 'EntryAbility';
  /*
   * The store type scan.
   */
  readonly STORE_TYPE_SCAN: string = '1';

  build() {
    if (this.formDimension === 3) {
      WidgetMidCard({
        formDimension: this.formDimension,
        storeName: this.storeName,
        orderType: this.orderType,
        storeTable: this.storeTable,
        orderId: this.orderId,
        orderPickNum: this.orderPickNum,
        stateType: this.stateType,
        preorderTime: this.preorderTime,
        preorderRoom: this.preorderRoom,
        orderTime: this.orderTime,
        queueTable: this.queueTable,
        queueWaitTime: this.queueWaitTime,
        queueWaitNum: this.queueWaitNum,
      })
    } else {
      WidgetSmallCard({
        formDimension: this.formDimension,
        storeName: this.storeName,
        orderState: this.orderState,
        orderId: this.orderId,
        orderType: this.orderType,
        storeTable: this.storeTable,
        orderPickNum: this.orderPickNum,
      })
    }
  }
}