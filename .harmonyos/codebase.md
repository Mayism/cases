# Project Exploration Report: Scenario Fusion Kit / 002 / original_project

## 1. Overall Project Structure (Top 2-3 Levels)

```
E:\repo\cases\Scenario Fusion Kit\002\original_project\
├── .gitignore
├── .template-plugin.json
├── AppScope/
├── build-profile.json5
├── CHANGELOG.md
├── code-linter.json5
├── commons/
│   ├── commonLib/              # Shared utilities, models, constants
│   │   ├── Index.ets           # Exports: AccountUtil, UserInfoModel, LoginModel, Logger, RouterModule, etc.
│   │   └── src/main/ets/
│   │       ├── constants/      # CommonEnums.ets (RouterMap, DialogMap, AppStorageMap), CommonContants.ets, BreakpointConstants.ets
│   │       ├── database/       # PreferencesUtil.ets (font size preferences)
│   │       ├── model/          # WindowModel.ets, NewsViewModel.ets, NewsTypeModel.ets, NewsDataSource.ets, NewsData.ets
│   │       ├── preferences/    # Preferences.ets
│   │       ├── types/          # Types.ets (UserInfo interface, HuaweiIDResp interface)
│   │       └── utils/          # AccountUtil.ets, Logger.ets, RouterModule.ets, PermissionUtil.ets, FormatUtil.ets, GlobalContext.ets, BreakpointType.ets
│   ├── componentLib/           # Shared UI components
│   │   ├── Index.ets           # Exports: CommonButton, BaseTitle, GlobalDialog, RefreshListView
│   │   └── src/main/ets/
│   │       ├── components/     # CommonButton.ets, BaseTitle.ets, GlobalDialog.ets, RefreshListView.ets, NewsCard.ets
│   │       └── dialog/        # BindPhoneDialog.ets
│   └── network/                # HTTP/network layer
│       ├── Index.ets           # Exports: HttpRequestApi, RequestModel, ResponseModel, Utils
│       └── src/main/ets/
│           ├── axiosHttpRequest/ # AxiosModel.ets, AxiosRequest.ets, AxiosHttp.ets, HttpRequestApi.ets
│           ├── cardManager/      # CardManager.ets, SubscriberClass.ets
│           ├── constants/        # Common.ets
│           ├── mock/             # MockData.ets, MockResponse.ets
│           ├── models/           # RouterModel.ets, ResponseModel.ets, RequestModel.ets
│           └── utils/            # Utils.ets
├── entry/                      # Main entry module
│   └── src/main/ets/
│       ├── entryability/        # EntryAbility.ets
│       ├── entryformability/    # EntryFormAbility.ets
│       ├── pages/               # MainEntry.ets (Tabs: Home, Video, Mine)
│       ├── types/               # Types.ets (TabListItem)
│       ├── viewmodels/          # MainEntryVM.ets
│       └── widget/pages/        # WidgetCard.ets
├── EntryCard/
├── features/
│   ├── home/                   # Home feature module
│   │   └── src/main/ets/
│   │       ├── components/     # HomeContentView.ets, NewsDetail.ets, CommentDetail.ets
│   │       ├── constants/       # Constants.ets
│   │       ├── pages/           # HomePage.ets
│   │       ├── types/           # Types.ets
│   │       └── viewModels/     # HomePageVM.ets, CommentModel.ets
│   ├── mine/                   # Mine (My) feature module
│   │   ├── Index.ets           # Exports: minePageBuilder, myCommentBuilder
│   │   └── src/main/ets/
│   │       ├── components/     # UserInfoSettingPage.ets, MySettings.ets, MyComment.ets, HistoryRecord.ets, SetFontSize.ets, PrivacyPolicyPage.ets
│   │       ├── pages/          # MinePage.ets (main "My" page)
│   │       ├── utils/          # Util.ets (maskPhone), SetFontSizeUtil.ets
│   │       └── viewModels/     # MainPageVM.ets, QuitLoginDialog.ets
│   └── video/                  # Video feature module
│       └── src/main/ets/
│           ├── components/     # VideoPlayer.ets
│           ├── pages/           # VideoView.ets, VideoDetailPage.ets
│           ├── utils/           # CommonDataSource.ets
│           └── viewModels/     # VideoViewVm.ets, VideoModel.ets
├── hvigor/
├── hvigorfile.ts
├── LICENSE
├── oh-package.json5
├── README.md
└── screenshots/
```

