//
//  SendPhoneNumViewController.m
//  TosTov
//
//  Created by Pichzz on 11/4/16.
//  Copyright © 2016 Chhaly. All rights reserved.
//

#import "SendPhoneNumViewController.h"
#import "PasscodeViewController.h"
#import "MyManager.h"
#import "Reachability.h"
#import "WSGetUserByPhone.h"

@interface SendPhoneNumViewController () <UITextFieldDelegate>
@property (nonatomic, strong) UITextField *txtPhoneNumber;
@property (nonatomic, strong) UIButton *btnResetPasswd;
@property (nonatomic, strong) UILabel *signUp;
@property (nonatomic ,strong) NSDictionary *responseData;
@end

@implementation SendPhoneNumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addComponents];
}

                                        /** Functionality **/

// Go back to log in view
-(void)backToLogin{
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Reset to new password
-(void)resetPassword{
    if([self.txtPhoneNumber.text isEqualToString:@""]){
        [self alertBoxWithMessage:@"Invalid" message:@"Phone Number cannot be empty"];
    }
    else{
        //[self getUserByPhone];
        [[MyManager sharedManager]setPhone:self.txtPhoneNumber.text];
        NSUserDefaults *standardUserdefault = [NSUserDefaults standardUserDefaults];
        [standardUserdefault setObject:@"changePass" forKey:@"status"];
        PasscodeViewController *passCodeVC = [[PasscodeViewController alloc]initWithAccName:@"" phoneNumber:[self.responseData objectForKey:@"phone"] andPassword:@""];
        passCodeVC.view.frame = self.view.bounds;
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:passCodeVC];
        [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavBackground.png"] forBarMetrics:UIBarMetricsDefault];
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0,
                                                               nav.navigationBar.frame.origin.y + nav.navigationBar.bounds.size.height,
                                                               self.view.bounds.size.width, 1)];
        line.backgroundColor = [UIColor whiteColor];
        [nav.navigationBar addSubview:line];
        
        [self presentViewController:nav animated:true completion:nil];
        }
}

// Unused method, just keep it
// Get user by phone
-(void)getUserByPhone{
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable) {
        //connection unavailable
        [self alertBoxWithMessage:@"No Internet!" message:@"Please check internet connection."];
    }
    else {
        
        //connection available
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
        [parameters setObject:self.txtPhoneNumber.text forKey:@"phone"];
        
        __weak SendPhoneNumViewController *weakSelf = self;
        WSGetUserByPhone *getUserService = [[WSGetUserByPhone alloc]init];
        getUserService.postBody = parameters;
        
        getUserService.onSuccess = ^(id contr, id result) {
            
            // Dispatch a block of code to a background queue
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(queue, ^{
                self.responseData = [[NSDictionary alloc]initWithDictionary:result];
                [[MyManager sharedManager] setUserId:[self.responseData objectForKey:@"id"]];
                [[MyManager sharedManager] setPassword:[self.responseData objectForKey:@"password"]];
                [[MyManager sharedManager]setPhone:[self.responseData objectForKey:@"phone"]];
                [[MyManager sharedManager] setSessionId:[self.responseData objectForKey:@"sessionId"]];
                NSLog(@"Reponse data is %@",self.responseData);
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    NSUserDefaults *standardUserdefault = [NSUserDefaults standardUserDefaults];
                    [standardUserdefault setObject:@"changePass" forKey:@"status"];
                    PasscodeViewController *passCodeVC = [[PasscodeViewController alloc]initWithAccName:@"" phoneNumber:[self.responseData objectForKey:@"phone"] andPassword:@""];
                    passCodeVC.view.frame = self.view.bounds;
                    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:passCodeVC];
                    [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavBackground.png"] forBarMetrics:UIBarMetricsDefault];
                    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0,
                                                                           nav.navigationBar.frame.origin.y + nav.navigationBar.bounds.size.height,
                                                                           self.view.bounds.size.width, 1)];
                    line.backgroundColor = [UIColor whiteColor];
                    [nav.navigationBar addSubview:line];
                    
                    [self presentViewController:nav animated:true completion:nil];
                });
            });
            
        
        };
        getUserService.onError = ^(id contr, id result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSDictionary *responseResult = [[NSDictionary alloc]initWithDictionary:result];
                [weakSelf alertBoxWithMessage:@"" message:[NSString stringWithFormat:@"%@",[responseResult objectForKey:@"error"]]];
                
            });
        };
        
        [getUserService callRequest];
