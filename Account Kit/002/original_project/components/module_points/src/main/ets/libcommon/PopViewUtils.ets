/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import { ComponentContent, promptAction } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { ContextUtils } from './ContextUtils';
import { Logger } from './Utils';

export enum PopViewShowType {
  OPEN
}

interface PopViewModel {
  com: ComponentContent<object>;
  popType: PopViewShowType;
}

const TAG = '[PointsPopViewUtils]';

export class PopViewUtils {
  private static popShare: PopViewUtils;
  static uiContext: UIContext;
  private infoList: PopViewModel[] = [];

  static shareInstance(): PopViewUtils {
    if (!PopViewUtils.popShare) {
      PopViewUtils.popShare = new PopViewUtils();
    }
    return PopViewUtils.popShare;
  }

  static async showDialog<T extends object>(type: PopViewShowType,
    contentView: WrappedBuilder<[T]> | WrappedBuilder<[]>, args?: T,
    options?: promptAction.BaseDialogOptions): Promise<void> {
    if (!PopViewUtils.uiContext) {
      PopViewUtils.uiContext = ContextUtils.globalUIContext;
    }
    if (PopViewUtils.uiContext) {
      let prompt = PopViewUtils.uiContext.getPromptAction();
      let componentContent: ComponentContent<Object> | null = null;
      if (args) {
        componentContent = new ComponentContent(PopViewUtils.uiContext, contentView, args);
      } else {
        componentContent = new ComponentContent(PopViewUtils.uiContext, contentView as WrappedBuilder<[]>);
      }

      let customOptions: promptAction.BaseDialogOptions = {
        alignment: options?.alignment ?? DialogAlignment.Center,
        autoCancel: options?.autoCancel ?? true,
        onWillDismiss: (v: DismissDialogAction) => {
          if (options?.autoCancel ?? true) {
            v.dismiss();
          }
        },
      };
      prompt.openCustomDialog(componentContent, customOptions).then(() => {
        if (componentContent) {
          let infoList = PopViewUtils.shareInstance().infoList;
          let info: PopViewModel = {
            com: componentContent,
            popType: type,
          };
          infoList[0] = info;
        }
      }).catch((e: BusinessError) => {
        Logger.error(TAG, `openCustomDialog fail. Code: ${e.code}, message: ${e.message}`);
      });
    }
  }

  static async closeDialog(type: PopViewShowType): Promise<void> {
    if (!PopViewUtils.uiContext) {
      PopViewUtils.uiContext = ContextUtils.globalUIContext;
    }
    if (PopViewUtils.uiContext) {
      let prompt = PopViewUtils.uiContext.getPromptAction();
      let sameTypeList = PopViewUtils.shareInstance().infoList.filter((model) => {
        return model.popType === type;
      })
      let info = sameTypeList[sameTypeList.length - 1];
      if (info?.com) {
        PopViewUtils.shareInstance().infoList = PopViewUtils.shareInstance().infoList.filter((model) => {
          return model.com !== info.com;
        })
        prompt.closeCustomDialog(info.com).catch((e: BusinessError) => {
          Logger.error(TAG, `closeCustomDialog fail. Code: ${e.code}, message: ${e.message}`);
        });
      }
    }
  }

  static showPopView<T extends object>(contentView: WrappedBuilder<[T]> | WrappedBuilder<[]>, args?: T,
    options?: promptAction.BaseDialogOptions): void {
    PopViewUtils.showDialog(PopViewShowType.OPEN, contentView, args, options);
  }

  static closePopView(): void {
    PopViewUtils.closeDialog(PopViewShowType.OPEN);
  }
}