---

## 2. The "Mine" Module

**Location:** `E:\repo\cases\Scenario Fusion Kit\002\original_project\features\mine\`

**Module Index:** `features/mine/Index.ets` exports:
- `minePageBuilder` from MinePage
- `myCommentBuilder` from MyComment

**Files within the mine module:**
| File | Purpose |
|------|---------|
| `src/main/ets/pages/MinePage.ets` | Main "My" page with UserMsgCard and HelpCenter |
| `src/main/ets/components/UserInfoSettingPage.ets` | User info settings (avatar, name, phone) |
| `src/main/ets/components/MySettings.ets` | Settings page (font size, privacy policy) |
| `src/main/ets/components/MyComment.ets` | My comments page |
| `src/main/ets/components/HistoryRecord.ets` | Browsing history / favorites page |
| `src/main/ets/components/SetFontSize.ets` | Font size adjustment page |
| `src/main/ets/components/PrivacyPolicyPage.ets` | Privacy policy web page |
| `src/main/ets/viewModels/MainPageVM.ets` | View model for mine page (singleton) |
| `src/main/ets/viewModels/QuitLoginDialog.ets` | Logout confirmation dialog |
| `src/main/ets/utils/Util.ets` | Utility: maskPhone function |
| `src/main/ets/utils/SetFontSizeUtil.ets` | Utility: font size text mapping |

---

## 3. The "My" (Mine) Page

### Main Mine Page
**Full Path:** `E:\repo\cases\Scenario Fusion Kit\002\original_project\features\mine\src\main\ets\pages\MinePage.ets`

**Content Summary (450 lines):**
- `MinePage` struct: Main page with `BaseTitle` (title "我的"), `Scroll` containing `UserMsgCard` and `HelpCenter`
- `UserMsgCard` struct: Displays user avatar, name, phone, and account association button
  - Uses `UserInfoModel` and `LoginModel` from AppStorageV2
  - Has `getUserAvatar()` method that checks sandbox paths (`file://`) and uses `fs.accessSync()` to verify file existence
  - When logged in: shows user name and masked phone; when not: shows default avatar and "华为用户"
  - Account association/disassociation logic using Huawei ID authentication
- `HelpCenter` struct: "常用服务" section with CardItems for:
  - 我的收藏 (My Favorites) -> RouterMap.HISTORY_RECORD
  - 我的评论 (My Comments) -> RouterMap.MY_COMMENT
  - 浏览记录 (Browsing History) -> RouterMap.HISTORY_RECORD
  - 设置 (Settings) -> RouterMap.MY_SETTINGS
- `CardItem` struct: Reusable row component with icon, label, and right arrow

### User Info Setting Page
**Full Path:** `E:\repo\cases\Scenario Fusion Kit\002\original_project\features\mine\src\main\ets\components\UserInfoSettingPage.ets`

**Content Summary (149 lines):**
- `UserInfoSettingPage` struct: NavDestination page titled "个人信息"
  - Shows avatar, nickname, phone number in card layout
  - Has `getUserAvatar()` method (same sandbox path logic as MinePage)
  - Avatar section: currently only shows right arrow (no avatar image displayed in the right area)
  - Nickname: editable via GlobalDialog input box
  - Phone: displayed with maskPhone masking
- `UserInfoItem` struct: Reusable row with text label and BuilderParam right content

---

## 4. FunctionalButton / UI Components

**No "FunctionalButton" component exists in the project.**

The closest existing button component is:

### CommonButton
**Full Path:** `E:\repo\cases\Scenario Fusion Kit\002\original_project\commons\componentLib\src\main\ets\components\CommonButton.ets`

**Content (46 lines):**
```typescript
@ComponentV2
export struct CommonButton {
  @Param bgColor: ResourceColor = '#007dff';
  @Param title: string = '';
  @Param subTitle: string = '';
  @Param fullWidth: boolean = true;
  @Event handleClick?: () => void = () => {};

  build() {
    Row() {
      Button(this.title) {
        Column() {
          Text(this.title).fontSize(32).fontWeight(500);
          if (this.subTitle) {
            Text(this.subTitle).fontSize(20).fontColor('#99ffffff');
          }
        };
      }
      .width(this.fullWidth ? '100%' : 'auto')
      .padding({ left: 16, right: 16 })
      .height('88lpx')
      .backgroundColor(this.bgColor)
      .fontColor('#ffffff')
      .onClick(() => { this.handleClick?.(); });
    }
    .padding({ left: 8, right: 8 });
  }
}
```

