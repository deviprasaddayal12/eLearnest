//
//  ClassTokenViewController.m
//  app
//
//  Created by durgesh on 11/11/21.
//  Copyright © 2021 Facebook. All rights reserved.
//

#import "ClassTokenViewController.h"
#import "ViewController.h"

@import JitsiMeetSDK;

@interface ClassTokenViewController ()

@end

@implementation ClassTokenViewController

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  NSString *deeplinkUrl = [[NSUserDefaults standardUserDefaults]
      stringForKey:@"deeplinkUrl"];
  NSLog(@"deeplinkUrl = %@", deeplinkUrl);
  
  if (deeplinkUrl != NULL) {
    //self.tfClassName.text = self.deeplinkUrl.query;
    ViewController *meetController = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
        [self.navigationController pushViewController:meetController animated:YES];
  }
}

- (IBAction)launchClass:(UIButton *)sender {
  NSString *className = self.tfClassName.text;
  NSString *token = self.tfToken.text;
  
  if ([className isEqualToString:@""]) {
    NSLog(@"empty class name");
    [self showInfoAlert:@"Please enter class name"];
  } else if ([token isEqualToString:@""]) {
    NSLog(@"empty token");
    [self showInfoAlert:@"Please enter token"];
  } else {
    NSLog(@"launch jitsi");
    [[NSUserDefaults standardUserDefaults] setObject:className forKey:@"className"];
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    ViewController *meetController = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    [self.navigationController pushViewController:meetController animated:YES];
  }
}

-(void) showInfoAlert: (NSString * ) msg {
  UIAlertController * alertvc = [UIAlertController alertControllerWithTitle: @ "Invalid Information"
                                 message: msg preferredStyle: UIAlertControllerStyleAlert
                                ];
  UIAlertAction * action = [UIAlertAction actionWithTitle: @ "Dismiss"
                            style: UIAlertActionStyleDefault handler: ^ (UIAlertAction * _Nonnull action) {
                              NSLog(@ "Dismiss Tapped");
                            }
                           ];
  [alertvc addAction: action];
  [self presentViewController: alertvc animated: true completion: nil];
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
