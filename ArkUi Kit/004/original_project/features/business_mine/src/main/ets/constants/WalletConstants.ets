export interface WalletItem {
  title: string,
  value: number,
}

export class WalletConstants {
  static readonly TAB_OPTIONS: WalletItem[] = [
    {
      title: '全部',
      value: 0,
    },
    {
      title: '充值',
      value: 1,
    },
    {
      title: '支出',
      value: 2,
    },
  ]
}