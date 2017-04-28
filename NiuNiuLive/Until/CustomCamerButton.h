//
//  CustomCamerButton.h
//  ImagePicker
//
//  Created by fenglongteng on 16/6/30.
//
//

#import <UIKit/UIKit.h>

typedef void (^PickerSeletedImageBlock)(UIImage*);
@interface CustomCamerButton : UIButton<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
//xib是使用
//当前window上显示的控制器
@property(nonatomic,weak)UIViewController *customVC;
//选择图片回调
@property(nonatomic,copy)PickerSeletedImageBlock pickSeletedImageBlock;
//手动初始化使用
//初始化
-(instancetype)initAddTargetVC:(UIViewController*)viewController AndSeltedCompleteHandle:(PickerSeletedImageBlock)block;
//开启拍照+照片选择功能
-(void)showImagePicker;
@end
