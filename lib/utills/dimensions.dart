import 'package:get/get.dart';


/// this class provides the different dimensions used arround the application
/// like widths, height, raduis and ...etc
class Dimensions {
  static double screenHeight = Get.context!.height;//(360)
  static double screenWidth = Get.context!.width;//(360)
  ///getting the scale factor fo the pageView
  /// 752(phone height)/260(pageview hieght on debuging phone) = 2.89 
  
  static double pageViewContainer = screenHeight/2.8;
  /// similarly we do for text constainer in the pageView 
  /// 752/120(text container height) = 6.27
  static double pageViewTextContainer = screenHeight/6.27;
  ///similarly for the Container containing both containers
  static double pageView = screenHeight/2.35;
  // dynamic height
  static double height9 = screenHeight/83.55; //(752/9)
  static double height10 = screenHeight/75.2; //(752/10)
  static double height18 = screenHeight/41.77; //(752/18)
  static double height15 = screenHeight/50.13; //(752/15)
  static double height20 = screenHeight/37.6; //(752/20)
  static double height45 = screenHeight/16.71; //(752/45)
  static double height30 = screenHeight/25.067; //(752/30)


  //dynamic width
  static double width3 = screenHeight/250.667; //(752/3)
  static double width5 = screenHeight/150.4; //(752/5)
  static double width10 = screenHeight/75.2; //(752/10)
  static double width18 = screenHeight/41.77; //(752/18)
  static double width15 = screenHeight/50.13; //(752/15)
  static double width20 = screenHeight/37.6; //(752/20)
  static double width30 = screenHeight/25.067; //(752/30)
  static double width45 = screenHeight/16.71; //(752/45)
  
  // font size
  static double font12 = screenHeight/62.67; //(752/12)
  static double font16 = screenHeight/47; //(752/16)
  static double font20 = screenHeight/37.6; //(752/20)
  static double font26 = screenHeight/28.92; //(752/26)

  // list view size
  static double listViewIm = screenHeight/7.52;//(752/100)
  static double listViewText = screenHeight/7.52;//(752/100)
  
  //radius
  static double radius5 = screenHeight/150.4; //(752/5)
  static double radius15 = screenHeight/50.13; //(752/15)
  static double radius20 = screenHeight/37.6; //(752/20)
  static double radius30 = screenHeight/25.1; //(752/30)

  static double dimension9 = screenHeight/83.55; //(752/9) 
   
  static double iconSize24 = screenHeight/31.33; //(752/24)
  static double iconSize16 = screenHeight/47; //(752/16) 

  //Popular food
  static double popularFoodImgSize = screenHeight/2.15;//(752/350)

}