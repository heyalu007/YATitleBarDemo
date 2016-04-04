

#import "ViewController.h"
#import "YATitleBarController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIViewController *oneVc = [[UIViewController alloc] init];
    oneVc.title = @"哈哈";
    oneVc.view.backgroundColor = [UIColor grayColor];
    
    UIViewController *twoVC = [[UIViewController alloc] init];
    twoVC.title = @"呵呵";
    twoVC.view.backgroundColor = [UIColor yellowColor];
    
    UIViewController *threeVC = [[UIViewController alloc] init];
    threeVC.title = @"嘿嘿";
    threeVC.view.backgroundColor = [UIColor blueColor];
    
    YATitleBarController *titleBarController = [[YATitleBarController alloc] init];
    titleBarController.viewControllers = @[oneVc, twoVC, threeVC];
    [titleBarController showInViewContoller:self];
}





@end
