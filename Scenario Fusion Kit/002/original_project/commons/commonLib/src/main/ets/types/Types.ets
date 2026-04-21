export interface UserInfo {
  id: number;
  avatar: string;
  phoneNumber: string;
  name: string;
  isAssociate: boolean
}

export interface HuaweiIDResp {
  openId: string
  unionId: string
  authCode: string
}