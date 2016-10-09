//
//  ALiCollectionViewLayout.m
//  ALiEditPhotoCollection
//
//  Created by LeeWong on 2016/10/8.
//  Copyright © 2016年 LeeWong. All rights reserved.
//

#import "ALiCollectionViewLayout.h"

@interface ALiCollectionViewLayout () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UILongPressGestureRecognizer *longPress;
@property (nonatomic, strong) NSIndexPath *currentIndexPath;    //当前的IndexPath
@property (nonatomic, strong) UIView *mappingImageCell;         //拖动cell的截图

@end

@implementation ALiCollectionViewLayout

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self configureObserver];
    }
    return self;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self configureObserver];
    }
    return self;
}

- (void)dealloc{
    [self removeObserver:self forKeyPath:@"collectionView"];
}

#pragma mark - setup

- (void)configureObserver{
    [self addObserver:self forKeyPath:@"collectionView" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)setUpGestureRecognizers{
    if (self.collectionView == nil) {
        return;
    }
    _longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPress:)];
    _longPress.minimumPressDuration = 0.2f;
    _longPress.delegate = self;
    [self.collectionView addGestureRecognizer:_longPress];
}

#pragma mark - observer
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"collectionView"]) {
        [self setUpGestureRecognizers];
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)handleLongPress:(UILongPressGestureRecognizer*)longPress
{
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan:
        {
            CGPoint location = [longPress locationInView:self.collectionView];
            NSIndexPath* indexPath = [self.collectionView indexPathForItemAtPoint:location];
            if (!indexPath) return;
            
            self.currentIndexPath = indexPath;
            UICollectionViewCell* targetCell = [self.collectionView cellForItemAtIndexPath:self.currentIndexPath];
            //得到当前cell的映射(截图)
            UIView* cellView = [targetCell snapshotViewAfterScreenUpdates:YES];
            self.mappingImageCell = cellView;
            self.mappingImageCell.frame = cellView.frame;
            targetCell.hidden = YES;
            [self.collectionView addSubview:self.mappingImageCell];
            
            cellView.center = targetCell.center;
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint point = [longPress locationInView:self.collectionView];
            //更新cell的位置
            self.mappingImageCell.center = point;
            NSIndexPath * indexPath = [self.collectionView indexPathForItemAtPoint:point];
            if (indexPath == nil )  return;
            if (![indexPath isEqual:self.currentIndexPath])
            {
                //改变数据源
                if ([self.delegate respondsToSelector:@selector(moveDataItem:toIndexPath:)]) {
                    [self.delegate moveDataItem:self.currentIndexPath toIndexPath:indexPath];
                }
                [self.collectionView moveItemAtIndexPath:self.currentIndexPath toIndexPath:indexPath];
                self.currentIndexPath = indexPath;
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:self.currentIndexPath];
            
            [UIView animateWithDuration:0.25 animations:^{
                self.mappingImageCell.center = cell.center;
            } completion:^(BOOL finished) {
                [self.mappingImageCell removeFromSuperview];
                cell.hidden           = NO;
                self.mappingImageCell = nil;
                self.currentIndexPath = nil;
            }];
        }
            break;
        default:
        {
            
        }
            break;
    }
    
    
    if (longPress.state == UIGestureRecognizerStateEnded) {
        //抖动效果
        CGPoint loc = [longPress locationInView:self.collectionView];
        __block BOOL isIn = YES;
        [[self.collectionView visibleCells] enumerateObjectsUsingBlock:^(__kindof UICollectionViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSLog(@"%tu",obj.tag);
            CGRect rect = [obj convertRect:obj.frame toView:self.collectionView];
            if (CGRectContainsPoint(rect, loc)) {
                isIn = YES;
                *stop = YES;
            } else {
                isIn = NO;
            }
        }];
        
        if (isIn) {
            [[self.collectionView visibleCells] enumerateObjectsUsingBlock:^(__kindof UICollectionViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                CABasicAnimation *animation = (CABasicAnimation *)[obj.layer animationForKey:@"rotation"];
                if (animation == nil) {
                    [self shakeView:obj];
                }else {
                    [self resume:obj];
                }
            }];
        }
        
    }
}



//layer.speed
/* The rate of the layer. Used to scale parent time to local time, e.g.
 * if rate is 2, local time progresses twice as fast as parent time.
 * Defaults to 1. */
//这个参数的理解比较复杂，我的理解是所在layer的时间与父layer的时间的相对速度，为1时两者速度一样，为2那么父layer过了一秒，而所在layer过了两秒（进行两秒动画）,为0则静止。
- (void)stop:(UICollectionViewCell *)aView {
    aView.layer.speed = 0.0;
}

- (void)resume:(UICollectionViewCell *)aView  {
    aView.layer.speed = 1.0;
}

- (void)shakeView:(UICollectionViewCell *)aView {
    //创建动画对象,绕Z轴旋转
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    //设置属性，周期时长
    [animation setDuration:0.08];
    
    //抖动角度
    animation.fromValue = @(-M_1_PI/2);
    animation.toValue = @(M_1_PI/2);
    //重复次数，无限大
    animation.repeatCount = HUGE_VAL;
    //恢复原样
    animation.autoreverses = YES;
    //锚点设置为图片中心，绕中心抖动
    aView.layer.anchorPoint = CGPointMake(0.5, 0.5);
    
    [aView.layer addAnimation:animation forKey:@"rotation"];
}

@end
