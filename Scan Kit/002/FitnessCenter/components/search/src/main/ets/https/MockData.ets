import { FilterTagAndList, SearchItem, SearchWordItem, StoreInfo } from '../types/Type';

/**
 * Mock数据类
 */
export const HOT_SEARCH_MOCK: SearchItem[] = [
  {
    title: '苹果',
    index: '1',
    id: 'fruit-1',
    image: $r('app.media.startIcon'),
    intro: '口感脆甜，富含维生素C，富含蛋白质，口感鲜嫩',
    price: 5.99,
    type: 'fruit',
    classId: 'fruit',
  },
  {
    title: '牛肉',
    index: '2',
    id: 'meat-1',
    image: $r('app.media.startIcon'),
    intro: '富含蛋白质，口感鲜嫩，口感脆甜，富含维生素',
    type: 'meat',
    classId: 'meat',
  },
  {
    title: '菠菜',
    index: '3',
    id: 'vegetable-2',
    image: $r('app.media.startIcon'),
    intro: '富含铁质，口感鲜嫩',
    type: 'vegetable',
    classId: 'vegetable',
  },
  {
    title: '鸡肉',
    index: '4',
    id: 'meat-2',
    image: $r('app.media.startIcon'),
    intro: '口感鲜美，富含蛋白质',
    type: 'meat',
    classId: 'meat',
  },
  {
    title: '橙子',
    index: '5',
    id: 'fruit-3',
    image: $r('app.media.startIcon'),
    intro: '富含维生素C，口感酸甜',
    type: 'fruit',
    classId: 'fruit',
  },
  {
    title: '葡萄',
    index: '6',
    id: 'fruit-4',
    image: $r('app.media.startIcon'),
    intro: '口感酸甜，富含多种维生素',
    type: 'fruit',
    classId: 'fruit',
  },
  {
    title: '草莓',
    index: '7',
    id: 'fruit-5',
    image: $r('app.media.startIcon'),
    intro: '口感酸甜，富含抗氧化物质',
    type: 'fruit',
    classId: 'fruit',
  },
  {
    title: '西瓜',
    index: '8',
    id: 'fruit-6',
    image: $r('app.media.startIcon'),
    intro: '口感脆甜，富含维生素C',
    type: 'fruit',
    classId: 'fruit',
  },
  {
    title: '香蕉',
    index: '9',
    id: 'fruit-2',
    image: $r('app.media.startIcon'),
    intro: '富含钾元素，口感软甜',
    type: 'fruit',
    classId: 'fruit',
  }
];

export const STORE_SEARCH_RESULTS1: StoreInfo[] = [
  {
    distance: '8km',
    name: '北京总店',
    address: '北京市中心总店',
    categoryName: '北京'
  },
  {
    distance: '5km',
    name: '东城区分店',
    address: '东城区分店',
    categoryName: '东城区'
  },
  {
    distance: '9km',
    name: '北京旗舰店',
    address: '北京市中心旗舰店',
    categoryName: '北京'
  },
  {
    distance: '6km',
    name: '东城朝阳门店',
    address: '东城区朝阳门店',
    categoryName: '东城区'
  },
  {
    distance: '5km',
    name: '西城金融街店',
    address: '西城区金融街店',
    categoryName: '西城区'
  },
  {
    distance: '4km',
    name: '西城区分店',
    address: '西城区分店',
    categoryName: '西城区'
  },
  {
    distance: '3km',
    name: '朝阳区总店',
    address: '朝阳区总店',
    categoryName: '朝阳区'
  },
  {
    distance: '5km',
    name: '朝阳国贸店',
    address: '朝阳区国贸店',
    categoryName: '朝阳区'
  },
  {
    distance: '4km',
    name: '朝阳三里屯店',
    address: '朝阳区三里屯店',
    categoryName: '朝阳区'
  },
  {
    distance: '7km',
    name: '丰台区分店',
    address: '丰台区分店',
    categoryName: '丰台区'
  },
  {
    distance: '2km',
    name: '海淀区分店',
    address: '海淀区总店',
    categoryName: '海淀区'
  },
  {
    distance: '8km',
    name: '石景山店',
    address: '石景山区店',
    categoryName: '石景山区'
  },
  {
    distance: '3km',
    name: '中关村店',
    address: '海淀区中关村店',
    categoryName: '海淀区'
  },
  {
    distance: '20km',
    name: '房山店',
    address: '房山区店',
    categoryName: '房山区'
  },
  {
    distance: '15km',
    name: '门头沟店',
    address: '门头沟区店',
    categoryName: '门头沟区'
  },
  {
    distance: '18km',
    name: '通州区分店',
    address: '通州区总店',
    categoryName: '通州区'
  },
  {
    distance: '14km',
    name: '昌平区分店',
    address: '昌平区分店',
    categoryName: '昌平区'
  },
  {
    distance: '16km',
    name: '顺义店',
    address: '顺义区店',
    categoryName: '顺义区'
  },
  {
    distance: '17km',
    name: '大兴店',
    address: '大兴区店',
    categoryName: '大兴区'
  },
  {
    distance: '40km',
    name: '平谷店',
    address: '平谷区店',
    categoryName: '平谷区'
  },
  {
    distance: '35km',
    name: '怀柔店',
    address: '怀柔区店',
    categoryName: '怀柔区'
  },
  {
    distance: '45km',
    name: '密云店',
    address: '密云区店',
    categoryName: '密云区'
  },
  {
    distance: '50km',
    name: '延庆店',
    address: '延庆区店',
    categoryName: '延庆区'
  },
]

