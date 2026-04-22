import { Constants, CONTAINER_STYLE } from 'common';
import { BookVM } from '../../viewmodels/BookVM';

@ComponentV2
export struct BookOrderInfoCom {
  vm: BookVM = BookVM.instance;

  build() {
    Column(){
      Text('基本信息').titleTextStyle()
      Column({ space: 12 }) {
        Column() {
            Row() {
              SymbolGlyph($r('sys.symbol.person_fill')).fontSize(24).fontColor([$r('sys.color.icon_secondary'),'#000000'])
              Text('订座人').descTextStyle()
              TextInput({ text: $$this.vm.name, placeholder: '请输入您的姓名' })
                .maxLength(10)
                .textInputStyle()
                .type(InputType.USER_NAME)
          }
          Divider().margin({ left: 40,top:12,bottom:12 })
            Row() {
              SymbolGlyph($r('sys.symbol.phone_fill')).fontSize(24).fontColor([$r('sys.color.icon_secondary'),'#000000'])
              Text('联系方式').descTextStyle()
              TextInput({ text: $$this.vm.phone, placeholder: '请输入您的联系方式' })
                .textInputStyle()
                .type(InputType.PhoneNumber)
            }
        }
      }
      .attributeModifier(CONTAINER_STYLE)
    }

  }
}

@Extend(Text)
function titleTextStyle() {
  .fontSize($r('sys.float.Subtitle_L'))
  .fontColor($r('sys.color.font_primary'))
  .fontWeight(FontWeight.Bold)
  .width(Constants.FULL_SIZE)
  .padding({top:12,bottom:8})
}

@Extend(Text)
function descTextStyle() {
  .fontSize($r('sys.float.Subtitle_M'))
  .fontColor($r('sys.color.font_primary'))
  .fontWeight(FontWeight.Medium)
  .margin({ left: $r('app.string.margin_16') })
}

@Extend(TextInput)
function textInputStyle() {
  .padding({
    left: 0,
    right: 14,
    top: 0,
    bottom: 0,
  })
  .layoutWeight(1)
  .textAlign(TextAlign.End)
  .backgroundColor(Color.Transparent)
  .placeholderColor($r('sys.color.font_secondary'))
  .placeholderFont({
    weight: FontWeight.Regular,
    size: $r('sys.float.Body_L'),
  })
  .fontWeight(FontWeight.Regular)
  .fontColor($r('sys.color.font_primary'))
  .fontSize($r('sys.float.Body_L'))
}
