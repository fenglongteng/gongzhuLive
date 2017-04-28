//
//  AHLiveSenderMessageToolView.m
//  NiuNiuLive
//
//  Created by anhui on 17/3/27.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHLiveSenderMessageToolView.h"

@interface AHLiveSenderMessageToolView ()

@property (nonatomic,strong)UITextField *messageTextField;

@end

@implementation AHLiveSenderMessageToolView

- (id)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];

        [self addSubview:self.messageTextField];
    }
    return self;
}

- (void)layoutSubviews{

    [super layoutSubviews];
    
    self.messageTextField.frame = CGRectMake(14, 5, self.width-22, self.height-10);
}

- (UITextField*)messageTextField{

    if (!_messageTextField) {
        _messageTextField = [[UITextField alloc]init];
        _messageTextField.rightViewMode = UITextFieldViewModeAlways;
        _messageTextField.placeholder = @"说点什么吧...";
        _messageTextField.font = [UIFont systemFontOfSize:13.0];
    }
    return _messageTextField;
}

@end
