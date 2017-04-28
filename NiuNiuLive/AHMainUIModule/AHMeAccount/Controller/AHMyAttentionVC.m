//
//  AHMyAttentionVC.m
//  NiuNiuLive
//
//  Created by ComAnvei on 17/3/24.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHMyAttentionVC.h"
#import "AHAttentionCell.h"
#import "AHSearchViewController.h"
#import "AHPersonInfoVC.h"
#import "PPGetAddressBook.h"
#import "AHNetworkMonitor.h"
#import "AHPinyinSort.h"
#import "ResultTableViewController.h"
#import "YYModel.h"
#import "NSString+Tool.h"
typedef NS_ENUM(NSInteger, SortStyle)  {
    SortStyleByCharace= 0,//依靠首字母排序
    SortStyleByTime,//依靠时间排序
} ;

@interface AHMyAttentionVC ()<UISearchBarDelegate,UISearchBarDelegate>
//排序方式的segmentControl
@property(nonatomic,strong)UISegmentedControl *sortStyleSegmentControl;
//排序方式
@property(nonatomic,assign)SortStyle sortStyle;
//搜索条
@property(nonatomic,strong)UISearchBar *searchBar;
//搜索结果数据源
@property(nonatomic,strong) NSMutableArray * resulteDataSource;
//搜索结果列表
@property(nonatomic,strong) ResultTableViewController * resultVC;
//本地我关注的人
@property(nonatomic,strong)NSMutableArray *MyAttentionOfLocalityArray;

//我关注的  拼音排序
@property(nonatomic,strong)NSMutableArray *pinYinKey;
@property(nonatomic,strong)NSMutableDictionary *attentionDic;

//特别关注
@property(nonatomic,strong)NSMutableArray *specialAttentionArray;
//时间排序
@property(nonatomic,strong)NSMutableArray *timeSortArray;

@end

@implementation AHMyAttentionVC

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(instancetype)intWithSourceArray:(NSMutableArray*)sourceArray{
    if ( [super init]) {
        self.sourceArray = sourceArray;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpView];
    [self getNewSourceArray];
    self.MyAttentionOfLocalityArray = [[AHPersonInfoManager manager].getMyLikeArray mutableCopy];
    //接受特别关注通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reload) name:SepecialAttention object:nil];
    // Do any additional setup after loading the view.
}

-(void)reload{
    [self GetSpecialAttention];
}

#pragma mark 数据方面

-(void)getNewSourceArray{
    self.skip = 0;
    //    [self simulatedData];
    if ([AHNetworkMonitor monitorNetwork].networkStatus ==0) {
        self.sourceArray = [[AHPersonInfoManager manager].getMyLikeArray mutableCopy];
        [self.listTableView.mj_header endRefreshing];
        [self pinyinSort:self.sourceArray];
    }else{
        [self getAttetionMe];
    }
}

//模拟数据
-(void)simulatedData{
    NSArray *array = @[@"我靠",@"你日",@"打印",@"啊",@"比",@"想",@"张",@"里",@"哇",@"好",@"哦",@"个",@"额",@"才"];
    for (int i = 0; i<10; i++) {
        UsersGetMeLikeUserInfoResponse_MeLikeUser *model = [[UsersGetMeLikeUserInfoResponse_MeLikeUser alloc]init];
        model.nickName =array[i];
        model.likeTimestamp = i;
        [self.sourceArray addObject:model];
    }
    [self pinyinSort:self.sourceArray];
}

-(void)getMoreSourceArray{
    self.skip++;
    //       [self simulatedData];
    if ([AHNetworkMonitor monitorNetwork].networkStatus ==0) {
        [self.listTableView.mj_footer endRefreshing];
    }else{
        [self getAttetionMe];
    }
}

