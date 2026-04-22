# 选择店铺组件快速入门

## 目录
- [简介](#简介)
- [约束与限制](#约束与限制)
- [使用](#使用)
- [API参考](#API参考)
- [示例代码](#示例代码)

## 简介

本组件提供了店铺选择功能，可以展示地图窗口，显示店铺位置与名称，选择店铺时可以切换地图上的店铺。

<img src="./screenshot/Screenshot_1.jpeg" width="300">

## 约束与限制

### 环境

* DevEco Studio版本：DevEco Studio 5.0.4 Release及以上
* HarmonyOS SDK版本：HarmonyOS 5.0.4 Release SDK及以上
* 设备类型：华为手机（包括双折叠和阔折叠）
* 系统版本：HarmonyOS 5.0.4(16)及以上

### 权限

- 获取位置权限：ohos.permission.APPROXIMATELY_LOCATION、ohos.permission.LOCATION
- 网络权限：ohos.permission.INTERNET

## 使用

1. 安装组件。  
   如果是在DevEco Studio使用插件集成组件，则无需安装组件，请忽略此步骤。
   如果是从生态市场下载组件，请参考以下步骤安装组件。  
   a. 解压下载的组件包，将包中所有文件夹拷贝至您工程根目录的xxx目录下。  
   b. 在项目根目录build-profile.json5并添加select_store和base_ui模块。
   ```typescript
   // 在项目根目录的build-profile.json5填写search、select_store和base_ui路径。其中xxx为组件存在的目录名
   "modules": [
     {
       "name": "search",
       "srcPath": "./xxx/search",
     },
     {
       "name": "select_store",
       "srcPath": "./xxx/select_store",
     },
     {
       "name": "base_ui",
       "srcPath": "./xxx/base_ui",
     }
   ]
   ```
   c. 在项目根目录oh-package.json5中添加依赖
   ```typescript
   // xxx为组件存放的目录名称
   "dependencies": {
     "search": "file:./xxx/search",
     "select_store": "file:./xxx/select_store"
   }
   ```

2. 引入组件。

   ```typescript
   import { SelectStore } from 'select_store';
   ```
   
3. 在主工程的src/main路径下的module.json5文件的requestPermissions字段中添加如下权限：

   ```typescript
     "requestPermissions": [
      ...
      {
        "name": "ohos.permission.INTERNET",
        "reason": "$string:app_name",
        "usedScene": {
          "abilities": [
            "FormAbility"
          ],
          "when": "inuse"
        }
      },
      {
        "name": "ohos.permission.LOCATION",
        "reason": "$string:app_name",
        "usedScene": {
          "abilities": [
            "EntryAbility"
          ],
          "when": "inuse"
        }
      },
      {
        "name": "ohos.permission.APPROXIMATELY_LOCATION",
        "reason": "$string:app_name",
        "usedScene": {
          "abilities": [
            "EntryAbility"
          ],
          "when": "inuse"
        }
      }
      ...
    ],
   ```
   
4. 调用组件，详细参数配置说明参见[API参考](#API参考)。

   ```typescript
   SelectStore({
     routerStack: RouterModule.getStack(),
     storeInfoList: this.storeInfoList,
     storeId: this.storeModel.storeId,
     packageName: this.appInfoModel.packageName,
     selectStoreCb: (storeId: string) => {
       // 选择店铺后跳转页面
     },
   })
   ```

## API参考

### 接口

SelectStore(options?: SelectStoreOptions)

选择店铺组件。

**参数：**

| 参数名     | 类型                                            | 是否必填 | 说明       |
|---------|-----------------------------------------------|------|----------|
| options | [SelectStoreOptions](#SelectStoreOptions对象说明) | 是    | 选择店铺的参数。 |

### SelectStoreOptions对象说明

| 名称            | 类型                                                                                                                              | 是否必填 | 说明              |
|---------------|---------------------------------------------------------------------------------------------------------------------------------|------|-----------------|
| routerStack   | [NavPathStack](https://developer.huawei.com/consumer/cn/doc/harmonyos-references/ts-basic-components-navigation#navpathstack10) | 是    | Navigation导航控制器 |
| storeInfoList | [StoreInfo](#StoreInfo对象说明)[]                                                                                                   | 是    | 店铺列表            |
| storeId       | string                                                                                                                          | 是    | 选中的店铺           |
| packageName   | string                                                                                                                          | 是    | 应用包名            |

### StoreInfo对象说明

| 名称             | 类型      | 是否必填 | 说明       |
|----------------|---------|------|----------|
| id             | string  | 是    | 店铺序号     |
| name           | string  | 是    | 店铺名称     |
| address        | string  | 是    | 店铺地址     |
| time1          | string  | 是    | 店铺营业开始时间 |
| time2          | string  | 是    | 店铺营业结束时间 |
| tel            | string  | 是    | 店铺电话     |
| logo           | string  | 是    | 店铺图标     |
| coordinates    | string  | 是    | 店铺位置     |
| distance       | number  | 是    | 店铺距离     |
| distanceStr    | string  | 是    | 店铺距离字符串  |

### 事件

支持以下事件：

#### selectedStore

selectedStore(callback: (storeId: string) => void)

选择店铺后跳转页面

## 示例代码

说明：Index.ets和Index2.ets文件需要放在同一目录
```typescript
// Index.ets
import { abilityAccessCtrl, common } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { StoreInfo } from 'search';
import { Index2 } from './Index2';

@Entry
@ComponentV2
struct Index {
   @Provider('routerStack') routerStack: NavPathStack = new NavPathStack();
   @Local storeInfoList: StoreInfo[] = [];

   aboutToAppear(): void {
      let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
      atManager.requestPermissionsFromUser(this.getUIContext().getHostContext() as common.UIAbilityContext,
      ['ohos.permission.LOCATION', 'ohos.permission.APPROXIMATELY_LOCATION'])
      .then((data) => {
         let grantStatus: Array<number> = data.authResults;
         if (grantStatus.every(item => item === 0)) {
         // 授权成功
            this.routerStack.replacePath({ name: 'Index2' })
         }
      }).catch((err: BusinessError) => {
         console.error(`Failed to request permissions from user. Code is ${err.code}, message is ${err.message}`);
      });
   }
   
   @Builder
   pageMap(name: string) {
      if (name === 'Index2') {
         Index2();
      }
   }
   
   build() {
      Navigation(this.routerStack) {
      }
      .hideTitleBar(true)
      .navDestination(this.pageMap)
      .mode(NavigationMode.Stack)
      .height('100%')
      .width('100%');
   }
}
```
```typescript
// Index2.ets
import { StoreInfo } from 'search';
import { SelectStore } from 'select_store';

@ComponentV2
export struct Index2 {
   @Consumer('routerStack') routerStack: NavPathStack = new NavPathStack();
   @Local storeInfoList: StoreInfo[] = [];

   aboutToAppear(): void {
      for (let index = 0; index < 3; index++) {
         let store = new StoreInfo()
         store.id = `${index}`
         store.name = `店铺名称（${index}）`
         store.address = '南京市雨花台区华为路华为云楼'
         store.time1 = '00:00'
         store.time2 = '21:30'
         store.tel = `1000000000${index}`
         store.logo = ''
         store.coordinates = '31.97919489020034,118.76224773565536'
         store.distanceStr = '888M'
         this.storeInfoList.push(store)
      }
      this.storeInfoList[1].coordinates = '31.97831,118.76362'
      this.storeInfoList[2].coordinates = '31.97052568354233,118.76447685976373'
   }
   
   build() {
      NavDestination() {
         RelativeContainer() {
            SelectStore({
               routerStack: this.routerStack,
               storeInfoList: this.storeInfoList,
               storeId: this.storeInfoList[0].id,
               packageName: 'test',
               selectedStore: (storeId: string) => {
                  // 选择店铺后跳转页面
                  this.getUIContext().getPromptAction().showToast({ message: `选择店铺:${storeId}` })
               },
            })
         }.height('100%')
         .width('100%')
         .padding({ top: 45 })
      }
      .hideTitleBar(true)
      .height('100%')
      .width('100%');
   }
}
```