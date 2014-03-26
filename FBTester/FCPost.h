//
//  FCPost.h
//  FBTester
//
//  Created by Farhan on 2014-03-25.
//  Copyright (c) 2014 Farhan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
@interface FCPost : UIViewController<UITextFieldDelegate>
@property (strong, nonatomic) FBRequestConnection *requestConnection;
@property (strong, nonatomic) IBOutlet UITextField *msg;

@end
