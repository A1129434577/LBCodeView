//
//  ViewController.m
//  LBTextFieldDemo
//
//  Created by 刘彬 on 2019/9/24.
//  Copyright © 2019 刘彬. All rights reserved.
//

#import "ViewController.h"
#import "LBCodeView.h"
@interface ViewController ()
@property (nonatomic, strong) LBCodeView *codeView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"LBCodeView";
    LBCodeView *codeView = [[LBCodeView alloc] initWithFrame:CGRectMake(20, 200, CGRectGetWidth(self.view.frame)-20*2, 60) numbersCount:6 space:15];
    codeView.hiddenTextField.secureTextEntry = YES;
    codeView.hiddenTextField.textColor = [UIColor cyanColor];
    [codeView.codeShowButtons enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.layer.borderWidth = 0.5;
        obj.layer.borderColor = [UIColor magentaColor].CGColor;
    }];
    [self.view addSubview:codeView];
    _codeView = codeView;
    codeView.codeInputFinish = ^(NSString * _Nonnull code) {
        NSLog(@"%@",code);
    };
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [_codeView.hiddenTextField becomeFirstResponder];
}
@end
