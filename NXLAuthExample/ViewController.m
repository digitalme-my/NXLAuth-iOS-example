//
//  ViewController.m
//  testAppAuth
//
//  Created by Jason Lee on 10/10/2018.
//  Copyright © 2018 Jaosn Lee. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
//#import <AppAuth/AppAuth.h>
#import <NXLAuth/NXLAuth.h>
//#import <JWT/JWT.h>
//
//typedef void (^PostRegistrationCallback)(OIDServiceConfiguration *configuration,
//                                         OIDRegistrationResponse *registrationResponse);

//static NSString *const kIssuer = @"https://accounts.google.com";
////static NSString *const kIssuer = @"https://unifi-reza.auth0.com";
////static NSString *const kIssuer = @"https://issuer.example.com";
//
//static NSString *const kClientID = @"685658855670-orj0kero7cor49a546m88kmovhd26shk.apps.googleusercontent.com";
////static NSString *const kClientID = @"s6fklgJwjafAAzHIjN3WdQhw5oJ_NjWf";
//
//static NSString *const kRedirectURI = @"com.googleusercontent.apps.685658855670-orj0kero7cor49a546m88kmovhd26shk:/oauth2redirect/google";
//static NSString *const kRedirectURI = @"net.openid.appauthdemo:/oauth2redirect";

static NSString *const kAppAuthExampleAuthStateKey = @"currentAuthState";

@interface ViewController () <OIDAuthStateChangeDelegate, OIDAuthStateErrorDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _logTextView.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1.0].CGColor;
    _logTextView.layer.borderWidth = 1.0f;
    _logTextView.alwaysBounceVertical = true;
    _logTextView.textContainer.lineBreakMode = NSLineBreakByCharWrapping;
    _logTextView.text = @"";
    _accessToken.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1.0].CGColor;
    _accessToken.layer.borderWidth = 1.0f;
    _idToken.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1.0].CGColor;
    _idToken.layer.borderWidth = 1.0f;
    // Do any additional setup after loading the view, typically from a nib.
    [self loadState];
    [self updateUI];
    
}

