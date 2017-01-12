//
//  HistoryViewController.m
//  TosTov
//
//  Created by Charlie on 11/3/16.
//  Copyright © 2016 Chhaly. All rights reserved.
//

#import "HistoryViewController.h"
#import "CompleteTripViewController.h"
#import "ProgressTripViewController.h"
#import "Reachability.h"
#import "WSGetTosGoTripList.h"
#import "WSGetAllList.h"
#import "MyManager.h"
#import "MyUtils.h"

@interface HistoryViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UISegmentedControl *btnSegment;
@property (nonatomic, strong) UIBarButtonItem *btnRefresh;
@property (nonatomic, strong) UITableView *progressTable;
@property (nonatomic, strong) UITableView *completeTable;
@property (nonatomic, strong) NSMutableArray *arrCompleteContent;
@property (nonatomic, strong) NSMutableArray *arrprogressContent;
@property (nonatomic, strong) NSArray *responseData;



@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.arrprogressContent = [[NSMutableArray alloc]init];
    self.arrCompleteContent = [[NSMutableArray alloc]init];
    // Force navigation bar not to hide any top view
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    
 
//    self.arrCompleteContent = [[NSMutableArray alloc]initWithObjects:
//                        @{@"status":@"Completed",@"place":@"AEON MALL", @"date":@"22 Feb, 10:10",@"isRated":@"no"},
//                       @{@"status":@"Canceled",@"place":@"AEON MALL", @"date":@"22 Feb, 09:10",@"isRated":@"no"},
//                       @{@"status":@"Completed",@"place":@"PSAR TMEY", @"date":@"19 Feb, 10:10",@"isRated":@"no"},
//                       @{@"status":@"Completed",@"place":@"HOME", @"date":@"19 Feb, 10:45",@"isRated":@"yes"},
//                       nil];
//    self.arrprogressContent = [[NSMutableArray alloc]initWithObjects:@{@"status":@"Finding Driver",@"place":@"AEON MALL", @"date":@"22 Feb, 10:10"},
//                            @{@"status":@"In Progress",@"place":@"AEON MALL", @"date":@"22 Feb, 09:10"},
//                            nil];
    [self addComponents];
    //[self getTosGoTripList];
    [self getAllList];

}

//- (void)viewWillAppear:(BOOL)animated{
//    [self getAllList];
//}

                                        /** Functionality **/

// Check segment value to change color
-(void)checkSegmentValueChanged{
    if (self.btnSegment.selectedSegmentIndex == 0) {
        [self.progressTable setHidden:NO];
        [self.completeTable setHidden:YES];
    }else {
        [self.progressTable setHidden:YES];
        [self.completeTable setHidden:NO];
    }
}

// Get All List
-(void)getAllList{
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable) {
    }
    else{
        self.arrprogressContent = [[NSMutableArray alloc]init];
        self.arrCompleteContent = [[NSMutableArray alloc]init];
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
        [parameters setObject:[[MyManager sharedManager]userId]  forKey:@"userId"];
        WSGetAllList *getAllListService = [[WSGetAllList alloc]init];
        getAllListService.postBody = parameters;
        getAllListService.onSuccess = ^(id contr, id result){
//            self.responseData = [[[NSDictionary alloc]initWithDictionary:result]objectForKey:@"responseData"];
//            NSLog(@"resutl is  : %@",self.responseData);
            NSArray *arr = [[[NSDictionary alloc]initWithDictionary:result]objectForKey:@"responseData"];
            
            for (NSDictionary *tempDic in arr) {
                if([[tempDic objectForKey:@"status"] isEqualToString:@"0"]){
                   [self.arrprogressContent addObject:tempDic];
                }else{
                    [self.arrCompleteContent addObject:tempDic];
                }
            }
            NSLog(@"progress list is: %@",self.arrprogressContent);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.progressTable reloadData];
                [self.completeTable reloadData];
                NSLog(@"arrComplete is : %@",self.arrCompleteContent);
            });
        };
        getAllListService.onError = ^(id contr, id result){
            
        };
        [getAllListService callRequest];
    }
}


// Get TosGo trip list
//-(void)getTosGoTripList{
//    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable) {
//    }
//    else{
//        NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
//        [parameters setObject:[[MyManager sharedManager]userId]  forKey:@"userId"];
//        WSGetTosGoTripList *getTripListService = [[WSGetTosGoTripList alloc]init];
//        getTripListService.postBody = parameters;
//        getTripListService.onSuccess = ^(id contr, id result){
//            self.responseData = [[[NSDictionary alloc]initWithDictionary:result]objectForKey:@"responseData"];
//            NSLog(@"resutl is  : %@",self.responseData);
//            
//        };
//        getTripListService.onError = ^(id contr, id result){
//            
//        };
//        [getTripListService callRequest];
//        
//    }
//}

-(void)reloadTrip{
    [self getAllList];
}

                                        /** View Decoration **/
