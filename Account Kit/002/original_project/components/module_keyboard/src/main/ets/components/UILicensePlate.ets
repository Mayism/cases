import { CustomKeyItem } from './IndexType';
import { window } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { getWindowWidth } from './Utils';
import { Logger, UIBase } from '@hw-agconnect/ui-base';
import { DEFAULT_MAX_DESIGN_WIDTH, HALF_HEIGHT } from './Constant';

const TAG = '[UILicensePlate]';

@ComponentV2
export struct UILicensePlate {
  @Param intFocus: boolean = false;
  @Param plateNumber: string = '';
  @Param controller: TextInputController = new TextInputController();
  @Event onChange: (carNumber: string[], isComplete: boolean) => void = () => {
  };
  @Event onFormatError: (plateNumber: string) => void = () => {
  };
  @Local inputValue: string[] = new Array(8).fill('');
  @Local focusMark: boolean[] = new Array(8).fill(false);
  @Local keyBordTotal: CustomKeyItem[][] = [[], [], [], []];
  @Local inputIndex: number = 0;
  // 初始默认为360vp
  @Local windowWidth: number = 360;
  // 输入框宽度
  @Local inputWidth: number = 0;
  // 输入框高度
  @Local inputHeight: number = 0;
  // 按键宽度
  @Local keyWidth: number = 0;
  // 按键高度
  @Local keyHeight: number = 0;
  // 底部导航条高度 默认28
  @Local avoidAreaHeight: number = 28;
  // 是否输入了文本
  @Local isInput: boolean = false;
  // 标志是视窗宽度是否过宽
  @Local isLargeWidth: boolean = false;
  // 标志是视窗高度是否过小
  @Local isSmallHeight: boolean = false;
  provincesKeyBoard: string[][] =
    [['京', '津', '沪', '渝', '冀', '豫', '云', '辽', '黑'], ['湘', '皖', '鲁', '新', '苏', '浙', '赣', '鄂', '桂'],
      ['甘', '晋', '蒙', '陕', '吉', '闽', '贵', '粤', '青'], ['藏', '川', '宁', '琼', '删']];
  commonKeys: string[][] =
    [['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'], ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'O', 'P', '港'],
      ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L', '澳'], ['Z', 'X', 'C', 'V', 'B', 'N', 'M', '学', '警', '删']];
  layoutOptions: GridLayoutOptions = {
    regularSize: [1, 1],
    irregularIndexes: [34], //  索引为34的GridItem占用的列数由onGetIrregularSizeByIndex指定
    onGetIrregularSizeByIndex: (index: number) => {
      return [1, 2];
    },
  };
  // 车牌号每位所能取的值
  validateRules: string[][] = new Array(8).fill([]);
  // 禁用的按键
  forbiddenArr1: string[] = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '港', '澳', '学', '警'];
  forbiddenArr2: string[] = ['O', '港', '澳', '学', '警'];
  forbiddenArr3: string[] = ['O'];

  // 监听8个输入框对应的值的变化
  @Monitor('inputValue.0','inputValue.1','inputValue.2','inputValue.3','inputValue.4','inputValue.5','inputValue.6','inputValue.7')
  onInputValueChange(monitor: IMonitor) {
    let isComplete = true;
    this.inputValue.forEach((item: string, index) => {
      if (!item && index !== 7) {
        isComplete = false;
      }
    });
    if (isComplete) {
      // 选择完成时，将车牌号传递出去
      const bak = [...this.inputValue];
      // 如果不是新能源,去除占位的空字符串
      if (!bak[bak.length - 1]) {
        bak.pop();
      }
      this.onChange(bak, isComplete);
    } else {
      // 输入未完成时返回中间态的车牌号
      this.onChange(this.inputValue, isComplete);
    }
    // 判断是否输入了文本
    this.isInput = this.inputValue.some(item => item !== '');
  }

  @Monitor('plateNumber')
  onPlateNumberChange(monitor: IMonitor) {
    this.handlePlateNumber();
  }

  handlePlateNumber(): void {
    const plateNumberArr = this.plateNumber.split('');
    // 校验车牌长度
    if (plateNumberArr.length !== 7 && plateNumberArr.length !== 8) {
      this.onFormatError(this.plateNumber);
      return;
    }
    //  校验格式
    let isCorrect = true;
    plateNumberArr.forEach((item, index) => {
      if (!this.validateRules[index].includes(item)) {
        isCorrect = false;
      }
    });
    if (isCorrect) {
      if (plateNumberArr.length === 7) {
        //  增加占位符
        plateNumberArr[7] = '';
      }
      this.inputValue = plateNumberArr;
      this.handleInputFocus(plateNumberArr.length - 1);
    } else {
      this.onFormatError(this.plateNumber);
    }
  }

  // 处理校验数组
  handleValidateRules(): void {
    const commonKeysBak = this.commonKeys.flat(1).filter((val) => val !== '删');
    this.validateRules = this.validateRules.map((item: string[], index) => {
      if (index === 0) {
        item = this.provincesKeyBoard.flat(1).filter((val) => val !== '删');
      } else if (index === 1) {
        item = commonKeysBak.filter((val) => !this.forbiddenArr1.includes(val));
      } else if (index === 6) {
        item = commonKeysBak.filter((val) => !this.forbiddenArr3.includes(val));
      } else {
        item = commonKeysBak.filter((val) => !this.forbiddenArr2.includes(val));
      }
      return item;
    });
  }

  // 初始化输入框宽高及避让区域尺寸
  intSize(): void {
    // 获取当前窗口的宽度
    if (getWindowWidth(this.getUIContext())) {
      this.windowWidth = getWindowWidth(this.getUIContext());
    }
    // 根据窗口宽度计算输入框宽高
    if (this.windowWidth <= DEFAULT_MAX_DESIGN_WIDTH) {
      this.inputWidth = (this.windowWidth - 40 - 6) / 8;
    } else {
      this.inputWidth = (DEFAULT_MAX_DESIGN_WIDTH - 40 - 6) / 8;
    }
    this.inputHeight = this.inputWidth * 1.3;
    window.getLastWindow(this.getUIContext().getHostContext()).then((data) => {
      try {
        // 获取导航条区域
        const avoidArea = data.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR);
        // 获取到导航条区域的高度
        const indicatorHeight = avoidArea.bottomRect.height;
        this.avoidAreaHeight = this.getUIContext().px2vp(indicatorHeight);
      } catch (e) {
        Logger.error(TAG, `getWindowAvoidArea fail. Code: ${e.code}, message: ${e.message}`);
      }
    }).catch((err: BusinessError) => {
      Logger.error(TAG, `Failed to obtain the window. Cause: ${JSON.stringify(err)}`);
    });
  }

  aboutToAppear(): void {
    // 初始化拉起键盘，选中第一输入框
    if (this.intFocus) {
      this.focusMark[0] = true;
    }
    // 初始化判断视窗状态
    this.handleView();
    // 开启窗口监控
    UIBase.onWindowSizeChange(this.handleView);
    // 处理车牌号校验规则
    this.handleValidateRules();
    // 处理传入车牌号
    this.handlePlateNumber();
  }

  aboutToDisappear(): void {
    UIBase.offWindowSizeChange(this.handleView);
  }

  // 改变输入框的选中状态
  handleInputFocus(index: number) {
    this.focusMark.fill(false);
    this.focusMark[index] = true;
  }

  // 更新输入框和自定义键盘
  updateView() {
    this.handleInputFocus(this.inputIndex);
    this.intDisableKey(this.inputIndex);
  }

  // 自定义键盘组件
  @Builder
  CustomKeyboardBuilder() {
    Column() {
      Row() {
        Text(this.isInput ? $r('app.string.keyBord_complete') : $r('app.string.keyBord_collapse'))
          .fontSize($r('sys.float.ohos_id_text_size_headline9'))
          .fontFamily($r('sys.string.ohos_id_text_font_family_regular'))
          .fontColor($r('sys.color.ohos_id_color_text_primary'));
      }
      .height(this.isSmallHeight ? 26 : 38)
      .width('100%')
      .justifyContent(FlexAlign.End)
      .padding({
        right: 3,
        left: 3,
      })
      .margin({
        bottom: 5,
      })
      .onClick(() => {
        // 退出编辑收起键盘
        this.controller.stopEditing();
      });

      if (this.inputIndex === 0) {
        // 省份输入键盘
        this.provinceKeyBoardBuilder();
      }
      // 根据不同的输入框，切换不同的键盘
      ForEach([1, 2, 3, 4, 5, 6, 7], (num: number) => {
        if (this.inputIndex === num) {
          this.commKeyBordBuilder();
        }
      }, (v: number) => v.toString());


    }.backgroundColor($r('app.color.keyBord_background')).padding({ bottom: this.avoidAreaHeight });
  }

  // 通用键盘
  @Builder
  commKeyBordBuilder() {
    Grid() {
      ForEach(this.keyBordTotal, (v: CustomKeyItem[]) => {
        ForEach(v, (item: CustomKeyItem) => {
          GridItem() {
            if (item.key === '删') {
              Row() {
                Image($r('app.media.ic_delete')).width(24).fillColor($r('sys.color.ohos_id_color_primary'));
              }
              .width('100%')
              .justifyContent(FlexAlign.Center)
              .height(this.isSmallHeight ? 30 : 46)
              .onClick(() => {
                // 判断当前输入框是否有值
                if (this.inputValue[this.inputIndex]) {
                  this.inputValue[this.inputIndex] = '';
                } else {
                  this.inputIndex--;
                  this.inputValue[this.inputIndex] = '';
                }
                this.updateView();
              });
            } else {
              Text(item.key)
                .fontFamily($r('sys.string.ohos_id_text_font_family_regular'))
                .textAlign(TextAlign.Center)
                .height(this.isSmallHeight ? 30 : 46)
                .width('100%')
                .opacity(item.disable ? $r('sys.float.ohos_id_alpha_disabled') : 1)
                .fontSize($r('sys.float.ohos_id_text_size_headline9'))
                .fontColor($r('sys.color.ohos_id_color_text_primary'))
                .onClick(() => {
                  if (!item.disable) {
                    this.inputValue[this.inputIndex] = item.key;
                    if (this.inputIndex <= 6) {
                      this.inputIndex++;
                    }
                    this.updateView();
                  }

                });
            }
          }
          .backgroundColor(item.key === '删' ? $r('app.color.del_background') : $r('app.color.key_background'))
          .borderRadius(6)
          .shadow({
            radius: this.getUIContext().vp2px(0.6),
            color: $r('app.color.key_shadow'),
            offsetY: this.getUIContext().vp2px(1.2),
          });

        }, (item: CustomKeyItem, index: number) => {
          return item.key + index;
        });
      }, (v: CustomKeyItem, i) => i.toString());
    }
    .width(this.isLargeWidth ? '80%' : '100%')
    .maxCount(10)
    .columnsGap(2)
    .rowsGap(5)
    .padding({ bottom: 5, left: 3, right: 3 })
    .columnsTemplate('1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr');

  }

  // 省份输入键盘
  @Builder
  provinceKeyBoardBuilder() {
    Grid(undefined, this.layoutOptions) {
      ForEach(this.provincesKeyBoard, (v: string[]) => {
        ForEach(v, (item: string) => {
          if (item === '删') {
            // 无实际功能布局占位
            ForEach([1, 2, 3], (val: number) => {
              GridItem() {
              };
            }, (val: number) => val.toString());
            GridItem() {
              Row() {
                Image($r('app.media.ic_delete')).width(24).fillColor($r('sys.color.ohos_id_color_primary'));
              }
              .width('100%')
              .justifyContent(FlexAlign.Center)
              .height(this.isSmallHeight ? 30 : 46)
              .backgroundColor($r('app.color.del_background'))
              .shadow({
                radius: this.getUIContext().vp2px(0.6),
                color: $r('app.color.key_shadow'),
                offsetY: this.getUIContext().vp2px(1.2),
              })
              .borderRadius(6)
              .onClick(() => {
                this.inputValue[0] = '';
              });
            };
          } else {
            GridItem() {
              Text(item)
                .width('100%')
                .fontSize($r('sys.float.ohos_id_text_size_headline9'))
                .fontFamily($r('sys.string.ohos_id_text_font_family_regular'))
                .fontColor($r('sys.color.ohos_id_color_text_primary'))
                .textAlign(TextAlign.Center)
                .height(this.isSmallHeight ? 30 : 46)
                .backgroundColor($r('app.color.key_background'))
                .shadow({
                  radius: this.getUIContext().vp2px(0.6),
                  color: $r('app.color.key_shadow'),
                  offsetY: this.getUIContext().vp2px(1.2),
                })
                .borderRadius(6)
                .onClick(() => {
                  this.inputValue[0] = item;
                  this.inputIndex = 1;
                  this.updateView();
                });
            };
          }

        }, (item: string, index: number) => {
          return item + index;
        });
      }, (v: string[], i) => i.toString());
    }
    .width(this.isLargeWidth ? '80%' : '100%')
    .maxCount(9)
    .columnsGap(3)
    .rowsGap(5)
    .padding({ bottom: 5, left: 3, right: 3 })
    .columnsTemplate('1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr');

  }

  build() {
    Row() {
      TextInput({ controller: this.controller })
        .width(0)
        .customKeyboard(this.CustomKeyboardBuilder(), { supportAvoidance: true })
        .height(0)
        .padding(0)
        .id('customKeyboardInput')
        .defaultFocus(this.intFocus);
      Row() {
        ForEach(this.inputValue, (item: string, index) => {
          if (index === 2) {
            Row()
              .width(6)
              .height(6)
              .backgroundColor($r('sys.color.ohos_id_color_text_primary'))
              .borderRadius(3)
              .margin({ right: 4 });
          }
          // 第8个输入框没输入就默认显示新能源
          if (index === 7) {
            Row() {
              Text(item ? item : $r('app.string.new_energy'))
                .fontColor(item ? $r('sys.color.ohos_id_color_connected') : $r('sys.color.ohos_id_color_palette4'))
                .fontSize(item ? $r('sys.float.ohos_id_text_size_headline8') :
                  $r('sys.float.ohos_id_text_size_caption'))
                .fontFamily($r('sys.string.ohos_id_text_font_family_regular'))
                .width('100%')
                .height('100%')
                .padding(this.focusMark[index] ? { top: 2 } : '')// 防止文字因边框被抬升
                .textAlign(TextAlign.Center)
                .border({
                  width: { bottom: this.focusMark[index] ? 2 : 0 },
                  color: $r('sys.color.ohos_id_color_connected'),
                });
            }
            .width(this.inputWidth)
            .height(this.inputHeight)
            .backgroundColor($r('app.color.new_energy_background'))
            .justifyContent(FlexAlign.Center)
            .padding({
              right: 4,
              left: 4,
              top: 5,
              bottom: 5,
            })
            .borderRadius(6)
            .onClick(() => {
              this.inputIndex = index;
              this.updateView();
              focusControl.requestFocus('customKeyboardInput');
            });
          } else {
            Row() {
              Text(item)
                .fontColor(this.focusMark[index] ? $r('sys.color.ohos_id_color_text_primary_activated') :
                  $r('sys.color.ohos_id_color_text_primary'))
                .fontSize($r('sys.float.ohos_id_text_size_headline8'))
                .fontFamily(this.focusMark[index] ? $r('sys.string.ohos_id_text_font_family_medium') : '')
                .width('100%')
                .height('100%')
                .fontWeight(this.focusMark[index] ? FontWeight.Medium : FontWeight.Normal)
                .padding(this.focusMark[index] ? { top: 2 } : '')
                .textAlign(TextAlign.Center)
                .border({
                  width: { bottom: this.focusMark[index] ? 2 : 0 },
                  color: $r('sys.color.ohos_id_color_emphasize'),
                });
            }
            .width(this.inputWidth)
            .height(this.inputHeight)
            .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
            .margin({ right: 4 })
            .justifyContent(FlexAlign.Center)
            .padding({
              left: 4,
              right: 4,
              top: 5,
              bottom: 5,
            })
            .borderRadius(6)
            .onClick(() => {
              this.inputIndex = index;
              this.updateView();
              focusControl.requestFocus('customKeyboardInput');
            });
          }
        }, (v: string) => v);
      }.padding({ left: 4, right: 4 });
    };
  }

  //判断目前窗口的宽高,进行适配
  private handleView: () => void = () => {
    const windowWidth = this.getUIContext().px2vp(UIBase.getWindowProperties()?.windowRect?.width);
    const windowHeight = this.getUIContext().px2vp(UIBase.getWindowProperties()?.windowRect?.height);
    if (windowWidth > DEFAULT_MAX_DESIGN_WIDTH) {
      this.isLargeWidth = true;
    } else {
      this.isLargeWidth = false;
    }
    if (windowHeight < HALF_HEIGHT) {
      this.isSmallHeight = true;
    } else {
      this.isSmallHeight = false;
    }
    this.intSize();
  };

  // 初始化每个输入框对应的禁用按键
  private intDisableKey(inputIndex: number) {
    switch (inputIndex) {
      case 1:
        this.setForbiddenKey(this.forbiddenArr1);
        break;
      case 2:
      case 3:
      case 4:
      case 5:
      case 7:
        this.setForbiddenKey(this.forbiddenArr2);
        break;
      case 6:
        this.setForbiddenKey(this.forbiddenArr3);
        break;
      default:
        break;
    }
  }

  // 设置按键禁用
  private setForbiddenKey(forbiddenKeys: string[]) {
    this.commonKeys.forEach((item, i) => {
      item.forEach((v, j) => {
        if (forbiddenKeys.includes(v)) {
          this.keyBordTotal[i][j] = new CustomKeyItem(v, true);
        } else {
          this.keyBordTotal[i][j] = new CustomKeyItem(v, false);
        }
      });
    });
  }
}