- (IBAction)button:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    NXLAppAuthManager *nexMng = [[NXLAppAuthManager alloc] init];
    NSArray *scopes = @[ ScopeOpenID, ScopeOffline];
    [nexMng ssoAuthRequest:scopes :^(OIDAuthorizationRequest *request){
        [self logMessage:@"[Client] Initiating authorization request with scope: %@", request.scope];
        [self logMessage:@"[Client] Request URL: %@", request.authorizationRequestURL];
        
        appDelegate.currentAuthorizationFlow = [nexMng ssoAuthStateByPresentingAuthorizationRequest:request presentingViewController:self :^(OIDAuthState * _Nonnull authState) {
            NSLog(@"[Client] authState: %@", authState);
            NSLog(@"[Client] authorizationCode: %@", authState.lastAuthorizationResponse.authorizationCode);
            NSLog(@"[Client] accessToken: %@", authState.lastTokenResponse.accessToken);
            NSLog(@"[Client] idToken: %@", authState.lastTokenResponse.idToken);
            NSLog(@"[Client] refreshToken: %@", authState.lastTokenResponse.refreshToken);
            self->_accessToken.text = authState.lastTokenResponse.accessToken;
            self->_idToken.text = authState.lastTokenResponse.idToken;
            
            if (authState) {
                [self setAuthState:authState];
                [self logMessage:@"[Client] Got authorization tokens. Access token: %@",authState.lastTokenResponse.accessToken];
                
            }
            //            else {
            //                [self logMessage:@"[Client] Authorization error: %@", [error localizedDescription]];
            //                                                                               [self setAuthState:nil];
            
        }];
        
        
        //        appDelegate.currentAuthorizationFlow =
        //        [ssoMng ssoAuthStateByPresentingAuthorizationRequest:request
        //                                       presentingViewController:self
        //                                                       callback:^(OIDAuthState *_Nullable authState, NSError *_Nullable error) {
        //                                                           NSLog(@"[Client] authState: %@", authState);
        //                                                           NSLog(@"[Client] authorizationCodeRESSSSS: %@", authState);
        //                                                           NSLog(@"[Client] authorizationCode: %@", authState.lastAuthorizationResponse.authorizationCode);
        //                                                            NSLog(@"[Client] AAAA: %@", authState.lastTokenResponse.request.configuration);
        //                                                           NSLog(@"[Client] accessToken: %@", authState.lastTokenResponse.accessToken);
        //                                                           NSLog(@"[Client] idToken: %@", authState.lastTokenResponse.idToken);
        //                                                           NSLog(@"[Client] refreshToken: %@", authState.lastTokenResponse.refreshToken);
        //
        //                                                           self->_accessToken.text = authState.lastTokenResponse.accessToken;
        //
        //                                                           self->_idToken.text = authState.lastTokenResponse.idToken;
        //
        //                                                           if (authState) {
        //                                                               [self setAuthState:authState];
        //                                                               [self logMessage:@"[Client] Got authorization tokens. Access token: %@",
        //                                                                authState.lastTokenResponse.accessToken];
        //                                                           } else {
        //                                                               [self logMessage:@"[Client] Authorization error: %@", [error localizedDescription]];
        //                                                               [self setAuthState:nil];
        //                                                           }
        //                                                       }];
    }];
    
    //    OIDAuthorizationRequest *authRequest = [ssoMng ssoAuthRequest];
    //    [self logMessage:@"[Client] Request: %@", authRequest];
    
    //    [SSOAppAuthManager ssoAuthRequest];
    
    //    [self verifyConfig];
    //    NSURL *issuer = [NSURL URLWithString:kIssuer];
    //
    //    [self logMessage:@"Fetching configuration for issuer: %@", issuer];
    //
    //    [OIDAuthorizationService discoverServiceConfigurationForIssuer:issuer completion:^(OIDServiceConfiguration *_Nullable configuration, NSError *_Nullable error) {
    //        NSLog(@"[my log] Configuration: %@", configuration.discoveryDocument);
    //        if (!configuration) {
    //            [self logMessage:@"Error retrieving discovery document: %@", [error localizedDescription]];
    //            [self setAuthState:nil];
    //            return;
    //        }
    //
    //        [self logMessage:@"Got configuration: %@", configuration];
    //
    //        if (!kClientID) {
    //            [self doClientRegistration:configuration
    //                              callback:^(OIDServiceConfiguration *configuration,
    //                                         OIDRegistrationResponse *registrationResponse) {
    //                                  [self doAuthWithAutoCodeExchange:configuration
    //                                                          clientID:registrationResponse.clientID
    //                                                      clientSecret:registrationResponse.clientSecret];
    //                              }];
    //        } else {
    //            [self doAuthWithAutoCodeExchange:configuration clientID:kClientID clientSecret:nil];
    //        }
    //
    //    }];
}
- (IBAction)getUserInfo:(id)sender {
    NXLAppAuthManager *ssoMng = [[NXLAppAuthManager alloc] init];
    [ssoMng getUserInfo:^(NSDictionary * _Nonnull response) {
        [self logMessage:@"[Client] User Info: %@", response];
    }];
}

