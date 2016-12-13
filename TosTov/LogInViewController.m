//
//  LogInViewController.m
//  TosTov
//
//  Created by Charlie on 11/2/16.
//  Copyright © 2016 Chhaly. All rights reserved.
//

#import "LogInViewController.h"
#import "SendPhoneNumViewController.h"
#import "MyManager.h"
#import "Reachability.h"
#import "MyUtils.h"
#import "WSLogin.h"

@interface LogInViewController () <UITextFieldDelegate>
@property (nonatomic, strong) UITextField *txtPhoneNumber;
@property (nonatomic, strong) UITextField *txtPassword;
@property (nonatomic, strong) UIButton *btnSignIn;
@property (nonatomic, strong) UILabel *forgetPassword;
@property (nonatomic, strong) UILabel *signUp;
@property (nonatomic, strong) UIImageView *showPassimage;
@property (nonatomic, strong) UIButton *btnShowPassimage;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;

@end

@implementation LogInViewController{
    bool isShownPassword;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    isShownPassword=false;
    
    [self addComponents];
    
    
}
-(void)viewDidAppear:(BOOL)animated{
    [self checkIfChangePassword];
}


                                        /** Functionality **/
// Login
-(void)login{
    
    if([self.txtPhoneNumber.text isEqualToString:@""]||[self.txtPassword.text isEqualToString:@""]){
                [self alertBoxWithMessage:@"Oops" message:@"Please input data."];
    }
        
    else{
        if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable){
            //connection unavailable
            [self alertBoxWithMessage:@"No Internet!" message:@"Please check internet connection."];
        }
        else{
            [self.spinner startAnimating];
            [self.view addSubview:self.spinner];
            
            NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
            [parameters setObject:self.txtPhoneNumber.text forKey:@"phone"];
            [parameters setObject:self.txtPassword.text forKey:@"password"];
            
            __weak LogInViewController *weakSelf = self;
            WSLogin *loginSerivce = [[WSLogin alloc]init];
            loginSerivce.postBody = parameters;
            loginSerivce.onSuccess=^(id contr, id result){
                NSDictionary *responseResult = [[NSDictionary alloc]initWithDictionary:result];
                [[MyManager sharedManager] setUserId:[responseResult objectForKey:@"id"]];
                [[MyManager sharedManager] setPassword:[responseResult objectForKey:@"password"]];
                [[MyManager sharedManager]setPhone:[responseResult objectForKey:@"phone"]];
                [[MyManager sharedManager] setSessionId:[responseResult objectForKey:@"sessionId"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.spinner removeFromSuperview];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"NofMain" object:nil];
                });
                
            };
            
            loginSerivce.onError=^(id contr, id result){
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.spinner removeFromSuperview];
                    NSDictionary *responseResult = [[NSDictionary alloc]initWithDictionary:result];
                    [weakSelf alertBoxWithMessage:@"Unable to login" message:[NSString stringWithFormat:@"%@",[responseResult objectForKey:@"error"]]];
                });
                
            };
            
            [loginSerivce callRequest];

        }
        
    }
    
    
    
//    NSString *dataURL = @"http://1-dot-tostov-server.appspot.com/tostovwebservice/changepassword";
//    
//    NSDictionary *result = [MyUtils requestDataWithUrlString:dataURL andParameter:parameters];
//    NSLog(@"Login resutl is %@",result);
    
//    if([self.txtPhoneNumber.text isEqualToString:@""]||[self.txtPassword.text isEqualToString:@""]){
//        [self alertBoxWithMessage:@"Oops" message:@"Please input data."];
//    }
//    
//    else{
//        if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
//        {
//            //connection unavailable
//            [self alertBoxWithMessage:@"No Internet!" message:@"Please check internet connection."];
//        }
//        else
//        {
//            //connection available
//            NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
//            [parameters setObject:self.txtPhoneNumber.text forKey:@"phone"];
//            [parameters setObject:self.txtPassword.text forKey:@"newPassword"];
//            
//            NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
//            NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
//            NSString *dataURL = @"http://1-dot-tostov-server.appspot.com/tostovwebservice/changepassword";
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
//            
//            __weak LogInViewController *weakSelf = self;
//            NSURLSessionDataTask *task = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//                // handle request error
//                if (error) {
//                    NSLog(@"Error is %@", error);
//                    [weakSelf alertBoxWithMessage:@"Error" message:[NSString stringWithFormat:@"%@",error]];
//                }else{
//                    NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//                    
//                    //NSLog(@"Response is %@",responseData);
//                    if ([responseData objectForKey:@"error"]!=nil) {
//                        NSLog(@"PPAP1");
//                        [weakSelf alertBoxWithMessage:@"" message:@""];
//                        NSLog(@"PPAP2");
//                        return;
//                    }
//                    
//                    [[MyManager sharedManager] setUserId:[responseData objectForKey:@"id"]];
//                    [[MyManager sharedManager] setPassword:[responseData objectForKey:@"password"]];
//                    [[MyManager sharedManager]setPhone:[responseData objectForKey:@"phone"]];
//                    [[MyManager sharedManager] setSessionId:[responseData objectForKey:@"sessionId"]];
//                    [[NSNotificationCenter defaultCenter] postNotificationName:@"NofMain" object:nil];
//                }
//                
//            }];
//            [task resume];
//            
//        }
//    }
    
}

