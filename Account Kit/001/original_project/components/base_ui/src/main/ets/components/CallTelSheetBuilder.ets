import { UtilLog as Logger } from '@hw-agconnect/util-log';
import { BusinessError } from '@kit.BasicServicesKit';
import { call } from '@kit.TelephonyKit';
import { BIND_SHEET_STYLE } from '../constants/Styles';

const TAG = '[callTelSheetBuilder]'

@Builder
export function callTelSheetBuilder(tel: string, close: () => void) {
  Column() {
    Text(`${tel.substring(0, tel.length - 8)}****${tel.substring(tel.length - 4)}`)
      .fontSize($r('sys.float.Subtitle_L'))
      .fontColor($r('sys.color.font_primary'))
      .margin({ top: 20 })

    Row() {
      Image($r('app.media.ic_tel_btn')).width(14).margin(5)
      Text($r('app.string.call'))
        .fontSize($r('sys.float.Body_M'))
        .fontColor($r('sys.color.font_on_primary'))
        .fontWeight(FontWeight.Medium)
        .margin({ left: 4 })
    }
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .width($r('app.string.full_size'))
    .borderRadius(18)
    .constraintSize({ maxWidth: $r('app.string.full_size') })
    .padding({
      top: 8,
      bottom: 8,
    })
    .margin({
      left: 2,
      right: 2,
      top: 32,
      bottom: 2,
    })
    .backgroundColor($r('sys.color.multi_color_09'))
    .onClick(() => {
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
          Logger.error(TAG, 'make call failed.', e);
        }
      } else {
        Logger.error(TAG, 'Contacts not available by this device.');
      }
      close()
    })

    Row() {
      Text($r('app.string.cancel'))
        .fontSize($r('sys.float.Body_M'))
        .fontColor($r('sys.color.font_secondary'))
        .width($r('app.string.full_size'))
        .textAlign(TextAlign.Center)
        .constraintSize({ maxWidth: $r('app.string.full_size') })
        .padding({
          top: 8,
          bottom: 8,
        })
        .margin(2)
        .borderRadius(18)
        .backgroundColor($r('sys.color.comp_background_tertiary'))
    }.justifyContent(FlexAlign.Center)
    .margin({ top: 8 })
    .onClick(() => {
      close()
    })

    Blank().layoutWeight(1)
  }
  .padding({ top: 39, left: 12, right: 12 })
  .attributeModifier(BIND_SHEET_STYLE)
}