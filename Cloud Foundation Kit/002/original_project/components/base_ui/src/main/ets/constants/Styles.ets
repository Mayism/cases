import { ColumnModifier, RowModifier } from '@kit.ArkUI';

class BindSheetModifier implements AttributeModifier<RowModifier | ColumnModifier> {
  public applyNormalAttribute(instance: CommonAttribute): void {
    instance
      .width($r('app.string.full_size'))
      .borderRadius(12)
      .margin({ left: 16, right: 16, bottom: 16 })
      .backgroundColor($r('sys.color.background_primary'))
      .constraintSize({ maxWidth: $r('app.string.full_size') })
  }
}

export const BIND_SHEET_STYLE: BindSheetModifier = new BindSheetModifier();