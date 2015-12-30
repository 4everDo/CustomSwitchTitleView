//
//  SwitchTitleView.h
//  WeShow
//
//  Created by yite on 15/8/25.
//  Copyright (c) 2015年 yite. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SwitchTitleView;
@protocol SwitchTitleViewDelegate <NSObject>
- (void)switchChange:(NSInteger)switchViewIndex;
@end

@interface SwitchTitleView : UIView
@property (nonatomic,assign)id <SwitchTitleViewDelegate> delegate;
- (SwitchTitleView *)initSwitchTitleView:(NSArray *)titleArray frame:(CGRect)frame;
- (void)resetSwitchIndex:(NSInteger)index;
@end
