//
//  JQTextView.m
//  微博项目
//
//  Created by xxjqr on 16/4/15.
//  Copyright © 2016年 xxjqr. All rights reserved.
//

//#define JQTextViewFont [UIFont systemFontOfSize:16] //默认字体大小
#define JQMainScreenSize [UIScreen mainScreen].bounds.size
#define JQPlacehoderPadding 8 //提示语与边框的距离(上下左)

#import "AHHighlyAdaptiveTextView.h"

@interface AHHighlyAdaptiveTextView() {
    UILabel *_placehoderLbl;//提示框
}

@end

@implementation AHHighlyAdaptiveTextView

#pragma mark 生命周期方法
//- (instancetype)init{
//    self = [super init];
//    if (self){
//        //1.自我初始化
//        //->设置默认字体\提示字体
//        self.font=JQTextViewFont;
//        self.translatesAutoresizingMaskIntoConstraints = NO;
//        self.backgroundColor=[UIColor whiteColor];//默认背景色
//        self.contentMode = UIViewContentModeCenter;
//        self.layer.cornerRadius = 8;
//        self.placeHoder = @"JQTextView";//默认提示语
//        
//        //2.添加子控件
//        [self addSubView];
//
//        //3.监听textView文字通知
//        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
//    }
//    
//    return self;
//}



- (void)awakeFromNib{
    [super awakeFromNib];
    //1.自我初始化
    //->设置默认字体\提示字体
    self.translatesAutoresizingMaskIntoConstraints = NO;//允许autoLayout
    self.backgroundColor=[UIColor clearColor];//默认背景色
    self.layer.cornerRadius = 6;//圆角
    //2.添加子控件
    [self addSubView];
    
    //3.清空text:(可能在故事板中拖动的时候没有清空文本)
    self.text = @"";
    
    //3.监听textView文字通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textDidChanges) name:UITextViewTextDidChangeNotification object:self];
    
    //4.监听键盘的弹起和收缩
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
}


- (void)dealloc{
    //移除所有通知
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


#pragma mark 控件相关

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self setupFrame];

    [self autoFitHeight];
}

- (void)addSubView{
    //1.添加子控件
    _placehoderLbl=[[UILabel alloc]init];
    //->设置默认提示文字
    _placehoderLbl.text=(self.customPlaceHoder.length>0?self.customPlaceHoder:@"JQTextView默认提示");
    //->默认字体 == textView字体
    _placehoderLbl.font=self.font;
    //->设置默认字体颜色
    _placehoderLbl.textColor=[UIColor lightGrayColor];
    //->设置默认字体透明度
    _placehoderLbl.alpha=0.8;
    //->提示框也可以多行
    _placehoderLbl.numberOfLines=0;
    
    [self addSubview:_placehoderLbl];
}


/**
 *  设置提示标签的frame
 */
- (void)setupFrame{
    CGRect frame = self.bounds;
    frame.origin.x = JQPlacehoderPadding;
    frame.size.width -= 2*JQPlacehoderPadding;
    _placehoderLbl.frame = frame;
    /*
     为了提示语和textView周围有有一定的距离
     提示标签的x和weight做了调整
     */
}

#pragma mark 其他方法
/**
 *  通过字体和最大尺寸计算文字所占size
 */
-(CGSize)sizeWithString:(NSString *)str Font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

/**
 *  自适应高度
 */
- (void)autoFitHeight{
    CGFloat curW = self.frame.size.width;
    CGFloat H = 0;
    if (_placehoderLbl.hidden) { //如果提示语隐藏了,那么使用textView的高度赋值高度约束
        if (self.contentSize.height<60) {
             self.constrainH1.constant = self.contentSize.height;
        }else{
           
        }
       

    }
    else{
        //约束高度 == 提示语文字高度+2*提示语跟textView之间的距离
        H = [self sizeWithString:_placehoderLbl.text Font:_placehoderLbl.font maxSize:CGSizeMake(curW, MAXFLOAT)].height;
        self.constrainH1.constant = H+2*JQPlacehoderPadding;
    }
    
    /*
     为什么不直接都用self.contentSize.height呢?
     因为如果提示语超过了一行的话,那么self.contentSize.height得到的也只是一行内容
     应占的高度
     */
    [self layoutIfNeeded];
}


#pragma mark 点击/响应通知方法
/**
 *  每一次文本改变时调用
 */
- (void)textDidChanges{
    //提示标签隐藏与否
    _placehoderLbl.hidden= self.text.length>0?YES:NO;
    
    //自适应高度
    [self autoFitHeight];
    
    //滚动到最后一行文字
    [self scrollRangeToVisible:NSMakeRange(self.text.length, 1)];
    
    if (self.text.length >= 80) {
        self.text = [self.text substringWithRange:NSMakeRange(0, 79)];
    }
}

- (void)keyBoardChange:(NSNotification *)note{
    // 0.取出键盘动画的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 1.取得键盘最后的frame
    CGRect keyboardFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // 2.计算控制器的view需要平移的距离
    CGFloat transformY = keyboardFrame.size.height;
    
    if (self.setUpViewBlock) {
        self.setUpViewBlock(duration,transformY);
    }
  
 
}


#pragma mark 公开方法
- (void)setCustomPlaceHoder:(NSString *)customPlaceHoder{
    _customPlaceHoder = customPlaceHoder;
    _placehoderLbl.text = [customPlaceHoder copy];
    
    /*为什么设置了提示语后,不调用autoFitHeight方法来更新高度呢?
     因为autoLayoutSubviews方法里面调用了,而且autoLayoutSubviews
     是在当前方法的后面被调用*/
}

- (void)setCustomPlaceHoderColor:(UIColor *)customPlaceHoderColor
{
    _customPlaceHoderColor = customPlaceHoderColor;
    _placehoderLbl.textColor = customPlaceHoderColor;
}

#pragma mark 重写方法
- (void)setFont:(UIFont *)font{
    [super setFont:font];
    _placehoderLbl.font=font;
    
}

/**
 *  直接给textField赋值时使用
 */
- (void)setText:(NSString *)text{
    [super setText:text];
    [self textDidChanges];
}
@end
