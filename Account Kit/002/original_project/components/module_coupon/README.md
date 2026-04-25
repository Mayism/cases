# 停车优惠券组件快速入门

## 目录

- [简介](#简介)
- [约束与限制](#约束与限制)
- [快速入门](#快速入门)
- [API参考](#API参考)
- [示例代码](#示例代码)

## 简介

本组件支持优惠券的管理和选择。

| 优惠券管理                                           | 优惠券选择                                           |
|-------------------------------------------------|-------------------------------------------------|
| <img src="./screenshots/优惠券管理.jpg" width="300"> | <img src="./screenshots/优惠券选择.jpg" width="300"> |

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

   b. 在项目根目录build-profile.json5添加module_coupon模块。

   ```
   // 项目根目录下build-profile.json5填写module_coupon路径。其中XXX为组件存放的目录名
   "modules": [
     {
       "name": "module_coupon",
       "srcPath": "./XXX/module_coupon"
     }
   ]
   ```

   c. 在项目根目录oh-package.json5添加依赖。
   ```
   // XXX为组件存放的目录名称
   "dependencies": {
     "module_coupon": "file:./XXX/module_coupon"
   }
   ```

2. 引入组件。

    ```
    import { MyCoupons, SelectCoupons, GlobalCouponUtils } from 'module_coupon';
    ```

3. 调用组件，详细参数配置说明参见[API参考](#API参考)。

## API参考

### 接口

MyCoupons(option?: [MyCouponsOptions](#MyCouponsOptions对象说明))

停车优惠券列表

**参数：**

| 参数名     | 类型                                        | 是否必填 | 说明            |
|:--------|:------------------------------------------|:-----|:--------------|
| options | [MyCouponsOptions](#MyCouponsOptions对象说明) | 否    | 配置停车优惠券列表的参数。 |

### MyCouponsOptions对象说明

| 参数名         | 类型         | 是否必填 | 说明        |
|:------------|:-----------|:-----|:----------|
| clickUseNow | () => void | 否    | 点击立即使用的回调 |

SelectCoupons(option?: [SelectCouponsOptions](#SelectCouponsOptions对象说明))

选择停车优惠券

**参数：**

| 参数名     | 类型                                                | 是否必填 | 说明            |
|:--------|:--------------------------------------------------|:-----|:--------------|
| options | [SelectCouponsOptions](#SelectCouponsOptions对象说明) | 否    | 配置选择停车优惠券的参数。 |

### SelectCouponsOptions对象说明

| 参数名           | 类型                                  | 是否必填 | 说明       |
|:--------------|:------------------------------------|:-----|:---------|
| selectIdParam | string                              | 否    | 传入的优惠券id |
| onSelect      | (id: string, money: number) => void | 否    | 选择优惠券的回调 |

### GlobalCouponUtils

优惠券对外方法

#### constructor

constructor()

GlobalCouponUtils的构造函数。

#### consumeCoupon

consumeCoupon(couponID: string): void

消费优惠券

## 示例代码

### 示例1（管理优惠券）

```ts
import { MyCoupons } from 'module_coupon';

@Entry
@ComponentV2
struct Sample1 {
  build() {
    NavDestination() {
      Column() {
        MyCoupons({
          clickUseNow: () => {
            this.getUIContext().getPromptAction().showToast({ message: '点击了立即使用' });
          },
        })
      }
      .width('100%')
    }
    .height('100%')
    .width('100%')
    .title('我的券包')
  }
}
```

### 示例2（选择优惠券）

```ts
import { SelectCoupons } from 'module_coupon';

@Entry
@ComponentV2
struct Sample2 {
  @Local selectedCouponID: string = '';
  @Local selectedCouponMoney: number = 0;
  @Local showCouponSheet: boolean = false;

  @Builder
  selectCouponBuilder() {
    Column() {
      SelectCoupons({
        selectIdParam: this.selectedCouponID,
        onSelect: (id: string, money: number) => {
          this.selectedCouponID = id;
          this.selectedCouponMoney = money;
          this.showCouponSheet = false;
        },
      })
    }
    .padding(10)
  }

  build() {
    NavDestination() {
      Column({ space: 20 }) {
        Text(`选择的优惠券ID：  ${this.selectedCouponID}`)
        Text(`选择的优惠券面额： ${this.selectedCouponMoney}`)
        Button('选择')
          .width('100%')
          .onClick(() => {
            this.showCouponSheet = true;
          })
          .bindSheet($$this.showCouponSheet, this.selectCouponBuilder(), {
            height: SheetSize.MEDIUM,
            preferType: SheetType.CENTER,
            title: {
              title: '选择优惠券',
            },
          })
      }
      .padding(12)
      .width('100%')
      .alignItems(HorizontalAlign.Start)
    }
    .height('100%')
    .width('100%')
    .title('选择优惠券')
  }
}
```
