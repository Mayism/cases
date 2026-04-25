import { call } from '@kit.TelephonyKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { Logger } from './Utils';

const TAG = '[CallTelSheet]';

export function callPhone(tel: string) {
  if (canIUse('SystemCapability.Applications.Contacts')) {
    try {
      call.makeCall(tel, (err: BusinessError) => {
        if (!err) {
          Logger.info(TAG, 'make call success.');
        } else {
          Logger.info(TAG, 'make call fail, err is:' + JSON.stringify(err));
        }
      });
    } catch (e) {
      Logger.error(TAG, `call.makeCall fail. Code: ${e.code}, message: ${e.message}`);
    }
  } else {
    Logger.error(TAG, 'Contacts not available by this device.');
  }
}

@Builder
export function CallTelSheetBuilder(tel: string, close: () => void) {
  Column() {
    Column() {
      Row() {
        Text('联系客服')
          .fontSize($r('sys.float.Title_S'))
          .fontWeight(FontWeight.Medium)
          .fontColor($r('sys.color.font_primary'))
        Image($r('app.media.ic_close')).width(40).onClick(() => {
          close()
        })
      }
      .width('100%')
      .height(56)
      .justifyContent(FlexAlign.SpaceBetween)
    }

    Column() {
      Text(tel).fontSize(18).fontWeight(500)
      Button() {
        Row({ space: 8 }) {
          SymbolGlyph($r('sys.symbol.phone')).fontSize(24).fontColor([$r('sys.color.font_on_primary')])
          Text('一键拨号')
            .fontSize($r('sys.float.Body_L'))
            .fontColor($r('sys.color.font_on_primary'))
            .fontWeight(FontWeight.Medium)
        }
        .height(40)
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.Center)
      }
      .width('100%')
      .backgroundColor($r('app.color.app_theme'))
      .margin({ top: 22 })
      .onClick(() => {
        callPhone(tel);
        close();
      })

      Button('取消')
        .width('100%')
        .fontSize($r('sys.float.Body_L'))
        .fontColor($r('sys.color.font_tertiary'))
        .backgroundColor($r('sys.color.comp_background_tertiary'))
        .margin({ top: 12 })
        .onClick(() => {
          close();
        })
    }
    .borderRadius(16)
    .backgroundColor($r('sys.color.background_primary'))
    .padding({
      top: 24,
      bottom: 20,
      left: 24,
      right: 24,
    })
  }
  .width('100%')
  .padding({ left: 16, right: 16, bottom: 28 })
  .backgroundColor($r('sys.color.background_secondary'))
}