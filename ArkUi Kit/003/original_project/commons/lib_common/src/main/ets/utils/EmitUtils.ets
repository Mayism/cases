import { Callback, emitter } from '@kit.BasicServicesKit';

/**
 * 全局事件
 */
export class EmitUtils {
  static onEmit(eventId: string, callback: Callback<emitter.EventData>) {
    emitter.on(eventId, callback);
  }

  static offEmit(eventId: string) {
    emitter.off(eventId);
  }

  static sendEmit(eventId: string, data?: emitter.EventData) {
    emitter.emit(eventId, data);
  }
}

