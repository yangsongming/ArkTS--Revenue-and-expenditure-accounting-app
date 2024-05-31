// @ts-nocheck

import AccountComponent, {AccountComponent} from '../view/AccountComponent'
import ChartComponent, {ChartComponent} from '../view/ChartComponent'
import ManageComponent, {ManageComponent} from '../view/ManageComponent'
import MeComponent, {MeComponent} from '../view/MeComponent'

@Entry
@Component
struct TabContentExample {
  @State fontColor: string = '#182431'
  @State selectedFontColor: string = '#ffa500'
  @State currentIndex: number = 0
  private controller: TabsController = new TabsController()

  @Builder TabBuilder0(index: number) {
    Column() {
      Image(this.currentIndex === index ? $r('app.media.home1') : $r('app.media.home') )
        .width(30)
        .height(30)
        .margin({ bottom: 4 })
        .objectFit(ImageFit.Contain)
      Text(`主页`)
        .fontColor(this.currentIndex === index ? this.selectedFontColor : this.fontColor)
        .fontSize(15)
        .fontWeight(500)
        .lineHeight(14)
    }.width('100%')
  }
  @Builder TabBuilder1(index: number) {
    Column() {
      Image(this.currentIndex === index ? $r('app.media.chart1') : $r('app.media.chart') )
        .width(30)
        .height(30)
        .margin({ bottom: 4 })
        .objectFit(ImageFit.Contain)
      Text(`图表`)
        .fontColor(this.currentIndex === index ? this.selectedFontColor : this.fontColor)
        .fontSize(15)
        .fontWeight(500)
        .lineHeight(14)
    }.width('100%')
  }


  @Builder TabBuilder2(index: number) {
    Column() {
      Image(this.currentIndex === index ? $r('app.media.manage1') : $r('app.media.manage'))
        .width(30)
        .height(30)
        .margin({ bottom: 4 })
        .objectFit(ImageFit.Contain)
      Text(`管理`)
        .fontColor(this.currentIndex === index ? this.selectedFontColor : this.fontColor)
        .fontSize(15)
        .fontWeight(500)
        .lineHeight(14)
    }.width('100%')
  }

  @Builder TabBuilder3(index: number) {
    Column() {
      Image(this.currentIndex === index ? $r('app.media.me1') : $r('app.media.me') )
        .width(30)
        .height(30)
        .margin({ bottom: 4 })
        .objectFit(ImageFit.Contain)
      Text(`作者`)
        .fontColor(this.currentIndex === index ? this.selectedFontColor : this.fontColor)
        .fontSize(15)
        .fontWeight(500)
        .lineHeight(14)
    }.width('100%')
  }


  build() {
    Column() {
      Tabs({ barPosition: BarPosition.End, controller: this.controller }) {
        TabContent() {
          AccountComponent()
        }.tabBar(this.TabBuilder0(0))

        TabContent() {
          ChartComponent()
        }.tabBar(this.TabBuilder1(1))

        TabContent() {
          ManageComponent()
        }.tabBar(this.TabBuilder2(2))

        TabContent() {
          MeComponent()
        }.tabBar(this.TabBuilder3(3))

      }
      .vertical(false)
      .barHeight(56)
      .onChange((index: number) => {
        this.currentIndex = index
      })
      .width('100%')
      .height('100%')
      .backgroundColor(Color.White)
    }
    .width('100%')
  }
}