//获取关注列表
-(void)getAttetionMe{
    UsersGetMeLikeUserInfoRequest *attentionMeRequest = [[UsersGetMeLikeUserInfoRequest alloc]init];
    attentionMeRequest.skip = self.skip*self.limit;
    attentionMeRequest.limit = self.limit;
    attentionMeRequest.online = NO;
    attentionMeRequest.userId = [AHPersonInfoManager manager].getInfoModel.userId;
    [[AHTcpApi shareInstance]requsetMessage:attentionMeRequest classSite:UsersClassName completion:^(id response, NSString *error) {
        [self.listTableView.mj_header endRefreshing];
        [self.listTableView.mj_footer endRefreshing];
        UsersGetMeLikeUserInfoResponse *attentionMeRespose = response;
        if (attentionMeRespose.result == 0 && attentionMeRespose.meLikeUserArray_Count>0) {
            if (self.skip == 0) {
                [self.sourceArray removeAllObjects];
            }
            [self.sourceArray addObjectsFromArray: attentionMeRespose.meLikeUserArray];
            
        }else{
            if (self.skip != 0) {
                [self.listTableView.mj_footer resetNoMoreData];
            }
        }
        if (_sortStyle == SortStyleByTime) {
            [self.listTableView ah_reloadData];
        }else{
            [self MyAttentionDataLocality:self.sourceArray];
            [self pinyinSort:self.sourceArray];
            [self GetSpecialAttention];
        }
        
    }];
}

//关注本地化
-(void)MyAttentionDataLocality:(NSArray*)attentArray{
    NSArray *myAttentionArray = [AHPersonInfoManager manager].getMyLikeArray;
    if (myAttentionArray.count<attentArray.count) {
        myAttentionArray = attentArray;
        [[AHPersonInfoManager manager]setMyLikeArray:[myAttentionArray mutableCopy]];
        self.MyAttentionOfLocalityArray = [attentArray mutableCopy];
    }
}

#pragma mark setUpView

-(void)setUpView{
    [self createTableView:UITableViewStyleGrouped andFrame:CGRectMake(0, 0, screenWidth, screenHeight - 64)];
    [self setLineViewColor:self.view.backgroundColor];
    [self.listTableView registerNib:[UINib nibWithNibName:@"AHAttentionCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    //设置侧边栏快捷索引颜色
    if ([self.listTableView respondsToSelector:@selector(setSectionIndexColor:)]) {
        /** 背景色 */
        self.listTableView.sectionIndexBackgroundColor = [UIColor clearColor];
        /** 字体颜色 */
        self.listTableView.sectionIndexColor = [UIColor darkGrayColor];
    }
    [self setTitleView:self.sortStyleSegmentControl];
    [self setRightButtonBarItemTitle:@"添加" titleColor:UIColorFromRGB(0xb434fe) target:self action:@selector(bt_addAction)];
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 50)];
    headView.backgroundColor = [UIColor whiteColor];
    [headView addSubview:self.searchBar];
    self.searchBar.center = headView.center;
    [self.listTableView setTableHeaderView:headView];
    //搜索相关
    _resultVC = [[ResultTableViewController alloc] initWithStyle:UITableViewStylePlain];
    self.resulteDataSource = [[NSMutableArray alloc] init];
    _resultVC.searchBar = self.searchBar;
    [_resultVC cellPressedWithBlock:^(NSString * userid) {
        AHPersonInfoVC *personInfoVC = [[AHPersonInfoVC alloc]initWithUserId:userid];
        [self.navigationController pushViewController:personInfoVC animated:YES];
    }];
}

//添加用户
-(void)bt_addAction{
    AHSearchViewController *searchVC = [[AHSearchViewController alloc]init];
    [self.navigationController pushViewController: searchVC animated:YES];
}

#pragma mark -搜索

