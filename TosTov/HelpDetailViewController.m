//
//  HelpDetailViewController.m
//  TosTov
//
//  Created by Pichzz on 11/9/16.
//  Copyright © 2016 Chhaly. All rights reserved.
//

#import "HelpDetailViewController.h"
#import "MyManager.h"
#import "Reachability.h"
#import "WSReport.h"

@interface HelpDetailViewController () <UITextViewDelegate>

@property (nonatomic, strong) UITextField *txtName;
@property (nonatomic, strong) UITextField *txtEmail;
@property (nonatomic, strong) UITextView *txtContent;
@property (nonatomic, strong) UIButton *btnSubmit;
@property (nonatomic, strong) UIButton *btnCallSupport;
@property (nonatomic, strong) UIView *popupView;
@property (nonatomic, strong) UIView *blurBackground;

@property (nonatomic, strong) UIActivityIndicatorView *spinner;

@end

@implementation HelpDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addComponents];
    
}


                                        /** Functionality **/

// Submit information
-(void)submitInfo{
    // check blank info
    if ([self.txtName.text isEqualToString:@""]||[self.txtEmail.text isEqualToString:@""]) {
        [self alertBoxWithMessage:@"" message:@"Name or Email cannot be empty"];
        return;
    }
    if ([self.txtContent.text isEqualToString:@""]) {
        [self alertBoxWithMessage:@"Sorry" message:@"Please fill your complaints in the box (min. 30 characters)"];
        return;
    }
    // validate mail
    if ([self validEmail:self.txtEmail.text]==NO) {
        [self alertBoxWithMessage:@"" message:@"Please enter a valid email"];
        return;
    }
    //
    [self submitReport];

    
}

// Submit report to server
-(void)submitReport{
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable) {
        //connection unavailable
        [self alertBoxWithMessage:@"No Internet!" message:@"Please check internet connection."];
    }
    else {
        [self.spinner startAnimating];
        [self.view addSubview:self.spinner];
        
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
        [parameters setObject:[[MyManager sharedManager] userId] forKey:@"userId"];
        [parameters setObject:self.txtName.text forKey:@"reporter"];
        [parameters setObject:self.txtEmail.text forKey:@"mail"];
        [parameters setObject:self.txtContent.text forKey:@"reportContent"];
        
        __weak HelpDetailViewController *weakSelf = self;
        WSReport *reportService = [[WSReport alloc]init];
        reportService.postBody = parameters;
        
        reportService.onSuccess = ^(id contr, id result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.spinner removeFromSuperview];
                [self popupReportSubmitted];
            });
        };
        
        reportService.onError = ^(id contr, id result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.spinner removeFromSuperview];
                NSDictionary *response = [[NSDictionary alloc]initWithDictionary:result];
                [weakSelf alertBoxWithMessage:@"Error" message:[NSString stringWithFormat:@"%@",[response objectForKey:@"error"]]];
            });
        };
        
        [reportService callRequest];
    }
    
}

