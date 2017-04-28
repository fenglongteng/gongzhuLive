//
//  createLiveHeader.m
//  NiuNiuLive
//
//  Created by Zhangwenmin on 17/3/24.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "createLiveHeader.h"

@interface createLiveHeader()<UISearchBarDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation createLiveHeader

- (void)initWithHeaderViewFrame:(CGRect)frame{
    self.frame = frame;
    self.passwordText.delegate = self;
    //搜索框相关
    self.searchBar.delegate = self;
    if ([self.searchBar isKindOfClass:NSClassFromString(@"UIView")] && self.searchBar.subviews.count > 0) {
        UIView *chaidView = [self.searchBar.subviews objectAtIndex:0];
        if (chaidView.subviews.count > 0) {
            [[chaidView.subviews objectAtIndex:0] removeFromSuperview];
        }
    }
}

#pragma mark UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (self.changeBlock) {
        self.changeBlock(searchText);
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
    if (self.cancelSearchBlock) {
        self.cancelSearchBlock();
    }
}

#pragma mark UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == self.passwordText) {
        if (string.length == 0) return YES;
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 12) {
            return NO;
        }
    }
    
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == self.passwordText) {
        if (textField.text.length > 12) {
            textField.text = [textField.text substringToIndex:12];
        }
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
