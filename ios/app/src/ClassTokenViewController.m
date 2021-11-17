//
//  ClassTokenViewController.m
//  app
//
//  Created by durgesh on 11/11/21.
//  Copyright © 2021 Facebook. All rights reserved.
//

#import "ClassTokenViewController.h"

@interface ClassTokenViewController ()

@end

@implementation ClassTokenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)launchClass:(UIButton *)sender {
  NSString *className = self.tfClassName.text;
  NSString *token = self.tfToken.text;
  
  if ([className isEqualToString:@""]) {
    NSLog(@"empty class name");
  } else if ([token isEqualToString:@""]) {
    NSLog(@"empty token");
  } else {
    NSLog(@"launch jitsi");
  }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
