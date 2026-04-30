import { AlertDialog, ButtonOptions } from '@kit.ArkUI';

interface ICustomAlertDialogParam {
  primaryTitle: string;
  secondaryTitle?: string;
  content: string;
  primaryButton?: ButtonOptions;
  secondaryButton?: ButtonOptions;
}

export class CustomAlertDialogParam implements ICustomAlertDialogParam {
  primaryTitle: string = '';
  secondaryTitle: string = '';
  content: string = '';
  primaryButton: ButtonOptions = {
    value: '取消',
  };
  secondaryButton: ButtonOptions = {
    value: '确定'
  };

  constructor(params: ICustomAlertDialogParam) {
    this.primaryTitle = params.primaryTitle;
    this.secondaryTitle = params.secondaryTitle ?? '';
    this.content = params.content;
    if (params.primaryButton) {
      this.primaryButton = params.primaryButton;
    }
    if (params.secondaryButton) {
      this.secondaryButton = params.secondaryButton;
    }

  }
}

@Builder
export function alertDialogBuilder(params: CustomAlertDialogParam) {
  AlertDialog({
    primaryTitle: params.primaryTitle,
    secondaryTitle: params.secondaryTitle,
    content: params.content,
    primaryButton: params.primaryButton,
    secondaryButton: params.secondaryButton,
  })
}