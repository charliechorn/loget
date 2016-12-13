//
//  NewPasswordViewController.m
//  TosTov
//
//  Created by Pichzz on 11/7/16.
//  Copyright © 2016 Chhaly. All rights reserved.
//

#import "NewPasswordViewController.h"
#import "Reachability.h"
#import "MyManager.h"
#import "WSChangePassword.h"

@interface NewPasswordViewController ()

@property (nonatomic, strong) UITextField *txtConfirmPassword;
@property (nonatomic, strong) UITextField *txtNewPassword;
@property (nonatomic, strong) UIButton *btnShowPassimage;
@property (nonatomic, strong) UIButton *btnResetPassword;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;

@end

@implementation NewPasswordViewController{
    bool isShownPassword;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    isShownPassword = false;
    [self addComponents];
}

                                        /** Functionality **/
// Reset new password
-(void)resetPassword{
    // Check blank input
    if ([self.txtNewPassword.text isEqualToString:@""]) {
        [self alertBoxWithMessage:@"Invalid" message:@"Please input new password"];
        return;
    }
    if ([self.txtConfirmPassword.text isEqualToString:@""]) {
        [self alertBoxWithMessage:@"Invalid" message:@"Please input confirm password"];
        return;
    }
    
    // Check match password
    if (![self.txtNewPassword.text isEqualToString:self.txtConfirmPassword.text]) {
        [self alertBoxWithMessage:@"" message:@"Your password doesn't match"];
        return;
    }
    
    // validate password
    //int numOfChars = 0;
    BOOL lowerCaseLetter = 0;
    BOOL uppercaseLetter = 0;
    BOOL digitChar =0;
    if (self.txtConfirmPassword.text.length >= 6) {
        for(int i=0; i<self.txtConfirmPassword.text.length ;i++){
            unichar c = [self.txtConfirmPassword.text characterAtIndex:i];
            if(!lowerCaseLetter){
                lowerCaseLetter = [[NSCharacterSet lowercaseLetterCharacterSet] characterIsMember:c];
            }
            if(!uppercaseLetter){
                uppercaseLetter = [[NSCharacterSet uppercaseLetterCharacterSet] characterIsMember:c];
            }
            if (!digitChar) {
                digitChar = [[NSCharacterSet decimalDigitCharacterSet] characterIsMember:c];
            }
        }
        if (lowerCaseLetter && uppercaseLetter && digitChar) {
            [self changeNewPasword];
            [self.view endEditing:true];
            
            
        }
        else{
            [self alertBoxWithMessage:@"" message:@"Password must be at least 6 characters (mininum 1 uppercase, 1 lowercase, 1 number))"];
        }
    }
    else {
        [self alertBoxWithMessage:@"" message:@"Password must be at least 6 characters (mininum 1 uppercase, 1 lowercase, 1 number))"];
    }
    
}

// Change new password
-(void)changeNewPasword{
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable) {
        //connection unavailable
        [self alertBoxWithMessage:@"No Internet!" message:@"Please check internet connection."];
    }
    else {
        [self.spinner startAnimating];
        [self.view addSubview:self.spinner];
        
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
        [parameters setObject:[[MyManager sharedManager]phone]  forKey:@"phone"];
        [parameters setObject:self.txtNewPassword.text forKey:@"newPassword"];
        
         __weak NewPasswordViewController *weakSelf = self;
        WSChangePassword *changePassService = [[WSChangePassword alloc]init];
        changePassService.postBody = parameters;
        
        changePassService.onSuccess = ^(id contr, id result){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.spinner removeFromSuperview];
                NSUserDefaults *standardUserDefault = [NSUserDefaults standardUserDefaults];
                [standardUserDefault setObject:@"1" forKey:@"isChangePassword"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NofLogin" object:nil];
            });
            
        };
        
        changePassService.onError = ^(id contr, id result){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.spinner removeFromSuperview];
                NSDictionary *response = [[NSDictionary alloc]initWithDictionary:result];
                [weakSelf alertBoxWithMessage:@"Error" message:[NSString stringWithFormat:@"%@",[response objectForKey:@"error"]]];
            });
        };
        
        [changePassService callRequest];
        
    }
