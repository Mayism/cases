# 分类搜索组件快速入门

## 目录

- [简介](#简介)
- [约束与限制](#约束与限制)
- [使用](#使用)
- [API参考](#API参考)
- [示例代码](#示例代码)

## 简介

本组件提供搜索过滤能力，支持按文本搜索和按标签过滤。

<img src="screenshots/searchFilter01.jpg" width="300">
<img src="screenshots/searchFilter02.jpg" width="300">

## 约束与限制

### 环境
* DevEco Studio版本：DevEco Studio 5.0.1 Release及以上
* HarmonyOS SDK版本：HarmonyOS 5.0.1 Release SDK及以上
* 设备类型：华为手机（直板机）
* 系统版本：HarmonyOS 5.0.1(13)及以上

### 权限
* 网络权限：ohos.permission.INTERNET

## 使用

1. 安装组件。
   如果是在DevEco Studio使用插件集成组件，则无需安装组件，请忽略此步骤。
   如果是从生态市场下载组件，请参考以下步骤安装组件。

   a. 解压下载的组件包，将包中所有文件夹拷贝至您工程根目录的XXX目录下。

   b. 在项目根目录build-profile.json5添加module_search_filter模块。

   ```
   // 在项目根目录build-profile.json5填写module_search_filter路径。其中XXX为组件存放的目录名
   "modules": [
        {
        "name": "module_search_filter",
        "srcPath": "./XXX/module_search_filter"
        }
    ]
   ```
   
   c. 在项目根目录oh-package.json5中添加依赖。

   ```
   // XXX为组件存放的目录名称
   "dependencies": {
     "module_search_filter": "file:./XXX/module_search_filter"
   }
   ```

2. 引入组件。

   ```
   import { SearchFilterContent } from 'module_search_filter'
   ```

## API参考

**Type 接口（过滤标签）**

| 参数名      | 类型     | 必填 | 说明   |
|:---------|:-------|:---|:-----|
| name     | string | 是  | 标签名称 |
| typeEnum | number | 是  | 标签索引 |

Type接口为SearchFilterContent组件对外暴露数据类型，包含name和typeNumber两个数据类型

在使用SearchFilterContent组件前需要将自己定义的标签列表转成Type类型
### SearchFilterContent

| 参数名             | 类型                                                        | 必填 | 说明                    |
|:----------------|:----------------------------------------------------------|:---|:----------------------|
| placeHolder     | string                                                    | 是  | 占位提示文本                |
| typeList        | Type[]                                                    | 是  | 筛选标签列表                |
| onContentChange | (name: string, index: number, searchWord: string) => void | 是  | 回调函数，返回选择的标签和搜索栏输入的内容 |
| searchWord      | string                                                    | 是  | 搜索框内容                 |
| selectIndex     | number                                                    | 是  | 用户选中标签索引              |

### 示例代码
````
import { SearchFilterContent, Type } from 'module_search_filter';

@Entry
@ComponentV2
struct PageTwo {
  @Local keyWords: string = ""
  courseList: string[] = [
    "跑步0",
    "有氧1",
    "跑步有氧01",
    "有氧单车12"
  ]
  @Local resList: string[] = []
  list: Type[] = [
    { name: '跑步', typeEnum: 0 },
    { name: '有氧', typeEnum: 1 },
    { name: '单车', typeEnum: 2 }
  ]

  build() {
    Column() {
      Row() {
        SearchFilterContent({
          placeHolder: '请输入卡项名称',
          typeList: this.list,
          onContentChange: (name: string, index: number, keyWords: string) => {
            this.handleBack(name, index, keyWords)
          }
        })
      }
      .width('90%')
      .justifyContent(FlexAlign.Center)

      Row() {
        List() {
          ForEach(this.resList, (item: string) => {
            ListItem() {
              Row() {
                Text(item).fontSize(20)
              }
              .width('100%')
              .justifyContent(FlexAlign.Center)
            }
          }, (item: string) => JSON.stringify(item))
        }
        .width('90%')
        .height('100%')
      }
      .width('90%')
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .margin({ top: 10 })
  }

  private handleBack(name: string, index: number, searchWord: string) {
    // 回调函数，处理 SearchFilterContent 组件回调事件，这里处理搜索到的数据
    this.resList = [];
    this.courseList.forEach((item: string) => {
      if (item.indexOf(searchWord) !== -1 && item.indexOf(index + '') !== -1) {
        this.resList.push(item);
      }
    });
  }
}

````