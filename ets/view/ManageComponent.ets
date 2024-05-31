import MoneyTable from '../common/database/tables/MoneyTable';
import MoneyData from '../viewmodel/MoneyData';
import CommonConstants from '../common/constants/CommonConstants';
import { DialogManageComponent } from './DialogManageComponent';
import { ImageList } from '../viewmodel/MoneyList';
import Logger from '../common/utils/Logger';
import AccountTable from '../common/database/tables/AccountTable';
import AccountData from '../viewmodel/AccountData';

@Component
export default struct ManageComponent {
  @State accounts: Array<AccountData> = [];
  @State newAccount: AccountData = { id: 0, accountType: 0, typeText: '', amount: 0 ,Date:'',remark:''};
  private AccountTable = new AccountTable(() => {});
  @State totalhua_month: number = 0;
  @State totalhua_year: number = 0;

  @State yusuan_month: number = 0;
  @State yusuan_year: number = 0;

  @State money: Array<MoneyData> = [];
  @State searchText: string = '';
  @State isInsert: boolean = false;
  @State newMoney: MoneyData = { id: 0, accountType: 0, typeText: '', amount: 0,amount2: 0,remark:''};
  @State index: number = -1;
  @State totalint: number = 0;
  @State totalout: number = 0;
  private MoneyTable = new MoneyTable(() => {});
  private deleteList: Array<MoneyData> = [];

  controller: TextClockController = new TextClockController();
  searchController: SearchController = new SearchController();
  private scrollerForList: Scroller = new Scroller()
  dialogController: CustomDialogController = new CustomDialogController({
    builder: DialogManageComponent({
      isInsert: $isInsert,
      newMoney: $newMoney,
      confirm: (isInsert: boolean, newMony: MoneyData) => this.accept(isInsert, newMony)
    }),
    customStyle: true,
    alignment: DialogAlignment.Bottom,
  });