- (IBAction)callApi:(id)sender {
    NXLAppAuthManager *ssoMng = [[NXLAppAuthManager alloc] init];
    NSURL *userinfoEndpoint =
    _authState.lastAuthorizationResponse.request.configuration.discoveryDocument.userinfoEndpoint;
    if (!userinfoEndpoint) {
        [self logMessage:@"[Client] Userinfo endpoint not declared in discovery document"];
        return;
    }
    NSString *currentAccessToken = _authState.lastTokenResponse.accessToken;
    [self logMessage:@"[Client] Performing userinfo request"];
    //    [self logMessage:@"[Client] AuthState: %@", _authState];
    [ssoMng getFreshToken:^(NSString * _Nonnull accessToken, NSString * _Nonnull idToken, OIDAuthState * _Nonnull currentAuthState, NSError * _Nullable error) {
        [self setAuthState:currentAuthState];
        if (error) {
            [self logMessage:@"[Client1] Error fetching fresh tokens: %@", [error localizedDescription]];
            return;
        }
        
        // log whether a token refresh occurred
        if (![currentAccessToken isEqual:accessToken]) {
            [self logMessage:@"[Client] Token refreshed"];
            [self logMessage:@"Access token was refreshed automatically (%@ to %@)",
             currentAccessToken,
             accessToken];
            
        } else {
            [self logMessage:@"[Client] Token still valid"];
            [self logMessage:@"Access token was fresh and not updated [%@]", accessToken];
        }
        // creates request to the userinfo endpoint, with access token in the Authorization header
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:userinfoEndpoint];
        NSString *authorizationHeaderValue = [NSString stringWithFormat:@"Bearer %@", accessToken];
        [request addValue:authorizationHeaderValue forHTTPHeaderField:@"Authorization"];
        
        NSURLSessionConfiguration *configuration =
        [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration
                                                              delegate:nil
                                                         delegateQueue:nil];
        
        [self logMessage:@"[Client] API Request URL: %@", request.URL];
        [self logMessage:@"[Client] API Request Header: %@", request.allHTTPHeaderFields];
        
        // performs HTTP request
        NSURLSessionDataTask *postDataTask =
        [session dataTaskWithRequest:request
                   completionHandler:^(NSData *_Nullable data,
                                       NSURLResponse *_Nullable response,
                                       NSError *_Nullable error) {
                       dispatch_async(dispatch_get_main_queue(), ^() {
                           if (error) {
                               [self logMessage:@"HTTP request failed %@", error];
                               return;
                           }
                           if (![response isKindOfClass:[NSHTTPURLResponse class]]) {
                               [self logMessage:@"Non-HTTP response"];
                               return;
                           }
                           
                           NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                           [self logMessage:@"[Client] API Response: %@", data];
                           id jsonDictionaryOrArray =
                           [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
                           
                           if (httpResponse.statusCode != 200) {
                               // server replied with an error
                               NSString *responseText = [[NSString alloc] initWithData:data
                                                                              encoding:NSUTF8StringEncoding];
                               if (httpResponse.statusCode == 401) {
                                   // "401 Unauthorized" generally indicates there is an issue with the authorization
                                   // grant. Puts OIDAuthState into an error state.
                                   NSError *oauthError =
                                   [OIDErrorUtilities resourceServerAuthorizationErrorWithCode:0
                                                                                 errorResponse:jsonDictionaryOrArray
                                                                               underlyingError:error];
                                   [self->_authState updateWithAuthorizationError:oauthError];
                                   // log error
                                   [self logMessage:@"Authorization Error (%@). Response: %@", oauthError, responseText];
                               } else {
                                   [self logMessage:@"HTTP: %d. Response: %@",
                                    (int)httpResponse.statusCode,
                                    responseText];
                               }
                               return;
                           }
                           
                           // success response
                           [self logMessage:@"Success: %@", jsonDictionaryOrArray];
                       });
                   }];
        
        [postDataTask resume];
    }];
    //    [ssoMng performActionWithFreshTokens:^(NSString * _Nullable accessToken, NSString * _Nullable idToken, NSError * _Nullable error) {
    //        if (error) {
    //                        [self logMessage:@"[Client] Error fetching fresh tokens: %@", [error localizedDescription]];
    //                        return;
    //                    }
    //
    //                    // log whether a token refresh occurred
    //                    if (![currentAccessToken isEqual:accessToken]) {
    //                        [self logMessage:@"[Client] Token refreshed"];
    //                        [self logMessage:@"Access token was refreshed automatically (%@ to %@)",
    //                         currentAccessToken,
    //                         accessToken];
    //
    //                    } else {
    //                        [self logMessage:@"[Client] Token still valid"];
    //                        [self logMessage:@"Access token was fresh and not updated [%@]", accessToken];
    //                    }
    //    }];
    //    [ssoMng getFreshToken:^(NSString * _Nullable accessToken, NSString * _Nullable idToken, NSError * _Nullable error) {
    //        if (error) {
    //            [self logMessage:@"[Client] Error fetching fresh tokens: %@", [error localizedDescription]];
    //            return;
    //        }
    //
    //        // log whether a token refresh occurred
    //        if (![currentAccessToken isEqual:accessToken]) {
    //            [self logMessage:@"[Client] Token refreshed"];
    //            [self logMessage:@"Access token was refreshed automatically (%@ to %@)",
    //             currentAccessToken,
    //             accessToken];
    //
    //        } else {
    //            [self logMessage:@"[Client] Token still valid"];
    //            [self logMessage:@"Access token was fresh and not updated [%@]", accessToken];
    //        }
    //
    //        // creates request to the userinfo endpoint, with access token in the Authorization header
    //        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:userinfoEndpoint];
    //        NSString *authorizationHeaderValue = [NSString stringWithFormat:@"Bearer %@", accessToken];
    //        [request addValue:authorizationHeaderValue forHTTPHeaderField:@"Authorization"];
    //
    //        NSURLSessionConfiguration *configuration =
    //        [NSURLSessionConfiguration defaultSessionConfiguration];
    //        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration
    //                                                              delegate:nil
    //                                                         delegateQueue:nil];
    //
    //        [self logMessage:@"[Client] API Request URL: %@", request.URL];
    //        [self logMessage:@"[Client] API Request Header: %@", request.allHTTPHeaderFields];
    //
    //        // performs HTTP request
    //        NSURLSessionDataTask *postDataTask =
    //        [session dataTaskWithRequest:request
    //                   completionHandler:^(NSData *_Nullable data,
    //                                       NSURLResponse *_Nullable response,
    //                                       NSError *_Nullable error) {
    //                       dispatch_async(dispatch_get_main_queue(), ^() {
    //                           if (error) {
    //                               [self logMessage:@"HTTP request failed %@", error];
    //                               return;
    //                           }
    //                           if (![response isKindOfClass:[NSHTTPURLResponse class]]) {
    //                               [self logMessage:@"Non-HTTP response"];
    //                               return;
    //                           }
    //
    //                           NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    //                           [self logMessage:@"[Client] API Response: %@", data];
    //                           id jsonDictionaryOrArray =
    //                           [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
    //
    //                           if (httpResponse.statusCode != 200) {
    //                               // server replied with an error
    //                               NSString *responseText = [[NSString alloc] initWithData:data
    //                                                                              encoding:NSUTF8StringEncoding];
    //                               if (httpResponse.statusCode == 401) {
    //                                   // "401 Unauthorized" generally indicates there is an issue with the authorization
    //                                   // grant. Puts OIDAuthState into an error state.
    //                                   NSError *oauthError =
    //                                   [OIDErrorUtilities resourceServerAuthorizationErrorWithCode:0
    //                                                                                 errorResponse:jsonDictionaryOrArray
    //                                                                               underlyingError:error];
    //                                   [self->_authState updateWithAuthorizationError:oauthError];
    //                                   // log error
    //                                   [self logMessage:@"Authorization Error (%@). Response: %@", oauthError, responseText];
    //                               } else {
    //                                   [self logMessage:@"HTTP: %d. Response: %@",
    //                                    (int)httpResponse.statusCode,
    //                                    responseText];
    //                               }
    //                               return;
    //                           }
    //
    //                           // success response
    //                           [self logMessage:@"Success: %@", jsonDictionaryOrArray];
    //                       });
    //                   }];
    //
    //        [postDataTask resume];
    //    }];
    //        NSURL *userinfoEndpoint =
    //        _authState.lastAuthorizationResponse.request.configuration.discoveryDocument.userinfoEndpoint;
    //        if (!userinfoEndpoint) {
    //            [self logMessage:@"[Client] Userinfo endpoint not declared in discovery document"];
    //            return;
    //        }
    //        NSString *currentAccessToken = _authState.lastTokenResponse.accessToken;
    //        [self logMessage:@"[Client] Performing userinfo request"];
    //        [self logMessage:@"[Client] AuthState: %@", _authState];
    //
    //        [_authState performActionWithFreshTokens:^(NSString *_Nonnull accessToken,
    //                                                   NSString *_Nonnull idToken,
    //                                                   NSError *_Nullable error) {
    //
    //            if (error) {
    //                [self logMessage:@"[Client] Error fetching fresh tokens: %@", [error localizedDescription]];
    //                return;
    //            }
    //
    //            // log whether a token refresh occurred
    //            if (![currentAccessToken isEqual:accessToken]) {
    //                [self logMessage:@"[Client] Token refreshed"];
    //                [self logMessage:@"Access token was refreshed automatically (%@ to %@)",
    //                 currentAccessToken,
    //                 accessToken];
    //            } else {
    //                [self logMessage:@"[Client] Token still valid"];
    //                [self logMessage:@"Access token was fresh and not updated [%@]", accessToken];
    //            }
    //
    //            // creates request to the userinfo endpoint, with access token in the Authorization header
    //            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:userinfoEndpoint];
    //            NSString *authorizationHeaderValue = [NSString stringWithFormat:@"Bearer %@", accessToken];
    //            [request addValue:authorizationHeaderValue forHTTPHeaderField:@"Authorization"];
    //
    //            NSURLSessionConfiguration *configuration =
    //            [NSURLSessionConfiguration defaultSessionConfiguration];
    //            NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration
    //                                                                  delegate:nil
    //                                                             delegateQueue:nil];
    //
    //            [self logMessage:@"[Client] API Request URL: %@", request.URL];
    //            [self logMessage:@"[Client] API Request Header: %@", request.allHTTPHeaderFields];
    //
    //            // performs HTTP request
    //            NSURLSessionDataTask *postDataTask =
    //            [session dataTaskWithRequest:request
    //                       completionHandler:^(NSData *_Nullable data,
    //                                           NSURLResponse *_Nullable response,
    //                                           NSError *_Nullable error) {
    //                           dispatch_async(dispatch_get_main_queue(), ^() {
    //                               if (error) {
    //                                   [self logMessage:@"HTTP request failed %@", error];
    //                                   return;
    //                               }
    //                               if (![response isKindOfClass:[NSHTTPURLResponse class]]) {
    //                                   [self logMessage:@"Non-HTTP response"];
    //                                   return;
    //                               }
    //
    //                               NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    //                               [self logMessage:@"[Client] API Response: %@", data];
    //                               id jsonDictionaryOrArray =
    //                               [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
    //
    //                               if (httpResponse.statusCode != 200) {
    //                                   // server replied with an error
    //                                   NSString *responseText = [[NSString alloc] initWithData:data
    //                                                                                  encoding:NSUTF8StringEncoding];
    //                                   if (httpResponse.statusCode == 401) {
    //                                       // "401 Unauthorized" generally indicates there is an issue with the authorization
    //                                       // grant. Puts OIDAuthState into an error state.
    //                                       NSError *oauthError =
    //                                       [OIDErrorUtilities resourceServerAuthorizationErrorWithCode:0
    //                                                                                     errorResponse:jsonDictionaryOrArray
    //                                                                                   underlyingError:error];
    //                                       [self->_authState updateWithAuthorizationError:oauthError];
    //                                       // log error
    //                                       [self logMessage:@"Authorization Error (%@). Response: %@", oauthError, responseText];
    //                                   } else {
    //                                       [self logMessage:@"HTTP: %d. Response: %@",
    //                                        (int)httpResponse.statusCode,
    //                                        responseText];
    //                                   }
    //                                   return;
    //                               }
    //
    //                               // success response
    //                               [self logMessage:@"Success: %@", jsonDictionaryOrArray];
    //                           });
    //                       }];
    //
    //            [postDataTask resume];
    //        }];
}

