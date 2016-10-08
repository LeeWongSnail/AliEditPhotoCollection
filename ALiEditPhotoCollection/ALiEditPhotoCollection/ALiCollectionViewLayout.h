//
//  ALiCollectionViewLayout.h
//  ALiEditPhotoCollection
//
//  Created by LeeWong on 2016/10/8.
//  Copyright © 2016年 LeeWong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ALiLayoutDelegate <NSObject>

//去改变数据源
- (void)moveDataItem:(NSIndexPath*)fromIndexPath toIndexPath:(NSIndexPath*)toIndexPath;

@end

@interface ALiCollectionViewLayout : UICollectionViewFlowLayout
@property (nonatomic, assign) id<ALiLayoutDelegate> delegate;

- (void)stop:(UICollectionViewCell *)aView;
@end