//搜索条
-(UISearchBar*)searchBar{
    if (!_searchBar) {
        //搜索栏
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(8, 5, screenWidth - 16, 30 )];
        _searchBar.searchBarStyle = UISearchBarStyleMinimal;
        UIImage *image =[UIImage imageNamed:@"bg_qlx_searchbg.png"];
        UIImage *imageBackgroud = [image resizableImageWithCapInsets:UIEdgeInsetsMake(17, 17, 17, 17) resizingMode:UIImageResizingModeStretch];
        [_searchBar setSearchFieldBackgroundImage:imageBackgroud forState:UIControlStateNormal];
        _searchBar.showsCancelButton = NO;
        //    [_searchBar setContentMode:UIViewContentModeLeft];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"搜索";
        _searchBar.tintColor = [UIColor blueColor];
        //搜索图片
        [_searchBar setImage:[UIImage imageNamed:@"btn_news_search0"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    }
    return _searchBar;
}

//搜索框开始编辑
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    //这里改变坐标并没有卵用呢
    _resultVC.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 0);
    [self.listTableView addSubview:_resultVC.view];
    //再次进行编辑且searchBar有内容时调用
    if (![self.searchBar.text  isEqual: @""]) {
        //搜索
        [self localSearch:self.searchBar.text];
        [self setSearchControllerHidden:NO];
    }
}

//搜索框中的内容发生改变时 回调（即要搜索的内容改变）
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (self.searchBar.text.length == 0){
        [self setSearchControllerHidden:YES];
    }else{
        [self setSearchControllerHidden:NO];
    }
        //本地搜索
        [self localSearch:searchText];
  
}

//搜索12字数限制
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (range.length+range.location > searchBar.text.length) {
        return NO;
    }
    NSUInteger newLength = [searchBar.text length]+[text length] -range.length;
    return newLength <= 12;
}

//本地搜索
-(void)localSearch:(NSString*)key{
    WeakSelf;
    NSInteger number = self.MyAttentionOfLocalityArray.count;
    [self.MyAttentionOfLocalityArray enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(UsersGetMeLikeUserInfoResponse_MeLikeUser  *model, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([model.userId containsString:key] || [model.nickName containsString:key]) {
            @synchronized (self.MyAttentionOfLocalityArray) {
                NSDictionary *dic = [model yy_modelToJSONObject];
                FindUser *findUser = [FindUser yy_modelWithJSON:dic];
                [weakSelf.resulteDataSource addObject:findUser];
            }
        }
        if (idx == number - 1) {
            weakSelf.resultVC.dataSource = self.resulteDataSource;
            [weakSelf.resultVC.tableView ah_reloadData];
            [weakSelf.resulteDataSource removeAllObjects];
            
        }
    }];

}

//隐藏列表
- (void) setSearchControllerHidden:(BOOL)hidden {
    NSInteger height = hidden ? 0: (CGRectGetHeight(self.view.bounds) - 64);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    
    [_resultVC.view setFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.bounds), height)];
    [UIView commitAnimations];
}

//搜索栏
-(UISegmentedControl*)sortStyleSegmentControl{
    if (!_searchBar) {
        NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"按字母排序",@"按时间排序",nil];
        _sortStyleSegmentControl = [[UISegmentedControl alloc]initWithItems:segmentedArray];
        _sortStyleSegmentControl.frame = CGRectMake(0, 0, 30/0.618*4, 30);
        _sortStyleSegmentControl.tintColor = UIColorFromRGB(0xb434fe);
        [_sortStyleSegmentControl addTarget:self action:@selector(changeSortStyle:)forControlEvents:UIControlEventValueChanged];
        _sortStyleSegmentControl.selectedSegmentIndex = 0;
    }
    
    return _sortStyleSegmentControl;
}

#pragma mark ----拼音排序、时间排序----
//   切换排序方式
-(void)changeSortStyle:(UISegmentedControl*)segmentControl{
    //生成拼音
    //    //    NSInteger Index = segmentControl.selectedSegmentIndex;
    //    //    NSLog(@"Index %li", (long)Index);
    //    //异步 参考文档https://github.com/kimziv/PinYin4Objc
    //    HanyuPinyinOutputFormat *outputFormat=[[HanyuPinyinOutputFormat alloc] init];
    //    [outputFormat setToneType:ToneTypeWithoutTone];
    //    [outputFormat setVCharType:VCharTypeWithV];
    //    [outputFormat setCaseType:CaseTypeLowercase];
    //    NSString *string;
    //    [PinyinHelper toHanyuPinyinStringWithNSString:string withHanyuPinyinOutputFormat:outputFormat withNSString:@" " outputBlock:^(NSString *pinYin) {
    //        //pinYin
    //
    //    }];
    if (_sortStyle == 0) {
        _sortStyle = 1;
    }else{
        _sortStyle = 0;
    }
    [self.listTableView ah_reloadData];
}

