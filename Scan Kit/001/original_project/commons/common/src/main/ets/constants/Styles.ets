import { ColumnModifier, ListItemModifier, ListModifier, RowModifier } from '@kit.ArkUI';
import { Constants } from './Common';

class ContainerModifier implements AttributeModifier<RowModifier | ColumnModifier | ListModifier | ListItemModifier> {
  public applyNormalAttribute(instance: CommonAttribute): void {
    instance
      .width(Constants.FULL_SIZE)
      .padding($r('app.string.padding_12'))
      .borderRadius($r('app.string.border_radius_16'))
      .backgroundColor($r('app.color.system_color_background_white'))
  }
}

export const CONTAINER_STYLE: ContainerModifier = new ContainerModifier();