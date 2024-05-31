import sms from '@ohos.telephony.sms'
export default interface AccountItem {
  icon: Resource;
  iconSelected: Resource;
  accountType: number;
  typeText: string;
}

export const PayList: Array<AccountItem> = [
  {
    icon: $rawfile('cy.png'),
    iconSelected: $rawfile('cy.png'),
    accountType: 0,
    typeText: '餐饮'
  },
  {
    icon: $rawfile('gw.png'),
    iconSelected: $rawfile('gw.png'),
    accountType: 0,
    typeText: '购物'
  },
  {
    icon: $rawfile('ry.png'),
    iconSelected: $rawfile('ry.png'),
    accountType: 0,
    typeText: '日用'
  },
  {
    icon: $rawfile('jt.png'),
    iconSelected: $rawfile('jt.png'),
    accountType: 0,
    typeText: '交通'
  },

  {
    icon: $rawfile('yd.png'),
    iconSelected: $rawfile('yd.png'),
    accountType: 0,
    typeText: '运动'
  },

  {
    icon: $rawfile('yl.png'),
    iconSelected: $rawfile('yl.png'),
    accountType: 0,
    typeText: '娱乐'
  },
  {
    icon: $rawfile('fs.png'),
    iconSelected: $rawfile('fs.png'),
    accountType: 0,
    typeText: '服饰'
  },
  {
    icon: $rawfile('hz.png'),
    iconSelected: $rawfile('hz.png'),
    accountType: 0,
    typeText: '家庭'
  },

  {
    icon: $rawfile('sj.png'),
    iconSelected: $rawfile('sj.png'),
    accountType: 0,
    typeText: '社交'
  },
  {
    icon: $rawfile('lx.png'),
    iconSelected: $rawfile('lx.png'),
    accountType: 0,
    typeText: '旅行'
  },

  {
    icon: $rawfile('xx.png'),
    iconSelected: $rawfile('xx.png'),
    accountType: 0,
    typeText: '学习'
  },

  {
    icon: $rawfile('lw.png'),
    iconSelected: $rawfile('lw.png'),
    accountType: 0,
    typeText: '礼物'
  },
  {
    icon: $rawfile('bg.png'),
    iconSelected: $rawfile('bg.png'),
    accountType: 0,
    typeText: '办公'
  },

  {
    icon: $rawfile('qtzc.png'),
    iconSelected: $rawfile('qtzc.png'),
    accountType: 0,
    typeText: '其他支出'
  }

]

export const EarnList: Array<AccountItem> = [
  {
    icon: $rawfile('gz.png'),
    iconSelected: $rawfile('gz.png'),
    accountType: 1,
    typeText: '工资'
  },
  {
    icon: $rawfile('lc.png'),
    iconSelected: $rawfile('lc.png'),
    accountType: 1,
    typeText: '理财'
  },
  {
    icon: $rawfile('fh.png'),
    iconSelected: $rawfile('fh.png'),
    accountType: 1,
    typeText: '奖励'
  },
  {
    icon: $rawfile('qtsr.png'),
    iconSelected: $rawfile('qtsr.png'),
    accountType: 1,
    typeText: '其他收入'
  }
]

export const ImageList: Record<string,Resource> = {
  '餐饮': $rawfile('cy.png'),
  '购物': $rawfile('gw.png'),
  '日用': $rawfile('ry.png'),
  '交通': $rawfile('jt.png'),


  '运动': $rawfile('yd.png'),
  '娱乐': $rawfile('yl.png'),

  '服饰': $rawfile('fs.png'),
  '家庭': $rawfile('hz.png'),

  '社交': $rawfile('sj.png'),
  '旅行': $rawfile('lx.png'),

  '学习': $rawfile('xx.png'),

  '礼物': $rawfile('lw.png'),

  '办公': $rawfile('bg.png'),

  '其他支出': $rawfile('qtzc.png'),



  '工资': $rawfile('gz.png'),
  '理财': $rawfile('lc.png'),
  '奖励': $rawfile('jj.png'),
  '其他收入': $rawfile('qtsr.png'),
}