//
//            NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
//            NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
//            NSString *dataURL = @"http://1-dot-tostov-server.appspot.com/tostovwebservice/getuserbyphone";
//            
//            //NSError *writeError = nil;
//            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
//            //NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
//            //    let jsonData = try! NSJSONSerialization.dataWithJSONObject(parameters, options: [])
//            //    //        let jsonString = String(data: jsonData, encoding: NSUTF8StringEncoding)
//            
//            NSURL *url = [[NSURL alloc]initWithString:dataURL];
//            NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc]initWithURL:url];
//            urlRequest.HTTPMethod = @"POST";
//            [urlRequest setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
//            urlRequest.HTTPBody = jsonData;
//            __weak SendPhoneNumViewController *weakSelf = self;
//            NSURLSessionDataTask *task = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//                // handle request error
//                if (error) {
//                    NSLog(@"Error is %@", error);
//                    [weakSelf alertBoxWithMessage:@"Error" message:[NSString stringWithFormat:@"%@",error]];
//                    return;
//                }else{
//                    
//                    weakSelf.responseData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//                    NSLog(@"Response is %@",self.responseData);
//                    if ([weakSelf.responseData objectForKey:@"error"]!=nil) {
//                        [weakSelf alertBoxWithMessage:@"" message:@"Wrong phone number."];
//                        return;
//                    }
//                    else {
//                        [[MyManager sharedManager] setUserId:[self.responseData objectForKey:@"id"]];
//                        [[MyManager sharedManager] setPassword:[self.responseData objectForKey:@"password"]];
//                        [[MyManager sharedManager]setPhone:[self.responseData objectForKey:@"phone"]];
//                        [[MyManager sharedManager] setSessionId:[self.responseData objectForKey:@"sessionId"]];
//                       
//                    }
//                }
//                
//            }];
//            [task resume];
    }

}

// Alert any message with title
-(void)alertBoxWithMessage : (NSString*) title message:(NSString*) message {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:actionOk];
        [self presentViewController:alert animated:true completion:nil];
    });
   
}



                                        /** View Decoration **/
