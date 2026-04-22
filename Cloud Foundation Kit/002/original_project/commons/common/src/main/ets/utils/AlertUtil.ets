import { UtilLog as Logger } from '@hw-agconnect/util-log';
import { FullLoading } from './FullLoading';
import { WindowUtil } from './WindowUtil';

export function alertToConfirm(message: string, confirm: () => Promise<void>) {
  WindowUtil.globalUIContext.showAlertDialog({
    message: message,
    alignment: DialogAlignment.Center,
    height: 125,
    primaryButton: {
      value: '取消',
      fontColor: '#1a1a1a',
      action: () => {
        Logger.info('取消');
      },
    },
    secondaryButton: {
      value: '确定',
      fontColor: $r('app.color.brand_red'),
      action: async () => {
        FullLoading.show();
        await confirm();
        FullLoading.hide();
      },
    },
  });
}