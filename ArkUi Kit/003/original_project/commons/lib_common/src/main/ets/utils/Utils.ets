import Decimal from '@arkts.math.Decimal';

export function getAnonymousTel(userTel: string = '') {
  if (userTel.length >= 8) {
    return `${userTel.substring(0, userTel.length - 8)}****${userTel.substring(userTel.length - 4)}`
  } else {
    return '****';
  }
}

export function getPlateFmt(plate: string) {
  return `${plate.slice(0, 2)}-${plate.slice(2)}`
}

export function getTime(date: Date): string {
  let hours = `0${date.getHours()}`.slice(-2)
  let minutes = `0${date.getMinutes()}`.slice(-2)
  return `${hours}:${minutes}`
}

export function getSecond(date: Date): string {
  let hours = `0${date.getHours()}`.slice(-2)
  let minutes = `0${date.getMinutes()}`.slice(-2)
  let seconds = `0${date.getSeconds()}`.slice(-2)
  return `${hours}:${minutes}:${seconds}`
}

export function getMonth(date: Date): string {
  let year = date.getFullYear()
  let month = `0${date.getMonth() + 1}`.slice(-2)
  return `${year}-${month}`
}

export function getDate(date: Date): string {
  let year = date.getFullYear()
  let month = `0${date.getMonth() + 1}`.slice(-2)
  let day = `0${date.getDate()}`.slice(-2)
  return `${year}-${month}-${day}`
}

export function getFullDate(date: Date): string {
  return `${getDate(date)} ${getSecond(date)}`
}

export function getCountdown(time: number) {
  let second = time % 60
  let minute = Math.floor(new Decimal(time).div(60).toNumber()) % 60
  let hour = Math.floor(new Decimal(time).div(60).div(60).toNumber())
  return `${hour} 时 ${minute} 分 ${second} 秒`
}