- (void)logMessage:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2) {
    // gets message as string
    va_list argp;
    va_start(argp, format);
    NSString *log = [[NSString alloc] initWithFormat:format arguments:argp];
    va_end(argp);
    
    // outputs to stdout
    NSLog(@"%@", log);
    
    // appends to output log
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"hh:mm:ss";
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    _logTextView.text = [NSString stringWithFormat:@"%@%@%@: %@",
                         _logTextView.text,
                         ([_logTextView.text length] > 0) ? @"\n" : @"",
                         dateString,
                         log];
}

- (void)updateUI {
    // dynamically changes authorize button text depending on authorized state
    if (!_authState) {
        _status.text = nil;
        _accessToken.text = nil;
        _idToken.text = nil;
        [self logMessage:@"[Client] Auth Status: %@", nil];
    } else {
        _status.text = @"Authenticated";
        [self logMessage:@"[Client] Auth Status: Authenticated"];
        
        _accessToken.text = _authState.lastTokenResponse.accessToken;
        
        _idToken.text = _authState.lastTokenResponse.idToken;
    }
}

- (void)setAuthState:(nullable OIDAuthState *)authState {
    NSLog(@"[Client] setAuthState");
    if (_authState == authState) {
        return;
    }
    _authState = authState;
//    if (authState != nil) {
//        [self performSegueWithIdentifier:@"login_success" sender:self];
//    }

    _authState.stateChangeDelegate = self;
    
    [self saveState];
    [self updateUI];
}