  accept(isInsert: boolean, newMoney: MoneyData): void {
    if (isInsert) {
      Logger.info(`${CommonConstants.INDEX_TAG}`, `The account inserted is:  ${JSON.stringify(newMoney)}`);
      this.MoneyTable.insertData(newMoney, (id: number) => {
        newMoney.id =id;
        this.money.push(newMoney);
      });
    } else {
      this.MoneyTable.updateData(newMoney, () => {
      });
      let list = this.money;
      this.money = [];
      list[this.index] = newMoney;
      this.money = list;
      this.index = -1;
    }
  }
  aboutToAppear() {
    this.MoneyTable.getRdbStore(() => {
      this.MoneyTable.query(0, (result: MoneyData[]) => {
        this.money = result;
      }, true);
    });
  }
  selectListItem(item: MoneyData) {
    this.isInsert = false;
    this.index = this.money.indexOf(item);
    this.newMoney = {
      id: item.id,
      accountType: item.accountType,
      typeText: item.typeText,
      amount: item.amount,
      amount2: item.amount2,
      remark:item.remark,
    };
  }
  deleteListItem() {
    for (let i = 0; i < this.deleteList.length; i++) {
      let index = this.money.indexOf(this.deleteList[i]);
      this.money.splice(index, 1);
      this.MoneyTable.deleteData(this.deleteList[i], () => {
      });
    }
    this.deleteList = [];
  }
  @Builder itemEnd(index: number,item) {
    // 侧滑后尾端出现的组件
    Button({ type: ButtonType.Normal }) {
      Text('删除')
        .fontSize(15)
        .fontColor(Color.White)
    }
    .width(55)
    .height(50)
    .borderRadius($r('app.float.radius_size_M'))
    .backgroundColor(Color.Red)
    .onClick(() => {
      this.deleteList.push(item);
      this.deleteListItem();
    })
  }
  findMonth(date: string): number {
    // 获取日期字符串中的月份部分，并将其转换为数字
    return Number(date.split('-')[1]);
  }
  findyear(date: string): number {
    // 获取日期字符串中的月份部分，并将其转换为数字
    return Number(date.split('-')[0]);
  }
  build() {
    Column() {
      Text(`管理资产`)
        .height(`30vp`)
        .fontSize(25)
        .fontColor(Color.Black)
        .margin({top:'10vp'})
      Row() {
        TextClock({ timeZoneOffset: -8, controller: this.controller })
          .format('yyyyMM')
          .fontSize(20)
          .height($r('app.float.component_size_SP'))


        Text('查询月度预算')
          .fontSize($r('app.float.font_size_M'))
          .fontColor(Color.White)
          .backgroundColor("#FF007DFF")
          .width('30%')
          .height($r('app.float.component_size_MP'))
          .textAlign(TextAlign.Center)
          .borderRadius($r('app.float.radius_size_M'))
          .onClick(() => {
            this.yusuan_month = 0;
            this.totalhua_month= 0;
            this.AccountTable.query(0, (result: AccountData[]) => {
              this.accounts = result;
            }, true);
            this.yusuan_month = this.newMoney.amount2;
            //this.yusuan_year = this.newMoney.amount;
            for (let i = 0; i < this.accounts.length; i++) {
              if(this.findMonth(this.accounts[i].Date) === 11){
                if(this.accounts[i].accountType === 0) {
                  this.totalhua_month = this.totalhua_month + this.accounts[i].amount;
                }
              }
            }

          })

        Text(' ')
          .fontSize($r('app.float.font_size_M'))
          .width('5%')
          .height($r('app.float.component_size_MP'))
          .textAlign(TextAlign.Center)
          .borderRadius($r('app.float.radius_size_M'))

        Text('查询年度预算')
          .fontSize($r('app.float.font_size_M'))
          .fontColor(Color.White)
          .backgroundColor("#FF007DFF")
          .width('30%')
          .height($r('app.float.component_size_MP'))
          .textAlign(TextAlign.Center)
          .borderRadius($r('app.float.radius_size_M'))
          .onClick(() => {
            this.yusuan_year = 0;
            this.totalhua_year = 0;
            this.AccountTable.query(0, (result: AccountData[]) => {
              this.accounts = result;
            }, true);
            this.yusuan_year = this.newMoney.amount;
            for (let i = 0; i < this.accounts.length; i++) {
              if(this.findyear(this.accounts[i].Date) === 2023) {
                if(this.accounts[i].accountType === 0) {
                  this.totalhua_year = this.totalhua_year + this.accounts[i].amount;
                }

              }
            }

          })
      }
      .width(CommonConstants.FULL_WIDTH)
      .align(Alignment.Center)

      Row({ space: 8 }) {
        Column(){
          Text('月度预算')
            .fontSize($r('app.float.font_size_M'))
            .fontColor(Color.Black)
            .textAlign(TextAlign.Center)
            .margin({top:'4vp'})

          Text(`已花费${this.totalhua_month}`).fontSize(15).lineHeight(20).fontWeight(500).opacity(0.6)

          Stack() {
            if(this.yusuan_month === 0){
              DataPanel({ values: [0], max: 100, type: DataPanelType.Circle }).width(187).height(165)
            }else{
              DataPanel({ values: [this.totalhua_month], max: this.yusuan_month, type: DataPanelType.Circle }).width(187).height(168)
            }

            Column() {
              if(this.yusuan_month === 0){
                Text('0').fontSize(35).fontColor('#182431')
              }else{
                Text(`${((this.totalhua_month/this.yusuan_month)*100).toFixed(1)}`).fontSize(35).fontColor('#182431')
              }
              Text('%')
                .fontSize(15)
                .lineHeight(12.83)
                .fontWeight(500)
                .opacity(0.6)
            }


          }
        }.backgroundColor(Color.White)
        .borderRadius('20vp')
        .height(200)


        Column() {
          Text('年度预算')
            .fontSize($r('app.float.font_size_M'))
            .fontColor(Color.Black)
            .textAlign(TextAlign.Center)
            .margin({ top: '4vp' })

          Text(`已花费${this.totalhua_year}`).fontSize(15).lineHeight(20).fontWeight(500).opacity(0.6)

          Stack() {

            if(this.yusuan_year === 0){
              DataPanel({ values: [0], max:100, type: DataPanelType.Circle }).width(187).height(165)
            }else{
              DataPanel({ values: [this.totalhua_year], max:this.yusuan_year, type: DataPanelType.Circle }).width(187).height(168)
            }
            Column() {
              if(this.yusuan_year === 0){
                Text('0').fontSize(35).fontColor('#182431')
              }else{
                Text(`${((this.totalhua_year/this.yusuan_year)*100).toFixed(1)}`).fontSize(35).fontColor('#182431')
              }
              Text('%')
                .fontSize(13)
                .lineHeight(12.83)
                .fontWeight(500)
                .opacity(0.6)
            }
          }
        }.backgroundColor(Color.White)
        .borderRadius('20vp')
        .height(200)
      }
      .margin({ top: '8vp' })



      Row() {
        List({ space: CommonConstants.FULL_SIZE, scroller: this.scrollerForList }) {
          ForEach(this.money, (item: MoneyData) => {
            ListItem() {
              Row() {
                Image($r('app.media.yusuan'))
                  .width($r('app.float.component_size_M'))
                  .aspectRatio(CommonConstants.FULL_SIZE)
                  .margin({ right: $r('app.float.edge_size_MP') })

                Column({space:8}){
                  Text(item.typeText)
                    .height($r('app.float.component_size_SM'))
                    .fontSize($r('app.float.font_size_M'))
                  if(item.remark === ''){
                    Text(`备注:无`)
                      .height($r('app.float.component_size_SM'))
                      .fontSize($r('app.float.font_size_M'))
                      .fontColor(Color.Gray)
                  }else {
                    Text(`备注:${item.remark}`)
                      .height($r('app.float.component_size_SM'))
                      .fontSize($r('app.float.font_size_M'))
                      .fontColor(Color.Gray)
                  }
                }

                Blank()
                  .layoutWeight(0.5)

                Text(
                    item.accountType === 0 ? '-' + item.amount.toString() :
                      item.accountType === 1 ? '+' + item.amount.toString() :
                    '年预算'+item.amount.toString()+'    月预算'+item.amount2.toString()
                )
                  .fontSize($r('app.float.font_size_M'))
                  .fontColor(
                      item.accountType === 0 ? $r('app.color.pay_color') :
                    item.accountType === 1 ? $r('app.color.main_color'):
                      "#DAA520"
                  )
                  .align(Alignment.End)
                  .flexGrow(CommonConstants.FULL_SIZE)
                  .onAppear(() => {
                    if (item.accountType === 1) {
                      this.totalint = this.totalint + item.amount;
                    } else if (item.accountType === 0){
                      this.totalout = this.totalout + item.amount;
                    }
                  })
              }
              .width(CommonConstants.FULL_WIDTH)
              .padding({ left: $r('app.float.edge_size_M'), right: $r('app.float.edge_size_M') })
              .backgroundColor("#E6E6FA")
              .borderRadius($r('app.float.radius_size_M'))

            }.swipeAction({ end: () => {
              this.itemEnd(this.index, item)
            } }) // 设置侧滑属性.
            .width(CommonConstants.FULL_WIDTH)
            .height($r('app.float.component_size_LM'))
            .onClick(() => {
              this.selectListItem(item);
              this.dialogController.open();
            })
          })
        }
        .height("20%")
        .width(CommonConstants.FULL_WIDTH)
        .borderRadius($r('app.float.radius_size_M'))
        .backgroundColor(Color.White)
        .opacity(0.8)
        .divider({
          strokeWidth: 1,
          startMargin: 60,
          endMargin: 10,
          color: '#ffe9f0f0'
        })
      }
      .width(CommonConstants.FULL_WIDTH)
      .padding({ left: $r('app.float.edge_size_M'), right: $r('app.float.edge_size_M') })
      .margin({ top: $r('app.float.edge_size_SM') })

      Row({space:8}){
        Text('添加预算')
          .fontSize($r('app.float.font_size_M'))
          .fontColor(Color.White)
          .borderRadius($r('app.float.radius_size_M'))
          .textAlign(TextAlign.Center)
          .backgroundColor("#DAA520")
          .width('60%')
          .height($r('app.float.component_size_MP'))
          .onClick(() => {
            this.isInsert = true;
            this.newMoney = { id: 0, accountType: 0, typeText: '', amount: 0 ,amount2: 0 ,remark:''};
            this.dialogController.open();
          })
      }.margin({ top: '8vp' })

      Column() {
        Text('支出评估')
          .fontSize(30)
          .fontColor("#DAA520")
          .textAlign(TextAlign.Center)
          .margin({ top: '4vp' })
      }.margin({ top: '12vp' })


      Column(){

        Text('年度支出评估')
          .fontSize($r('app.float.font_size_M'))
          .fontColor(Color.Black)
          .fontWeight(500)
          .textAlign(TextAlign.Start)
          .margin({top:'4vp'})

        Text(
            this.totalhua_year/this.yusuan_year >0.8 ? '您的年支出评定为：  高支出'  :

              this.totalhua_year/this.yusuan_year >0.4 && this.totalhua_year/this.yusuan_year <=0.8? '您的年支出评定为：  中支出'  :

               '您的年度支出评定为：  低支出'
        )
          .fontSize(20)
          .fontColor(
                this.totalhua_year/this.yusuan_year >0.8 ? $r('app.color.pay_color') :
                this.totalhua_year/this.yusuan_year >0.4 && this.totalhua_year/this.yusuan_year <=0.8?  $r('app.color.gold'):
                "#FF007DFF"
          )

        Blank()
          .layoutWeight(0.5)

        Text('月度支出评估')
          .fontSize($r('app.float.font_size_M'))
          .fontColor(Color.Black)
          .fontWeight(500)
          .textAlign(TextAlign.Center)
          .margin({top:'4vp'})

        Text(
            this.totalhua_month/this.yusuan_month >0.8 ? '您的月支出评定为：  高支出'  :

              this.totalhua_month/this.yusuan_month >0.4 && this.totalhua_month/this.yusuan_month <=0.8? '您的月支出评定为：  中支出'  :

              '您的月度支出评定为：  低支出'
        )
          .fontSize(20)
          .fontColor(
              this.totalhua_month/this.yusuan_month >0.8 ? $r('app.color.pay_color') :
                this.totalhua_month/this.yusuan_month >0.4 && this.totalhua_month/this.yusuan_month <=0.8?  $r('app.color.gold'):
                "#FF007DFF"
          )

      }
      .height("20%")
      .width('95%')
      .borderRadius($r('app.float.radius_size_M'))
      .backgroundColor("#E6E6FA")
      .opacity(0.8)
      .margin({ top: '5vp' })


    }
    .width(CommonConstants.FULL_WIDTH)
    .height(CommonConstants.FULL_HEIGHT)
    .backgroundImage($r('app.media.bg5'))
    .backgroundImageSize(ImageSize.Cover)
  }
}