### Other Shared UI Components in componentLib:
| Component | Path | Description |
|-----------|------|-------------|
| `BaseTitle` | `commons/componentLib/src/main/ets/components/BaseTitle.ets` | Page title bar with optional back button and custom title builder |
| `GlobalDialog` | `commons/componentLib/src/main/ets/components/GlobalDialog.ets` | Global dialog system (loading, text prompt, input box dialogs) |
| `RefreshListView` | `commons/componentLib/src/main/ets/components/RefreshListView.ets` | Pull-to-refresh list view |
| `NewsCard` | `commons/componentLib/src/main/ets/components/NewsCard.ets` | News card component |

### Mine Module Local Components:
| Component | Path | Description |
|-----------|------|-------------|
| `CardItem` | Inside `MinePage.ets` (line 422) | Row with icon + label + right arrow |
| `UserInfoItem` | Inside `UserInfoSettingPage.ets` (line 130) | Row with text label + custom right builder |

---

## 5. User Info / Model Classes with Avatar Information

### UserInfo Interface
**Full Path:** `E:\repo\cases\Scenario Fusion Kit\002\original_project\commons\commonLib\src\main\ets\types\Types.ets`

```typescript
export interface UserInfo {
  id: number;
  avatar: string;        // <-- Avatar field (string, can be URL or sandbox path)
  phoneNumber: string;
  name: string;
  isAssociate: boolean;
}

export interface HuaweiIDResp {
  openId: string;
  unionId: string;
  authCode: string;
}
```

### UserInfoModel Class (implements UserInfo)
**Full Path:** `E:\repo\cases\Scenario Fusion Kit\002\original_project\commons\commonLib\src\main\ets\utils\AccountUtil.ets` (lines 11-18)

```typescript
@ObservedV2
export class UserInfoModel implements UserInfo {
  @Trace id: number = 0;
  @Trace avatar: string = ''       // <-- Avatar stored as string
  @Trace phoneNumber: string = ''
  @Trace name: string = ''
  @Trace isAssociate: boolean = false
}
```

### LoginModel Class
**Full Path:** `E:\repo\cases\Scenario Fusion Kit\002\original_project\commons\commonLib\src\main\ets\utils\AccountUtil.ets` (lines 20-23)

```typescript
@ObservedV2
export class LoginModel {
  @Trace isLogin: boolean = false
}
```

### AccountUtil Class (manages user info)
**Full Path:** `E:\repo\cases\Scenario Fusion Kit\002\original_project\commons\commonLib\src\main\ets\utils\AccountUtil.ets` (lines 25-197)

Key methods:
- `AccountUtil.getUserInfo(): UserInfoModel` - Returns the shared UserInfoModel instance
- `AccountUtil.updateUserInfo(data: UserInfoModel)` - Updates name, phone, id, avatar
- `AccountUtil.silentLogin()` - Silent Huawei ID login
- `AccountUtil.authenticationLogin()` - Full Huawei ID authorization
- `AccountUtil.cancelAuthentication()` - Cancel authorization
- `AccountUtil.associatePhoneNumber(callback)` - Associate phone number

### UserInfoStorage Class (mine module local)
**Full Path:** `E:\repo\cases\Scenario Fusion Kit\002\original_project\features\mine\src\main\ets\viewModels\MainPageVM.ets` (lines 31-38)

```typescript
@ObservedV2
export class UserInfoStorage {
  idToken: string = ''
  authCode: string = ''
  @Trace avatar: string = ''
  @Trace phoneNumber: string = ''
  @Trace userName: string = ''
}
```

### MainPageVM Class (mine module view model)
**Full Path:** `E:\repo\cases\Scenario Fusion Kit\002\original_project\features\mine\src\main\ets\viewModels\MainPageVM.ets` (lines 7-28)

```typescript
@ObservedV2
export class MainPageVM {
  private static _instance: MainPageVM;
  @Trace navStack: NavPathStack = RouterModule.getStack();
  @Trace curIndex: number = 0;
  @Trace userInfo: UserInfoModel = AccountUtil.getUserInfo();
  @Trace loginInfo: LoginModel = AppStorageV2.connect(LoginModel, () => new LoginModel())!
  @Trace changeFontSize: number = 0;
  @Trace fontSizeText: string = '标准';
  @Trace comment: string = '真是一个好消息～哈哈哈～';

  public static get instance() { ... }
  public async init() { }
}
```

