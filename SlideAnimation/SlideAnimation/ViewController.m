//
//  ViewController.m
//  SlideAnimation
//
//  Created by 明镜止水 on 16/10/21.
//  Copyright © 2016年 明镜止水. All rights reserved.
//

#import "ViewController.h"
#import "SlideMeum.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT  [UIScreen mainScreen].bounds.size.height



@interface ViewController ()

@end

@implementation ViewController{
    
    UIVisualEffectView *blurView;
    SlideMeum *slideView;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    
    slideView = [[SlideMeum alloc] initWithFrame:CGRectMake(-WIDTH * fatorW - menuBlankWidth, 0, WIDTH * fatorW + menuBlankWidth, HEIGHT * fatorH)];
    
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(slideBtn)];
    
    self.navigationItem.leftBarButtonItem = leftBtn;
    
}


-(IBAction)slideBtn{
    [slideView slideAnmin];
}



@end
