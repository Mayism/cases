import { BuyCard } from '../pages/BuyCard';
import { CardDetail } from '../pages/CardDetail';
import { Order } from '../pages/Order';
import { OrderDetail } from '../pages/OrderDetail';
import { ShowAllCards } from '../pages/ShowAllCards';
import { UserCards } from '../pages/UserCards';

@Builder
export function ShowAllCardsBuilder() {
  ShowAllCards();
}

@Builder
export function CardDetailBuilder() {
  CardDetail();
}

@Builder
export function BuyCardBuilder() {
  BuyCard();
}

@Builder
export function UserCardsBuilder() {
  UserCards();
}

@Builder
export function OrderBuilder() {
  Order();
}

@Builder
export function OrderDetailBuilder() {
  OrderDetail();
}