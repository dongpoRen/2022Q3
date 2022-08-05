//
//  ViewController.m
//  CustomContainerViewController
//
//  Created by ren.dongpo on 2022/8/1.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = self.themeColor;
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    self.nameLabel.center = self.view.center;
    [self.view addSubview:self.nameLabel];
    self.nameLabel.text = self.title;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.barStyle;
}


@end
