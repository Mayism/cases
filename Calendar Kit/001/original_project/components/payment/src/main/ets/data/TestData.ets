import { PaymentType } from './PaymentType';

export const paymentTypeList: PaymentType[] = [
  {
    payTypeSerialNo: '1',
    payTypeDesc: '建设银行储蓄卡 (0606)',
    isAvailable: true,
    custPayType: 'BankFastPayment',
  },
  {
    payTypeSerialNo: '2',
    payTypeDesc: '工商银行储蓄卡 (0909)',
    isAvailable: true,
    custPayType: 'BankFastPayment',
  }
];

export const paymentTypes3PayShow: PaymentType[] = [
  {
    payTypeSerialNo: '3',
    payTypeDesc: '余额支付',
    isAvailable: true,
    custPayType: 'QuotaPayment',
  }
]