//拼音排序
-(void)pinyinSort:(NSArray*)array{
    [AHPinyinSort PinYin:array and:^(NSDictionary<NSString *,NSArray *> *addressBookDict, NSArray *nameKeys) {
        _pinYinKey = nameKeys;
        _attentionDic = addressBookDict;
        if (_sortStyle == SortStyleByCharace) {
            [self.listTableView ah_reloadData];
        }
    }];
}

//获取特别关注
-(void)GetSpecialAttention{
    [_specialAttentionArray removeAllObjects];
    NSInteger number = self.sourceArray.count;
    [self.sourceArray enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(UsersGetMeLikeUserInfoResponse_MeLikeUser *userInf, NSUInteger idx, BOOL * _Nonnull stop) {
        if (userInf.state == 1) {
            @synchronized (_specialAttentionArray) {
                [_specialAttentionArray addObject:userInf];
            }
        }
        if (idx == number - 1) {
            [self.listTableView ah_reloadData];
        }
    }];
}

-(NSMutableArray*)specialAttentionArray{
    if (_specialAttentionArray == nil) {
        _specialAttentionArray = [NSMutableArray array];
    }
    return _specialAttentionArray;
}

-(NSMutableArray*)resulteDataSource{
    if (!_resulteDataSource) {
        _resulteDataSource = [NSMutableArray array];
    }
    return _resulteDataSource;
}

//时间数据
-(NSMutableArray*)timeSortArray{
    //数目不等就重新排序
    if (self.sourceArray.count == _timeSortArray.count) {
        
    }else{
        //sourceArray时间排序
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"likeTimestamp" ascending:YES];
        NSArray *descriptors = [NSArray arrayWithObject:sortDescriptor];
        NSArray *sourceArray = [self.sourceArray copy];
        _timeSortArray = [[sourceArray sortedArrayUsingDescriptors:descriptors] mutableCopy];
    }
    
    return _timeSortArray;
}

#pragma mark UITableViewDateSourceAndDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_sortStyle == SortStyleByCharace) {
        if (self.specialAttentionArray.count>0) {
            return self.pinYinKey.count + 1;
        }else{
            return self.pinYinKey.count;
        }
        
    }else{
        return 1;
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_sortStyle == SortStyleByCharace) {
        if (self.specialAttentionArray.count>0) {
            if (section ==  0) {
                return self.specialAttentionArray.count;
            }else{
                NSString *key = self.pinYinKey[section-1];
                NSArray *array =self.attentionDic[key];
                return array.count;
            }
        }else{
            NSString *key = self.pinYinKey[section];
            NSArray *array =self.attentionDic[key];
            return array.count;
        }
        
    }else{
        return self.timeSortArray.count;
    }
    
}

//- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return _pinYinKey[section];
//}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 25;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AHAttentionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (_sortStyle == SortStyleByTime) {
        cell.meLikeUserInfoModel = self.timeSortArray[indexPath.row];
    }else{
        if (self.specialAttentionArray.count>0) {
            if (indexPath.section == 0) {
                cell.meLikeUserInfoModel = self.specialAttentionArray[indexPath.row];
            }else{
                NSString *key = self.pinYinKey[indexPath.section-1];
                NSArray *array =self.attentionDic[key];
                cell.meLikeUserInfoModel = array[indexPath.row];
            }
        }else{
            NSString *key = self.pinYinKey[indexPath.section];
            NSArray *array =self.attentionDic[key];
            cell.meLikeUserInfoModel = array[indexPath.row];
        }
        
    }
    AHWeakSelf(cell);
    WeakSelf;
    cell.specialAttentionBlock = ^(UIButton *sender){
        UsersChangeLikeStateRequest *changeLikeStatus = [[UsersChangeLikeStateRequest alloc]init];
        changeLikeStatus.state = weakcell.meLikeUserInfoModel.state==UsersChangeLikeStateRequest_State_Normal?UsersChangeLikeStateRequest_State_Special: UsersChangeLikeStateRequest_State_Normal;
        changeLikeStatus.userId = weakcell.meLikeUserInfoModel.userId;
        [[AHTcpApi shareInstance]requsetMessage:changeLikeStatus classSite:UsersClassName completion:^(id response, NSString *error) {
            UsersChangeLikeStateResponse *changeStatusRespose = response;
            if (changeStatusRespose.result != 0) {
                AHAlertView *alertView =    [[AHAlertView alloc]initAlertViewReminderTitle:@"温馨提示" title:@"失败啦" cancelBtnTitle:@"知道" cancelAction:nil];
                [alertView showAlert];
            }else{
                UIImage *imageAttention =  changeLikeStatus.state == 0?[UIImage imageNamed:@"btn_me_gz1"]:[UIImage imageNamed:@"btn_me_gz0"];
                [sender setImage:imageAttention forState:UIControlStateNormal];
                if(changeLikeStatus.state ==UsersChangeLikeStateRequest_State_Normal ){
                    AHAlertView *alertView =    [[AHAlertView alloc]initAlertViewReminderTitle:@"温馨提示" title:@"已取消特别关注成" cancelBtnTitle:@"知道" cancelAction:nil];
                    [alertView showAlert];
                }else{
                    AHAlertView *alertView =    [[AHAlertView alloc]initAlertViewReminderTitle:@"温馨提示" title:@"特别关注成功" cancelBtnTitle:@"知道" cancelAction:nil];
                    [alertView showAlert];
                }
                NSInteger index = [self.sourceArray indexOfObject:weakcell.meLikeUserInfoModel];
                weakcell.meLikeUserInfoModel.state = weakcell.meLikeUserInfoModel.state==UsersChangeLikeStateRequest_State_Normal?UsersChangeLikeStateRequest_State_Special: UsersChangeLikeStateRequest_State_Normal;
                [weakSelf.sourceArray replaceObjectAtIndex:index withObject:weakcell.meLikeUserInfoModel];
                [[NSNotificationCenter defaultCenter]postNotificationName:SepecialAttention object:nil];
            }
        }];
    };
    

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UsersGetMeLikeUserInfoResponse_MeLikeUser *userInfoModel = nil;
    if (_sortStyle == SortStyleByTime) {
        userInfoModel = self.timeSortArray[indexPath.row];
    }else{
        if (self.specialAttentionArray.count>0) {
            if (indexPath.section == 0) {
                userInfoModel = self.specialAttentionArray[indexPath.row];
            }else{
                NSString *key = self.pinYinKey[indexPath.section-1];
                NSArray *array =self.attentionDic[key];
                userInfoModel = array[indexPath.row];
            }
        }else{
            NSString *key = self.pinYinKey[indexPath.section];
            NSArray *array =self.attentionDic[key];
            userInfoModel = array[indexPath.row];
        }
        
    }
    AHPersonInfoVC *personInfoVC =[[AHPersonInfoVC alloc]initWithUserId:userInfoModel.userId];
    [self.navigationController pushViewController:personInfoVC animated:YES];
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 25)];
    headView.backgroundColor = self.view.backgroundColor;
    UILabel *titleLabel = [[UILabel   alloc]initWithFrame:CGRectMake(15, 10, screenWidth, 13)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor lightGrayColor];
    titleLabel.font = [UIFont systemFontOfSize:12];
    if (_sortStyle == SortStyleByTime) {
        titleLabel.text  = @"最近的关注";
    }else{
        if (self.specialAttentionArray.count>0) {
            if (section == 0) {
                titleLabel.text  = @"特别关注";
            }else{
                titleLabel.text  = _pinYinKey[section-1];
            }
        }else{
            titleLabel.text  = _pinYinKey[section];
        }
        
    }
    
    [headView addSubview:titleLabel];
    return headView;
}

//侧边栏快速索引数组
- (NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (_sortStyle == SortStyleByCharace) {
        return _pinYinKey;
    }else{
        return nil;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
