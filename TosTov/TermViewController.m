//
//  TermViewController.m
//  TosTov
//
//  Created by Charlie on 11/8/16.
//  Copyright © 2016 Chhaly. All rights reserved.
//

#import "TermViewController.h"

@interface TermViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIButton *btnEnglish;
@property (nonatomic, strong) UIButton *btnKhmer;

@property (nonatomic, strong) UITableView *englisTableView;


@property (nonatomic, strong) NSArray *arrEnglishTitle;
@property (nonatomic, strong) NSArray *arrEnglishContent;

@property (nonatomic, strong) NSString *conditionStr;

@property (nonatomic, strong) UILabel *lblKhmer;
@property (nonatomic, strong) UILabel *lblEnglish;

@property (nonatomic, strong) UIView *khLine;
@property (nonatomic, strong) UIView *englishLine;

@end

@implementation TermViewController{
    NSMutableArray *arrayForBool;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    arrayForBool = [[NSMutableArray alloc]init];
    self.arrEnglishTitle = [[NSArray alloc]initWithObjects:@"Terms of Use",@"Terms and Conditions", nil];
    
    NSString *engContent1 = @"Customer are required to provide complete information regarding to the type and specifications of the goods to be deliverd. \n\nGO-JEK does not provide specific box for shipping. Customers are responsible for properly packing the goods to be delivered. For fragile items mad of glass, ceramic and including cake, ice cream, food and fresh floers, it is suggested that the item is specially packaged. GO-JEK is not responsible for damage or deformation that occurs upon delivery of usch goods. \n\nThe GO-JEK driver ahs been riefed to drive his vehicle in a safe manner. However, customers who use GO-JEK transportation serice ar responsible for their own safety.";
    NSString *engContnet2 = @"Customer are required to provide complete information regarding to the type and specifications of the goods to be deliverd. \n\nGO-JEK does not provide specific box for shipping. Customers are responsible for properly packing the goods to be delivered. For fragile items mad of glass, ceramic and including cake, ice cream, food and fresh floers, it is suggested that the item is specially packaged. GO-JEK is not responsible for damage or deformation that occurs upon delivery of usch goods. \n\nThe GO-JEK driver ahs been riefed to drive his vehicle in a safe manner. However, customers who use GO-JEK transportation serice ar responsible for their own safety.";
    
    self.arrEnglishContent = [[NSArray alloc]initWithObjects:engContent1,engContnet2, nil];
    for (int i=0; i<[self.arrEnglishTitle count]; i++) {
        [arrayForBool addObject:[NSNumber numberWithBool:NO]];
    }
    
    [self addComponents];

}

                                        /** Functionality **/

// Show English content
-(void)clickOnEnglish{
    [self.englisTableView setHidden:NO];
    self.lblEnglish.textColor = [UIColor redColor];
    self.englishLine.backgroundColor = [UIColor redColor];
    self.lblKhmer.textColor = [UIColor grayColor];
    self.khLine.backgroundColor = [UIColor grayColor];
}


// Show Khmer content
-(void)clickOnKhmer{
    [self.englisTableView setHidden:YES];
    self.lblEnglish.textColor = [UIColor grayColor];
    self.englishLine.backgroundColor = [UIColor grayColor];
    self.lblKhmer.textColor = [UIColor redColor];
    self.khLine.backgroundColor = [UIColor redColor];
}



// Go bakc to sign up view
-(void)backToSignUp{
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Get max height of text
- (CGFloat)measureTextHeight:(NSString*)text constrainedToSize:(CGSize)constrainedToSize fontSize:(CGFloat)fontSize {
    
    CGRect rect = [text boundingRectWithSize:constrainedToSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil];
    
    return rect.size.height;
    
}


                                        /** View Decoration **/

-(void)addComponents{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // add back button    
    UIImage *backIcon = [[UIImage imageNamed:@"BackIcon.png"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:backIcon style:UIBarButtonItemStylePlain target:self action:@selector(backToSignUp)];
    self.navigationItem.leftBarButtonItem = barButtonItem;

    
    // add top background
    UIView *topView = [[UIView alloc]init];
    topView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 170);
    topView.backgroundColor = [UIColor darkGrayColor];
    
    UIImageView *topImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"TosTovCoverBackground.png"]];
    topImage.frame = CGRectMake(0, 0, self.view.bounds.size.width, 170);
    [topView addSubview:topImage];
    [self.view addSubview:topView];
    
    // add label title Tos Tov
