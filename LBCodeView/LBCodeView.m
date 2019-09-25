//
//  LBCodeView.m
//  Driver
//
//  Created by 刘彬 on 2019/5/7.
//  Copyright © 2019 BIN. All rights reserved.
//

#import "LBCodeView.h"

@interface LBCodeView ()<UITextFieldDelegate>
@property (nonatomic,assign)NSUInteger count;
@end

@implementation LBCodeView

- (instancetype)initWithFrame:(CGRect)frame numbersCount:(NSUInteger)count space:(CGFloat)space
{
    self = [super initWithFrame:frame];
    if (self) {
        _count = count;
        _codeShowButtons = [[NSMutableArray alloc] init];
        
        _hiddenTextField = [[UITextField alloc] init];
        _hiddenTextField.delegate = self;
        _hiddenTextField.keyboardType = UIKeyboardTypeNumberPad;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenTextFieldTextDidChange) name:UITextFieldTextDidChangeNotification object:_hiddenTextField];
        [self addSubview:_hiddenTextField];
        
        for (NSUInteger i = 0; i < count; i ++) {
            CGFloat showButtonSide = (CGRectGetWidth(frame)-space*(count-1))/count;
            UIButton *codeShowButton = [[UIButton alloc] initWithFrame:CGRectMake(i*(showButtonSide+space), (CGRectGetHeight(frame)-showButtonSide)/2, showButtonSide, showButtonSide)];
            codeShowButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
            [codeShowButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [codeShowButton addTarget:self action:@selector(editBegain) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:codeShowButton];
            [(NSMutableArray *)_codeShowButtons addObject:codeShowButton];
        }
    }
    return self;
}
-(void)editBegain{
    [_hiddenTextField becomeFirstResponder];
}

-(BOOL)becomeFirstResponder{
    [_hiddenTextField becomeFirstResponder];
    return [super becomeFirstResponder];
}
-(void)hiddenTextFieldTextDidChange{
    typeof(self) __weak weakSelf = self;
    [_codeShowButtons enumerateObjectsUsingBlock:^(__weak UIButton * _Nonnull btn, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < weakSelf.hiddenTextField.text.length) {
            [btn setTitle:[weakSelf.hiddenTextField.text substringWithRange:NSMakeRange(idx, 1)] forState:UIControlStateNormal];
        }else{
            [btn setTitle:nil forState:UIControlStateNormal];
        }
    }];
    if (_hiddenTextField.text.length == _count) {
        [self endEditing:YES];
        weakSelf.codeInputFinish?
        weakSelf.codeInputFinish(weakSelf.hiddenTextField.text):NULL;
    }
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (string.length) {
        if (textField.text.length > _count-1) {
            return NO;
        }
    }
    return YES;
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
