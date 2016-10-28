//
//  ViewController.m
//  FingerPrint
//
//  Created by yxhe on 16/10/28.
//  Copyright © 2016年 tashaxing. All rights reserved.
//

// ---- test the TouchID ---- //

#import "ViewController.h"
#import "VerifyView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view setBackgroundColor:[UIColor greenColor]];
    
    // add the verify page to hide mainpage
    VerifyView *verifyView = [[VerifyView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:verifyView];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
