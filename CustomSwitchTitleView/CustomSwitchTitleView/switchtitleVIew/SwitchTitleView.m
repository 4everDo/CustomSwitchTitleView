//
//  SwitchTitleView.m
//  WeShow
//
//  Created by yite on 15/8/25.
//  Copyright (c) 2015年 yite. All rights reserved.
//

#import "SwitchTitleView.h"
#import "UIColor+AddColor.h"

#define kTitleUnSelectedFont  15.f
#define kButtonTag 100
#define kYellowLineTag 1000
#define kBadgeTag 10
#define kBadgeFond 10.f
#define HEIGHT(view) view.frame.size.height
#define WIDTH(view)  view.frame.size.width
#define VIEW_X(view) view.frame.origin.x
#define VIEW_Y(view) view.frame.origin.y
//是否是iPhone6
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size)) : NO)
//iPhone6 plus
#define iPhone6plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size)) : NO)
#define HEXCOLOR(str) [UIColor colorWithHexString:str]
#define wordColorSecondary      HEXCOLOR(@"#999999")
#define KColorYellow    HEXCOLOR(@"#ffc028")



static const CGFloat Yellow_Line_Width = 50.f;
static const CGFloat Yellow_Line_Height = 2.f;
static const CGFloat Button_Height = 28.f;     //16+12
static const CGFloat Button_Width = 50.f;
static const CGFloat Bottom_Spacing = 4.f;

@interface SwitchTitleView()
{
    UIButton       *lastButton;
    UIView         *yellowLineView;
    UILabel        *xmppLabel; //测试所用
    NSInteger arrayCount;
    CGFloat Button_Space;
    CGFloat Button_Begin_X;
    CGFloat Space_X;
    
}
@property (nonatomic, strong)NSArray *titleArray;
@property (nonatomic, strong)NSMutableArray *labelArray;
@end
@implementation SwitchTitleView
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
- (SwitchTitleView *)initSwitchTitleView:(NSArray *)titleArray frame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _titleArray = titleArray;
        arrayCount = titleArray.count;
        _labelArray = [[NSMutableArray alloc]initWithCapacity:titleArray.count];
        Button_Space = (iPhone6||iPhone6plus)?30.f:20.f;
        Button_Begin_X = frame.size.width/2 - 0.5*arrayCount*Yellow_Line_Width - 0.5*(arrayCount - 1)*Button_Space;
        Space_X = Yellow_Line_Width + Button_Space;
        
        [self addBottomLabel];
        [self addYellowLine];
        [self addButton];
    }
    return self;
}

#pragma mark - Add Icon
/*
 添加所有控件
 */
-(void)addBottomLabel
{
    for (NSInteger i = 0; i < arrayCount; i++) {
        UILabel *bottomLabel = [self createLabelWithIndex:i];
        if (i == 0) {
            bottomLabel.textColor = [UIColor colorWithHexString:@"353535"];
            bottomLabel.transform = CGAffineTransformMakeScale(1.1, 1.1);
        }
        [_labelArray addObject:bottomLabel];
        [self addSubview:bottomLabel];
    }
}

-(void)addYellowLine
{
    yellowLineView = [[UIView alloc] initWithFrame:[self getYellowLineFrame:0]];
    [yellowLineView setBackgroundColor:KColorYellow];
    [self addSubview:yellowLineView];
}


-(void)addButton
{
    for (int i=0; i<arrayCount; i++) {
        UIButton *btn =[self getTitleButton:CGRectZero title:[_titleArray objectAtIndex:i] tag:i+kButtonTag];
        btn.frame = [self getButtonFrame:i];
        if (i==0){
            lastButton = btn;
        }
        [self addSubview:btn];
        [self addSubview:[self getBadgeNumberView:CGRectMake(Button_Begin_X + Space_X * i + 44,btn.center.y - 16 , 15, 15) title:@"1" tag:i+kBadgeTag]];
    }
    
}

/*
 Create Label
 */
-(UILabel *)createLabelWithIndex:(NSInteger) index
{
    UILabel *label = [[UILabel alloc]initWithFrame:[self getLabelFrame:index]];
    label.textAlignment = NSTextAlignmentCenter;
    [label setText:_titleArray[index]];
    UIColor *textColor = wordColorSecondary;
    UIFont *textFont = [UIFont systemFontOfSize:kTitleUnSelectedFont];
    [label setTextColor:textColor];
    [label setFont:textFont];
    return label;
}

