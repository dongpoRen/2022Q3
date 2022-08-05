//
//  ContainerViewController.m
//  CustomContainerViewController
//
//  Created by ren.dongpo on 2022/8/1.
//

#import "ContainerViewController.h"
#import "ViewController.h"
#import "Animator.h"
#import "PrivateTransitioningContext.h"

@interface ContainerViewController ()

@property (nonatomic, strong) NSArray *viewControllers;

@property (nonatomic, strong) UIViewController *selectedViewController;

@property (nonatomic, strong) UIView *childVCsContainerView;

@property (nonatomic, strong) UIView *buttonsContainerView;

@end


@implementation ContainerViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self _configSubViewControllers];
    }
    return self;
}

- (void)loadView {
    
    UIView *rootView = [[UIView alloc] init];
    
    self.childVCsContainerView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.childVCsContainerView.backgroundColor = [UIColor blackColor];
    
    self.buttonsContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 200)];
    
    [rootView addSubview:self.childVCsContainerView];
    [rootView addSubview:self.buttonsContainerView];
    
    [self.viewControllers enumerateObjectsUsingBlock:^(UIViewController *  _Nonnull vc, NSUInteger idx, BOOL * _Nonnull stop) {
            
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = idx;
        [button addTarget:self action:@selector(btnTap:) forControlEvents:UIControlEventTouchUpInside];
        [button setImage:vc.tabBarItem.image forState:UIControlStateNormal];
        [button setImage:vc.tabBarItem.selectedImage forState:UIControlStateSelected];
        button.frame = CGRectMake(0, 0, 64, 64);
        button.center = CGPointMake((idx + 0.5) * 64, CGRectGetHeight(self.buttonsContainerView.frame) / 2.0);
        
        [self.buttonsContainerView addSubview:button];
    }];
    
    self.view = rootView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.selectedViewController = (self.selectedViewController ?: self.viewControllers[0]);
}

- (void)setSelectedViewController:(UIViewController *)selectedViewController {
    _selectedViewController = selectedViewController;
    [self transitionViewController:selectedViewController];
    [self _updateBtnState];
}

- (void)transitionViewController:(UIViewController *)toViewController {
    
    // note: 此处取得是系统的子控制器属性 childViewControllers，而不是自己定义的viewControllers
    UIViewController *fromVC = (self.childViewControllers.count > 0 ? self.childViewControllers[0] : nil);
    if (fromVC == toViewController || ![self isViewLoaded]) {
        return;
    }
   
    [self addChildViewController:toViewController];
    
    if (!fromVC) {
        toViewController.view.frame = self.childVCsContainerView.bounds;
        [self.childVCsContainerView addSubview:toViewController.view];
        return;
    }
       
    NSUInteger fromIdx = [self.viewControllers indexOfObject:fromVC];
    NSUInteger toIdx = [self.viewControllers indexOfObject:toViewController];
    PrivateTransitioningContext *context = [[PrivateTransitioningContext alloc] initWithFromViewController:fromVC toViewController:toViewController goingRight:(toIdx > fromIdx)];
    context.animated = YES;
    context.interactive = NO;
    context.completionBlock = ^{
        [fromVC.view removeFromSuperview];
        [fromVC removeFromParentViewController];
        self.buttonsContainerView.userInteractionEnabled = YES;
    };
    
    Animator *animator = [[Animator alloc] init];
    [animator animateTransition:context];
    self.buttonsContainerView.userInteractionEnabled = NO;
    
//    [toViewController setNeedsStatusBarAppearanceUpdate];
}

#pragma mark - Target action

- (void)btnTap:(UIButton *)button {
    self.selectedViewController = self.viewControllers[button.tag];
}

#pragma mark - Private method

- (void)_updateBtnState {
    [self.buttonsContainerView.subviews enumerateObjectsUsingBlock:^(__kindof UIButton * _Nonnull btn, NSUInteger idx, BOOL * _Nonnull stop) {
        btn.selected = (self.selectedViewController == self.viewControllers[idx]);
    }];
}

- (void)_configSubViewControllers {
    
    NSArray *configurations = @[
        
        @{@"title": @"First",
          @"color": [UIColor colorWithRed:0.4f green:0.8f blue:1 alpha:1],
          @"barStyle": @(UIStatusBarStyleDefault)
        },
        
        @{@"title": @"Second",
          @"color": [UIColor colorWithRed:1 green:0.4f blue:0.8f alpha:1],
          @"barStyle": @(UIStatusBarStyleLightContent)
        },
        
        @{@"title": @"Third",
          @"color": [UIColor colorWithRed:1 green:0.8f blue:0.4f alpha:1],
          @"barStyle": @(UIStatusBarStyleDarkContent)
        },
    ];
    
    NSMutableArray *childVCs = [NSMutableArray array];
    for (NSDictionary *config in configurations) {
        
        ViewController *vc = [[ViewController alloc] init];
        vc.title = config[@"title"];
        vc.themeColor = config[@"color"];
        vc.barStyle = [config[@"barStyle"] integerValue];
        vc.tabBarItem.image = [UIImage imageNamed:config[@"title"]];
        vc.tabBarItem.selectedImage = [UIImage imageNamed:[config[@"title"] stringByAppendingString:@" Selected"]];
        
        [childVCs addObject:vc];
    }
    self.viewControllers = childVCs;
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.selectedViewController;
}

@end
