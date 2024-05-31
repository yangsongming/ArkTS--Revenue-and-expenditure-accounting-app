import CommonConstants from '../common/constants/CommonConstants'
@Component
export default struct MeComponent {
build(){
    Column() {

      Text(`作者信息-欢迎联系作者`)
        .fontSize(30)
        .fontWeight(500)
        .margin({top:80})

      Column() {

      }
      .backgroundImage($r('app.media.aboutmebg'))
      .width('80%')
      .height('80%')
      .backgroundImageSize(ImageSize.Cover)

    }
    .backgroundColor("#E6E6FA")
    .width(CommonConstants.FULL_WIDTH)
    .height(CommonConstants.FULL_HEIGHT)
}
}