---

## 6. Sandbox / File Utility Classes

**No dedicated sandbox or file utility class exists in the project.**

Sandbox/file path handling is done **inline** in two places using the `@ohos.file.fs` module directly:

### In MinePage.ets (lines 102-115):
```typescript
getUserAvatar(): ResourceStr {
  if (this.userInfo.avatar) {
    // 判断是否是沙箱路径
    if (this.userInfo.avatar.startsWith('file://')) {
      let sandboxPath = this.userInfo.avatar.split('file://')[1]
      // 判断沙箱路径的图片是否存在，不存在，则使用默认头像
      if (!fs.accessSync(sandboxPath)) {
        return $r('app.media.ic_default_hd')
      }
    }
    return this.userInfo.avatar || $r('app.media.ic_default_hd')
  }
  return $r('app.media.ic_default_hd')
}
```

### In UserInfoSettingPage.ets (lines 20-33):
```typescript
getUserAvatar(): ResourceStr {
  if (this.userInfo.avatar) {
    // 判断是否是沙箱路径
    if (this.userInfo.avatar.startsWith('file://')) {
      let sandboxPath = this.userInfo.avatar.split('file://')[1]
      // 判断沙箱路径的图片是否存在，不存在，则使用默认头像
      if (!fs.accessSync(sandboxPath)) {
        return $r('app.media.ic_default_hd')
      }
    }
    return this.userInfo.avatar || $r('app.media.ic_default_hd')
  }
  return $r('app.media.ic_default_hd')
}
```

**Note:** The same `getUserAvatar()` logic is duplicated in both files. There is no centralized utility for this.

### Other Utility Files in the Project:
| File | Path | Description |
|------|------|-------------|
| `Util.ets` | `features/mine/src/main/ets/utils/Util.ets` | `maskPhone()` - phone number masking |
| `SetFontSizeUtil.ets` | `features/mine/src/main/ets/utils/SetFontSizeUtil.ets` | Font size text mapping |
| `FormatUtil.ets` | `commons/commonLib/src/main/ets/utils/FormatUtil.ets` | Date formatting, mock image resource formatting |
| `AccountUtil.ets` | `commons/commonLib/src/main/ets/utils/AccountUtil.ets` | Account management (UserInfoModel, LoginModel, auth) |
| `PreferencesUtil.ets` | `commons/commonLib/src/main/ets/database/PreferencesUtil.ets` | Font size preferences storage |
| `Logger.ets` | `commons/commonLib/src/main/ets/utils/Logger.ets` | Logging utility |
| `RouterModule.ets` | `commons/commonLib/src/main/ets/utils/RouterModule.ets` | Navigation/routing utility |
| `PermissionUtil.ets` | `commons/commonLib/src/main/ets/utils/PermissionUtil.ets` | Permission management |
| `GlobalContext.ets` | `commons/commonLib/src/main/ets/utils/GlobalContext.ets` | Global context storage |
| `Utils.ets` | `commons/network/src/main/ets/utils/Utils.ets` | Network utilities |

---

## Key Observations

1. **No FunctionalButton component exists** - The project only has `CommonButton` (a full-width styled button) and `CardItem` (a row with icon/label/arrow). There is no generic "functional button" component.

2. **No dedicated sandbox/file utility class** - Sandbox path checking (`file://` prefix detection + `fs.accessSync()`) is duplicated inline in both `MinePage.ets` and `UserInfoSettingPage.ets`.

3. **Avatar handling is incomplete** - The `UserInfoSettingPage` has an `AvatarRightView` builder that only shows a right arrow icon but does NOT display the actual avatar image. The `MinePage` `UserMsgCard` also does not display the avatar when logged in (the `if (this.loginInfo.isLogin)` block at line 120 is empty).

4. **UserInfoModel.avatar** is a string field that can hold a URL or a sandbox file path (prefixed with `file://`). The default avatar resource is `$r('app.media.ic_default_hd')`.

5. **Router configuration** is in `CommonEnums.ets` with `RouterMap` enum defining all route names including `USER_INFO_SETTING = 'UserInfoSettingPage'`.

6. **The mine tab** is the third tab (index 2) in the main `Tabs` component in `MainEntry.ets`, labeled "我的" with icons `ic_mine` / `ic_mine_checked`.
