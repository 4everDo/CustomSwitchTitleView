//
//  ViewController.m
//  CustomSwitchTitleView
//
//  Created by yite on 15/12/30.
//  Copyright © 2015年 yite. All rights reserved.
//

#import "ViewController.h"
#import "SwitchTitleView.h"

#define  SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@interface ViewController ()<SwitchTitleViewDelegate,UIScrollViewDelegate>
{
    SwitchTitleView *navView;
    NSArray         *titleArr;
    UIScrollView    *subScrollView;
}
@end

@implementation ViewController
- (void)viewWillAppear:(BOOL)animated{
//    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initSubViews];
    
    titleArr = @[@"第一页",@"第二页",@"第三页"];
    navView = [[SwitchTitleView alloc] initSwitchTitleView:titleArr frame:CGRectMake(12, 24,[UIScreen mainScreen].bounds.size.width-24, 40)];
    navView.delegate =self;
    self.navigationItem.titleView = navView;
}
- (void)initSubViews{
    subScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH,SCREEN_HEIGHT)];
    [subScrollView setBackgroundColor:[UIColor clearColor]];
    subScrollView.delegate =self;
    subScrollView.pagingEnabled = YES;
    subScrollView.bounces = NO;
    subScrollView.showsVerticalScrollIndicator = NO;
    subScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:subScrollView];
    [subScrollView setContentSize:CGSizeMake(SCREEN_WIDTH*3, 0)];
    
    NSArray *colorArr = @[[UIColor redColor],[UIColor blackColor],[UIColor yellowColor]];
    for (int i=0; i<colorArr.count; i++) {
        [subScrollView addSubview:[self addSubViewsForScrollView:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, SCREEN_HEIGHT) backgroundColor:[colorArr objectAtIndex:i]]];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)switchChange:(NSInteger)switchViewIndex{
    CGFloat scrollViewOffset = subScrollView.contentOffset.x;
    if (switchViewIndex != (int)(scrollViewOffset/SCREEN_WIDTH)) {
        [subScrollView setContentOffset:CGPointMake(switchViewIndex*SCREEN_WIDTH, 0) animated:YES];
    }
}
#pragma mark Private Method
- (UIView *)addSubViewsForScrollView:(CGRect)rect backgroundColor:(UIColor *)color{
    UIView *subView = [[UIView alloc] initWithFrame:rect];
    [subView setBackgroundColor:color];
    return subView;
}
#pragma mark Delegate Method
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if ([scrollView isEqual:subScrollView]) {
        NSInteger index = (int)(scrollView.contentOffset.x/[UIScreen mainScreen].bounds.size.width);
        [navView resetSwitchIndex:index];
    }
}
- (void)setSelectedPageIndex:(NSInteger)index{
    [self switchChange:index];
    [navView resetSwitchIndex:index];
}
@end
