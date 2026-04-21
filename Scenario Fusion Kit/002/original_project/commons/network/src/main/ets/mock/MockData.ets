import { CommonReq, MyOrderReq } from '../models/RequestModel';
import {
  GetTableInfoResp,
  GetUserInfoResp, MockNewsData, MockVideoData,
} from '../models/ResponseModel';
import { Decimal } from '@kit.ArkTS';
import { DnState, GoodSpecEnum, OrderStateEnum } from '../constants/Common';

export class MockData {

  static get getIsNew(): number {
    // 1 新用户 2老用户
    return 1
  }

  static userInfo = new GetUserInfoResp(1, 'success', '1', '华为用户', '', '', '', '88', '200', '')

  static get getUserInfoResp(): GetUserInfoResp {
    return this.userInfo
  }

  static get getOpenLogin(): GetUserInfoResp {
    this.userInfo.userTel = '10000002222'
    this.userInfo.name = '华为用户'
    return this.userInfo
  }

  static get getCloseLogin(): GetUserInfoResp {
    this.userInfo.userTel = ''
    return this.userInfo
  }

  static get getTableTitleResp(): Array<MockNewsData> {
    let result = [
      new MockNewsData('0','1', 'HarmonyOS Connect伙伴峰会上海站圆满结束', 'HarmonyOS Connect伙伴峰会在上海举办，此次峰会展示了鸿蒙智联生态业务的最新发展成果及业务战略布局。', '2022年08月16日', 'new0.png'),
      new MockNewsData('1','1', '华为发布机场智能运控中心等五大航空解决方案，加速行业智能化', '华为发布机场智能运控中心等五大航空解决方案，引领行业智能化升级。华为交通智慧化军团副总裁董方朔参加', '2024年3月22日', 'news1.jpg'),
      new MockNewsData('2','1', '华为斩获九项Lightwave+BTR光通信年度创新大奖', '全球光网络知名媒体Lightwave颁发了光通信年度创新大奖（Lightwave+BTR Innovation Reviews），华为全光数据中心方案。', '2022年7月26日'),
      new MockNewsData('3','1', '共筑数智未来：2025华为泰国合作伙伴大会成功召开', '华为泰国公司副总经理张晓祥在大会致辞中指出，人类已进入AI时代，通用人工智能正加速到来。', '2022年5月19日'),
      new MockNewsData('4','1', 'AI时代的短距连接革新与全场景体验升级', '星闪技术深度整合通讯、定位、感知三大功能，解决传统技术功能单一的局限，为消费者带来全场景新体验。', '2022年5月15日'),
      new MockNewsData('5','1', '鸿蒙智联推荐模组赋能生态产品鸿蒙智家一致体验', '鸿蒙智联始持续聚焦体验、效率和质量的提升,携手伙伴致力于为消费者打造全场景智慧生活新体验。', '2022年5月15日', 'news2.jpg'),
      new MockNewsData('6','1', '华为智选开启战略转型，产品势能全面提升', '本次峰会，华为智选与伙伴一起预告了多款新品，致力为消费者提供高品质的纯净用水体验；安全的家庭看护；高端创新的个护产品。', '2023年4月11日'),
      new MockNewsData('7','1', '华为携手伙伴发布城市全域数字化转型联合行动计划', '华为携手19家合作伙伴发布城市全域数字化转型联合行动计划，共同构建端到端解决方案能力，加速城市全域数字化转型。', '2024年7月15日'),
      new MockNewsData('8','0', 'HarmonyOS Connect伙伴峰会上海站圆满结束', 'HarmonyOS Connect伙伴峰会在上海举办，此次峰会展示了鸿蒙智联生态业务的最新发展成果及业务战略布局。', '2022年08月16日', $r('app.media.ic_picture')),
      new MockNewsData('9','0', 'HarmonyOS Connect伙伴峰会上海站圆满结束', 'HarmonyOS Connect伙伴峰会在上海举办，此次峰会展示了鸿蒙智联生态业务的最新发展成果及业务战略布局。', '2022年08月16日', $r('app.media.ic_fengjing_01')),
    ]
    return result
  }

  static get getVideoInfoResp(): Array<MockVideoData> {
    let result = [
      new MockVideoData('0', 'HarmonyOS Connect伙伴峰会上海站圆满结束', 'HarmonyOS Connect伙伴峰会在上海举办，此次峰会展示了鸿蒙智联生态业务的最新发展成果及业务战略布局。', '2022年08月16日', '', $r('app.media.ic_picture')),
      new MockVideoData('1', '华为发布机场智能运控中心等五大航空解决方案，加速行业智能化', '华为发布机场智能运控中心等五大航空解决方案，引领行业智能化升级。华为交通智慧化军团副总裁董方朔参加', '2024年3月22日', '', $r('app.media.ic_fengjing_01')),
      new MockVideoData('2', '华为斩获九项Lightwave+BTR光通信年度创新大奖', '全球光网络知名媒体Lightwave颁发了光通信年度创新大奖（Lightwave+BTR Innovation Reviews），华为全光数据中心方案。', '2022年7月26日', '', $r('app.media.ic_picture')),
      new MockVideoData('3', '共筑数智未来：2025华为泰国合作伙伴大会成功召开', '华为泰国公司副总经理张晓祥在大会致辞中指出，人类已进入AI时代，通用人工智能正加速到来。', '2022年5月19日', '', $r('app.media.preview')),
      new MockVideoData('4', 'AI时代的短距连接革新与全场景体验升级', '星闪技术深度整合通讯、定位、感知三大功能，解决传统技术功能单一的局限，为消费者带来全场景新体验。', '2022年5月15日', '', $r('app.media.ic_fengjing_01'))
    ]
    return result
  }

  static getTableInfoResp = (params: CommonReq) => {
    if (params.type) {
      return this.getTableTitleResp
    } else {
      return this.getVideoInfoResp
    }
  }

  // 订单
  static orderId: number = 1
}