// Show pop up view after submit
-(void)popupReportSubmitted{
    self.blurBackground = [[UIView alloc]initWithFrame:self.view.bounds];
    self.blurBackground.backgroundColor = [UIColor grayColor];
    self.blurBackground.alpha = 0.1;
    [self.view addSubview:self.blurBackground];
    
    self.popupView = [[UIView alloc]initWithFrame:CGRectMake(self.txtContent.frame.origin.x,
                                                       self.txtContent.frame.origin.y,
                                                        self.txtContent.bounds.size.width, 250)];
    self.popupView.backgroundColor = [UIColor whiteColor];
    // add label report submit
    UILabel *lblReportSubmit = [[UILabel alloc]initWithFrame:CGRectMake((self.popupView.bounds.size.width-150)/2,
                                                                        15, 150, 20)];
    lblReportSubmit.text = @"REPORT SUBMITTED";
    lblReportSubmit.textColor = [UIColor redColor];
    lblReportSubmit.font = [UIFont systemFontOfSize:15];
    [self.popupView addSubview:lblReportSubmit];
    
    // add tick image
    UIImageView *imgTick = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"TickIcon.png"]];
    imgTick.frame = CGRectMake((self.popupView.bounds.size.width-120)/2,
                               lblReportSubmit.frame.origin.y + lblReportSubmit.bounds.size.height+10, 120, 117);
    [self.popupView addSubview:imgTick];
    // add label more
    UILabel *lbl1 = [[UILabel alloc]initWithFrame:CGRectMake((self.popupView.bounds.size.width - 185)/2,
                                                            imgTick.frame.origin.y + imgTick.bounds.size.height + 5,
                                                             185, 10)];
    lbl1.font = [UIFont systemFontOfSize:10];
    lbl1.text = @"Your request is now being processed,";
    //lbl1.textColor = [UIColor redColor];
    [self.popupView addSubview:lbl1];
    
    UILabel *lbl2 = [[UILabel alloc]initWithFrame:CGRectMake((self.popupView.bounds.size.width - 140)/2,
                                                             imgTick.frame.origin.y + imgTick.bounds.size.height + 20,
                                                             140, 10)];
    lbl2.font = [UIFont systemFontOfSize:10];
    lbl2.text = @"thank you for your feedback";
    //lbl2.textColor = [UIColor redColor];
    [self.popupView addSubview:lbl2];
    
    UIButton *btnDone = [UIButton buttonWithType:UIButtonTypeCustom];
    btnDone.frame = CGRectMake(0, self.popupView.bounds.size.height-40,
                                           self.popupView.bounds.size.width, 40);
    btnDone.backgroundColor = [UIColor redColor];
    UILabel *lblDone = [[UILabel alloc]initWithFrame:CGRectMake((btnDone.frame.size.width-40)/2,
                                                                10,40,20)];
    lblDone.text = @"Done";
    lblDone.font = [UIFont systemFontOfSize:15];
    lblDone.textColor = [UIColor whiteColor];
    
    [btnDone addTarget:self action:@selector(dimissPopup) forControlEvents:UIControlEventTouchUpInside];
    
    [btnDone addSubview:lblDone];
    [self.popupView addSubview:btnDone];
    
    [self.view addSubview:self.popupView];
    
}

// Dimiss pop up view
-(void)dimissPopup{
    [self.blurBackground removeFromSuperview];
    [self.popupView removeFromSuperview];
}

// Back to help tab
-(void)backToHelp{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)dismissKeyboard{
    [self.view endEditing:true];
}

// Validate email
- (BOOL) validEmail:(NSString*) emailString {
    
    if([emailString length]==0){
        return NO;
    }
    
    NSString *regExPattern = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:emailString options:0 range:NSMakeRange(0, [emailString length])];
    
    //NSLog(@"%i", regExMatches);
    if (regExMatches == 0) {
        return NO;
    } else {
        return YES;
    }
}

// Alert any message with title
-(void)alertBoxWithMessage : (NSString*) title message:(NSString*) message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:actionOk];
    [self presentViewController:alert animated:true completion:nil];
}


                                        /** View Decoration **/
