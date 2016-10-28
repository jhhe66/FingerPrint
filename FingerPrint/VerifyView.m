//
//  VerifyView.m
//  FingerPrint
//
//  Created by yxhe on 16/10/28.
//  Copyright © 2016年 tashaxing. All rights reserved.
//
// ---- verify page ---- //

#import "VerifyView.h"
#import <LocalAuthentication/LocalAuthentication.h>

@implementation VerifyView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(self.frame.size.width / 2 - 100, 300, 200, 50);
        [button setTitle:@"verify TouchID" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(verifyTouchID) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        // initialize
        [self verifyTouchID];
    }
    return self;
}

- (void)verifyTouchID
{
    // when iOS version > 8, then use TouchID
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0)
    {
        // check if supports TouchID
        LAContext *context = [[LAContext alloc] init];
        NSError *error;
        if (![context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error])
        {
            switch (error.code)
            {
                case LAErrorTouchIDNotEnrolled:
                {
                    NSLog(@"TouchID is not enrolled");
                    break;
                }
                case LAErrorPasscodeNotSet:
                {
                    NSLog(@"A passcode has not been set");
                    break;
                }
                default:
                {
                    NSLog(@"TouchID not available");
                    break;
                }
                    
                    return;
            }
        }
        
        // verify TouchID
        // 用LAPolicyDeviceOwnerAuthentication可以在指纹密码失败之后调出系统密码键盘
        // 用LAPolicyDeviceOwnerAuthenticationWithBiometrics智能是指纹识别
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthentication
                localizedReason:@"test for fun"
                          reply:^(BOOL success, NSError * _Nullable error) {
                              if (success)
                              {
                                  NSLog(@"verify success");
                                  // update UI
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      
                                      // show mainpage with fading animation
                                      [UIView animateWithDuration:1 animations:^{
                                          self.alpha = 0;
                                      } completion:^(BOOL finished) {
                                          [self removeFromSuperview];
                                      }];
                                  });
                              }
                              
                              if (error)
                              {
                                  switch (error.code)
                                  {
                                      case LAErrorSystemCancel:
                                      {
                                          NSLog(@"系统取消授权，如其他APP切入");
                                          break;
                                      }
                                      case LAErrorUserCancel:
                                      {
                                          NSLog(@"用户取消验证Touch ID");
                                          break;
                                      }
                                      case LAErrorAuthenticationFailed:
                                      {
                                          NSLog(@"授权失败");
                                          break;
                                      }
                                      case LAErrorPasscodeNotSet:
                                      {
                                          NSLog(@"系统未设置密码");
                                          break;
                                      }
                                      case LAErrorTouchIDNotAvailable:
                                      {
                                          NSLog(@"设备Touch ID不可用，例如未打开");
                                          break;
                                      }
                                      case LAErrorTouchIDNotEnrolled:
                                      {
                                          NSLog(@"设备Touch ID不可用，用户未录入");
                                          break;
                                      }
                                      case LAErrorUserFallback:
                                      {
                                          [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                              NSLog(@"用户选择输入密码，切换主线程处理");
                                          }];
                                          break;
                                      }
                                      default:
                                      {
                                          [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                              NSLog(@"其他情况，切换主线程处理");
                                          }];
                                          break;
                                      }
                                  }
                              }
                              
                          }];
    }
}




@end