//- (void)didChangeState:(OIDAuthState *)state {
//    NSLog(@"AB");
//    NSLog(@"BBBBBBBB: %@", state);
//    [self setAuthState:state];
//}

- (void)stateChanged {
    [self saveState];
    [self updateUI];
}

- (void)saveState {
    // for production usage consider using the OS Keychain instead
    //    NSLog(@"[Client] AuthState before archieve: %@", _authState);
    NSData *archivedAuthState = [ NSKeyedArchiver archivedDataWithRootObject:_authState];
    [[NSUserDefaults standardUserDefaults] setObject:archivedAuthState
                                              forKey:kAppAuthExampleAuthStateKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)loadState {
    // loads OIDAuthState from NSUSerDefaults
    NSData *archivedAuthState =
    [[NSUserDefaults standardUserDefaults] objectForKey:kAppAuthExampleAuthStateKey];
    OIDAuthState *authState = [NSKeyedUnarchiver unarchiveObjectWithData:archivedAuthState];
    if (!authState) {
        [self logMessage:@"[Client] Load Previous State: %@", nil];
    } else {
        [self logMessage:@"[Client] Load Previous State Success"];
    }
    [self setAuthState:authState];
}


- (IBAction)logout:(id)sender {
    NSLog(@"Logout");
    [self setAuthState:nil];
    NXLAppAuthManager *ssoMng = [[NXLAppAuthManager alloc] init];
    [ssoMng logOut];
    _status.text = nil;
    _logTextView.text = @"";
}
- (IBAction)logOutHome:(id)sender {
    NSLog(@"Logout");
    [self setAuthState:nil];
    NXLAppAuthManager *ssoMng = [[NXLAppAuthManager alloc] init];
    [ssoMng logOut];
    _status.text = nil;
    _logTextView.text = @"";
    [self performSegueWithIdentifier:@"logout_success" sender:self];
}


- (IBAction)clearLog:(id)sender {
    _logTextView.text = @"";
}

@end
