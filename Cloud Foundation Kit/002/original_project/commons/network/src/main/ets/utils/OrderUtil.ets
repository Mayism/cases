import { UtilLog } from '@hw-agconnect/util-log';
import { preferences } from '@kit.ArkData';
import { BookOrderDetail, BookOrderModel, QueueOrderDetail } from '../types/Order';

export class OrderUtil {
  private static _ctx: Context;
  private static readonly _fileName: string = 'order_file';
  private static readonly _bookOrderKey: string = 'book_order_key';
  private static readonly _queueOrderKey: string = 'queue_order_key';

  public static setContext(context: Context) {
    OrderUtil._ctx = context;
  }

  public static getBookOrders() {
    const store = OrderUtil._getStore();
    return store.getSync(OrderUtil._bookOrderKey, []) as BookOrderModel[];
  }

  public static getBookOrderById(orderId: number) {
    const list = OrderUtil.getBookOrders();
    return list.find(order => order.orderId === orderId);
  }

  public static async addBookOrder(order: BookOrderDetail) {
    const list = OrderUtil.getBookOrders();
    if (!list.some(item => item.orderId === order.orderId)) {
      list.unshift({
        schedule: false,
        orderId: order.orderId,
        store: order.store,
        time: order.time,
        count: order.count,
        room: order.room,
        name: order.name,
        phone: order.phone,
        decoration: order.decoration,
        tableWares: order.tableWares,
        tips: order.tips,
      });
      const store = OrderUtil._getStore();
      store.putSync(OrderUtil._bookOrderKey, list);
      await store.flush();
    }
  }

  public static async delBookOrder(orderId: number) {
    const list = OrderUtil.getBookOrders();
    const index = list.findIndex(order => order.orderId === orderId);

    if (index !== -1) {
      list.splice(index, 1);
      const store = OrderUtil._getStore();
      store.putSync(OrderUtil._bookOrderKey, list);
      await store.flush();

    }
  }

  public static checkHasSchedule(orderId: number) {
    const index = OrderUtil.getBookOrders().findIndex(order => order.orderId === orderId);
    if (index !== -1) {
      return OrderUtil.getBookOrders()[index].schedule;
    }
    return false;
  }

  public static async updateSchedule(orderId: number) {
    const list = OrderUtil.getBookOrders();
    const index = list.findIndex(order => order.orderId === orderId);
    if (index !== -1) {
      list[index].schedule = true;
      const store = OrderUtil._getStore();
      store.putSync(OrderUtil._bookOrderKey, list);
      await store.flush();
    }
  }

  public static getQueueOrders() {
    const store = OrderUtil._getStore();
    return store.getSync(OrderUtil._queueOrderKey, []) as QueueOrderDetail[];
  }

  public static getQueueOrderById(orderId: number) {
    const list = OrderUtil.getQueueOrders();
    return list.find(order => order.orderId === orderId);
  }

  public static async addQueueOrder(order: QueueOrderDetail) {
    const list = OrderUtil.getQueueOrders();
    if (!list.some(item => item.orderId === order.orderId)) {
      list.unshift(order);
      const store = OrderUtil._getStore();
      store.putSync(OrderUtil._queueOrderKey, list);
      await store.flush();
    }
  }

  public static async delQueueOrder(orderId: number) {
    const list = OrderUtil.getQueueOrders();
    const index = list.findIndex(order => order.orderId === orderId);
    if (index !== -1) {
      list.splice(index, 1);
      const store = OrderUtil._getStore();
      store.putSync(OrderUtil._queueOrderKey, list);
      await store.flush();
    }
  }

  public static async refreshQueueOrder(orderId: number) {
    const list = OrderUtil.getQueueOrders();

    const index = list.findIndex(order => order.orderId === orderId);
    if (index !== -1) {
      const order = list[index];
      order.now += 1;
      order.wait -= 1;
      const store = OrderUtil._getStore();
      store.putSync(OrderUtil._queueOrderKey, list);
      await store.flush();
      return order;
    }
    return undefined;
  }

  public static checkHasQueue(storeId: number) {
    const index =
      OrderUtil.getQueueOrders().findIndex(order => Number(order.store.id) === storeId && order.wait >= 0);
    if (index !== -1) {
      return true;
    }
    return false;
  }

  private static _getStore() {
    try {
      preferences.removePreferencesFromCacheSync(OrderUtil._ctx, OrderUtil._fileName)
    } catch (e) {
      UtilLog.info(`removePreferencesFromCacheSync failed.: ${JSON.stringify(e)}.`);
    }
    return preferences.getPreferencesSync(OrderUtil._ctx, { name: OrderUtil._fileName });
  }
}