export class BaseResponse {
  status: number
  msg: string

  constructor(status: number, msg: string) {
    this.status = status
    this.msg = msg
  }
}

export class PreloadResponse {
  hmSystem?: GetHmSystemResp
  tableTitleArr?: GetTableTitleResp
}

export class GetHmSystemResp extends BaseResponse {
  storeId: string
  // 商户类型 1 桌号点餐  2 取餐码点餐
  storeType: number

  constructor(status: number, msg: string, storeId: string, storeType: number) {
    super(status, msg)
    this.storeId = storeId
    this.storeType = storeType
  }
}

export class AccessToken {
  scope: string = ''
  accessToken: string = ''
  refreshToken: string = ''
  tokenType: string = ''
  expiresIn: number = 0
  idToken: string = ''
}

export class PhoneInfo {
  unionID: string = ''
  phoneCountryCode: string = ''
  mobileNumber: string = ''
  openID: string = ''
  purePhoneNumber: string = ''
}

export class GetLoginHmSystemResp extends BaseResponse {
  data: GetUserInfoResp
  data2: AccessToken
  data3: PhoneInfo

  constructor(status: number, msg: string, data: GetUserInfoResp, data2: AccessToken, data3: PhoneInfo) {
    super(status, msg)
    this.data = data
    this.data2 = data2
    this.data3 = data3
  }
}

export class GetCancelHmSystemResp extends BaseResponse {
  data: string
  data1: string
  data2: string

  constructor(status: number, msg: string, data: string, data1: string, data2: string) {
    super(status, msg)
    this.data = data
    this.data1 = data1
    this.data2 = data2
  }
}

export class GetUserInfoResp extends BaseResponse {
  id: string
  name: string
  img: string
  openId: string
  unionId: string
  storeId: string
  totalScore: string
  wallet: string
  userTel?: string

  constructor(status: number, msg: string, id: string, name: string, img: string, openId: string,
    storeId: string, totalScore: string, wallet: string, unionId: string) {
    super(status, msg)
    this.id = id
    this.name = name
    this.img = img
    this.openId = openId
    this.storeId = storeId
    this.totalScore = totalScore
    this.wallet = wallet
    this.unionId = unionId
  }
}



export class GetTableTitleResp extends Array<MockNewsData> {
}

export class MockNewsData {
  newsId?: string
  type?: string
  newsTitle?: string | Resource;
  newsContent?: string | Resource;
  newsTime?: string | Resource;
  newsImage?: string | Resource;

  constructor(newsId?: string, type?: string, newsTitle?: string | Resource, newsContent?: string | Resource,
    newsTime?: string | Resource, newsImage?: string | Resource) {
    this.newsId = newsId
    this.type = type
    this.newsTitle = newsTitle
    this.newsContent = newsContent
    this.newsTime = newsTime
    this.newsImage = newsImage
  }
}

export class MockVideoData {
  videoId?: string=''
  title?: string=''
  content?: string=''
  videoUrl?: string | ResourceStr
  previewUri?:string | ResourceStr
  newsTime?: string | Resource;

  constructor(videoId?: string, title?: string, content?: string, newsTime?: string | Resource,
    videoUrl?: string | Resource, previewUri?: string | Resource
) {
    this.videoId = videoId
    this.title = title
    this.content = content
    this.newsTime = newsTime
    this.videoUrl = videoUrl
    this.previewUri = previewUri
  }
}

export class GetTableInfoResp extends Array<MockNewsData> {
}



export class PackageSpec {
  specName?: string
  specNum?: number
}

export class GetVideoInfoResp extends Array<MockVideoData> {
}



