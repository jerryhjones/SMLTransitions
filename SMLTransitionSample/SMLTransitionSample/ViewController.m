//
//  ViewController.m
//  SMLTransitionSample
//
//  Created by Jerry Jones on 6/17/15.
//  Copyright (c) 2015 SpacemanLabs. All rights reserved.
//

#import "ViewController.h"
#import "SMLTransitionsManager.h"
#import "TransitionAnimator.h"
#import "SecondViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showSecondController:(id)sender
{
    SecondViewController *vc = [[SecondViewController alloc] initWithNibName:nil bundle:nil];
    
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismiss:)];
    vc.navigationItem.rightBarButtonItem = done;
    
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:navVC animated:YES
                  animatorClass:[TransitionAnimator class]
                     completion:nil];
}

- (IBAction)dismiss:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