//    else
//    {
//        //connection available
//        NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
//        
//        
//        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
//        NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
//        NSString *dataURL = @"http://1-dot-tostov-server.appspot.com/tostovwebservice/changepassword";
//        
//        //NSError *writeError = nil;
//        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
//        //NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
//        //    let jsonData = try! NSJSONSerialization.dataWithJSONObject(parameters, options: [])
//        //    //        let jsonString = String(data: jsonData, encoding: NSUTF8StringEncoding)
//        
//        NSURL *url = [[NSURL alloc]initWithString:dataURL];
//        NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc]initWithURL:url];
//        urlRequest.HTTPMethod = @"POST";
//        [urlRequest setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
//        urlRequest.HTTPBody = jsonData;
//        
//        NSURLSessionDataTask *task = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//            // handle request error
//            if (error) {
//                NSLog(@"Error is %@", error);
//            }else{
//                NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//                //NSLog(@"Response is %@",responseData);
//                
//                [[MyManager sharedManager] setUserId:[responseData objectForKey:@"id"]];
//                [[MyManager sharedManager] setPassword:[responseData objectForKey:@"password"]];
//                [[MyManager sharedManager]setPhone:[responseData objectForKey:@"phone"]];
//                [[MyManager sharedManager] setSessionId:[responseData objectForKey:@"sessionId"]];
//                
//            }
//            
//        }];
//        [task resume];
//    }

}

// Show hidden secured text
-(void)showPassword{
    if (isShownPassword) {
        [self.txtNewPassword setSecureTextEntry:true];
        isShownPassword = false;
        [self.btnShowPassimage setBackgroundImage:[UIImage imageNamed:@"EyeLogo.png"] forState:UIControlStateNormal];
    }
    else {
        [self.txtNewPassword setSecureTextEntry:false];
        isShownPassword = true;
        [self.btnShowPassimage setBackgroundImage:[UIImage imageNamed:@"EyeActionLogo.png"] forState:UIControlStateNormal];
    }
}