// Register new account
-(void)registerNewAcc{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NofSignUp" object:nil];
}

// Check if password has been changed
-(void)checkIfChangePassword{
    NSUserDefaults *standardUserDefault = [NSUserDefaults standardUserDefaults];
    NSString *isChangePassword = [standardUserDefault objectForKey:@"isChangePassword"];
    if ([isChangePassword isEqualToString:@"1"]) {
        [self alertBoxWithMessage:@"" message:@"You have successfully changed your password"];
    }
    [standardUserDefault setObject:@"0" forKey:@"isChangePassword"];
    
}

// Show hiddenp password secured text
-(void)showPassword{
    if (isShownPassword) {
        NSLog(@"work");
        [self.txtPassword setSecureTextEntry:true];
        isShownPassword = false;
        [self.btnShowPassimage setBackgroundImage:[UIImage imageNamed:@"EyeLogo.png"] forState:UIControlStateNormal];
    }
    else {
        NSLog(@"work");
        [self.txtPassword setSecureTextEntry:false];
        isShownPassword = true;
        [self.btnShowPassimage setBackgroundImage:[UIImage imageNamed:@"EyeActionLogo.png"] forState:UIControlStateNormal];
    }
}

// Got to configure new password
-(void)tapOnForgetPassword{
    SendPhoneNumViewController *sendPhoneVC = [[SendPhoneNumViewController alloc]init];
    sendPhoneVC.view.frame = self.view.bounds;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:sendPhoneVC];
    [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavBackground.png"] forBarMetrics:UIBarMetricsDefault];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0,
                                                          nav.navigationBar.frame.origin.y + nav.navigationBar.bounds.size.height,
                                                           self.view.bounds.size.width, 1)];
    line.backgroundColor = [UIColor whiteColor];
    [nav.navigationBar addSubview:line];
    //nav.navigationBar.barTintColor = [UIColor darkGrayColor];
    nav.navigationBar.translucent = NO;
    [self presentViewController:nav animated:YES completion:nil];
    
    
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







                                        /** View decoration **/

-(void)addComponents {
    
    
    // add spinner
    self.spinner = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-25,self.view.frame.size.height/2-25,50,50)];
    
    self.spinner.color = [UIColor redColor];
    
    //self.view.backgroundColor = [UIColor grayColor];
    UIImageView *backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"TosTovBackgroundAll.png"]];
    backgroundView.contentMode = UIViewContentModeScaleAspectFill;
    backgroundView.frame = self.view.bounds;
    [self.view insertSubview:backgroundView atIndex:0];
    
    UITapGestureRecognizer *areaTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:areaTap];
    
    // add label title Tos Tov
