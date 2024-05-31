import AccountTable from '../common/database/tables/AccountTable';
import AccountData from '../viewmodel/AccountData';
import CommonConstants from '../common/constants/CommonConstants';
import { DialogComponent } from '../view/DialogComponent';
import { ImageList } from '../viewmodel/AccountList';
import Logger from '../common/utils/Logger';
import promptAction from '@ohos.promptAction';


const allmenu:string[]=['金额查找','时间查找','备注查找','类型查找']

@Component
export default struct AccountComponent {

  @State accounts: Array<AccountData> = [];
  @State searchText: string = '';
  @State searchtype: string = '暂无查找';
  @State searchcheck: number= 1;
  @State isInsert: boolean = false;
  @State newAccount: AccountData = { id: 0, accountType: 0, typeText: '', amount: 0 ,Date:'',remark:''};
  @State index: number = -1;
  @State totalint: number = 0;
  @State totalout: number = 0;
  private AccountTable = new AccountTable(() => {});
  private deleteList: Array<AccountData> = [];



  controller: TextClockController = new TextClockController();
  searchController: SearchController = new SearchController();
  private scrollerForList: Scroller = new Scroller()
  dialogController: CustomDialogController = new CustomDialogController({
    builder: DialogComponent({
      isInsert: $isInsert,
      newAccount: $newAccount,
      confirm: (isInsert: boolean, newAccount: AccountData) => this.accept(isInsert, newAccount)
    }),
    customStyle: true,
    alignment: DialogAlignment.Bottom,
  });


  accept(isInsert: boolean, newAccount: AccountData): void {
    if (isInsert) {
      Logger.info(`${CommonConstants.INDEX_TAG}`, `The account inserted is:  ${JSON.stringify(newAccount)}`);
      this.AccountTable.insertData(newAccount, (id: number) => {
        newAccount.id =id;
        this.accounts.push(newAccount);
      });
    } else {
      this.AccountTable.updateData(newAccount, () => {
      });
      let list = this.accounts;
      this.accounts = [];
      list[this.index] = newAccount;
      this.accounts = list;
      this.index = -1;


    }
  }

  aboutToAppear() {
    this.AccountTable.getRdbStore(() => {
      this.AccountTable.query(0, (result: AccountData[]) => {
        this.accounts = result;
      }, true);
    });
  }

  selectListItem(item: AccountData) {
    this.isInsert = false;
    this.index = this.accounts.indexOf(item);
    this.newAccount = {
      id: item.id,
      accountType: item.accountType,
      typeText: item.typeText,
      amount: item.amount,
      Date:item.Date,
      remark:item.remark,
    };
  }

  deleteListItem() {
    for (let i = 0; i < this.deleteList.length; i++) {
      let index = this.accounts.indexOf(this.deleteList[i]);
      this.accounts.splice(index, 1);
      if(this.deleteList[i].accountType === 1){
        this.totalint = this.totalint - this.deleteList[i].amount;
      }else {
        this.totalout = this.totalout - this.deleteList[i].amount;
      }
      this.AccountTable.deleteData(this.deleteList[i], () => {
      });
    }
    this.deleteList = [];
  }

