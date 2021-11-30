/*
 * Copyright @ 2018-present 8x8, Inc.
 * Copyright @ 2017-2018 Atlassian Pty Ltd
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "AppDelegate.h"
#import "FIRUtilities.h"
#import "Types.h"
#import "ClassTokenViewController.h"
#import "ViewController.h"

@import Firebase;
@import JitsiMeetSDK;

@implementation AppDelegate

-             (BOOL)application:(UIApplication *)application
  didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    return YES;
}

- (void) applicationWillTerminate:(UIApplication *)application {
    NSLog(@"Application will terminate!");
}

#pragma mark Linking delegate methods

-    (BOOL)application:(UIApplication *)application
  continueUserActivity:(NSUserActivity *)userActivity
    restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> *restorableObjects))restorationHandler {
  
  if (userActivity.webpageURL != NULL) {
    NSString *inputUrl = userActivity.webpageURL.absoluteString;
    NSLog(@"openUrl.deeplink.inputUrl: %@", inputUrl);
    NSString *finalDeeplinkUrl = @"";
    if ([inputUrl containsString:@"https"]) {
      NSArray *urlArray = [inputUrl componentsSeparatedByString:@"https"];
      NSLog(@"openUrl.deeplink.urlArray: %@", urlArray);
      NSLog(@"openUrl.deeplink.urlArray[0]: %@", urlArray[0]);
      finalDeeplinkUrl = [NSString stringWithFormat:@"https%@", [urlArray lastObject]];
      NSLog(@"openUrl.deeplink.finalDeeplinkUrl: %@", finalDeeplinkUrl);
    } else
      finalDeeplinkUrl = inputUrl;
    NSLog(@"openUrl.deeplink.finalDeeplinkUrl: %@", finalDeeplinkUrl);
    
    [[NSUserDefaults standardUserDefaults] setObject:finalDeeplinkUrl forKey:@"deeplinkUrl"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    UINavigationController *navController = (UINavigationController *)self.window.rootViewController;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    [navController pushViewController:viewController animated:YES];
    
    return YES;
  }

//    if ([FIRUtilities appContainsRealServiceInfoPlist]) {
//        // 1. Attempt to handle Universal Links through Firebase in order to support
//        //    its Dynamic Links (which we utilize for the purposes of deferred deep
//        //    linking).
//        BOOL handled
//          = [[FIRDynamicLinks dynamicLinks]
//                handleUniversalLink:userActivity.webpageURL
//                         completion:^(FIRDynamicLink * _Nullable dynamicLink, NSError * _Nullable error) {
//           NSURL *firebaseUrl = [FIRUtilities extractURL:dynamicLink];
//           if (firebaseUrl != nil) {
//             userActivity.webpageURL = firebaseUrl;
//             [[JitsiMeet sharedInstance] application:application
//                                continueUserActivity:userActivity
//                                  restorationHandler:restorationHandler];
//           }
//        }];
//
//        if (handled) {
//          return handled;
//        }
//    }
//
//
//
//    // 2. Default to plain old, non-Firebase-assisted Universal Links.
//    return [[JitsiMeet sharedInstance] application:application
//                              continueUserActivity:userActivity
//                                restorationHandler:restorationHandler];
  
  return YES;
}

- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
  NSLog(@"openUrl.deeplinkUrl: %@", url);
  
    // This shows up during a reload in development, skip it.
    // https://github.com/firebase/firebase-ios-sdk/issues/233
//    if ([[url absoluteString] containsString:@"google/link/?dismiss=1&is_weak_match=1"]) {
//        return NO;
//    }

//    NSURL *openUrl = url;
//
//    if ([FIRUtilities appContainsRealServiceInfoPlist]) {
//        // Process Firebase Dynamic Links
//        FIRDynamicLink *dynamicLink = [[FIRDynamicLinks dynamicLinks] dynamicLinkFromCustomSchemeURL:url];
//        NSURL *firebaseUrl = [FIRUtilities extractURL:dynamicLink];
//        if (firebaseUrl != nil) {
//            openUrl = firebaseUrl;
//        }
//    }
//
//    return [[JitsiMeet sharedInstance] application:app
//                                           openURL:openUrl
//                                           options:options];
  
  return YES;
}

@end
