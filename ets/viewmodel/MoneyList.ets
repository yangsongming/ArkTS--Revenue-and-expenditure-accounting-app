export default interface MoneyItem {
  icon: Resource;
  iconSelected: Resource;
  accountType: number;
  typeText: string;
}

export const YusuanList: Array<MoneyItem> =[
{
    icon: $r('app.media.yusuan'),
    iconSelected: $r('app.media.yusuan'),
    accountType: 2,
    typeText: '预算'
  }
]
export const ImageList: Record<string,Resource> = {

  '年度预算':  $r('app.media.yusuan'),


}