-(void)addComponents{
    
    // Force navigation bar not to hide any top view
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }

    //self.view.backgroundColor = [UIColor grayColor];
    UIImageView *backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"TosTovBackgroundAll.png"]];
    backgroundView.contentMode = UIViewContentModeScaleAspectFill;
    backgroundView.frame = self.view.bounds;
    [self.view insertSubview:backgroundView atIndex:0];
    
    
    self.navigationController.navigationBar.barTintColor = [UIColor grayColor];
    self.navigationController.navigationBar.translucent = NO;
    
    // add gester to main view to dimiss keyboard
    UITapGestureRecognizer *areaTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:areaTap];
    
    
    // add back button
    UIImage *backIcon = [[UIImage imageNamed:@"BackIcon.png"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:backIcon style:UIBarButtonItemStylePlain target:self action:@selector(backToLogin)];
    self.navigationItem.leftBarButtonItem = barButtonItem;
    
    
    // add logo tos tov
    UIImageView *tosTovLogo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"TosTovLogo.png"]];
    tosTovLogo.frame = CGRectMake((self.view.frame.size.width - 150) / 2, 10, 150, 35);
    [self.view addSubview:tosTovLogo];
    
    // add label message
    UILabel *lblMessage = [[UILabel alloc]initWithFrame:CGRectMake((self.view.bounds.size.width - 224) / 2,
                                                                   tosTovLogo.frame.origin.y + tosTovLogo.frame.size.height + 10,
                                                                   224, 20)];
    lblMessage.text = @"A message will be sent to reset your password";
    lblMessage.font = [UIFont systemFontOfSize:10];
    lblMessage.textColor = [UIColor whiteColor];
    [self.view addSubview:lblMessage];
    
    UIImageView *phoneLogo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"PhoneLogo.png"]];
    phoneLogo.frame = CGRectMake(30,
                                 tosTovLogo.frame.origin.y + 170,
                                 30, 30);
    phoneLogo.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:phoneLogo];
    
    // phone number text field
    self.txtPhoneNumber = [[UITextField alloc]initWithFrame:CGRectMake(phoneLogo.frame.origin.x + phoneLogo.frame.size.width + 20,
                                                                       phoneLogo.frame.origin.y,
                                                                       self.view.bounds.size.width - 110, 30)];
    self.txtPhoneNumber.borderStyle = UITextBorderStyleNone;
    [self.txtPhoneNumber setKeyboardType:UIKeyboardTypeNumberPad];
    self.txtPhoneNumber.textColor = [UIColor whiteColor];
    self.txtPhoneNumber.font = [UIFont systemFontOfSize:12];
    self.txtPhoneNumber.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Phone Number" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName : [UIFont systemFontOfSize:12]}];
    self.txtPhoneNumber.delegate = self;
    [self.view addSubview:self.txtPhoneNumber];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(phoneLogo.frame.origin.x + phoneLogo.frame.size.width + 20,
                                                          self.txtPhoneNumber.frame.origin.y + self.txtPhoneNumber.bounds.size.height + 3,
                                                           self.txtPhoneNumber.bounds.size.width, 1)];
    line.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:line];
    
    // add button sign in
    self.btnResetPasswd = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnResetPasswd.frame = CGRectMake(30,
                                      self.txtPhoneNumber.frame.origin.y + 100,
                                      self.view.bounds.size.width - 60,
                                      30);
    
    self.btnResetPasswd.backgroundColor = [UIColor redColor];
    UILabel *signin = [[UILabel alloc]initWithFrame:CGRectMake((self.btnResetPasswd.frame.size.width-110) / 2,
                                                               5, 110, 20)];
    signin.text = @"RESET PASSWORD";
    signin.font = [UIFont systemFontOfSize:12];
    signin.textColor = [UIColor whiteColor];
    
    [self.btnResetPasswd addSubview:signin];
    [self.btnResetPasswd addTarget:self action:@selector(resetPassword) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnResetPasswd];
    
    // add footer view
    UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50)];
    footer.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:footer];
    
    // add label Don't have an account
    UILabel *dontHaveAcc = [[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width-165) / 2,
                                                                    15, 115, 20)];
    dontHaveAcc.text = @"Don't have an account?";
    dontHaveAcc.textColor = [UIColor blackColor];
    dontHaveAcc.font = [UIFont systemFontOfSize:10];
    [footer addSubview:dontHaveAcc];
    
    // add sign up label
    self.signUp = [[UILabel alloc]initWithFrame:CGRectMake(dontHaveAcc.frame.origin.x + dontHaveAcc.frame.size.width ,
                                                           15, 50, 20)];
    self.signUp.text = @"SIGN UP";
    self.signUp.textColor = [UIColor redColor];
    self.signUp.font = [UIFont systemFontOfSize:10];
    [footer addSubview:self.signUp];
    
}

// UITextfield Delegate methods

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow) name:UIKeyboardWillShowNotification object:nil];
   
    
    return true;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide) name:UIKeyboardWillHideNotification object:nil];
    [self.view endEditing:true];
    return true;
}


-(void)keyboardDidShow{
    self.view.frame = CGRectMake(0, -90, self.view.bounds.size.width, self.view.bounds.size.height);
}
-(void)keyboardDidHide{
    self.view.frame = CGRectMake(0, self.navigationController.navigationBar.bounds.size.height+22, self.view.bounds.size.width, self.view.bounds.size.height);
}

-(void)dismissKeyboard{
    [self.view endEditing:true];
    [self keyboardDidHide];
}


@end
