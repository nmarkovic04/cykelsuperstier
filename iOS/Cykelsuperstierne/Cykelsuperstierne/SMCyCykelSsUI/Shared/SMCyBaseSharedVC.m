//
//  SMCyBaseSharedVC.m
//  Cykelsuperstierne
//
//  Created by Rasko on 6/30/13.
//  Copyright (c) 2013 Rasko Gojkovic. All rights reserved.
//

#import "SMCyBaseSharedVC.h"
#import <objc/runtime.h>

@interface SMCyBaseSharedVC ()

@end

@implementation SMCyBaseSharedVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)isPushedToNavController{
    return (self.navigationController != nil);
}

- (BOOL)isModallyPresented{
    return (self.presentingViewController && self.presentingViewController.presentedViewController == self);
}

-(void) prepareViewForPush{
    
}

-(void) prepareViewForModalPresent{
    
}

-(BOOL) backCloseAnimated:(BOOL)animated withCompletion:(void (^)(void))completion{
    if([self isModallyPresented]){
        [self dismissViewControllerAnimated:animated completion:completion];
        return YES;
    } else if([self isPushedToNavController]){
        [self.navigationController popViewControllerAnimated:animated];
        return YES;
    }
    return NO;
}

+(SMCyBaseSharedVC*)createInstanceFromNib{
    NSString * name = NSStringFromClass(self);
    NSAssert(![name isEqualToString:@"SMCyBaseSharedVC"],@"SMCyBaseSharedVC shouldn't be instantiated this way ... only derived classes");
    return [[self alloc] initWithNibName:name bundle:nil];
}

+(SMCyBaseSharedVC*) showModalOnViewController:(UIViewController*)parentVC animated:(BOOL)animated withCompletion:(void (^)(void))completion{
    
    SMCyBaseSharedVC * vc = [self createInstanceFromNib];
    [vc prepareViewForModalPresent];
    [parentVC presentViewController:vc animated:animated completion:completion];
    return vc;
}

+(SMCyBaseSharedVC*) pushOnNavigationController:(UINavigationController*)navController animated:(BOOL)animated{
    SMCyBaseSharedVC * vc = [self createInstanceFromNib];
    [vc prepareViewForPush];
    [navController pushViewController:vc animated:animated];
    return vc;
}

@end
