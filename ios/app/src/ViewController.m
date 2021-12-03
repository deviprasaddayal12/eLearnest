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

#import <Availability.h>

@import CoreSpotlight;
@import MobileCoreServices;
@import Intents;  // Needed for NSUserActivity suggestedInvocationPhrase

@import JitsiMeetSDK;

#import "Types.h"
#import "ViewController.h"


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    JitsiMeetView *view = (JitsiMeetView *) self.view;
    view.delegate = self;
  
  @try {
    JitsiMeetConferenceOptions *options = [JitsiMeetConferenceOptions fromBuilder:^(JitsiMeetConferenceOptionsBuilder *builder) {
      
      NSString *deeplinkUrl = [[NSUserDefaults standardUserDefaults]
            stringForKey:@"deeplinkUrl"];
      NSString *className = [[NSUserDefaults standardUserDefaults] stringForKey:@"className"];
      NSString *token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
      
      if (deeplinkUrl != NULL) {
        deeplinkUrl = [deeplinkUrl stringByReplacingOccurrencesOfString:@"https://demo-eschool.examdo.co.in/deeplink?meetingId"
                                             withString:@""];
        NSLog(@"deeplink.url.replace = %@", deeplinkUrl);
        
        deeplinkUrl = [deeplinkUrl stringByReplacingOccurrencesOfString:@"&jwt"
                                                                   withString:@""];
        NSLog(@"deeplink.url.& = %@", deeplinkUrl);
        
        NSArray *paramsArray = [deeplinkUrl componentsSeparatedByString:@"="];
        NSLog(@"deeplink.url.split = %@", paramsArray);
        
        className = paramsArray[1];
        token = paramsArray[2];
      }
      
      builder.room = [[[@"https://demo-eschool.examdo.co.in/" stringByAppendingString:className] stringByAppendingString:@"?jwt="] stringByAppendingString:token];
      
      [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"className"];
      [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
      [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"deeplinkUrl"];
      [[NSUserDefaults standardUserDefaults] synchronize];
      
        builder.audioOnly = NO;
        builder.audioMuted = YES;
        builder.videoMuted = YES;
        builder.welcomePageEnabled = NO;
        [builder setFeatureFlag:@"ios.screensharing.enabled" withBoolean:YES];
        [builder setConfigOverride:@"requireDisplayName" withBoolean:YES];
    }];

    [view join:options];
  }
  @catch(NSException *exception) {
    NSLog(@"%@", exception.reason);
  }
}

 //JitsiMeetViewDelegate

- (void)_onJitsiMeetViewDelegateEvent:(NSString *)name
                             withData:(NSDictionary *)data {
    NSLog(
        @"[%s:%d] JitsiMeetViewDelegate %@ %@",
        __FILE__, __LINE__, name, data);

#if DEBUG
    NSAssert(
        [NSThread isMainThread],
        @"JitsiMeetViewDelegate %@ method invoked on a non-main thread",
        name);
#endif
}

- (void)conferenceJoined:(NSDictionary *)data {
    [self _onJitsiMeetViewDelegateEvent:@"CONFERENCE_JOINED" withData:data];

    // Register a NSUserActivity for this conference so it can be invoked as a
    // Siri shortcut. This is only supported in iOS >= 12.
#ifdef __IPHONE_12_0
    if (@available(iOS 12.0, *)) {
      NSUserActivity *userActivity
        = [[NSUserActivity alloc] initWithActivityType:JitsiMeetConferenceActivityType];

      NSString *urlStr = data[@"url"];
      NSURL *url = [NSURL URLWithString:urlStr];
      NSString *conference = [url.pathComponents lastObject];

      userActivity.title = [NSString stringWithFormat:@"Join %@", conference];
      userActivity.suggestedInvocationPhrase = @"Join my Jitsi meeting";
      userActivity.userInfo = @{@"url": urlStr};
      [userActivity setEligibleForSearch:YES];
      [userActivity setEligibleForPrediction:YES];
      [userActivity setPersistentIdentifier:urlStr];

      // Subtitle
      CSSearchableItemAttributeSet *attributes
        = [[CSSearchableItemAttributeSet alloc] initWithItemContentType:(NSString *)kUTTypeItem];
      attributes.contentDescription = urlStr;
      userActivity.contentAttributeSet = attributes;

      self.userActivity = userActivity;
      [userActivity becomeCurrent];
    }
#endif

}

- (void)conferenceTerminated:(NSDictionary *)data {
    [self _onJitsiMeetViewDelegateEvent:@"CONFERENCE_TERMINATED" withData:data];
  [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)conferenceWillJoin:(NSDictionary *)data {
    [self _onJitsiMeetViewDelegateEvent:@"CONFERENCE_WILL_JOIN" withData:data];
}

#if 0
- (void)enterPictureInPicture:(NSDictionary *)data {
    [self _onJitsiMeetViewDelegateEvent:@"ENTER_PICTURE_IN_PICTURE" withData:data];

}
#endif

- (void)participantJoined:(NSDictionary *)data {
  NSLog(@"%@%@", @"Participant joined: ", data[@"participantId"]);
}

- (void)participantLeft:(NSDictionary *)data {
  NSLog(@"%@%@", @"Participant left: ", data[@"participantId"]);
}

- (void)audioMutedChanged:(NSDictionary *)data {
  NSLog(@"%@%@", @"Audio muted changed: ", data[@"muted"]);
}

- (void)endpointTextMessageReceived:(NSDictionary *)data {
  NSLog(@"%@%@", @"Endpoint text message received: ", data);
}

- (void)screenShareToggled:(NSDictionary *)data {
  NSLog(@"%@%@", @"Screen share toggled: ", data);
}

- (void)chatMessageReceived:(NSDictionary *)data {
    NSLog(@"%@%@", @"Chat message received: ", data);
}

- (void)chatToggled:(NSDictionary *)data {
  NSLog(@"%@%@", @"Chat toggled: ", data);
}

- (void)videoMutedChanged:(NSDictionary *)data {
  NSLog(@"%@%@", @"Video muted changed: ", data[@"muted"]);
}

#pragma mark - Helpers

- (void)terminate {
  NSLog(@"meet.controller.terminate");
    JitsiMeetView *view = (JitsiMeetView *) self.view;
    [view leave];
  
  [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"className"];
  [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
  [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"deeplinkUrl"];
  [[NSUserDefaults standardUserDefaults] synchronize];
  [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
