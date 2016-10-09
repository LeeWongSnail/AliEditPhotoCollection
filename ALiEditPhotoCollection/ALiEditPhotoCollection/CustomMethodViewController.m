//
//  CustomMethodViewController.m
//  ALiEditPhotoCollection
//
//  Created by LeeWong on 2016/10/8.
//  Copyright © 2016年 LeeWong. All rights reserved.
//

#import "CustomMethodViewController.h"
#import "ALiCollectionViewLayout.h"

@interface CustomMethodViewController () <UIGestureRecognizerDelegate,ALiLayoutDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UIImageView *orgImageV;

@property (nonatomic, strong) UIImageView *thumbilImage;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *images;

@property (nonatomic, strong)  ALiCollectionViewLayout *layout;

@end

@implementation CustomMethodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"随意拖动改变位置";
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.images = [NSMutableArray array];
    for (NSInteger i = 0; i < 20; i++) {
        [self.images addObject:[NSString stringWithFormat:@"%tu",i]];
    }
    
    [self.collectionView reloadData];
    
//    UIImageView *imageV = [[UIImageView alloc] init];
//    imageV.image = [UIImage imageNamed:@"1"];
//    [self.view addSubview:imageV];
//    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.height.equalTo(@200);
//        make.centerX.equalTo(self.view.mas_centerX);
//        make.centerY.equalTo(self.view.mas_centerY);
//    }];
//    
//    imageV.userInteractionEnabled = YES;
//    
//    [imageV addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)]];
//    
//    
//    self.orgImageV = imageV;
}

//- (void)panGesture:(UIGestureRecognizer *)gesture
//{
//    if (gesture.state == UIGestureRecognizerStateChanged) {
//        CGPoint point = [gesture locationInView:self.view];
//        [self.thumbilImage mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(self.view.mas_left).offset(point.x);
//            make.centerY.equalTo(self.view.mas_top).offset(point.y);
//            make.width.height.equalTo(@80);
//        }];
//    } else if (gesture.state == UIGestureRecognizerStateEnded){
//        
//    }
//}


//- (void)longPress:(UIGestureRecognizer *)gesture
//{
//    if (gesture.state == UIGestureRecognizerStateBegan) {
//        self.thumbilImage = [[UIImageView alloc] init];
//        self.thumbilImage.userInteractionEnabled = YES;
//        [self.thumbilImage addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)] ];
//        self.thumbilImage.image = [UIImage imageNamed:@"1"];
//        [self.view addSubview:self.thumbilImage];
//        [self.thumbilImage mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.width.height.equalTo(@80);
//            make.centerX.equalTo(self.view.mas_centerX);
//            make.centerY.equalTo(self.view.mas_centerY);
//        }];
//        
//        UIView *whiteCover = [[UIView alloc] init];
//        whiteCover.backgroundColor = [UIColor whiteColor];
//        whiteCover.alpha = 0.7;
//        [self.orgImageV addSubview:whiteCover];
//        [whiteCover mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(self.orgImageV);
//        }];
//        
//        self.orgImageV.userInteractionEnabled = NO;
//    }
//}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.tag = 10000+indexPath.item;
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    label.text = self.images[indexPath.item];
    [label sizeToFit];
    cell.contentView.backgroundColor = [UIColor redColor];
    [cell.contentView addSubview:label];
    [cell.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(cell.contentView);
    }];
    
    cell.backgroundColor = [UIColor redColor];
    
    return cell;
}

- (void)moveDataItem:(NSIndexPath*)fromIndexPath toIndexPath:(NSIndexPath*)toIndexPath
{
    id obj = [self.images objectAtIndex:fromIndexPath.item];
    [self.images removeObjectAtIndex:fromIndexPath.item];
    [self.images insertObject:obj atIndex:toIndexPath.item];
    
}

- (void)handleTapGesture:(UIGestureRecognizer *)gesture
{
    CGPoint loc = [gesture locationInView:self.collectionView];
    __block BOOL isIn = YES;
    [[self.collectionView visibleCells] enumerateObjectsUsingBlock:^(__kindof UICollectionViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (CGRectContainsPoint(obj.frame, loc)) {
            isIn = YES;
            return ;
        } else {
            isIn = NO;
        }
    }];
    
    if (!isIn) {
        [[self.collectionView visibleCells] enumerateObjectsUsingBlock:^(__kindof UICollectionViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.layout stop:obj];
        }];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        self.layout = [[ALiCollectionViewLayout alloc] init];
        self.layout.delegate = self;
        //layout.dataSource = self;
        self.layout.itemSize = CGSizeMake(100, 100);
        self.layout.minimumInteritemSpacing = 1;
        self.layout.minimumLineSpacing      = 1;
        self.layout.sectionInset = UIEdgeInsetsMake(1, 1, 1, 1);
        self.layout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 40.f);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.height) collectionViewLayout:self.layout];
        
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        //此处给其增加长按手势，用此手势触发cell移动效果
        UITapGestureRecognizer *longGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        [_collectionView addGestureRecognizer:longGesture];
        
    }
    return _collectionView;
}
@end
