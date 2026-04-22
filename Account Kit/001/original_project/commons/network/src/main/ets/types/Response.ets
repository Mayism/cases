/**
 * 定义接口响应包装类
 */
export interface BaseResponse<T> {
  code: number
  msg: string
  data: T
}