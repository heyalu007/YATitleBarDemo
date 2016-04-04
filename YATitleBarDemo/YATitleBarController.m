

#import "YATitleBarController.h"
#import "Util.h"

@interface YATitleBar ()

@property (nonatomic, copy) NSMutableArray <UIButton *> *titleButtons;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIColor *selectedColor;
@property (nonatomic, assign) NSInteger currentButtonIndex;

@end

@implementation YATitleBar

- (instancetype)initWithFrame:(CGRect)frame andTitles:(NSArray <NSString *> *)titles {

    if (self = [super init]) {
        self.frame = frame;//Review:self不设置尺寸，它上面的button是点不动的;父控件没有尺寸，子控件点不动;
        self.backgroundColor = [UIColor whiteColor];
        [self arrangeSubViewsWithTitles:titles];
    }
    return self;
}

+ (instancetype)titleBarWithFrame:(CGRect)frame andTitles:(NSArray <NSString *> *)titles {

    YATitleBar *titleBar = [[YATitleBar alloc] initWithFrame:frame andTitles:titles];
    return titleBar;
}

/**
 *  排列子控件
 */
- (void)arrangeSubViewsWithTitles:(NSArray <NSString *> *)titles {
    
    CGFloat width = kScreenWidth / titles.count;//按键的宽度;
    //添加按键;
    for (int i = 0; i < titles.count; i++) {
        
        UIButton *titleBtn = [[UIButton alloc] init];
        titleBtn.tag = i;
        titleBtn.frame = CGRectMake(i * width, 0, width, self.frame.size.height - 5);
        [titleBtn setTitle:[titles objectAtIndex:i] forState:UIControlStateNormal];
        [titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [titleBtn addTarget:self action:@selector(titleBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:titleBtn];
        [self.titleButtons addObject:titleBtn];
    }
    
    //把第一个按键默认为选中状态;
    UIButton *selectedBtn = [self.titleButtons objectAtIndex:0];
    [selectedBtn setTitleColor:self.selectedColor forState:UIControlStateNormal];
    
    //添加lineView，并且把它移动到默认被选中的button下面;
    [self moveLineViewToButton:0 animated:NO];
}

/**
 *  button被点击
 *
 *  @param button 被点击的button
 */
- (void)titleBtnClicked:(UIButton *)button
{
    [self setSelectedButton:button.tag];
    
    if ([self.delegate respondsToSelector:@selector(titleButtonIsClicked:)]) {
        [self.delegate titleButtonIsClicked:button.tag];
    }
}

/**
 *  设置哪一个button处于被选中状态，同时把lineView移动到这个button下面;
 */
- (void)setSelectedButton:(NSInteger)buttonIndex {

    if (self.currentButtonIndex != buttonIndex) {
        
        for (int i=0; i<self.titleButtons.count; i++) {
            
            //改变button内部title的颜色;
            UIButton *titleBtn = [self.titleButtons objectAtIndex:i];
            if (buttonIndex == i) {//如果是被选中的btn;
                [titleBtn setTitleColor:self.selectedColor forState:UIControlStateNormal];
            }
            else {
                [titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
        }
        //移动lineView;
        [self moveLineViewToButton:buttonIndex animated:YES];
        
        self.currentButtonIndex = buttonIndex;
    }
}

/**
 *  把lineView移动到某个button下面
 *  @param button btn
 */
- (void)moveLineViewToButton:(NSInteger)buttonIndex animated:(BOOL)animated {
    
    CGPoint lineViewCenter = self.lineView.center;
    UIButton *button = [self.titleButtons objectAtIndex:buttonIndex];
    lineViewCenter.x = button.center.x;
    
    if (animated) {
        [UIView animateWithDuration:0.3 animations:^{
            self.lineView.center = lineViewCenter;
        }];
    }
    else {
        self.lineView.center = lineViewCenter;
    }
}


#pragma mark - 懒加载

- (UIView *)lineView {

    if (_lineView == nil) {
        _lineView = [[UIView alloc] init];
        CGFloat titleBarButtonWidth = kScreenWidth / self.titleButtons.count;//计算出titleBarButton的宽度;
        self.lineView.frame = CGRectMake(0, self.frame.size.height - 5, titleBarButtonWidth - 10, 4);
        self.lineView.backgroundColor = self.selectedColor;
        [self addSubview:_lineView];
    }
    return _lineView;
}

- (UIColor *)selectedColor {

    if (_selectedColor == nil) {
        _selectedColor = [UIColor colorWithRed:54/255.0 green:162/255.0 blue:249/255.0 alpha:0.8];//默认为蓝色;
    }
    return _selectedColor;
}

- (NSMutableArray<UIButton *> *)titleButtons {

    if (_titleButtons == nil) {
        _titleButtons = [NSMutableArray array];
    }
    return _titleButtons;
}

@end



@interface YATitleBarController ()<YATitleBarDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) YATitleBar *titleBar;
@property (nonatomic, weak) UIViewController *currentVC;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) NSMutableArray <NSString *> *titles;

@end



@implementation YATitleBarController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //先把默认要显示的控制器添加进来;
    UIViewController *defaultVC = [self.viewControllers objectAtIndex:self.initialIndex];
    defaultVC.view.frame = CGRectMake(self.initialIndex * kScreenWidth, 0, kScreenWidth, self.scrollView.frame.size.height);
    [self addChildViewController:defaultVC];
    [self.scrollView addSubview:defaultVC.view];
    self.currentVC = defaultVC;
    self.currentIndex = 0;
    
    //创建titleBar;
    CGRect rect = CGRectMake(0, 0, kScreenWidth, self.titleBarHeight);
    _titleBar = [YATitleBar titleBarWithFrame:rect andTitles:self.titles];
    _titleBar.delegate = self;
    [self.view addSubview:_titleBar];
}


- (void)showInViewContoller:(UIViewController *)viewContoller {
    
    if (viewContoller.navigationController) {
        viewContoller.edgesForExtendedLayout = UIRectEdgeNone;
    }
    if(self.titleBarHeight == 0) {
        self.titleBarHeight = kTitleBarHeight;
    }
    [viewContoller addChildViewController:self];
    [viewContoller.view addSubview:self.view];
}




#pragma mark - YATitleBarDelegate

- (void)titleButtonIsClicked:(NSInteger)buttonIndex {
    
    [self.scrollView setContentOffset:CGPointMake(buttonIndex * kScreenWidth, 0) animated:NO];
    [self addSubController:buttonIndex];
}

#pragma mark - UIScrollViewDelegate


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    NSInteger index = scrollView.contentOffset.x / kScreenWidth;
    [self.titleBar setSelectedButton:index];
    [self addSubController:index];
}

- (void)addSubController:(NSInteger)index {

    UIViewController *newVC = [self.viewControllers objectAtIndex:index];
    if (![self.scrollView.subviews containsObject:newVC.view]) {
        newVC.view.frame = CGRectMake(index * kScreenWidth, 0, kScreenWidth, self.scrollView.frame.size.height);
        [self addChildViewController:newVC];
        [self.scrollView addSubview:newVC.view];
    }
}


#pragma mark - 懒加载

- (UIScrollView *)scrollView {
    
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = CGRectMake(0, self.titleBarHeight, kScreenWidth, kScreenHeight - self.titleBarHeight);
        //review:如果不需要上下滑动,contentSize的y值设置为0;
        _scrollView.contentSize = CGSizeMake(kScreenWidth * self.viewControllers.count, 0.0);
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.bounces = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}


- (NSMutableArray <NSString *> *)titles {

    if (_titles == nil) {
        _titles = [NSMutableArray array];
        for (int i = 0; i < self.viewControllers.count; i ++) {
            UIViewController *vc = [self.viewControllers objectAtIndex:i];
            [_titles addObject:vc.title];
        }
    }
    return _titles;
}

@end
