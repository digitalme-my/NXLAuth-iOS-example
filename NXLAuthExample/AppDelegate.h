//
//  AppDelegate.h
//  testAppAuth
//
//  Created by Jason Lee on 10/10/2018.
//  Copyright © 2018 Jaosn Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OIDExternalUserAgentSession;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(nonatomic, strong, nullable) id<OIDExternalUserAgentSession> currentAuthorizationFlow;


@end