//    UILabel *lblTosTov = [[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 140) / 2 ,
//                                                                  (topView.frame.size.height-30) / 2, 140, 30)];
//    lblTosTov.textColor = [UIColor whiteColor];
//    lblTosTov.text = @"TOS @ TOV";
//    lblTosTov.font = [UIFont systemFontOfSize:25];
//    //lblTosTov.center = topView.center;
//    //[topView addSubview:lblTosTov];
//    [self.view addSubview:lblTosTov];
    
    // add logo tos tov
    UIImageView *tosTovLogo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"TosTovBigLogo.png"]];
    tosTovLogo.frame = CGRectMake((self.view.frame.size.width - 175) / 2 ,(topView.frame.size.height-45) / 2, 175, 45);
    [self.view addSubview:tosTovLogo];
    
    // add khmer button
    self.btnKhmer = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnKhmer.frame = CGRectMake(0, topView.frame.origin.y + topView.frame.size.height,
                                     self.view.bounds.size.width / 2, 30);
    self.btnKhmer.layer.borderColor = [UIColor grayColor].CGColor;
    self.khLine = [[UIView alloc]initWithFrame:CGRectMake(0, 28, self.btnKhmer.bounds.size.width, 2)];
    self.khLine.backgroundColor = [UIColor grayColor];
    [self.btnKhmer addSubview: self.khLine];
    
    self.lblKhmer = [[UILabel alloc]initWithFrame:CGRectMake((self.btnKhmer.frame.size.width-45) / 2,
                                                                 5, 45, 20)];
    self.lblKhmer.text = @"Khmer";
    self.lblKhmer.font = [UIFont systemFontOfSize:12];
    self.lblKhmer.textColor = [UIColor grayColor];
    [self.btnKhmer addSubview:self.lblKhmer];
    [self.btnKhmer addTarget:self action:@selector(clickOnKhmer) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: self.btnKhmer];
    
    // add english button
    self.btnEnglish = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnEnglish.frame = CGRectMake(self.btnKhmer.frame.origin.x + self.btnKhmer.frame.size.width,
                                       topView.frame.origin.y + topView.frame.size.height,
                                       self.view.bounds.size.width / 2, 30);
    self.btnEnglish.layer.borderColor = [UIColor redColor].CGColor;
    self.englishLine = [[UIView alloc]initWithFrame:CGRectMake(0, 28, self.btnEnglish.bounds.size.width, 2)];
    self.englishLine.backgroundColor = [UIColor redColor];
    [self.btnEnglish addSubview:self.englishLine];
    self.lblEnglish = [[UILabel alloc]initWithFrame:CGRectMake((self.btnEnglish.frame.size.width-45) / 2,
                                                                    5, 45, 20)];
    self.lblEnglish.text = @"English";
    self.lblEnglish.font = [UIFont systemFontOfSize:12];
    self.lblEnglish.textColor = [UIColor redColor];
    [self.btnEnglish addSubview:self.lblEnglish];
    [self.btnEnglish addTarget:self action:@selector(clickOnEnglish) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: self.btnEnglish];
    
    // add table view
    self.englisTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,
                                                                       self.btnKhmer.frame.origin.y+self.btnKhmer.frame.size.height + 30,
                                                                       self.view.bounds.size.width,
                                                                        self.view.bounds.size.height - (self.btnKhmer.frame.origin.y+self.btnKhmer.frame.size.height)) style:UITableViewStylePlain];
    self.englisTableView.dataSource = self;
    self.englisTableView.delegate = self;
    
    [self.view addSubview:self.englisTableView];
    
}