// Back to passcode view
-(void)backToPasscode{
    [self dismissViewControllerAnimated:YES completion:nil];
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
    
    // Force navigation bar not to hide any top view
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    // add spinner
    self.spinner = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-25,self.view.frame.size.height/2-25,50,50)];
    
    self.spinner.color = [UIColor redColor];
    
    // add back button
    UIImage *backIcon = [[UIImage imageNamed:@"BackIcon.png"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:backIcon style:UIBarButtonItemStylePlain target:self action:@selector(backToPasscode)];
    self.navigationItem.leftBarButtonItem = barButtonItem;

    
    //self.view.backgroundColor = [UIColor grayColor];
    UIImageView *backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"TosTovBackgroundAll.png"]];
    backgroundView.contentMode = UIViewContentModeScaleAspectFill;
    backgroundView.frame = self.view.bounds;
    [self.view insertSubview:backgroundView atIndex:0];
    
    UITapGestureRecognizer *areaTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:areaTap];
    
    
    // add logo tos tov
    UIImageView *tosTovLogo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"TosTovLogo.png"]];
    tosTovLogo.frame = CGRectMake((self.view.frame.size.width - 150) / 2, 10, 150, 35);
    [self.view addSubview:tosTovLogo];
    
    // add label message
    UILabel *lblMessage = [[UILabel alloc]initWithFrame:CGRectMake((self.view.bounds.size.width - 150) / 2,
                                                                   tosTovLogo.frame.origin.y + tosTovLogo.frame.size.height + 15,
                                                                   150,20)];
    lblMessage.text = @"CHANGE PASSWORD";
    lblMessage.font = [UIFont systemFontOfSize:15];
    lblMessage.textColor = [UIColor whiteColor];
    [self.view addSubview:lblMessage];
    
    // add textfield new password
    UIImageView *lockLogo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"LockLogo.png"]];
    lockLogo.frame = CGRectMake(30,
                                 lblMessage.frame.origin.y+100,
                                 30, 30);
    lockLogo.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:lockLogo];
    
    self.txtNewPassword = [[UITextField alloc]initWithFrame:CGRectMake(lockLogo.frame.origin.x + lockLogo.frame.size.width + 20,
                                                                       lockLogo.frame.origin.y,
                                                                       self.view.bounds.size.width - 110,30)];
    self.txtNewPassword.borderStyle = UITextBorderStyleNone;
    self.txtNewPassword.secureTextEntry = YES;
    self.txtNewPassword.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"New Password" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName : [UIFont systemFontOfSize:12]}];
    self.txtNewPassword.delegate = self;
    [self.view addSubview:self.txtNewPassword];
    
    // add show password button
    self.btnShowPassimage = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnShowPassimage.frame = CGRectMake(0, 0, 25, 15);
    [self.btnShowPassimage setBackgroundImage:[UIImage imageNamed:@"EyeLogo.png"] forState:UIControlStateNormal];
    [self.btnShowPassimage addTarget:self action:@selector(showPassword) forControlEvents:UIControlEventTouchUpInside];
    self.txtNewPassword.rightViewMode = UITextFieldViewModeAlways;
    self.txtNewPassword.rightView = self.btnShowPassimage;
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(lockLogo.frame.origin.x + lockLogo.frame.size.width + 20,
                                                           self.txtNewPassword.frame.origin.y + self.txtNewPassword.bounds.size.height + 3,
                                                            self.txtNewPassword.bounds.size.width, 1)];
    line1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:line1];
    
    // add textfield confirm password
    UIImageView *lockLogo2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"LockLogo.png"]];
    lockLogo2.frame = CGRectMake(30,
                                self.txtNewPassword.frame.origin.y + 50,
                                30, 30);
    lockLogo2.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:lockLogo2];
    
    self.txtConfirmPassword = [[UITextField alloc]initWithFrame:CGRectMake(lockLogo.frame.origin.x + lockLogo.frame.size.width + 20,
                                                                           lockLogo2.frame.origin.y,
                                                                           self.view.bounds.size.width - 110, 30)];
    self.txtConfirmPassword.borderStyle = UITextBorderStyleNone;
    self.txtConfirmPassword.secureTextEntry = YES;
    self.txtConfirmPassword.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Confirm New Password" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName : [UIFont systemFontOfSize:12]}];
    self.txtConfirmPassword.delegate = self;
    [self.view addSubview:self.txtConfirmPassword];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(lockLogo.frame.origin.x + lockLogo.frame.size.width + 20,
                                                           self.txtConfirmPassword.frame.origin.y + self.txtConfirmPassword.bounds.size.height + 3,
                                                            self.txtConfirmPassword.bounds.size.width, 1)];
    line2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:line2];
    
    // add button reset password
    self.btnResetPassword = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnResetPassword.frame = CGRectMake(30,
                                      self.txtConfirmPassword.frame.origin.y + 70,
                                      self.view.bounds.size.width - 60,
                                      30);
    
    self.btnResetPassword.backgroundColor = [UIColor redColor];
    UILabel *signin = [[UILabel alloc]initWithFrame:CGRectMake((self.btnResetPassword.frame.size.width - 110)/2,
                                                               5,110,20)];
    signin.text = @"RESET PASSWORD";
    signin.font = [UIFont systemFontOfSize:12];
    signin.textColor = [UIColor whiteColor];
    
    [self.btnResetPassword addSubview:signin];
    [self.btnResetPassword addTarget:self action:@selector(resetPassword) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnResetPassword];
    
    
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
