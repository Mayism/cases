/**
 * 课程助手 - 签到页 ViewModel
 */

import { AuthStatus, CheckinInfo } from '../../common/models/Models';
import { CHECKIN_CODE_LENGTH, DEV_CHECKIN_CODE } from '../../common/constants/Constants';

@ObservedV2
export class CheckinViewModel {
  @Trace codeDigits: string[] = ['', '', '', ''];
  @Trace isCheckedIn: boolean = false;
  @Trace checkinCourseName: string = '';
  @Trace showError: boolean = false;
  @Trace isLoading: boolean = false;
  @Trace authStatus: AuthStatus = AuthStatus.Unknown;

  isCodeComplete(): boolean {
    for (let i = 0; i < this.codeDigits.length; i++) {
      if (this.codeDigits[i].length === 0) {
        return false;
      }
    }
    return true;
  }

  getCode(): string {
    let code: string = '';
    for (let i = 0; i < this.codeDigits.length; i++) {
      code += this.codeDigits[i];
    }
    return code;
  }

  setDigit(index: number, value: string): void {
    if (index >= 0 && index < this.codeDigits.length) {
      this.codeDigits[index] = value;
    }
  }

  clearCode(): void {
    for (let i = 0; i < this.codeDigits.length; i++) {
      this.codeDigits[i] = '';
    }
    this.showError = false;
  }

  async submitCheckin(): Promise<boolean> {
    this.isLoading = true;
    this.showError = false;

    const code: string = this.getCode();

    if (code === DEV_CHECKIN_CODE) {
      this.isCheckedIn = true;
      this.checkinCourseName = '概率论与数理统计';
      this.isLoading = false;
      return true;
    }

    this.showError = true;
    this.isLoading = false;
    this.clearCode();
    return false;
  }
}