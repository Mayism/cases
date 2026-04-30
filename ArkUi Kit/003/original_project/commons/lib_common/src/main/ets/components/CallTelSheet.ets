import { call } from '@kit.TelephonyKit'
import { BusinessError } from '@kit.BasicServicesKit'
import { Constants } from '../constants/Common'
import { SheetHeaderComp } from './SheetHeaderComp'
import { Logger } from '../utils/Logger';

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
    SheetHeaderComp({
      title: $r('app.string.contact_us'), close: () => {
        close()
      },
    })

    Column() {
      Text(tel).fontSize(18).fontWeight(500)
      Button() {
        Row({ space: 8 }) {
          SymbolGlyph($r('sys.symbol.phone')).fontSize(24).fontColor([$r('sys.color.font_on_primary')])
          Text($r('app.string.call'))
            .fontSize($r('sys.float.Body_L'))
            .fontColor($r('sys.color.font_on_primary'))
            .fontWeight(FontWeight.Medium)
        }
        .height(40)
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.Center)
      }
      .width(Constants.FULL_SIZE)
      .backgroundColor($r('app.color.app_theme'))
      .margin({ top: 22 })
      .onClick(() => {
        callPhone(tel);
        close();
      })

      Button('取消')
        .width(Constants.FULL_SIZE)
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
  .width(Constants.FULL_SIZE)
  .padding({ left: Constants.BORDER_WIDTH, right: Constants.BORDER_WIDTH, bottom: 28 })
  .backgroundColor($r('sys.color.background_secondary'))
}