//    UILabel *lblTosTov = [[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 140) / 2 , 60, 140, 50)];
//    lblTosTov.textColor = [UIColor whiteColor];
//    lblTosTov.text = @"TOS @ TOV";
//    lblTosTov.font = [UIFont systemFontOfSize:25];
//    [self.view addSubview:lblTosTov];
    
    // add logo tos tov
    UIImageView *tosTovLogo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"TosTovLogo.png"]];
    tosTovLogo.frame = CGRectMake((self.view.frame.size.width - 150) / 2, 60, 150, 35);
    [self.view addSubview:tosTovLogo];
    
    // add logo phone
    UIImageView *phoneLogo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"PhoneLogo.png"]];
    phoneLogo.frame = CGRectMake(30,tosTovLogo.frame.origin.y+150,
                                 30, 30);
    phoneLogo.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:phoneLogo];
    
    // phone number text field
    self.txtPhoneNumber = [[UITextField alloc]initWithFrame:CGRectMake(phoneLogo.frame.origin.x + phoneLogo.frame.size.width + 20,
                                                                      phoneLogo.frame.origin.y,
                                                                       self.view.bounds.size.width - 110, 30)];
    //self.txtPhoneNumber.placeholder = @"Phone Number";
    self.txtPhoneNumber.borderStyle = UITextBorderStyleNone;
    [self.txtPhoneNumber setKeyboardType:UIKeyboardTypeNumberPad];
    self.txtPhoneNumber.textColor = [UIColor whiteColor];
    self.txtPhoneNumber.font = [UIFont systemFontOfSize:12];
    self.txtPhoneNumber.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Phone Number" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName : [UIFont systemFontOfSize:12]}];
    self.txtPhoneNumber.delegate = self;
    
    self.txtPhoneNumber.text = @"010576020";
    
    [self.view addSubview:self.txtPhoneNumber];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(phoneLogo.frame.origin.x + phoneLogo.frame.size.width + 20,
                                                           self.txtPhoneNumber.frame.origin.y + self.txtPhoneNumber.bounds.size.height + 3 ,
                                                            self.txtPhoneNumber.bounds.size.width, 1)];
    line1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:line1];
    
    // add logo lock
    UIImageView *lockLogo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"LockLogo.png"]];
    lockLogo.frame = CGRectMake(30,self.txtPhoneNumber.frame.origin.y + 50,
                                 30, 30);
    //lockLogo.layer.borderWidth = 2;
    lockLogo.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:lockLogo];
    
    // add password text field
    self.txtPassword = [[UITextField alloc]initWithFrame:CGRectMake(lockLogo.frame.origin.x + lockLogo.frame.size.width + 20,
                                                                   lockLogo.frame.origin.y,
                                                                   self.view.bounds.size.width - 110, 30)];
    //self.txtPassword.placeholder = @"Password";
    self.txtPassword.borderStyle = UITextBorderStyleNone;
    self.txtPassword.secureTextEntry = YES;
    self.txtPassword.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName : [UIFont systemFontOfSize:12]}];
    self.txtPassword.delegate = self;
    
    self.txtPassword.text = @"Charlie@92";
    
    [self.view addSubview:self.txtPassword];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(lockLogo.frame.origin.x + lockLogo.frame.size.width + 20,
                                                           self.txtPassword.frame.origin.y + self.txtPassword.bounds.size.height + 3,
                                                            self.txtPassword.bounds.size.width, 1)];
    line2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:line2];
    
    
    // add show password button
    self.btnShowPassimage = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnShowPassimage.frame = CGRectMake(0,0, 25, 15);
    [self.btnShowPassimage setBackgroundImage:[UIImage imageNamed:@"EyeLogo.png"] forState:UIControlStateNormal];
    self.btnShowPassimage.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.btnShowPassimage addTarget:self action:@selector(showPassword) forControlEvents:UIControlEventTouchUpInside];
    self.txtPassword.rightViewMode = UITextFieldViewModeAlways;
    self.txtPassword.rightView = self.btnShowPassimage;
    
    // add button sign in
    self.btnSignIn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnSignIn.frame = CGRectMake(30,self.txtPassword.frame.origin.y + 100,
                                    self.view.bounds.size.width - 60,
                                      30);
    
    self.btnSignIn.backgroundColor = [UIColor redColor];
    UILabel *signin = [[UILabel alloc]initWithFrame:CGRectMake((self.btnSignIn.frame.size.width-45) / 2,
                                                               5, 45, 20)];
    signin.text = @"SIGN IN";
    signin.font = [UIFont systemFontOfSize:12];
    signin.textColor = [UIColor whiteColor];
    
    [self.btnSignIn addSubview:signin];
    [self.btnSignIn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnSignIn];
    
    // add forget password
    self.forgetPassword = [[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width-90) / 2,
                                                                  self.btnSignIn.frame.origin.y + 50,
                                                                   90, 20)];
    self.forgetPassword.text = @"Forget Password?";
    self.forgetPassword.textColor = [UIColor whiteColor];
    self.forgetPassword.font = [UIFont systemFontOfSize:10];
    // add gesture tap to forget password
    UITapGestureRecognizer *tapForgetPass = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnForgetPassword)];
    tapForgetPass.numberOfTapsRequired = 1;
    self.forgetPassword.userInteractionEnabled = YES;
    [self.forgetPassword addGestureRecognizer:tapForgetPass];
    [self.view addSubview:self.forgetPassword];
    
    // add footer view
    UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50)];
    footer.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:footer];
    
    // add label Don't have an account
    UILabel *dontHaveAcc = [[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 165) / 2,
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
    // add gesture tap to sign up
    UITapGestureRecognizer *tapForSignUp = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(registerNewAcc)];
    tapForSignUp.numberOfTapsRequired = 1;
    self.signUp.userInteractionEnabled = YES;
    [self.signUp addGestureRecognizer:tapForSignUp];
    
    [footer addSubview:self.signUp];
    
    // add gesture tap to sign up
    UITapGestureRecognizer *tapForSignUp2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(registerNewAcc)];
    tapForSignUp2.numberOfTapsRequired = 1;
    
    footer.userInteractionEnabled = YES;
    [footer addGestureRecognizer:tapForSignUp2];
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
    self.view.frame = CGRectMake(0, -120, self.view.bounds.size.width, self.view.bounds.size.height);
}
-(void)keyboardDidHide{
    self.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
}

-(void)dismissKeyboard{
    [self.view endEditing:true];
    [self keyboardDidHide];
}


@end
