

#import "ViewController.h"
#import "YATitleBarController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIViewController *oneVc = [[UIViewController alloc] init];
    oneVc.view.backgroundColor = [UIColor grayColor];
    UIViewController *twoVC = [[UIViewController alloc] init];
    twoVC.view.backgroundColor = [UIColor lightGrayColor];
    UIViewController *threeVC = [[UIViewController alloc] init];
    threeVC.view.backgroundColor = [UIColor blueColor];
    YATitleBarController *titleBarController = [[YATitleBarController alloc] init];
    titleBarController.viewControllers = @[oneVc, twoVC, threeVC];
    titleBarController.titles = @[@"重要", @"全部", @"已结束"];
    [titleBarController showInViewContoller:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}




@end
