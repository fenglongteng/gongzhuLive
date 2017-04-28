//
//  monthController.m
//  NiuNiuLive
//
//  Created by Zhangwenmin on 17/3/21.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "monthController.h"
#import "ListCell.h"
#import "sendView.h"
#import "giftListView.h"
#import "AHPersonInfoVC.h"
#import "Chats.pbobjc.h"

@interface monthController ()<UITableViewDataSource,UITableViewDelegate>{
    //frame
    CGRect selfFrame;
    //榜单周期类型
    ListType _listType;
    //榜单类型
    BangType _bangType;
}

@property (weak, nonatomic) IBOutlet UITableView *monthTable;
//送出head
@property(nonatomic,strong)sendView * headView;
//礼物head
@property(nonatomic,strong)giftListView * headerView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableTop;

@property (nonatomic,strong)NSMutableArray *giftData;//礼物周

@end

@implementation monthController

- (instancetype)initWithFrame:(CGRect)frame bangType:(BangType)bangType listType:(ListType)listType{
    self = [super init];
    if (self) {
        self.giftData = [NSMutableArray arrayWithCapacity:2];
        selfFrame = frame;
        _listType = listType;
        _bangType = bangType; 
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.frame = selfFrame;
    self.loaded = NO;
    self.monthTable.mj_header =  [AHCustomHeader headerWithRefreshingTarget:self refreshingAction:@selector(getNewSourceArray)];
    self.monthTable.delegate = self;
    self.monthTable.dataSource = self;
    self.monthTable.rowHeight = 65;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.monthTable.tableFooterView = [[UIView alloc] init];
    self.monthTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.monthTable.alwaysBounceVertical = YES;
    [self.monthTable registerNib:[UINib nibWithNibName:@"ListCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"listCells"];
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"sendView" owner:nil options:nil];
    self.headView = (sendView *)[nibView objectAtIndex:0];
    [self.headView initWithFrame:CGRectMake(0, 0, screenWidth, 274) bangType:sentimentBang listType:weekList];
    
    NSArray* nibView1 =  [[NSBundle mainBundle] loadNibNamed:@"giftListView" owner:nil options:nil];
    self.headerView = (giftListView *)[nibView1 objectAtIndex:0];
    [self.headerView initWithFrame:CGRectMake(0, 0, screenWidth, 307) bangType:sentimentBang listType:weekList];
    if (_bangType == giftBang) {
        self.monthTable.tableHeaderView = self.headerView;
    }else{
        self.monthTable.tableHeaderView = self.headView;
    }
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.headView.height = 274;
    self.headerView.height = 307;
}

-(void)subViewReload{
    if (!self.loaded) {
//        [self getNewSourceArray];
        [((AHCustomHeader *)self.monthTable.mj_header) beginRefreshing];
        self.loaded = YES;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint point = scrollView.contentOffset;
    CGFloat proportion = point.y / 70;
    //是否大于1倍
    CGFloat tmpProportion = proportion  > 1 ? 1 : proportion;
    //是否小于0倍
    tmpProportion = tmpProportion < 0 ? 0 : tmpProportion;
    self.tableTop.constant = 70 - 70 * tmpProportion;
    [self.monthTable layoutIfNeeded];
}

#pragma mark UItableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.giftData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"listCells"];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.listLabel.text = [NSString stringWithFormat:@"%ld",(indexPath.row + 4)];
    
    for (id obj in cell.subviews)
    {
        if ([NSStringFromClass([obj class])isEqualToString:@"UITableViewCellScrollView"])
        {
            UIScrollView *scroll = (UIScrollView *) obj;
            scroll.delaysContentTouches = NO;
            break;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [[AppDelegate getNavigationTopController].navigationController pushViewController:[[AHPersonInfoVC alloc] initWithUserId:@"58e8afda397d853ab8961bf9"] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
  
}

- (void)getNewSourceArray{
    
   NSString *userid = [AHPersonInfoManager manager].getInfoModel.userId;
    if (_bangType == giftBang &&_listType == weekList) {
        //获得礼物周榜请求
        GiftChartsForWeeksRequest *weeksCharts = [[GiftChartsForWeeksRequest alloc]init];
        weeksCharts.userId = userid;
        [[AHTcpApi shareInstance]requsetMessage:weeksCharts classSite:ChatsClassName completion:^(id response, NSString *error) {
            GiftChartsForWeeksResponse *weekResponse = (GiftChartsForWeeksResponse *)response;
            //请求成功
            [self.monthTable.mj_header endRefreshing];
            
            if (weekResponse.result == 0) {
                if (weekResponse.responseArray.count >3) {
                    [self.giftData removeAllObjects];
                    [self.giftData addObjectsFromArray:[weekResponse.responseArray subarrayWithRange:NSMakeRange(3, weekResponse.responseArray.count -3)]];
                    [self.monthTable reloadData];
                }else{
                    self.headerView.topChartArr = weekResponse.responseArray;
                }
            }
        }];
    }
    //礼物月榜
    if (_bangType == giftBang && _listType == monthList) {
        
        GiftChatsForMonthRequest *monthChat = [[GiftChatsForMonthRequest alloc]init];
        monthChat.userId = userid;
        
        [[AHTcpApi shareInstance]requsetMessage:monthChat classSite:ChatsClassName completion:^(id response, NSString *error) {
            GiftChatsForMonthResponse *monthResp = (GiftChatsForMonthResponse *)response;
            //请求成功
            [self.monthTable.mj_header endRefreshing];
            if (monthResp.result == 0) {
                if (monthResp.responseArray.count >3) {
                    [self.giftData removeAllObjects];
                    [self.giftData addObjectsFromArray:[monthResp.responseArray subarrayWithRange:NSMakeRange(3, monthResp.responseArray.count -3)]];
                    [self.monthTable reloadData];
                }else{
                    self.headerView.topChartArr = monthResp.responseArray;
                }
            }
            
        }];
        
    }
    //礼物总榜 
    if (_bangType == giftBang && _listType == allList) {
        
        GiftChatsRequest *allChat = [[GiftChatsRequest alloc]init];
    
        allChat.userId = userid;
        
        [[AHTcpApi shareInstance]requsetMessage:allChat classSite:ChatsClassName completion:^(id response, NSString *error) {
            
            GiftChatsResponse *giftRes = (GiftChatsResponse *)response;
            //请求成功
            [self.monthTable.mj_header endRefreshing];
            if (giftRes.result == 0) {
                if (giftRes.responseArray.count >3) {
                    [self.giftData removeAllObjects];
                    [self.giftData addObjectsFromArray:[giftRes.responseArray subarrayWithRange:NSMakeRange(3, giftRes.responseArray.count -3)]];
                    [self.monthTable reloadData];
                }else{
                    self.headerView.topChartArr = giftRes.responseArray;
                }
            }
        }];
    }
    
    //送出周榜
    if (_bangType == sendBang && _listType == weekList) {
        
        OutcomeChatsForWeekRequest *outChatweek = [[OutcomeChatsForWeekRequest alloc]init];
        
        outChatweek.userId = userid;
        
        [[AHTcpApi shareInstance]requsetMessage:outChatweek classSite:ChatsClassName completion:^(id response, NSString *error) {
            
            OutcomeChatsForWeekResponse *outChatRes = (OutcomeChatsForWeekResponse *)response;
            //请求成功
            [self.monthTable.mj_header endRefreshing];
            if (outChatRes.result == 0) {
                if (outChatRes.responseArray.count >3) {
                    [self.giftData removeAllObjects];
                    [self.giftData addObjectsFromArray:[outChatRes.responseArray subarrayWithRange:NSMakeRange(3, outChatRes.responseArray.count -3)]];
                    [self.monthTable reloadData];
                }else{
                    self.headView.outChatTopArr = outChatRes.responseArray;
                }
            }
        }];
    }
    //送出月榜
    if (_bangType == sendBang && _listType == monthList) {
        
        OutcomeChatsForMonthRequest *outChatMonth = [[OutcomeChatsForMonthRequest alloc]init];
        
        outChatMonth.userId = userid;
        
        [[AHTcpApi shareInstance]requsetMessage:outChatMonth classSite:ChatsClassName completion:^(id response, NSString *error) {
            
            OutcomeChatsForMonthResponse *outChatRes = (OutcomeChatsForMonthResponse *)response;
            //请求成功
            [self.monthTable.mj_header endRefreshing];
            if (outChatRes.result == 0) {
                if (outChatRes.responseArray.count >3) {
                    [self.giftData removeAllObjects];
                    [self.giftData addObjectsFromArray:[outChatRes.responseArray subarrayWithRange:NSMakeRange(3, outChatRes.responseArray.count -3)]];
                    [self.monthTable reloadData];
                }else{
                    self.headView.outChatTopArr = outChatRes.responseArray;
                }
            }
        }];

    }
    //送出总榜
    if (_bangType == sendBang && _listType == allList) {
        
        OutcomeChatsRequest *outChatAll = [[OutcomeChatsRequest alloc]init];
        outChatAll.userId = userid;
        [[AHTcpApi shareInstance]requsetMessage:outChatAll classSite:ChatsClassName completion:^(id response, NSString *error) {
            OutcomeChatsResponse *outChatRes = (OutcomeChatsResponse *)response;
            //请求成功
            [self.monthTable.mj_header endRefreshing];
            if (outChatRes.result == 0) {
                if (outChatRes.responseArray.count >3) {
                    [self.giftData removeAllObjects];
                    [self.giftData addObjectsFromArray:[outChatRes.responseArray subarrayWithRange:NSMakeRange(3, outChatRes.responseArray.count -3)]];
                    [self.monthTable reloadData];
                }else{
                    self.headView.outChatTopArr = outChatRes.responseArray;
                }
            }
        }];
    }

}

@end
