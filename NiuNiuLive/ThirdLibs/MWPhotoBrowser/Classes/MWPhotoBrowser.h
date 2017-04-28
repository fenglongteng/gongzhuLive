//
//  MWPhotoBrowser.h
//  MWPhotoBrowser
//
//  Created by Michael Waterfall on 14/10/2010.
//  Copyright 2010 d3i. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWPhoto.h"
#import "MWPhotoProtocol.h"
#import "MWCaptionView.h"
#import "AHSetAttentionOfPhotoAlbum.h"
// Debug Logging
#if 0 // Set to 1 to enable debug logging
#define MWLog(x, ...) NSLog(x, ## __VA_ARGS__);
#else
#define MWLog(x, ...)
#endif

@class MWPhotoBrowser;

@protocol MWPhotoBrowserDelegate <NSObject>

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser;
- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index;

@optional

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index;
- (MWCaptionView *)photoBrowser:(MWPhotoBrowser *)photoBrowser captionViewForPhotoAtIndex:(NSUInteger)index;
- (NSString *)photoBrowser:(MWPhotoBrowser *)photoBrowser titleForPhotoAtIndex:(NSUInteger)index;
- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index;
- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser actionButtonPressedForPhotoAtIndex:(NSUInteger)index;
- (BOOL)photoBrowser:(MWPhotoBrowser *)photoBrowser isPhotoSelectedAtIndex:(NSUInteger)index;
- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index selectedChanged:(BOOL)selected;
- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser;

@end

#pragma mark  删除照片block和设置头像block  业务逻辑

typedef BOOL (^DeletePhotoBlock)(id info);
typedef BOOL (^SetHeadBlock)(id info);
typedef BOOL (^AttentionHandleBlock)(id info);

@interface MWPhotoBrowser : UIViewController <UIScrollViewDelegate, UIActionSheetDelegate>
@property (nonatomic, weak) IBOutlet id<MWPhotoBrowserDelegate> delegate;
@property (nonatomic) BOOL zoomPhotosToFill;
@property (nonatomic) BOOL displayNavArrows;
@property (nonatomic) BOOL displayActionButton;
@property (nonatomic) BOOL displaySelectionButtons;
@property (nonatomic) BOOL alwaysShowControls;
@property (nonatomic) BOOL enableGrid;
@property (nonatomic) BOOL enableSwipeToDismiss;
@property (nonatomic) BOOL startOnGrid;
@property (nonatomic) BOOL autoPlayOnAppear;
@property (nonatomic) BOOL dismissWithTap;
@property (nonatomic) NSUInteger delayToHideElements;
@property (nonatomic, readonly) NSUInteger currentIndex;

@property (nonatomic) BOOL showPageControl;
@property (nonatomic,strong) UIPageControl *pageControl;

// Customise image selection icons as they are the only icons with a colour tint
// Icon should be located in the app's main bundle
@property (nonatomic, strong) NSString *customImageSelectedIconName;
@property (nonatomic, strong) NSString *customImageSelectedSmallIconName;

#warning 添加的view(因为原来的需要navigation支持),而修改后不需要navigation支持

/**
 *  是否需要显示自己定义的
 */
@property (nonatomic) BOOL showCustomView;

/**
 *  头部view
 */
@property (nonatomic) UIView *headView;

/**
 *  底部view
 */
@property (nonatomic) UIView *bottomView;

/**
 *  关闭btn
 */
@property (nonatomic) UIButton *doneBtn;

/**
 *  删除按钮
 */
@property (nonatomic) UIButton *deleteBtn;

/**
 *  图片保存到相册
 */
@property (nonatomic) UIButton *saveSystemPhoto;

#pragma mark  自己添加的属性 依赖于项目
/**
 图片在数组中的位置
 */
@property(nonatomic,strong)UILabel *currentIndexLabel;

/**
 是否是自己的
 */
@property(nonatomic,assign) BOOL isOwn;

/**
 设置头像按钮
 */
@property(nonatomic,strong)UIButton *setHeadImageBt;

/**
 关注view
 */
@property(nonatomic,strong)AHSetAttentionOfPhotoAlbum *setAttentionView;

/**
 关注block
 */
@property(nonatomic,copy)AttentionHandleBlock attentionBlock;

/**
 删除照片block
 */
@property(nonatomic,copy)DeletePhotoBlock deletePhotoBlock;

/**
 设置头像block
 */
@property(nonatomic,copy)SetHeadBlock setHeadBlock;

#pragma mark 方法

// Init
- (id)initWithPhotos:(NSArray *)photosArray;
- (id)initWithDelegate:(id <MWPhotoBrowserDelegate>)delegate;

// Reloads the photo browser and refetches data
- (void)reloadData;

// Set page that photo browser starts on
- (void)setCurrentPhotoIndex:(NSUInteger)index;

// Navigation
- (void)showNextPhotoAnimated:(BOOL)animated;
- (void)showPreviousPhotoAnimated:(BOOL)animated;
//关闭
- (void)closeSelf;
@end
