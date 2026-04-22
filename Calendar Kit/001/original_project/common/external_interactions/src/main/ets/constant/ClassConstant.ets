@ObservedV2
export class ScreenPropStorage {
  @Trace topRectHeight: number = 0;
  @Trace bottomRectHeight: number = 0;
}

@ObservedV2
export class LoginState {
  @Trace loginState: boolean = false;
}

@ObservedV2
export class JumpLogin {
  @Trace jumpLogin: boolean = false;
}

@ObservedV2
export class AccountUpdate {
  @Trace accountUpdate: boolean = false;
}
@ObservedV2
export class GlobalBalance {
  @Trace globalBalance: number = 0;
}


@ObservedV2
export class BookJumpSearch {
  @Trace bookJumpSearch: string = '';
}

@ObservedV2
export class BookingRestQuotaUpdate {
  @Trace bookingRestQuotaUpdate: boolean = false;
}

@ObservedV2
export class ClearPath {
  @Trace clearPath: boolean = false;
}


@ObservedV2
export class ListLength {
  @Trace listLength: number = 0;
}