export const STORE_SEARCH_RESULTS2: StoreInfo[] = [
  {
    distance: '8km',
    name: '南京总店',
    address: '南京市中心总店',
    categoryName: '南京'
  },
  {
    distance: '3km',
    name: '玄武区分店',
    address: '玄武区分店',
    categoryName: '玄武区'
  },
  {
    distance: '9km',
    name: '南京旗舰店',
    address: '南京市中心旗舰店',
    categoryName: '南京'
  },
  {
    distance: '2km',
    name: '秦淮区分店',
    address: '秦淮区分店',
    categoryName: '秦淮区'
  },
  {
    distance: '4km',
    name: '建邺区分店',
    address: '建邺区分店',
    categoryName: '建邺区'
  },
  {
    distance: '2.5km',
    name: '夫子庙店',
    address: '秦淮区夫子庙店',
    categoryName: '秦淮区'
  },
  {
    distance: '1km',
    name: '鼓楼区分店',
    address: '鼓楼区分店',
    categoryName: '鼓楼区'
  },
  {
    distance: '10km',
    name: '栖霞店',
    address: '栖霞区店',
    categoryName: '栖霞区'
  },
  {
    distance: '12km',
    name: '浦口店',
    address: '浦口区店',
    categoryName: '浦口区'
  },
  {
    distance: '6km',
    name: '雨花台店',
    address: '雨花台区店',
    categoryName: '雨花台区'
  },
  {
    distance: '25km',
    name: '六合店',
    address: '六合区店',
    categoryName: '六合区'
  },
  {
    distance: '15km',
    name: '江宁区分店',
    address: '江宁区分店',
    categoryName: '江宁区'
  },
  {
    distance: '30km',
    name: '溧水店',
    address: '溧水区店',
    categoryName: '溧水区'
  },
  {
    distance: '35km',
    name: '高淳店',
    address: '高淳区店',
    categoryName: '高淳区'
  },
]

