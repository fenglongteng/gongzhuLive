//
//  CustomCamerButton.m
//  ImagePicker
//
//  Created by fenglongteng on 16/6/30.
//
//

#import "CustomCamerButton.h"
#import "IBActionSheet.h"
#import "AppDelegate.h"
@interface CustomCamerButton()<IBActionSheetDelegate>
@property(nonatomic,strong) UIImagePickerController* picker;
@end

@implementation CustomCamerButton
//带picker的初始化方法
-(instancetype)initAddTargetVC:(UIViewController*)viewController AndSeltedCompleteHandle:(PickerSeletedImageBlock)block{
    self =   [super init];
    if (self) {
        _customVC = viewController;
        [self setTitle:@"图片选择器" forState:UIControlStateNormal] ;
        [self addTarget:self action:@selector(showImagePicker) forControlEvents:UIControlEventTouchUpInside];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.pickSeletedImageBlock = block;
    }
    
    return self;
}

-(void)showImagePicker{
    _picker = [[UIImagePickerController alloc]init];//创建
    _picker.delegate = self;//设置为托
    _picker.allowsEditing=YES;//允许编辑图片
    NSArray *array = @[@"相册",@"拍照"];
    [self showActionsSheetWithTions:array];
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    
    /*添加处理选中图像代码*/
    if (_pickSeletedImageBlock) {
        _pickSeletedImageBlock(image);
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage *image = info[@"UIImagePickerControllerEditedImage"];
    if (image) {
        if (_pickSeletedImageBlock) {
            _pickSeletedImageBlock(image);
        }
    }
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    /*添加代码，处理选中图像又取消的情况*/
    [picker dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - ibActionsSheet

/**
 *  显示操作栏
 */
- (void)showActionsSheetWithTions:(NSArray *)actions{
    IBActionSheet *sheet = [[IBActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitlesArray: actions];
    [sheet setFont:[UIFont systemFontOfSize:17]];
    [sheet setButtonTextColor:[UIColor blackColor]];
    [sheet showInView:[AppDelegate getAppdelegateWindow]];
}

/**
 *  actionSheet代理
 *
 *  @param actionSheet actionSheet description
 *  @param buttonIndex 按钮的下标
 */
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
            case 0:
        {
            _picker.sourceType =UIImagePickerControllerSourceTypePhotoLibrary;
            [_customVC presentViewController:_picker animated:YES completion:nil];
            
        }
            break;
            case 1:
        {
            _picker.sourceType =  UIImagePickerControllerSourceTypeCamera;
            [_customVC presentViewController:_picker animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
    
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end

