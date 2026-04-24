import fs from '@ohos.file.fs';
import { Logger } from 'commonlib';

const TAG = '[AvatarUtil]';
const AVATAR_DIR = '/avatar/';
const AVATAR_FILENAME = 'user_avatar.png';

/**
 * 将选中的头像保存到沙箱目录
 * @param sourceUri 头像源URI（从FunctionalButton CHOOSE_AVATAR回调获取）
 * @param filesDir 应用沙箱文件目录
 * @returns 保存后的沙箱路径（带file://前缀），失败返回空字符串
 */
export function saveAvatarToSandbox(sourceUri: string, filesDir: string): string {
  try {
    const avatarDir = filesDir + AVATAR_DIR;

    // 创建头像目录（如不存在）
    if (!fs.accessSync(avatarDir)) {
      fs.mkdirSync(avatarDir);
    }

    const targetPath = avatarDir + AVATAR_FILENAME;

    // 解析源URI，移除file://前缀
    let sourcePath = sourceUri;
    if (sourceUri.startsWith('file://')) {
      sourcePath = sourceUri.substring(7);
    }

    // 如果目标文件已存在，先删除
    if (fs.accessSync(targetPath)) {
      fs.unlinkSync(targetPath);
    }

    // 复制文件到沙箱
    fs.copyFileSync(sourcePath, targetPath);

    return 'file://' + targetPath;
  } catch (e) {
    Logger.error(TAG, 'Failed to save avatar: ' + JSON.stringify(e));
    return '';
  }
}

/**
 * 获取头像显示路径
 * @param avatar 用户信息中的头像路径
 * @returns 用于显示的头像资源路径
 */
export function getAvatarDisplayPath(avatar: string): ResourceStr {
  if (avatar) {
    if (avatar.startsWith('file://')) {
      const sandboxPath = avatar.substring(7);
      try {
        if (!fs.accessSync(sandboxPath)) {
          return $r('app.media.ic_default_hd');
        }
      } catch (e) {
        return $r('app.media.ic_default_hd');
      }
      return avatar;
    }
    return avatar;
  }
  return $r('app.media.ic_default_hd');
}