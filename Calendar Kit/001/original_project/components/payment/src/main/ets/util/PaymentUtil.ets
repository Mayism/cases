import { CustPayType } from '../data/CustPayType';
import { PaymentType } from '../data/PaymentType';

/**
 * Is the payment type a new card
 * @param paymentType payment type
 * @returns Is the payment type a new card
 */
export const isNewCardPaymentType = (paymentType: PaymentType): boolean => {
  if (!paymentType) {
    return false;
  }
  return paymentType.custPayType === CustPayType.NewBankCard;
};

/**
 * Get the icon's rounded corner value
 * @param length Corner Radius
 * @returns Icon corner radius value
 */
export const getBorderRadius = (length: number): number => {
  // The rounded corner value for the square icon is: 14 / 54 * Icon side length
  return 7 / 27 * length;
}