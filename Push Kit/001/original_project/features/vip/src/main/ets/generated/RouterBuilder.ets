import { MineInfoPage } from '../pages/MineInfoPage';
import { SettingPage } from '../pages/SettingPage';
import { Recharge } from 'module_recharge';
import { qrCodeDialog } from '../components/QrCodeDialog'

@Builder
export function SettingPageBuilder() {
  SettingPage();
}

@Builder
export function MineInfoBuilder() {
  MineInfoPage();
}

@Builder
export function VipRechargeBuilder() {
  Recharge();
}

@Builder
export function qrCodeDialogBuilder() {
  qrCodeDialog();
}


