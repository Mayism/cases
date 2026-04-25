# 车牌输入键盘组件快速入门

## 目录

- [简介](#简介)
- [约束与限制](#约束与限制)
- [快速入门](#快速入门)
- [API参考](#API参考)
- [示例代码](#示例代码)

## 简介

本组件支持国内通用车牌号的输入。

| 输入省份                                             | 输入字母数字+特殊字                                       |
|--------------------------------------------------|--------------------------------------------------|
| <img src="./screenshots/车牌号输入1.jpg" width="300"> | <img src="./screenshots/车牌号输入2.jpg" width="300"> |

## 约束与限制

### 环境

* DevEco Studio版本：DevEco Studio 5.0.0 Release及以上
* HarmonyOS SDK版本：HarmonyOS 5.0.0 Release SDK及以上
* 设备类型：华为手机（包括双折叠和阔折叠）
* 系统版本：HarmonyOS 5.0.0(12)及以上

## 快速入门

1. 安装组件。

   如果是在DevEco Studio使用插件集成组件，则无需安装组件，请忽略此步骤。

   如果是从生态市场下载组件，请参考以下步骤安装组件。

   a. 解压下载的组件包，将包中所有文件夹拷贝至您工程根目录的XXX目录下。

   b. 在项目根目录build-profile.json5添加module_keyboard模块。

   ```
   // 项目根目录下build-profile.json5填写module_keyboard路径。其中XXX为组件存放的目录名
   "modules": [
     {
       "name": "module_keyboard",
       "srcPath": "./XXX/module_keyboard"
     }
   ]
   ```

   c. 在项目根目录oh-package.json5添加依赖。
   ```
   // XXX为组件存放的目录名称
   "dependencies": {
     "module_keyboard": "file:./XXX/module_keyboard"
   }
   ```

2. 引入组件。

    ```
    import { UILicensePlate } from 'module_keyboard';
    ```

3. 调用组件，详细参数配置说明参见[API参考](#API参考)。

## API参考

### 接口

UILicensePlate(options?: [UILicensePlateOptions](#UILicensePlateOptions对象说明))

车牌输入键盘组件

**参数：**

| 参数名     | 类型                                                  | 是否必填 | 说明             |
|:--------|:----------------------------------------------------|:-----|:---------------|
| options | [UILicensePlateOptions](#UILicensePlateOptions对象说明) | 否    | 配置车牌输入键盘组件的参数。 |

### UILicensePlateOptions对象说明

| 参数            | 类型                                                                                                                                          | 是否必填 | 说明                                                   |
|:--------------|:--------------------------------------------------------------------------------------------------------------------------------------------|:-----|:-----------------------------------------------------|
| intFocus      | boolean                                                                                                                                     | 否    | 默认值为false，初始化是否为输入框聚焦状态                              |
| plateNumber   | string                                                                                                                                      | 否    | 默认值为''，传入的车牌号，当该车牌号格式不合法时，不回显该车牌号。                   |
| controller    | [TextInputController](https://developer.huawei.com/consumer/cn/doc/harmonyos-references/ts-basic-components-textinput#textinputcontroller8) | 否    | 设置TextInput控制器，可控制键盘收起。                              |
| onChange      | (carNumber:string[], isComplete:boolean) => void                                                                                            | 否    | 输入车牌号发生变化时触发，carNumber为输入车牌号，isComplete标志当前车牌号是否输入完成 |
| onFormatError | (plateNumber: string) => void                                                                                                               | 否    | 传入的车牌号格式不正确时触发，plateNumber为格式不正确的车牌号                 |

## 示例代码

```ts
import { UILicensePlate } from 'module_keyboard';

@Entry
@ComponentV2
struct Sample1 {
  @Local plateNumber: string = '';

  build() {
    NavDestination() {
      Column() {
        UILicensePlate({
          //  传入的车牌号
          plateNumber: this.plateNumber,
          //  是否默认激活键盘，选中输入框
          intFocus: false,
          //  输入完整车牌后触发回调，获取车牌号
          onChange: (carNumber: string[], isComplete: boolean) => {
            console.log('当前输入车牌号', carNumber, '是否为完整车牌号', isComplete);
          },
          //  传入车牌号格式错误时触发
          onFormatError: (plateNumber: string) => {
            console.log('格式错误的车牌号', plateNumber);
          },
        })
      }
      .padding(10)
      .width('100%')
    }
    .height('100%')
    .width('100%')
    .title('车牌输入')
  }
}
```
