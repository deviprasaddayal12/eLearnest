//
//  ClassTokenViewController.h
//  app
//
//  Created by durgesh on 11/11/21.
//  Copyright © 2021 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ClassTokenViewController : UIViewController {    
}

//@property (nonatomic, assign) NSString *deeplinkUrl;
@property (weak, nonatomic) IBOutlet UITextField *tfToken;
@property (weak, nonatomic) IBOutlet UITextField *tfClassName;

@property (nonatomic, strong) UIWindow *window;

@end

NS_ASSUME_NONNULL_END