// UITableView datasource and delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([[arrayForBool objectAtIndex:section] boolValue]) {
        NSLog(@"number of row return 1");
        return 1;
    }else{
        NSLog(@"number of row return 0");
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellid = @"CellID";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellid];
    }
    BOOL manyCells = [[arrayForBool objectAtIndex:indexPath.section]boolValue];
    
    //if the section supposed to be closed
    if (!manyCells) {
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.text = @"";
    }
    
    //if the section supposed to be opened
    else {
        
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font=[UIFont systemFontOfSize:12.0f];
        cell.backgroundColor=[UIColor whiteColor];
        cell.textLabel.text=[NSString stringWithFormat:@"%@",[self.arrEnglishContent objectAtIndex:indexPath.section]];
        cell.selectionStyle=UITableViewCellSelectionStyleNone ;
    }
    cell.textLabel.textColor = [UIColor blackColor];
    
    return cell;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.arrEnglishTitle count];
   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //clsoe the seciton , once the data is selected
    [arrayForBool replaceObjectAtIndex:indexPath.section withObject:[NSNumber numberWithBool:NO]];
    [self.englisTableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,30)];
    sectionView.backgroundColor = [UIColor whiteColor];
    sectionView.tag=section;
    UILabel *viewLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 8, self.englisTableView.frame.size.width-10, 15)];
    viewLabel.backgroundColor=[UIColor clearColor];
    viewLabel.textColor=[UIColor blackColor];
    viewLabel.font=[UIFont systemFontOfSize:12];
    viewLabel.text=[NSString stringWithFormat:@"%@",[self.arrEnglishTitle objectAtIndex:section]];
    [sectionView addSubview:viewLabel];
    if ([[arrayForBool objectAtIndex:section] boolValue]) {
        UIImageView *arrowDown = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ArrowUpIcon.png"]];
        arrowDown.frame = CGRectMake(sectionView.bounds.size.width-30, 2, 14, 25);
        [sectionView addSubview:arrowDown];
    }
    else{
        UIImageView *arrowDown = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ArrowDownIcon.png"]];
        arrowDown.frame = CGRectMake(sectionView.bounds.size.width-30, 2, 14, 25);
        [sectionView addSubview:arrowDown];
    }
    
    UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(10, 29, self.englisTableView.frame.size.width-20, 1)];
    separatorLineView.backgroundColor = [UIColor blackColor];
    [sectionView addSubview:separatorLineView];
    
    // add UITapGestureRecognizer to SectionView
    
    UITapGestureRecognizer  *headerTapped   = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionHeaderTapped:)];
    [sectionView addGestureRecognizer:headerTapped];
    NSLog(@"View ");
    return  sectionView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (void)sectionHeaderTapped:(UITapGestureRecognizer *)gestureRecognizer{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:gestureRecognizer.view.tag];
    if (indexPath.row == 0) {
        BOOL collapsed  = [[arrayForBool objectAtIndex:indexPath.section] boolValue];
        for (int i=0; i<[self.arrEnglishTitle count]; i++) {
            if (indexPath.section==i) {
                [arrayForBool replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:!collapsed]];
            }
        }
        [self.englisTableView reloadSections:[NSIndexSet indexSetWithIndex:gestureRecognizer.view.tag] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat maxHeight = 0.0f;
    if ([[arrayForBool objectAtIndex:indexPath.section] boolValue]) {
        if (indexPath.section==0) {
            maxHeight = [self measureTextHeight:self.arrEnglishContent[0] constrainedToSize:CGSizeMake(self.view.frame.size.width, 2000.0f) fontSize:13.0f];
            //return maxHeight;
        }
        else {
            maxHeight = [self measureTextHeight:self.arrEnglishContent[1] constrainedToSize:CGSizeMake(self.view.frame.size.width, 2000.0f) fontSize:13.0f];
            //return maxHeight;
        }
    }
    return maxHeight;
}




@end
