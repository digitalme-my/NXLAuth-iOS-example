//
//  ViewController.h
//  ExampleApp for NXLAuth
//
//  Created by Jason Lee on 10/10/2018.
//  Copyright © 2018 Jaosn Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OIDAuthState;
//@class OIDServiceConfiguration;

@interface ViewController : UIViewController


@property (weak, nonatomic) IBOutlet UITextField *status;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UITextView *logTextView;
@property (weak, nonatomic) IBOutlet UITextView *accessToken;
@property (weak, nonatomic) IBOutlet UITextView *idToken;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet UIButton *apiButton;
@property (weak, nonatomic) IBOutlet UIButton *userinfoButton;

@property(nonatomic, strong, nullable) OIDAuthState *authState;


- (IBAction)clearLog:(id)sender;




@end