  jisuan(account: AccountData[]) {
    this.totalint = 0;
    this.totalout = 0;

    for (let i = 0;i < account.length; i++) {
      if (account[i].accountType == 0) {
        this.totalout = this.totalout + account[i].amount;
      }
      else {
        this.totalint = this.totalint + account[i].amount;
      }
    }
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


  build() {
    Stack() {
      Column() {
        Text('智慧收支')
          .height($r('app.float.component_size_SP'))
          .fontSize(30)
          .align(Alignment.Center)

        Row() {
          Column() {
            TextClock({ timeZoneOffset: -8, controller: this.controller })
              .format('yyyyMMdd')
              .fontSize(20)
              .height($r('app.float.component_size_SP'))
          }.margin({ left: ('12vp') })
        }
        .width(CommonConstants.FULL_WIDTH)
        .justifyContent(FlexAlign.SpaceBetween)
        .margin({ top:('5vp'), bottom: ('0vp') })

        Row(){
          Column() {
            Text('您的总结余：' + `${this.totalint - this.totalout}`+'元')
              .height($r('app.float.component_size_SP'))
              .fontSize(30)
              .fontColor('#DAA520')
              .margin({ left: ('10vp'), bottom: ('10vp') })
              .align(Alignment.Center)


              Text(`总收入：` + `${this.totalint}` + '元')
                .height($r('app.float.component_size_SP'))
                .fontSize(22)
                .fontColor(Color.White)
                .textAlign(TextAlign.Start)
                .alignSelf(ItemAlign.Start)
                .margin({ left: ('20vp') })

              Text(`总支出：` + `${this.totalout}`+'元')
                .height($r('app.float.component_size_SP'))
                .fontSize(22)
                .fontColor(Color.White)
                .textAlign(TextAlign.Start)
                .alignSelf(ItemAlign.Start)
                .margin({ left: ('20vp') })


          }
          .backgroundImage($r('app.media.bg10'))
          .backgroundImageSize(ImageSize.Cover)
          .opacity(0.9)
          .width('100%')
          .height(120)
          .borderRadius($r('app.float.radius_size_M'))
          .borderWidth($r('app.float.border_size_S'))
          .borderColor($r('app.color.border_color'))

        }
        .width(CommonConstants.FULL_WIDTH)
        //.justifyContent(FlexAlign.SpaceBetween)
        .margin({ top:('5vp'), bottom: ('0vp') })


        Row() {
          Search({
            value: this.searchText,
            placeholder: CommonConstants.SEARCH_TEXT,
            controller: this.searchController
          })
            .width(CommonConstants.FULL_WIDTH)
            .borderRadius($r('app.float.radius_size_M'))
            .borderWidth($r('app.float.border_size_S'))
            .borderColor($r('app.color.border_color'))
            .placeholderFont({ size: $r('app.float.font_size_M') })
            .textFont({ size: $r('app.float.font_size_M') })
            .backgroundColor(Color.White)
            .onChange((searchValue: string) => {
              this.searchText = searchValue;
            })
            .onSubmit((searchValue: string) => {
              if (searchValue === '') {
                this.AccountTable.query(0, (result: AccountData[]) => {
                  this.accounts = result;
                  this.jisuan(this.accounts)
                }, true);
              }

              else if(this.searchcheck === 1){
                if(isNaN(Number(searchValue)) === false){
                  this.AccountTable.query(Number(searchValue), (result: AccountData[]) => {
                    this.accounts = result;
                  }, false);
                }else{
                  promptAction.showToast({ message: '请输入数字！' })
                }

              }else if(this.searchcheck === 2){
                this.AccountTable.queryDate(searchValue, (result: AccountData[]) => {
                  this.accounts = result;
                }, false);

              }else if(this.searchcheck === 3){
                this.AccountTable.queryremark(searchValue, (result: AccountData[]) => {
                  this.accounts = result;
                }, false);
              }

              else if(this.searchcheck === 4){
                if(searchValue === 'cy'){
                  searchValue = '餐饮';
                }else if(searchValue === 'gw'){
                  searchValue = '购物';
                }else if(searchValue === 'ry'){
                  searchValue = '日用';
                }else if(searchValue === 'jt'){
                  searchValue = '交通';
                }else if(searchValue === 'yd'){
                  searchValue = '运动';
                }else if(searchValue === 'yl'){
                  searchValue = '娱乐';
                }else if(searchValue === 'fs'){
                  searchValue = '服饰';
                }else if(searchValue === 'jia'){
                  searchValue = '家庭';
                }else if(searchValue === 'sj'){
                  searchValue = '社交';
                }else if(searchValue === 'lx'){
                  searchValue = '旅行';
                }else if(searchValue === 'xx'){
                  searchValue = '学习';
                }else if(searchValue === 'lw'){
                  searchValue = '礼物';
                }else if(searchValue === 'bg'){
                  searchValue = '办公';
                }else if(searchValue === 'qtzc'){
                  searchValue = '其他支出';
                }

                else if(searchValue === 'gz'){
                  searchValue = '工资';
                }else if(searchValue === 'lc'){
                  searchValue = '理财';
                }else if(searchValue === 'jl'){
                  searchValue = '奖励';
                }else if(searchValue === 'qtsr'){
                  searchValue = '其他收入';
                } else{
                  promptAction.showToast({ message: '请输入正确的检字组合！' })
                }
                this.AccountTable.queryType(searchValue, (result: AccountData[]) => {
                  this.accounts = result;
                }, false);
              }
            })
        }
        .width(CommonConstants.FULL_WIDTH)
        .padding({ left: $r('app.float.edge_size_M'), right: $r('app.float.edge_size_M') })
        .margin({ top: ('0vp'), bottom: ('2vp') })

        Row({space:6}) {
          Image($r('app.media.edit'))
            .width($r('app.float.component_size_S'))
            .aspectRatio(CommonConstants.FULL_SIZE)
            .bindMenu([
              {
                value:allmenu[0],
                action:()=>{
                  this.searchcheck = 1;
                  this.searchtype='金额查找'
                }
              },
              {
                value: allmenu[1],
                action: () => {
                  this.searchcheck = 2;
                  this.searchtype='时间查找'
                }
              },
              {
                value: allmenu[2],
                action: () => {
                  this.searchcheck = 3;
                  this.searchtype='备注查找'
                }
              },
              {
                value: allmenu[3],
                action: () => {
                  this.searchcheck = 4;
                  this.searchtype='类型查找'
                }
              },
            ])

          Text('查询类型:'+this.searchtype)
            .fontSize(18)

          Divider()
            .vertical(true)
            .height(15)

          Button() {
            Text('刷新')
              .fontSize(15)
              .fontColor(Color.White)
          }
          .width(80)
          .height(35)
          .backgroundColor($r('app.color.gold'))
          .onClick(()=>{
            this.AccountTable.query(0, (result: AccountData[]) => {
              this.accounts = result;
              this.jisuan(this.accounts)
            }, true);
          })

        }.justifyContent(FlexAlign.Center)


        Row() {
          List({ space: CommonConstants.FULL_SIZE, scroller: this.scrollerForList }) {
            ForEach(this.accounts, (item: AccountData) => {
              ListItem() {
                Row() {
                  Image(ImageList[item.typeText])
                    .width($r('app.float.component_size_M'))
                    .aspectRatio(CommonConstants.FULL_SIZE)
                    .margin({ right: $r('app.float.edge_size_MP') })

                  Column() {
                    Row({space:8}){
                      Text(item.typeText)
                        .height($r('app.float.component_size_SM'))
                        .fontSize($r('app.float.font_size_M'))

                    }
                    Row({space:8}) {
                      Text(item.Date)
                        .height($r('app.float.component_size_SM'))
                        .fontSize($r('app.float.font_size_M'))

                      if (item.remark === '') {
                        Text(`备注:无`)
                          .height($r('app.float.component_size_SM'))
                          .fontSize($r('app.float.font_size_M'))
                          .fontColor(Color.Gray)
                      }
                      else {
                        Text(`备注:${item.remark}`)
                          .height($r('app.float.component_size_SM'))
                          .fontSize($r('app.float.font_size_M'))
                          .fontColor(Color.Gray)
                      }
                    }
                  }.alignItems(HorizontalAlign.Start)

                  Blank()
                    .layoutWeight(1)

                  Text(item.accountType === 0 ? '-' + item.amount.toString() +'元' : '+' + item.amount.toString()+'元')
                    .fontSize(20)
                    .fontColor(item.accountType === 0 ? $r('app.color.pay_color') : $r('app.color.gain_color'))
                    .align(Alignment.End)
                    .flexGrow(CommonConstants.FULL_SIZE)
                    .onAppear(() => {
                      if(item.accountType === 1){
                        this.totalint = this.totalint + item.amount;
                      }else {
                        this.totalout = this.totalout + item.amount;
                      }
                    })
                }
                .width(CommonConstants.FULL_WIDTH)
                .padding({ left: $r('app.float.edge_size_M'), right: $r('app.float.edge_size_M') })
              }
              .backgroundColor(Color.White)
              .borderRadius($r('app.float.radius_size_M'))
              .swipeAction({ end: () => {
                this.itemEnd(this.index, item)
              }
              }) // 设置侧滑属性.
              .width(CommonConstants.FULL_WIDTH)
              .height($r('app.float.component_size_LM'))
              .onClick(() => {
                this.selectListItem(item);
                this.dialogController.open();
              })
            })
          }
          .height("71%")
          .width('100%')
          .borderRadius($r('app.float.radius_size_M'))

          Divider()
            .vertical(false)
            .height(15)
            .width(50)
            .opacity(0.3)
            .margin({left:8,right:8})

        }
        .width(CommonConstants.FULL_WIDTH)
        .padding({ left: $r('app.float.edge_size_M'), right: $r('app.float.edge_size_M') })
        .margin({ top:'2vp' })
      }
      .width(CommonConstants.FULL_WIDTH)
      .height(CommonConstants.FULL_HEIGHT)


      Button() {
        Image($r('app.media.add'))
      }
      .width(55)
      .height(55)
      .position({ x: CommonConstants.EDIT_POSITION_X, y: CommonConstants.EDIT_POSITION_Y })
      .onClick(() => {
        this.isInsert = true;
        this.newAccount = { id: 0, accountType: 0, typeText: '', amount: 0 ,Date:'',remark:''};
        this.dialogController.open();
      })
    }
    .width(CommonConstants.FULL_WIDTH)
    .height(CommonConstants.FULL_HEIGHT)
    .backgroundImage($r('app.media.bg2'))
    .backgroundImageSize(ImageSize.Cover)
  }
}