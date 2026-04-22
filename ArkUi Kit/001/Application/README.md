# 生活服务（医保）元服务模板快速入门

## 目录

- [功能介绍](#功能介绍)
- [约束与限制](#约束与限制)
- [快速入门](#快速入门)
- [示例效果](#示例效果)
- [开源许可协议](#开源许可协议)

## 功能介绍

您可以基于此模板直接定制元服务，也可以挑选此模板中提供的多种组件使用，从而降低您的开发难度，提高您的开发效率。

此模板提供如下组件，所有组件存放在工程根目录的components下，如果您仅需使用组件，可参考对应组件的指导链接；如果您使用此模板，请参考本文档。

| 组件                                              | 描述                     | 使用指导                                                     |
| :------------------------------------------------ | :----------------------- | :----------------------------------------------------------- |
| 元服务关联账号组件（automatic_association_count） | 元服务关联账号、解除关联 | [使用指导](components/automatic_association_count/README.md) |

本模板为医保元服务提供了常用功能的开发样例，模板主要分首页、服务、医保码、资讯、和我的五大模块：

* 首页：主要提供医保码展示，长辈模式，以及热点查询，便民服务等功能

* 服务：展示全部服务列表，支持搜索所需服务。

* 资讯：展示当前医保相关资讯，支持上拉刷新、下拉加载、以及跳转h5查看资讯详情

* 医保码：展示当前账号绑定的医保码，

* 我的：展示个人信息、关于我们，切换头像，并支持意见反馈。

本模板已集成华为账号、定位、地图等服务，只需做少量配置和定制即可快速实现华为账号的登录、位置定位等功能，从而快速完成相关功能的实现。

| 首页                                                   | 服务                                                      | 我的                                                   | 资讯                                                   |
| ------------------------------------------------------ | --------------------------------------------------------- | ------------------------------------------------------ | ------------------------------------------------------ |
| <img src="screenshot/home.png" alt="首页" width="300"> | <img src="screenshot/service.png" alt="服务" width="300"> | <img src="screenshot/mine.png" alt="我的" width="300"> | <img src="screenshot/news.png" alt="资讯" width="300"> |

本模板主要页面及核心功能如下所示：

```ts
家政模板
 |-- 首页
 |    |-- 医保信息
 |    |-- 长辈模式
 |    |-- 医保码
 |    |-- 热点查询
 |    |     |-- 个人参保信息查询
 |    |     |-- 个人就诊记录查询
 |    |     |-- 个人账户明细查询
 |    └-- 便民服务
 |          |-- 医保地图
 |          |-- 医保机构
 |          |-- 定点医院
 |          |-- 药品查询
 |-- 服务
 |    |-- 个人医保查询
 |          |-- 参保信息
 |          |-- 缴费记录 
 |          |-- 账户收支明细 
 |          |-- 参保证明 
 |    |-- 医保业务办理
 |          |-- 异地备案
 |          |-- 亲情账号 
 |          |-- 城乡居民参保登记 
 |          |-- 灵活就业参保登记
 |          |-- 家庭共济 
 |          |-- 医保关系转移接续 
 |    |-- 医保公共查询
 |          |-- 定点医疗机构
 |          |-- 定点零售药店 
 |          |-- 账户收支明细 
 |          |-- 参保信息
 └-- 我的
      |-- 用户信息
      |     |-- 个人信息
      |     └-- 编辑资料
      |-- 办证进度
      |     |-- 待审核
      |     |-- 已审核
      |     |-- 已撤销
      |-- 个人信息
      └-- 联系客服
      └-- 关于我们
            └-- 意见反馈
            └-- 反馈记录
```

本模板工程代码结构如下所示：

```ts
├──commons
│   ├──common                                // 公共能力层
│     ├──src/main/ets                        // 基础能力
│     │  ├──axios                            // 网络请求封装
│     │  └──AxiosHttpRequest                 // 业务请求
│     │  └──AxiosMockData                    // 网络请求mock接口
│     │  └──basicDataSource                  // 懒加载数据源
│     │  └──constants                        // 公共常量
│     │  └──h5                               // h5页面封装
│     │  └──imagePreview                     // 图片预览公共组件
│     │  └──permissionRequest                // 获取权限工具类
│     │  └──quickLogin                       // 华为账号一键登录
│     │  └──utils                            // 公共方法
│     └──Index.ets                           // 对外接口类
│   ├──components                            // 细化业务组件
│     ├──src/main/ets                        // 基础能力
│     │  ├──AboutUs                          // 关于我们组件
│     │  └──CertificationProgress            // 暂无数据公共组件
│     │  └──ConvenientService                // 便民服务组件
│     │  └──DrugInquiry                      // 药品查询组件
│     │  └──HotServiceCard                   // 热门服务组件
│     │  └──InstitutionsPage                 // 医疗机构组件
│     │  └──MedicalPersonCardInfo            // 个人医保信息卡片组件
│     │  └──OlderModel                       // 长辈模式组件
│     │  └──OnlineReservation                // 在线预约组件
│     │  └──ReservationSheet                 // 在线预约记录组件
│     └──Index.ets                           // 对外接口类  
├──feature                                   // 基础特性层
│  ├──home/src/main/ets                      // 首页（包含卡证识别，智能填充，花瓣地图）
│  │  ├──commonconstants      
│  │  ├──model    
│  │  ├──pages                               // 首页入口
│  │  ├──views    
│  ├──home/src/main/resources                // 资源文件目录
│  ├──home/Index.ets                         // 对外接口类
│  ├──service/src/main/ets                   // 全部服务
│  │  ├──view                                // 全部服务入口
│  ├──instantDelivery/src/main/resources     // 资源文件目录
│  ├──instantDelivery/Index.ets              // 对外接口类
│  ├──information/src/main/ets               // 资讯
│  │  ├──view                                // 资讯入口
│  ├──information/src/main/resources         // 资源文件目录
│  ├──mine/src/main/ets                      // 我的（包含一键登录）
│  │  ├──components
│  │  └──pages                               // 我的入口页   
│  │  └──utils
│  └──mine/src/main/resources                // 资源文件目录
└──products                                  // 产品定制层
   ├──phone/src/main/ets                      
   │  ├──entryability                        // 主入口生命周期（包含预加载） 
   │  └──pages                               // 首页主入口 
   │  └──components                          // 首页公共组件  
   │  └──entryformability                    // 服务卡片入口生命周期 
   │  └──widget                              // 服务卡片    
   └──phone/src/main/resources               // 资源文件目录
```

## 约束与限制

### 环境

* DevEco Studio版本：DevEco Studio 5.0.4 Release及以上
* HarmonyOS SDK版本：HarmonyOS 5.0.4 Release SDK及以上
* 设备类型：华为手机（直板机）
* 系统版本：HarmonyOS 5.0.4(16)及以上

### 权限要求

* 获取位置权限：ohos.permission.APPROXIMATELY_LOCATION
* 网络权限：ohos.permission.INTERNET

## 快速入门

### 配置工程

在运行此模板前，需要完成以下配置：

1. 在AppGallery Connect创建元服务，将包名配置到模板中。

   a. 参考[创建元服务](https://developer.huawei.com/consumer/cn/doc/app/agc-help-create-app-0000002247955506)为元服务创建APP ID，并将APP ID与元服务进行关联。

   b. 返回应用列表页面，查看元服务的包名。

   c. 将Application/AppScope/app.json5文件中的bundleName替换为创建元服务的包名。

2. 配置地图服务。

   a. 参考[开通地图服务](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/map-config-agc)。

   <img src="screenshot/img_14.png" alt="开通服务" width="1200">

3. 本模板是端云一体模版，采用云函数接口的方式mock请求数据，所以需要部署云函数以及云数据库。

   a. [开通元函数服务](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/cloudfoundation-enable-function)和[开通云数据库服务](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/cloudfoundation-enable-database)

   b. 在CloudProgram/cloud-config.json文件中配置相关信息，依次填写当前项目的appId、appName、projectId、teamId、projectName，相关信息查询参考[查看应用基本信息](https://developer.huawei.com/consumer/cn/doc/app/agc-help-view-app-info-0000002282674569) 。

   <img src="screenshot/img_19.png" alt="配置信息" width="600">
   <img src="screenshot/img_18.png" alt="查询信息" width="600">

   c. 部署云数据库。右击clouddb选择“deploy Cloud db”进行部署，部署成功之后可以在AGC上查看数据库状态。

   <img src="screenshot/img_20.png" alt="部署数据库">
   <img src="screenshot/img_21.png" alt="查询数据库" width="600">

   d. 打开云函数中govn-userinfo函数的[AxiosApi.ts](../CloudProgram/cloudfunctions/govn-userinfo/AxiosApi.ts)文件，将getAccessToken方法中的client_id以及client_secret修改为你当前项目下对应应用的client_id和client_secret。

   <img src="screenshot/img_24.png" alt="配置id和secret" width="600">

   e. 部署云函数。右击goven-userinfo，点击Deploy 'goven-userinfo'部署云函数，类似操作部署home-service、informations-service和service-list。

   <img src="screenshot/img_11.png" alt="部署云函数">

   f. 云函数部署成功，可以在AGC上查看相关记录。

   <img src="screenshot/img_10.png" alt="查询云函数" width="600">

4. 配置预加载。

   a. [开通预加载服务](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/cloudfoundation-enable-prefetch)。

   b. 为预加载绑定前面部署的云函数home-service。

   <img src="screenshot/img_13.png" alt="选择云函数" width="600">

   c. 详细预加载文档，请参考：https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/cloudfoundation-prefetch-service

5. 配置华为账号服务。

   a. 将元服务的client ID配置到Application/product/entry模块的[module.json5](./product/entry/src/main/module.json5)文件，详细参考：[配置Client ID](https://developer.huawei.com/consumer/cn/doc/atomic-guides/account-atomic-client-id)。

   b. 如需获取用户真实手机号，需要申请phone权限，详细参考：[配置scope权限](https://developer.huawei.com/consumer/cn/doc/atomic-guides/account-guide-atomic-permissions)，并在端侧使用快速验证手机号码Button进行[验证获取手机号码](https://developer.huawei.com/consumer/cn/doc/atomic-guides/account-guide-atomic-get-phonenumber)。

6. 对元服务进行[手工签名](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/ide-signing#section297715173233)。

7. 添加手工签名所用证书对应的公钥指纹。详细参考：[配置应用签名证书指纹](https://developer.huawei.com/consumer/cn/doc/app/agc-help-cert-fingerprint-0000002278002933)。

### 运行调试工程

1. 连接调试手机和PC。

2. 菜单选择“Run > Run 'entry' ”或者“Run > Debug 'entry' ”，运行或调试模板工程。

## 示例效果

1. [首页](https://agc-storage-drcn.platform.dbankcloud.cn/v0/zwmb-xlw7o/video%2F1.mp4?token=e4952413-5cc9-4e65-a7ce-189956cd5462)

2. [服务](https://agc-storage-drcn.platform.dbankcloud.cn/v0/zwmb-xlw7o/video%2F2.mp4?token=817c37a1-0cba-4508-ad2b-c725c9b8dd36)

3. [资讯](https://agc-storage-drcn.platform.dbankcloud.cn/v0/zwmb-xlw7o/video%2F3.mp4?token=d1f6be36-ec66-4a4b-adec-444168512942)

4. [我的](https://agc-storage-drcn.platform.dbankcloud.cn/v0/zwmb-xlw7o/video%2F4.mp4?token=a23c05d9-baa1-45f6-b082-63bd0554cbc0)

## 开源许可协议

该代码经过[Apache 2.0 授权许可](http://www.apache.org/licenses/LICENSE-2.0)。