export const SEARCH_RESULTS_MOCK: FilterTagAndList[] = [
  {
    label: '水果',
    id: 'fruit',
    itemList: [
      {
        title: '苹果',
        index: '1',
        id: 'fruit-1',
        image: $r('app.media.startIcon'),
        intro: '口感脆甜，富含维生素C',
        price: 5.99
      },
      {
        title: '香蕉',
        index: '2',
        id: 'fruit-2',
        image: $r('app.media.startIcon'),
        intro: '富含钾元素，口感软甜',
      },
      {
        title: '橙子',
        index: '3',
        id: 'fruit-3',
        image: $r('app.media.startIcon'),
        intro: '富含维生素C，口感酸甜',
      },
      {
        title: '葡萄',
        index: '4',
        id: 'fruit-4',
        image: $r('app.media.startIcon'),
        intro: '口感酸甜，富含多种维生素',
      },
      {
        title: '草莓',
        index: '5',
        id: 'fruit-5',
        image: $r('app.media.startIcon'),
        intro: '口感酸甜，富含抗氧化物质',
      },
      {
        title: '西瓜',
        index: '6',
        id: 'fruit-6',
        image: $r('app.media.startIcon'),
        intro: '口感脆甜，富含维生素C',
      },
      {
        title: '苹果',
        index: '7',
        id: 'fruit-7',
        image: $r('app.media.startIcon'),
        intro: '口感脆甜，富含维生素C',
        price: 5.99
      },
      {
        title: '香蕉',
        index: '8',
        id: 'fruit-8',
        image: $r('app.media.startIcon'),
        intro: '富含钾元素，口感软甜',
      },
      {
        title: '橙子',
        index: '9',
        id: 'fruit-9',
        image: $r('app.media.startIcon'),
        intro: '富含维生素C，口感酸甜',
      },
      {
        title: '葡萄',
        index: '10',
        id: 'fruit-10',
        image: $r('app.media.startIcon'),
        intro: '口感酸甜，富含多种维生素',
      },
      {
        title: '草莓',
        index: '11',
        id: 'fruit-11',
        image: $r('app.media.startIcon'),
        intro: '口感酸甜，富含抗氧化物质',
      }
    ]
  },
  {
    label: '蔬菜',
    id: 'vegetable',
    itemList: [
      {
        title: '胡萝卜',
        index: '1',
        id: 'vegetable-1',
        image: $r('app.media.startIcon'),
        intro: '富含维生素A，口感脆甜',
      },
      {
        title: '菠菜',
        index: '2',
        id: 'vegetable-2',
        image: $r('app.media.startIcon'),
        intro: '富含铁质，口感鲜嫩',
      }
    ]
  },
  {
    label: '肉类',
    id: 'meat',
    itemList: [
      {
        title: '牛肉',
        index: '1',
        id: 'meat-1',
        image: $r('app.media.startIcon'),
        intro: '富含蛋白质，口感鲜嫩',
      },
      {
        title: '鸡肉',
        index: '2',
        id: 'meat-2',
        image: $r('app.media.startIcon'),
        intro: '口感鲜美，富含蛋白质',
      }
    ]
  },
  {
    label: '肉类',
    id: 'meat1',
    itemList: []
  },
  {
    label: '肉类',
    id: 'meat2',
    itemList: []
  },
  {
    label: '肉类',
    id: 'meat3',
    itemList: []
  },
  {
    label: '肉类',
    id: 'meat4',
    itemList: []
  },
  {
    label: '肉类',
    id: 'meat5',
    itemList: []
  }
];

export const GUESS_LIKE_LIST1: SearchWordItem[] = [
  {
    content: '单行展示，超长文本截断',
    id: '001'
  },
  {
    content: '推荐词A',
    id: '002'
  },
  {
    content: '推荐词B',
    id: '003'
  },
  {
    content: '推荐词C',
    id: '004'
  },
];

export const GUESS_LIKE_LIST2: SearchWordItem[] = [
  {
    content: '推荐词A',
    id: '002'
  },
  {
    content: '推荐词B',
    id: '003'
  },
  {
    content: '单行展示，超长文本截断',
    id: '001'
  },
  {
    content: '推荐词C',
    id: '004'
  },
  {
    content: '推荐词D',
    id: '005'
  }
];

export const HISTORY_MOCK: SearchWordItem[] = [
  {
    content: '单行展示，超长文本截断',
    id: '001'
  },
  {
    content: '推荐词A',
    id: '002'
  },
  {
    content: '推荐词B',
    id: '003'
  },
  {
    content: '推荐词C',
    id: '004'
  },
  {
    content: '推荐词推荐词推荐词推荐词超长推荐词',
    id: '008'
  }
];