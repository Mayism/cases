import { ReadStateCode, TextReader } from '@kit.SpeechKit';
import { UIContext } from '@kit.ArkUI';
import { PlayInfo } from 'module_base';
import { UtilLog } from '@hw-agconnect/util-log';

const TAG = 'TEXT_READER';

@ObservedV2
export class TextReaderUtil {
  private static _instance: TextReaderUtil;
  readInfo: TextReader.ReadInfo = {
    id: '',
    title: {
      text: '',
      isClickable: true,
    },
  };
  private context?: Context;
  @Trace readState: ReadStateCode = ReadStateCode.WAITING;

  public static get instance() {
    if (!TextReaderUtil._instance) {
      TextReaderUtil._instance = new TextReaderUtil();
    }
    return TextReaderUtil._instance;
  }
}