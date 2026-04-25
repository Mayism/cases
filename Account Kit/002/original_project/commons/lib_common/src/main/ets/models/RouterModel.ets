import { StoreGuide } from '../models/ResponseModel'

export interface WebRouter {
  title: ResourceStr,
  index: number,
  content: string
}

export interface PaymentRouter {
  plate: string
}

export interface GuideRouter {
  guide: StoreGuide,
}