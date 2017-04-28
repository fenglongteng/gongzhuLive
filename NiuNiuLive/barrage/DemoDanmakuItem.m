//
//  DemoDanmakuItem.m
//  FXDanmakuDemo
//
//  Created by ShawnFoo on 2017/2/13.
//  Copyright © 2017年 ShawnFoo. All rights reserved.
//

#import "DemoDanmakuItem.h"
#import "DemoDanmakuItemData.h"
#import "UIImageView+CornerRadius.h"
#import "UIImage+extension.h"
@interface DemoDanmakuItem ()

@property (nonatomic, readonly) CGFloat avatarLength;

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *avatarWidthConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *avatarHeightConst;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backgroudImageView;

@end

@implementation DemoDanmakuItem

+ (NSString *)reuseIdentifier {
    return @"DemoItemIdentifier";
}

+ (CGFloat)itemHeight {
    return 40;
}

- (CGFloat)avatarLength {
    return 30;
}

#pragma mark - Overrides
#pragma mark LifeCycle
- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithReuseIdentifier:[[self class] reuseIdentifier]];
}

// if you custom your item through xib
- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupSubViews];
}

#pragma mark Reuse
- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.avatarImageView.image = nil;
    self.descLabel.text = nil;
}

- (void)itemWillBeDisplayedWithData:(DemoDanmakuItemData *)data {
    static UIImage *image =  nil;
    if (!image) {
        image = [UIImage imageWithColor:[UIColor blackColor] imageSize:CGSizeMake(18, 18)];
        image =  [image imageByRoundCornerRadius:9];
        image = [image stretchableImageWithLeftCapWidth:9 topCapHeight:9];
    }
    if (data.desc.length>0) {
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:data.avatarName] placeholderImage:DefaultHeadImage];
        self.descLabel.text = data.desc;
        self.backgroudImageView.image = image;
    }else{
        self.avatarImageView.image = nil;
        self.backgroudImageView.image = nil;
        self.descLabel.text = @"";
    }
}

#pragma mark - Setup
- (void)setupSubViews {
    [self.avatarImageView zy_cornerRadiusAdvance:self.avatarLength/2.0 rectCornerType:UIRectCornerAllCorners];
    self.descLabel.textColor = [UIColor whiteColor];
    self.descLabel.backgroundColor = [UIColor clearColor];
    self.descLabel.textAlignment = NSTextAlignmentLeft;
    [self.avatarImageView zy_attachBorderWidth:1 color:[UIColor blackColor]];
}

@end
