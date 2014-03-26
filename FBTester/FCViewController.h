//
//  FCViewController.h
//  FBTester
//
//  Created by Farhan on 3/10/2014.
//  Copyright (c) 2014 Farhan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface FCViewController : UIViewController
@property (nonatomic, retain) IBOutlet UITextView *userDetails;
@property (nonatomic, retain) IBOutlet UIImageView *userImage;
@property (strong, nonatomic) FBRequestConnection *requestConnection;

-(IBAction)FBConnect:(id)sender;
-(void)fbProcessUserData:(NSDictionary *)user;
-(IBAction)Signout:(id)sender;
@end
