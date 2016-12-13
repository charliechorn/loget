//
//  HistoryViewController.m
//  TosTov
//
//  Created by Pichzz on 11/3/16.
//  Copyright © 2016 Chhaly. All rights reserved.
//

#import "HistoryViewController.h"
#import "CompleteTripViewController.h"
#import "ProgressTripViewController.h"

@interface HistoryViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UISegmentedControl *btnSegment;
@property (nonatomic, strong) UIBarButtonItem *btnRefresh;
@property (nonatomic, strong) UITableView *progressTable;
@property (nonatomic, strong) UITableView *completeTable;
@property (nonatomic, strong) NSMutableArray *arrCompleteContent;
@property (nonatomic, strong) NSMutableArray *arrprogressContent;


@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Force navigation bar not to hide any top view
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
 
    self.arrCompleteContent = [[NSMutableArray alloc]initWithObjects:
                        @{@"status":@"Completed",@"place":@"AEON MALL", @"date":@"22 Feb, 10:10",@"isRated":@"no"},
                       @{@"status":@"Canceled",@"place":@"AEON MALL", @"date":@"22 Feb, 09:10",@"isRated":@"no"},
                       @{@"status":@"Completed",@"place":@"PSAR TMEY", @"date":@"19 Feb, 10:10",@"isRated":@"no"},
                       @{@"status":@"Completed",@"place":@"HOME", @"date":@"19 Feb, 10:45",@"isRated":@"yes"},
                       nil];
    self.arrprogressContent = [[NSMutableArray alloc]initWithObjects:@{@"status":@"Finding Driver",@"place":@"AEON MALL", @"date":@"22 Feb, 10:10"},
                            @{@"status":@"In Progress",@"place":@"AEON MALL", @"date":@"22 Feb, 09:10"},
                            nil];
    [self addComponents];

}

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

-(void)reloadData{
    
}

                                        /** View Decoration **/
-(void)addComponents{
    
    UIImage *refreshIcon = [[UIImage imageNamed:@"RefreshIcon.png"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:refreshIcon style:UIBarButtonItemStylePlain target:self action:@selector(reloadData)];
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
    self.completeTable= [[UITableView alloc]initWithFrame:self.view.bounds];
    self.completeTable.dataSource = self;
    self.completeTable.delegate = self;
    self.completeTable.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:self.completeTable];
    
    // add progress table
    self.progressTable = [[UITableView alloc]initWithFrame:self.view.bounds];
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
    if (tableView==self.progressTable) {
       
        cell.imageView.image = [UIImage imageNamed:@"TosTovIcon.png"];
        cell.textLabel.text = [[self.arrprogressContent objectAtIndex:indexPath.row] objectForKey:@"status"];
        cell.detailTextLabel.text = [[self.arrprogressContent objectAtIndex:indexPath.row] objectForKey:@"place"];
        lblDate.text = [[self.arrprogressContent objectAtIndex:indexPath.row] objectForKey:@"date"];
        [cell.contentView addSubview:lblDate];
        
    }
    else {
        cell.imageView.image = [UIImage imageNamed:@"TosTovIcon.png"];
        cell.textLabel.text = [[self.arrCompleteContent objectAtIndex:indexPath.row] objectForKey:@"status"];
        cell.detailTextLabel.text = [[self.arrCompleteContent objectAtIndex:indexPath.row] objectForKey:@"place"];
        lblDate.text = [[self.arrCompleteContent objectAtIndex:indexPath.row] objectForKey:@"date"];
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