-(void)addComponents{
    
    // add spinner
    self.spinner = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-25,self.view.frame.size.height/2-25,50,50)];
    
    self.spinner.color = [UIColor redColor];
    
    self.view.backgroundColor = [UIColor whiteColor];
    //self.navigationController.navigationBar.barTintColor = [UIColor grayColor];
    //self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //self.navigationController.navigationBar.translucent = NO;
    
    
    
    UITapGestureRecognizer *areaTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:areaTap];
    
    // add back button
    UIImage *backIcon = [[UIImage imageNamed:@"BackIcon.png"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:backIcon style:UIBarButtonItemStylePlain target:self action:@selector(backToHelp)];
    self.navigationItem.leftBarButtonItem = barButtonItem;

    
    // add logo user
    UIImageView *userLogo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"UserIcon.png"]];
    userLogo.frame = CGRectMake(30,15,30, 30);
    
    userLogo.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:userLogo];
    
    
    // add textfield account
    self.txtName = [[UITextField alloc]initWithFrame:CGRectMake(userLogo.frame.origin.x + userLogo.frame.size.width + 10,
                                                                userLogo.frame.origin.y,
                                                                self.view.bounds.size.width - 100,30)];
    self.txtName.placeholder = @"Name";
    self.txtName.borderStyle = UITextBorderStyleNone;
    [self.view addSubview:self.txtName];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(userLogo.frame.origin.x + userLogo.frame.size.width + 10,
                                                             self.txtName.frame.origin.y + self.txtName.bounds.size.height + 3, self.view.bounds.size.width - 100, 1)];
    line1.backgroundColor = [UIColor blackColor];
    [self.view addSubview:line1];
    
    // add mail logo
    UIImageView *mailLogo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"MailIcon.png"]];
    mailLogo.frame = CGRectMake(30,
                                userLogo.frame.origin.y + 50,30, 30);
    
    mailLogo.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:mailLogo];
    
    // add textfield account
    self.txtEmail = [[UITextField alloc]initWithFrame:CGRectMake(mailLogo.frame.origin.x + mailLogo.frame.size.width + 10,
                                                                 mailLogo.frame.origin.y,
                                                                 self.view.bounds.size.width - 100,30)];
    self.txtEmail.placeholder = @"Email";
    self.txtEmail.borderStyle = UITextBorderStyleNone;
    [self.view addSubview:self.txtEmail];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(mailLogo.frame.origin.x + mailLogo.frame.size.width + 10,
                                                             self.txtEmail.frame.origin.y + self.txtEmail.bounds.size.height + 3, self.view.bounds.size.width - 100, 1)];
    line2.backgroundColor = [UIColor blackColor];
    [self.view addSubview:line2];
    
    // add label tell us more
    UILabel *lblTellUs = [[UILabel alloc]initWithFrame:CGRectMake(mailLogo.frame.origin.x,
                                                                  mailLogo.frame.origin.y + mailLogo.bounds.size.height + 10,120,25)];
    lblTellUs.text = @"TELL US MORE";
    lblTellUs.font = [UIFont systemFontOfSize:15];
    lblTellUs.textColor = [UIColor redColor];
    [self.view addSubview:lblTellUs];
    
    // add text view
    self.txtContent = [[UITextView alloc]initWithFrame:CGRectMake(lblTellUs.frame.origin.x,
                                                                 lblTellUs.frame.origin.y + lblTellUs.bounds.size.height+5,
                                                                 self.view.bounds.size.width - 60 , 120)];
    self.txtContent.layer.borderColor = [UIColor blackColor].CGColor;
    self.txtContent.layer.borderWidth = 1;
    self.txtContent.delegate = self;
    [self.view addSubview:self.txtContent];
    
    // add label
    UILabel *lblNum = [[UILabel alloc]initWithFrame:CGRectMake(self.txtContent.frame.origin.x + self.txtContent.bounds.size.width-15,
                                                               self.txtContent.frame.origin.y + self.txtContent.bounds.size.height+3, 15, 15)];
    lblNum.text = @"30";
    lblNum.font = [UIFont systemFontOfSize:10];
    lblNum.textColor = [UIColor blackColor];
    [self.view addSubview:lblNum];
    
    // add button submit
    self.btnSubmit = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnSubmit.frame = CGRectMake((self.view.bounds.size.width-80)/2,
                                      self.txtContent.frame.origin.y + self.txtContent.bounds.size.height+50,
                                      80,80);
    //self.btnSubmit.layer.cornerRadius = 35;
    //self.btnSubmit.layer.borderWidth = 2;
    
    //self.btnSubmit.backgroundColor = [UIColor redColor];
    UIImage *buttonImage = [UIImage imageNamed:@"SubmitIcon.png"];
    [self.btnSubmit setImage:buttonImage forState:UIControlStateNormal];
    
    
    UILabel *lblSubmit = [[UILabel alloc]initWithFrame:CGRectMake((self.btnSubmit.frame.size.width-56)/2,
                                                               30,56,20)];
    lblSubmit.text = @"SUBMIT";
    lblSubmit.font = [UIFont systemFontOfSize:15];
    lblSubmit.textColor = [UIColor whiteColor];
    
    [self.btnSubmit addSubview:lblSubmit];
    [self.btnSubmit addTarget:self action:@selector(submitInfo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnSubmit];
    
    // add button call support
    self.btnCallSupport = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnCallSupport.frame = CGRectMake(self.txtContent.frame.origin.x,
                                           self.btnSubmit.frame.origin.y + self.btnSubmit.bounds.size.height+50,
                                           self.txtContent.bounds.size.width, 40);
    UILabel *lblCall = [[UILabel alloc]initWithFrame:CGRectMake((self.btnCallSupport.frame.size.width-110)/2,
                                                                  10,110,20)];
    lblCall.text = @"CALL SUPPORT";
    lblCall.font = [UIFont systemFontOfSize:15];
    lblCall.textColor = [UIColor redColor];
    
    [self.btnCallSupport addSubview:lblCall];
    self.btnCallSupport.layer.borderColor = [UIColor redColor].CGColor;
    self.btnCallSupport.layer.borderWidth = 1;
    self.btnCallSupport.layer.cornerRadius = 5;
    [self.view addSubview:self.btnCallSupport];

    
}

                                        // UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (textView==self.txtContent) {
        if (textView.text.length > 30 && range.length==0) {
            return NO;
        }
    }
    return YES;
}




@end
