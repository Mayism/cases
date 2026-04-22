import { UIDialog } from '@hw-agconnect/ui-dialog';

export interface IConfirmDialogParams {
  primaryTitle?: ResourceStr;
  secondaryTitle?: ResourceStr;
  content: ResourceStr;
  confirm?: () => void;
  cancel?: () => void;
}

/**
 * 确认弹窗
 */
export class ConfirmDialog {
  public static show(param: IConfirmDialogParams) {
    UIDialog.open({
      titleOptions: {
        primaryTitle: param.primaryTitle,
      },
      contentOptions: {
        content: param.content,
        contentTextAlign: TextAlign.Center,
      },
      confirmButtonOptions: {
        buttonFontColor: $r('sys.color.font_emphasize'),
      },
      cancelButtonOptions: {
        buttonFontColor: $r('sys.color.font_emphasize'),
      },
      showConfirmButton: true,
      showCancelButton: true,
      closeOnClickMask: true,
      closeOnBackPress: true,
      onConfirm: () => {
        UIDialog.closeLast();
        param.confirm?.()
      },
      onCancel: () => {
        UIDialog.closeLast();
        param.cancel?.()
      },
    })
  }
}