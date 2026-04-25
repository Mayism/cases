import { AppStorageV2 } from '@kit.ArkUI';
import { Constants, UserInfoModel, NavHeaderBar, PageHeaderComp, ContextUtils } from 'lib_common';
import { GlobalPointUtils } from 'module_points';

@Builder
export function MemberShipPageBuilder() {
  MemberShipPage()
}

@ComponentV2
struct MemberShipPage {
  @Local userInfo: UserInfoModel = AppStorageV2.connect(UserInfoModel, () => new UserInfoModel())!;
  @Local globalPointInfo: GlobalPointUtils = AppStorageV2.connect(GlobalPointUtils, () => new GlobalPointUtils())!;
  @Local qrcodeUrl: string = this.userInfo.userInfo.id + new Date().getTime()
  @Local count: number = 20
  @Local timer: number = 0
  @Local angle: number = 0;

  build() {
    NavDestination() {
      Stack() {
        Image($r('app.media.main_bg')).width('100%')
        Column() {
          NavHeaderBar({ title: '会员一码通', hasBgColor: false })
          Column() {
            PageHeaderComp({
              rightBtnBuilder: () => {
                this.rightBtnBuilder()
              }
            }).margin({ top: 16, left: 8 })
            Stack() {
              QRCode(this.qrcodeUrl).width(206).height(206)
              Row() {
                Image($r('app.media.ic_logo')).width(56)
              }
            }
            .width(240)
            .height(240)
            .margin({ top: 32 })
            .backgroundColor($r('sys.color.background_primary'))
            .borderRadius(12)
            .shadow({
              radius: 21,
              color: '#bdbcbec8',
              offsetX: 0,
              offsetY: 11,
            })

            Column() {
              Text('会员识别/积分/电子钱包支付').fontSize(12).fontColor($r('sys.color.font_secondary'))
              Text('二维码每5分钟自动刷新').fontSize(10).fontColor($r('sys.color.font_tertiary')).margin({ top: 8 })
            }.margin({ top: 32 })

            Row() {
              Image($r('app.media.ic_refresh')).width(18).rotate({ angle: this.angle })
              Text('刷新')
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .fontColor($r('app.color.app_theme'))
                .margin({ left: 8 })
            }
            .margin({ top: 32 })
            .borderRadius(20)
            .padding({
              left: 16,
              right: 16,
              top: 8,
              bottom: 8,
            })
            .backgroundColor($r('sys.color.comp_background_tertiary'))
            .onClick(() => {
              this.refreshTime()
            })
          }.padding({ left: Constants.BORDER_WIDTH, right: Constants.BORDER_WIDTH })
        }
      }
      .alignContent(Alignment.Top)
    }
    .hideTitleBar(true)
    .onShown(() => {
      this.refreshTime()
    })
    .onHidden(() => {
      clearInterval(this.timer)
    })
  }

  @Builder
  rightBtnBuilder() {
    Button(this.globalPointInfo.isCheckIn ? '已签到' : '签到', { controlSize: ControlSize.SMALL })
      .fontSize($r('sys.float.Body_M'))
      .fontColor($r('sys.color.font_on_primary'))
      .width(72)
      .backgroundColor($r('app.color.app_theme'))
      .padding({
        top: 4,
        bottom: 4,
        left: 8,
        right: 8,
      })
      .enabled(!this.globalPointInfo.isCheckIn)
      .onClick(() => {
        this.globalPointInfo.isCheckIn = true;
        this.globalPointInfo.myPoints += 10;
        ContextUtils.showToast({ message: '签到成功~' });
      })
  }

  rotateRefreshIcon() {
    this.getUIContext().animateTo({
      curve: Curve.EaseInOut,
      duration: 200,
    }, () => {
      this.angle += 360;
    })
  }

  refreshTime() {
    this.rotateRefreshIcon();
    clearInterval(this.timer)
    this.qrcodeUrl = this.userInfo.userInfo.id + new Date().getTime()
    this.count = 300
    this.timer = setInterval(() => {
      if (this.count <= 0) {
        clearInterval(this.timer)
        return
      }
      this.count--
    }, 1000)

  }
}