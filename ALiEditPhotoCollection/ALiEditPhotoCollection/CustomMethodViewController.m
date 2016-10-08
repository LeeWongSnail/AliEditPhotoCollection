//
//  CustomMethodViewController.m
//  ALiEditPhotoCollection
//
//  Created by LeeWong on 2016/10/8.
//  Copyright © 2016年 LeeWong. All rights reserved.
//

#import "CustomMethodViewController.h"

@interface CustomMethodViewController () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIImageView *orgImageV;

@property (nonatomic, strong) UIImageView *thumbilImage;

@end

@implementation CustomMethodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageV = [[UIImageView alloc] init];
    imageV.image = [UIImage imageNamed:@"1"];
    [self.view addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@200);
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
    }];
    
    imageV.userInteractionEnabled = YES;
    
    [imageV addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)]];
    
    
    self.orgImageV = imageV;
}

- (void)panGesture:(UIGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateChanged) {
        CGPoint point = [gesture locationInView:self.view];
        [self.thumbilImage mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.mas_left).offset(point.x);
            make.centerY.equalTo(self.view.mas_top).offset(point.y);
            make.width.height.equalTo(@80);
        }];
    } else if (gesture.state == UIGestureRecognizerStateEnded){
        
    }
}


- (void)longPress:(UIGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.thumbilImage = [[UIImageView alloc] init];
        self.thumbilImage.userInteractionEnabled = YES;
        [self.thumbilImage addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)] ];
        self.thumbilImage.image = [UIImage imageNamed:@"1"];
        [self.view addSubview:self.thumbilImage];
        [self.thumbilImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@80);
            make.centerX.equalTo(self.view.mas_centerX);
            make.centerY.equalTo(self.view.mas_centerY);
        }];
        
        UIView *whiteCover = [[UIView alloc] init];
        whiteCover.backgroundColor = [UIColor whiteColor];
        whiteCover.alpha = 0.7;
        [self.orgImageV addSubview:whiteCover];
        [whiteCover mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.orgImageV);
        }];
        
        self.orgImageV.userInteractionEnabled = NO;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
