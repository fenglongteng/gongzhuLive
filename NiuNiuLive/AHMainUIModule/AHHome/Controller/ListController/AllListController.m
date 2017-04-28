//
//  AllListController.m
//  NiuNiuLive
//
//  Created by Zhangwenmin on 17/3/21.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AllListController.h"
#import "ListCell.h"
#import "giftListView.h"
#import "AHPersonInfoVC.h"
#import "Chats.pbobjc.h"

@interface AllListController ()<UITableViewDelegate,UITableViewDataSource>{
    //frame
    CGRect selfFrame;
}
@property(nonatomic,strong)UITableView * sentimentTable;

@property(nonatomic,strong)giftListView * header;

@property (nonatomic,strong)NSMutableArray *bandeListArr;

@end

@implementation AllListController

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super init];
    if (self) {
        selfFrame = frame;
    }
    return self;
}

- (UITableView *)sentimentTable{
    if (!_sentimentTable) {
        //主滚动
        _sentimentTable = [[UITableView  alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-70)];
        _sentimentTable.showsHorizontalScrollIndicator = NO;
        _sentimentTable.showsVerticalScrollIndicator = NO;
        _sentimentTable.dataSource = self;
        _sentimentTable.delegate = self;
        _sentimentTable.rowHeight = 65;
        _sentimentTable.backgroundColor = BYColor(236,237,239);
        _sentimentTable.scrollsToTop = NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
        _sentimentTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_sentimentTable registerNib:[UINib nibWithNibName:@"ListCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"sentimentListCells"];
    }
    return _sentimentTable;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.frame = selfFrame;
    [self.view addSubview:self.sentimentTable];
    self.bandeListArr = [NSMutableArray arrayWithCapacity:3];
    
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"giftListView" owner:nil options:nil];
    self.header = (giftListView *)[nibView objectAtIndex:0];
    [self.header initWithFrame:CGRectMake(0, 0, screenWidth, 307) bangType:sentimentBang listType:weekList];
    self.sentimentTable.mj_header = [AHCustomHeader headerWithRefreshingTarget:self refreshingAction:@selector(getNewSourceArray)];
    self.sentimentTable.tableHeaderView = self.header;
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.header.height = 307;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)subViewReload{
    if (!self.loaded) {
//        [self getNewSourceArray];
        [((AHCustomHeader *)self.sentimentTable.mj_header) beginRefreshing];
        self.loaded = YES;
    }
}

#pragma mark UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.bandeListArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"sentimentListCells"];
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
    
    [[AppDelegate getNavigationTopController].navigationController pushViewController:[[AHPersonInfoVC alloc] init] animated:YES];
}

- (void)getNewSourceArray{

    NSString *userid = [AHPersonInfoManager manager].getInfoModel.userId;
    LikeChatsRequest *likeChat = [[LikeChatsRequest alloc]init];
    likeChat.userId = userid;
    [[AHTcpApi shareInstance]requsetMessage:likeChat classSite:ChatsClassName completion:^(id response, NSString *error) {
        LikeChatsResponse *likeChatRes = (LikeChatsResponse *)response;
        //请求成功
        [self.sentimentTable.mj_header endRefreshing];
        if (likeChatRes.result == 0) {
            if (likeChatRes.responseArray.count >3) {
                [self.bandeListArr removeAllObjects];
                [self.bandeListArr addObjectsFromArray:[likeChatRes.responseArray subarrayWithRange:NSMakeRange(3, likeChatRes.responseArray.count -3)]];
                [self.sentimentTable reloadData];
            }else{
                self.header.topChartArr = likeChatRes.responseArray;
            }
        }
    }];
}


@end
