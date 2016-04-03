

#import <UIKit/UIKit.h>

@protocol YATitleBarDelegate <NSObject>

@optional
- (void)titleButtonIsClicked:(NSInteger)buttonIndex;

@end

@interface YATitleBar : UIView

@property (nonatomic, weak) id<YATitleBarDelegate> delegate;
+ (instancetype)titleBarWithFrame:(CGRect)frame andTitles:(NSArray <NSString *> *)titles;
- (void)setSelectedButton:(NSInteger)buttonIndex;//设置某个button为选中状态;

@end




#define kTitleBarHeight         44      //默认的TitleBar的高度，可以通过titleBarHeight属性自己设定;
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenBounds [UIScreen mainScreen].bounds


@interface YATitleBarController : UIViewController

@property (nonatomic, strong) NSArray <UIViewController *> *viewControllers;//子控制器;
@property (nonatomic, strong) NSArray <NSString *> *titles;//子控制器的标题,和上面的子控制器是一一对应的;
@property (nonatomic, assign) CGFloat titleBarHeight;//标题栏的高度,不设置的话默认为44;
@property (nonatomic, assign) NSInteger initialIndex;//初始化时,第几个title为默认显示的;
@property (nonatomic, strong) UIColor *themeColor;//主题颜色,默认为白色;
- (void)showInViewContoller:(UIViewController *)viewContoller;

@end
