import { AppStorageV2 } from '@kit.ArkUI';
import { Constants } from '../constants/Common';
import { UserInfoModel } from '../models/StorageModel';
import { LoginButtonText } from './LoginComp';

@ComponentV2
export struct PageHeaderComp {
  @Local userInfo: UserInfoModel = AppStorageV2.connect(UserInfoModel, () => new UserInfoModel())!;
  @BuilderParam rightBtnBuilder: () => void;

  build() {
    Row() {
      Row() {
        Image(this.userInfo.isRelative ? $r('app.media.ic_public_add_member') : $r('app.media.default_hd'))
          .width(48)
          .height(48)
        Column() {
          Text('Hi,').fontSize(14).fontColor($r('sys.color.font_primary'))
          if (this.userInfo.isRelative) {
            Text(this.userInfo.userInfo.userTel)
              .fontSize(14)
              .fontColor($r('sys.color.font_primary'))
          } else {
            LoginButtonText({
              label: '暂未绑定'
            })
          }
        }
        .alignItems(HorizontalAlign.Start)
        .height(48)
        .padding({ left: 10, top: 4, bottom: 4 })
        .justifyContent(FlexAlign.SpaceBetween)
      }

      if (this.rightBtnBuilder) {
        this.rightBtnBuilder()
      }
    }
    .alignItems(VerticalAlign.Bottom)
    .justifyContent(FlexAlign.SpaceBetween)
    .width(Constants.FULL_SIZE)
    .constraintSize({ maxWidth: Constants.FULL_SIZE })
  }
}