#pragma mark -- Get Frame
-(CGRect)getLabelFrame:(NSInteger) index
{
    CGRect frame = CGRectMake(Button_Begin_X + Space_X*index, self.frame.size.height - Button_Height - Yellow_Line_Height - Bottom_Spacing, Button_Width, Button_Height);
    return frame;
}

-(CGRect)getButtonFrame:(NSInteger) index
{
    CGRect frame = CGRectMake(Button_Begin_X + Space_X*index,0, Button_Width,self.frame.size.height);
    return frame;
}

-(CGRect)getYellowLineFrame:(NSInteger) index
{
    CGRect lineFrame = CGRectMake(Button_Begin_X + Space_X*index, self.frame.size.height - Bottom_Spacing - Yellow_Line_Height, Yellow_Line_Width, Yellow_Line_Height);
    return lineFrame;
}


#pragma mark - 动画
-(void)startAnimation:(NSInteger) newIndex OldIndex:(NSInteger) oldIndex
{
    CGRect newLightViewFrame = [self getYellowLineFrame:newIndex];
    UILabel *selectLabel = _labelArray[newIndex];
    UILabel *unSelectLabel = _labelArray[oldIndex];
    //newTopViewFrame
    [UIView animateWithDuration:0.3f animations:^{
        yellowLineView.frame = newLightViewFrame;
    } completion:^(BOOL finished) {
        selectLabel.textColor = [UIColor colorWithHexString:@"353535"];
        unSelectLabel.textColor = wordColorSecondary;
        [UIView animateWithDuration:0.3f animations:^{
            selectLabel.transform = CGAffineTransformMakeScale(1.1, 1.1);
            unSelectLabel.transform = CGAffineTransformIdentity;
        }];
    }];
}
/**
 *  制作button
 *
 *  @param frame frame
 *  @param title 名称
 *
 *  @return
 */
#pragma mark - Action Method
- (void)switchButtonPress:(UIButton *)btn{
    if ([btn isEqual:lastButton]) {
        return;
    }
    NSInteger newIndex = btn.tag - kButtonTag;
    NSInteger oldIndex = lastButton.tag - kButtonTag;
    
    [self startAnimation:newIndex OldIndex:oldIndex];
    lastButton = btn;
    if (_delegate && [_delegate respondsToSelector:@selector(switchChange:)]) {
        [_delegate switchChange:newIndex];
    }
}

- (UILabel *)getBadgeNumberView:(CGRect)frame title:(NSString *)title tag:(NSInteger)tag{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    [label setText:title];
    [label setBackgroundColor:[UIColor redColor]];
    [label setFont:[UIFont systemFontOfSize:kBadgeFond]];
    [label setTextColor:[UIColor whiteColor]];
    [label setTextAlignment:NSTextAlignmentCenter];
    label.layer.cornerRadius = frame.size.height/2.f;
    label.layer.masksToBounds = YES;
    label.alpha = 0.f;
    [label setTag:tag];
    label.userInteractionEnabled = YES;
    return label;
}
- (UIButton *)getTitleButton:(CGRect)frame title:(NSString *)title tag:(NSInteger)tag{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    btn.tag = tag;
    [btn addTarget:self action:@selector(switchButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    btn.userInteractionEnabled = YES;
    return btn;
}

- (void)resetSwitchIndex:(NSInteger)index{
    if (lastButton.tag - kButtonTag !=index) {
        UIButton *btn = (UIButton *)[self viewWithTag:index+kButtonTag];
        NSInteger oldIndex = lastButton.tag - kButtonTag;
        [self startAnimation:index OldIndex:oldIndex];
        lastButton = btn;
    }
}
/**
 *  重置角标
 *
 *  @param index  tag
 *  @param number 数量
 */
- (void)setBadgeWithNumber:(NSInteger)index number:(NSInteger)number{
    UILabel *label = (UILabel *)[self viewWithTag:index+kBadgeTag];
    if (index == 0) {
        if (number>0) {
            [label setAlpha:1.0f];
            [label setText:nil];
            [label setFrame:CGRectMake(VIEW_X(label), VIEW_Y(label),10, 10)];
            label.layer.cornerRadius = 5.f;
        }else{
            [label setAlpha:0.f];
        }
    }else{
        if (number>0) {
            [label setAlpha:1.0f];
            NSString *str = [NSString stringWithFormat:@"%@",@(number)];
            CGSize size = [str sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kBadgeFond]}];
            if (size.width<15) {
                size.width = 15;
            }
            [label setText:str];
            [label setFrame:CGRectMake(VIEW_X(label), VIEW_Y(label), size.width, HEIGHT(label))];
        }else{
            [label setAlpha:0.f];
        }
    }
}
@end
