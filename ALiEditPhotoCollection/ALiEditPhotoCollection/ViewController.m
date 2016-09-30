//
//  ViewController.m
//  ALiEditPhotoCollection
//
//  Created by LeeWong on 2016/9/28.
//  Copyright © 2016年 LeeWong. All rights reserved.
//

#import "ViewController.h"
#import "SystemMethodViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)systemMethod:(UIButton *)sender {
    SystemMethodViewController *sysVc = [[SystemMethodViewController alloc] init];
    
    [self.navigationController pushViewController:sysVc animated:YES];
}

- (IBAction)customMethod:(UIButton *)sender {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
