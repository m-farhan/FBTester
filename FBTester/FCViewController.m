//
//  FCViewController.m
//  FBTester
//
//  Created by Farhan on 3/10/2014.
//  Copyright (c) 2014 Farhan. All rights reserved.
//

#import "FCViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "SDWebImage/UIImageView+WebCache.h"

@interface FCViewController ()

@end

@implementation FCViewController
@synthesize userDetails,userImage;
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)FBConnect:(id)sender
{
    [self doFacebookLogin];
}

-(void) doFacebookLogin
{
    NSArray *permissions = [[NSArray alloc] initWithObjects:
                            @"email", nil];
    
    // Attempt to open the session. If the session is not open, show the user the Facebook login UX
    [FBSession openActiveSessionWithReadPermissions:permissions
                                       allowLoginUI:true
                                  completionHandler:^(FBSession *session,
                                                      FBSessionState status,
                                                      NSError *error)
     {
         // Did something go wrong during login? I.e. did the user cancel?
         if (status == FBSessionStateClosedLoginFailed || status == FBSessionStateCreatedOpening) {
             
             // If so, just send them round the loop again
             [[FBSession activeSession] closeAndClearTokenInformation];
             [FBSession setActiveSession:nil];
             FBSession* session = [[FBSession alloc] init];
             [FBSession setActiveSession: session];
             NSLog(@"Fail");
             
             
         }
         else
         {
             [[FBRequest requestForMe] startWithCompletionHandler:
              ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
                  if (!error) {
                      __block NSString *jsonFriendsDataString=Nil;
                      //============================================================
                      [[FBRequest requestForGraphPath:@"me/friends?limit=20000"] startWithCompletionHandler:
                       ^(FBRequestConnection *connection, NSDictionary *data, NSError *error) {
                           if (!error) {
                               NSError *error;
                               NSData *jsonData2 = [NSJSONSerialization dataWithJSONObject:[data objectForKey:@"data"]
                                                                                   options:NSJSONWritingPrettyPrinted
                                                                                     error:&error];
                               if (! jsonData2) {
                                   NSLog(@"Got an error: %@", error);
                               } else {
                                   jsonFriendsDataString=[[NSString alloc] initWithData:jsonData2
                                                                               encoding:NSUTF8StringEncoding];
                               }
                           }
                           
                       }];
                      
                      //============================================================
                      [self fbProcessUserData:user];
                  }
                  
              }];
         }
     }];
    
}
-(void)fbProcessUserData:(NSDictionary *)user
{
    
    userDetails.text=[NSString stringWithFormat:@"First Name:%@\nLast Name:%@\nEmail:%@\nFacebook Name:%@\nFacebook ID:%@",[user objectForKey:@"first_name"],[user objectForKey:@"last_name"],[user objectForKey:@"email"],[user objectForKey:@"username"],[user objectForKey:@"id"]];
    [userImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large",[user objectForKey:@"id"]]]
              placeholderImage:[UIImage imageNamed:@"unknownUser.png"]];
}
@end