-(void)addComponents{
    
    UIImage *refreshIcon = [[UIImage imageNamed:@"RefreshIcon.png"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:refreshIcon style:UIBarButtonItemStylePlain target:self action:@selector(reloadTrip)];
    self.navigationItem.rightBarButtonItem = barButtonItem;

    // add segment controls
    self.btnSegment = [[UISegmentedControl alloc]initWithItems:@[@"In progress",@"Completed"]];
    self.btnSegment.frame = CGRectMake(0, 0, 180, 25);
    self.btnSegment.tintColor = [UIColor redColor];
    self.btnSegment.selectedSegmentIndex = 1;
    NSDictionary *highlightedAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [self.btnSegment setTitleTextAttributes:highlightedAttributes forState:UIControlStateSelected];
    [self.btnSegment addTarget:self action:@selector(checkSegmentValueChanged) forControlEvents:UIControlEventValueChanged];
    
    self.navigationItem.titleView = self.btnSegment;
    
    
    // add complete table
    //self.completeTable= [[UITableView alloc]initWithFrame:self.view.bounds];
    self.completeTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-120)];
    self.completeTable.dataSource = self;
    self.completeTable.delegate = self;
    self.completeTable.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:self.completeTable];
    
    // add progress table
    //self.progressTable = [[UITableView alloc]initWithFrame:self.view.bounds];
    self.progressTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-120)];
    self.progressTable.dataSource = self;
    self.progressTable.delegate = self;
    self.progressTable.tableFooterView = [[UIView alloc]init];
    [self.progressTable setHidden:YES];

    [self.view addSubview:self.progressTable];
    
}

                                        // UITableView datasource and delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==self.progressTable) {
        return self.arrprogressContent.count;
    }
    else {
        return self.arrCompleteContent.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = nil;
    UILabel *lblDate =nil;
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:10];
    //cell.textLabel.textColor = [UIColor redColor];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:11];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, 44, self.view.bounds.size.width - 30, 1)];
    line.backgroundColor = [UIColor blackColor];
    [cell.contentView addSubview:line];
//    lblDate = [[UILabel alloc]initWithFrame:CGRectMake(cell.contentView.bounds.size.width-70,
//                                                       11, 70, 10)];
    lblDate =[[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.size.width - 70 - 10, 11, 70, 10)];
    lblDate.font = [UIFont systemFontOfSize:10];
    //lblDate.textColor = [UIColor redColor];

    
    cell.imageView.image = [UIImage imageNamed:@"TosTovIcon.png"];
    if (tableView==self.progressTable) {
        
        //cell.textLabel.text = [[self.arrprogressContent objectAtIndex:indexPath.row] objectForKey:@"status"];
        cell.textLabel.text = @"In progress";
        cell.detailTextLabel.text = [[self.arrprogressContent objectAtIndex:indexPath.row] objectForKey:@"desText"];
        //lblDate.text = [[self.arrprogressContent objectAtIndex:indexPath.row] objectForKey:@"date"];
        
        NSString *showDate = [MyUtils getFormatDateWithString:[[self.arrprogressContent objectAtIndex:indexPath.row] objectForKey:@"tripDate"]];
        NSLog(@"date is %@",showDate);
        
        if (showDate == nil) {
            lblDate.text = @"";
        }else{
           lblDate.text = showDate;
        }
        
        [cell.contentView addSubview:lblDate];
        
    }
    else {
        //cell.textLabel.text = [[self.arrCompleteContent objectAtIndex:indexPath.row] objectForKey:@"status"];
        cell.textLabel.text = @"Completed";
        cell.detailTextLabel.text = [[self.arrCompleteContent objectAtIndex:indexPath.row] objectForKey:@"desText"];
        //lblDate.text = [[self.arrCompleteContent objectAtIndex:indexPath.row] objectForKey:@"date"];
        NSString *showDate = [MyUtils getFormatDateWithString:[[self.arrCompleteContent objectAtIndex:indexPath.row] objectForKey:@"tripDate"]];
        if (showDate == nil) {
            lblDate.text = @"";
        }else{
            lblDate.text = showDate;
        }
        [cell.contentView addSubview:lblDate];
    }
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView==self.progressTable) {
        ProgressTripViewController *progressVC = [[ProgressTripViewController alloc]initWithData:[self.arrprogressContent objectAtIndex:indexPath.row]];
        progressVC.view.frame = self.view.bounds;
        
        //progressVC.tripContent = [self.arrCompleteContent objectAtIndex:indexPath.row];
        
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:progressVC];
        [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavBackground.png"] forBarMetrics:UIBarMetricsDefault];
        nav.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
        nav.navigationBar.translucent = NO;
        [self presentViewController:nav animated:true completion:nil];
    }
    else {
        CompleteTripViewController *completeVC = [[CompleteTripViewController alloc]initWithData:[self.arrCompleteContent objectAtIndex:indexPath.row]];
        completeVC.view.frame = self.view.bounds;
        
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:completeVC];
        [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavBackground.png"] forBarMetrics:UIBarMetricsDefault];
        nav.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
        nav.navigationBar.translucent = NO;
        [self presentViewController:nav animated:true completion:nil];
    }
}




@end
