export interface BaseSuccessResponse<T> {
  code: number;
  msg?: string;
  data: T;
}
