/**
 * 课程助手 - 我的页面 ViewModel
 */

import { AuthStatus } from '../../common/models/Models';
import { maskPhoneNumber } from '../../common/utils/Utils';

@ObservedV2
export class MineViewModel {
  @Trace authStatus: AuthStatus = AuthStatus.Unknown;
  @Trace nickname: string = '华为用户';
  @Trace avatarUri: string = '';
  @Trace phoneNumber: string = '';
  @Trace isBound: boolean = false;
  @Trace showUnbindDialog: boolean = false;

  getDisplayPhone(): string {
    if (this.phoneNumber.length > 0) {
      return maskPhoneNumber(this.phoneNumber);
    }
    return '';
  }

  async bindAccount(): Promise<void> {
    this.authStatus = AuthStatus.SignedIn;
    this.nickname = '华为用户';
    this.phoneNumber = '13812341234';
    this.isBound = true;
  }

  async unbindAccount(): Promise<void> {
    this.authStatus = AuthStatus.SignedOut;
    this.nickname = '华为用户';
    this.phoneNumber = '';
    this.isBound = false;
  }
}