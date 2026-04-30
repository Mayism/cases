import { UIBase } from '@hw-agconnect/ui-base';

export const getWindowWidth = (uiContext: UIContext):number=> {
  let windowWidth = UIBase.getWindowProperties()?.windowRect.width
  return uiContext.px2vp(windowWidth)
}