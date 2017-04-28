//
//  AHSearchViewController.m
//  NiuNiuLive
//
//  Created by anhui on 17/3/16.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHSearchViewController.h"
#import "AHSearchMainView.h"
#import "AHAddressListViewController.h"
#import "AHWeiboViewController.h"
#import "AHNearyViewController.h"
#import "UIImage+extension.h"
#import "ResultTableViewController.h"
#import "AHPersonInfoVC.h"
@interface AHSearchViewController ()<AHSearchMainViewDelegate,UISearchBarDelegate>

/**
 选择好友类型
 */
@property (nonatomic,strong)AHSearchMainView *searchMainView;

/**
 顶部view
 */
@property (nonatomic,strong)UIView *searchNavBar;

/**
 searchBar
 */
@property (nonatomic,strong)UISearchBar *searchBar;

//搜索结果列表
@property(nonatomic,strong) ResultTableViewController * resultVC;
//搜索结果数据源
@property(nonatomic,strong) NSMutableArray * resulteDataSource;
@end

@implementation AHSearchViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.searchBar becomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xffffff);
    [self createSearchView];
    [self.view addSubview:self.searchNavBar];
    [self.view bringSubviewToFront:self.searchNavBar];
    //搜索相关
    _resultVC = [[ResultTableViewController alloc] initWithStyle:UITableViewStylePlain];
    _resultVC.searchBar = self.searchBar;
    self.resulteDataSource = [[NSMutableArray alloc] init];
    WeakSelf;
    [_resultVC cellPressedWithBlock:^(NSString * userid) {
        AHPersonInfoVC *personInfoVC = [[AHPersonInfoVC alloc]initWithUserId:userid];
        [weakSelf.navigationController pushViewController:personInfoVC animated:YES];
    }];
}

- (void)createSearchView{
    self.searchMainView = [[AHSearchMainView alloc]initWithFrame:CGRectMake(0, 59+navHeight, screenWidth, 110)];
    self.searchMainView.delegate = self;
    [self.view addSubview:self.searchMainView];
}

- (BOOL)fd_prefersNavigationBarHidden{
    
    return YES;
}

- (UIView *)searchNavBar{
    if (_searchNavBar == nil) {
        _searchNavBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, navHeight)];
        _searchNavBar.backgroundColor = UIColorFromRGB(0xecedef);
        self.searchBar.frame = CGRectMake(8, 26, screenWidth - 16, 28);
        [_searchNavBar addSubview:self.searchBar];
    }
    return _searchNavBar;
}

- (UISearchBar *)searchBar{
    if (_searchBar == nil) {
        _searchBar = [[UISearchBar alloc]init];
        _searchBar.backgroundColor = [UIColor whiteColor];
        _searchBar.searchBarStyle = UISearchBarStyleMinimal;
        UIImage *imageBackground = [UIImage imageWithColor:[UIColor whiteColor] imageSize:CGSizeMake(screenWidth - 16, 28)];
        [_searchBar setSearchFieldBackgroundImage:imageBackground forState:UIControlStateNormal];
        _searchBar.showsCancelButton = NO;
        [_searchBar setImage:[UIImage imageNamed:@"btn_news_search0"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
        _searchBar.showsCancelButton = YES;
        _searchBar.delegate = self;
        _searchBar.placeholder = @"搜索用户昵称或ID";
        _searchBar.tintColor = [UIColor blueColor];
        UITextField *txfSearchField = [_searchBar valueForKey:@"_searchField"];
        txfSearchField.font = [UIFont systemFontOfSize:12];
        UIButton *cancelBtn = [_searchBar valueForKeyPath:@"cancelButton"];
        cancelBtn.enabled = YES;
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _searchBar;
}

#pragma mark -AHSearchMainViewDelegate

- (void)searchView:(AHSearchBtnView *)searchButtom didSelect:(NSInteger)tag{
    if (tag == 1) { //通讯录
        AHAddressListViewController *addressListVC = [[AHAddressListViewController alloc]initWithNibName:@"AHAddressListViewController" bundle:nil];
        [self.navigationController pushViewController:addressListVC animated:YES];
    }
    if (tag == 2) { //微博好友
        AHWeiboViewController *weiboVC = [[AHWeiboViewController alloc]initWithNibName:@"AHWeiboViewController" bundle:nil];
        [self.navigationController pushViewController:weiboVC animated:YES];
    }
    if (tag == 3) { //附近的人
        AHNearyViewController *nearyVC = [[AHNearyViewController alloc]initWithNibName:@"AHNearyViewController" bundle:nil];
        [self.navigationController pushViewController:nearyVC animated:YES];
    }
}

#pragma UISearchBarDelegate

//搜索框中的内容发生改变时 回调（即要搜索的内容改变）
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (self.searchBar.text.length == 0){
        [self setSearchControllerHidden:YES];
    }else{
        [self setSearchControllerHidden:NO];
    }
    if (searchText.length > 0) {
        //网络搜索
        [self reloadSearchDatasource:searchText];
    }
}

//搜索框开始编辑
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    _resultVC.view.frame = CGRectMake(0, 108, CGRectGetWidth(self.view.bounds), 0);
    [self.view addSubview:_resultVC.view];
    //再次进行编辑且searchBar有内容时调用
    if (![self.searchBar.text  isEqual: @""]) {
        //网络搜索
        [self reloadSearchDatasource:self.searchBar.text];
        [self setSearchControllerHidden:NO];
    }
}

//点击搜索框上的 取消按钮时 调用
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self setSearchControllerHidden:YES];
    [self.navigationController popViewControllerAnimated:YES];
    
}

//搜索12字数限制
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (range.length+range.location > searchBar.text.length) {
        return NO;
    }
    NSUInteger newLength = [searchBar.text length]+[text length] -range.length;
    return newLength <= 12;
}

//隐藏列表
- (void)setSearchControllerHidden:(BOOL)hidden {
    NSInteger height = hidden ? 0: (CGRectGetHeight(self.view.bounds) - 64);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    
    [_resultVC.view setFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.bounds), height)];
    [UIView commitAnimations];
}

- (void)reloadSearchDatasource:(NSString *)searchKey{
    UsersFindOtherRequest * findUser = [[UsersFindOtherRequest alloc] init];
    findUser.key = searchKey;
    findUser.skip = 1;
    findUser.limit = 20;
    findUser.type = UsersFindOtherRequest_FindType_Search;
    [[AHTcpApi shareInstance] requsetMessage:findUser classSite:@"Users" completion:^(id response, NSString *error) {
        UsersFindOtherResponse * users = (UsersFindOtherResponse *)response;
        if (users.result == UsersLoginResponse_UserLoginResult_UserLoginResultSucceeded) {
            self.resulteDataSource = [NSMutableArray arrayWithArray:users.findUsersArray];
            self.resultVC.dataSource = self.resulteDataSource;
            [self.resultVC.tableView reloadData];
            [self.resulteDataSource removeAllObjects];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
