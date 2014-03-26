//
//  FCPost.m
//  FBTester
//
//  Created by Farhan on 2014-03-25.
//  Copyright (c) 2014 Farhan. All rights reserved.
//

#import "FCPost.h"

@interface FCPost ()

@end

@implementation FCPost
@synthesize requestConnection,msg;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.msg.delegate = self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}
-(IBAction)Back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//================ IBAction =============
-(IBAction)POSTImage:(id)sender
{
    UIImage *img = [UIImage imageNamed:@"FB.jpg"];
    [self requestPermissionForImage:img WithMessage:msg.text];
}
-(IBAction)POSTUrl:(id)sender
{
    NSString *URL=@"http://m-farhan.com/2014/03/ios-facebook-sdk-tutorial/";
    [self requestPermissionForURL:URL WithMessage:msg.text];
}
-(IBAction)DOCheckIn:(id)sender
{
    NSString *FBPageID=@"158386624285338";
    [self requestPermissionForChekInWithPageID:FBPageID WithMessage:msg.text];
}

//============Helper Functions=========

//----------------------- POST IMAGE------------------------------------
- (void)requestPermissionForImage:(UIImage *) img WithMessage:(NSString *)messag
{
    
    [FBSession openActiveSessionWithPublishPermissions:[NSArray arrayWithObjects:@"publish_actions", @"publish_checkins",nil]
                                       defaultAudience:FBSessionDefaultAudienceEveryone allowLoginUI:YES
                                     completionHandler:^(FBSession *session,FBSessionState s, NSError *error) {
                                         if (!error) {
                                             // Now have the permission
                                             [self processPostingImage:img WithMessage:messag];
                                         } else {
                                             // Facebook SDK * error handling *
                                             // if the operation is not user cancelled
                                             if (error.fberrorCategory != FBErrorCategoryUserCancelled) {
                                                 [self presentAlertForError:error];
                                             }
                                         }
                                     }];
}

- (void)processPostingImage:(UIImage *) img WithMessage:(NSString *)messag
{
    FBRequestConnection *newConnection = [[FBRequestConnection alloc] init];
    FBRequestHandler handler =
    ^(FBRequestConnection *connection, id result, NSError *error) {
        // output the results of the request
        [self requestCompleted:connection forFbID:@"me" result:result error:error];
    };
    FBRequest *request=[[FBRequest alloc] initWithSession:FBSession.activeSession graphPath:@"me/photos" parameters:[NSDictionary dictionaryWithObjectsAndKeys:UIImageJPEGRepresentation(img, 0.7),@"source",messag,@"message",@"{'value':'EVERYONE'}",@"privacy", nil] HTTPMethod:@"POST"];
    
    
    [newConnection addRequest:request completionHandler:handler];
    [self.requestConnection cancel];
    self.requestConnection = newConnection;
    [newConnection start];
}

//----------------------------------------------------------------------------------
//----------------------- POST URL------------------------------------
- (void)requestPermissionForURL:(NSString *)URL WithMessage:(NSString *)messag
{
    
    [FBSession openActiveSessionWithPublishPermissions:[NSArray arrayWithObjects:@"publish_actions", @"publish_checkins",nil]
                                       defaultAudience:FBSessionDefaultAudienceEveryone allowLoginUI:YES
                                     completionHandler:^(FBSession *session,FBSessionState s, NSError *error) {
                                         if (!error) {
                                             // Now have the permission
                                             [self processPostingURL:URL WithMessage:messag];
                                         } else {
                                             // Facebook SDK * error handling *
                                             // if the operation is not user cancelled
                                             if (error.fberrorCategory != FBErrorCategoryUserCancelled) {
                                                 [self presentAlertForError:error];
                                             }
                                         }
                                     }];
}

- (void)processPostingURL:(NSString *) URL WithMessage:(NSString *)messag
{
    FBRequestConnection *newConnection = [[FBRequestConnection alloc] init];
    FBRequestHandler handler =
    ^(FBRequestConnection *connection, id result, NSError *error) {
        // output the results of the request
        [self requestCompleted:connection forFbID:@"me" result:result error:error];
    };
    FBRequest *request=[[FBRequest alloc] initWithSession:FBSession.activeSession graphPath:@"me/feed" parameters:[NSDictionary dictionaryWithObjectsAndKeys:URL,@"link",
                                                                                                                   messag,@"message",
                                                                                                                   @"{'value':'EVERYONE'}",@"privacy",
                                                                                                                   nil] HTTPMethod:@"POST"];
    
    [newConnection addRequest:request completionHandler:handler];
    [self.requestConnection cancel];
    self.requestConnection = newConnection;
    [newConnection start];
}

//----------------------------------------------------------------------------------
//----------------------- POST Check In ------------------------------------
- (void)requestPermissionForChekInWithPageID:(NSString *)FBPageID WithMessage:(NSString *)messag
{
    
    [FBSession openActiveSessionWithPublishPermissions:[NSArray arrayWithObjects:@"publish_actions", @"publish_checkins",nil]
                                       defaultAudience:FBSessionDefaultAudienceEveryone allowLoginUI:YES
                                     completionHandler:^(FBSession *session,FBSessionState s, NSError *error) {
                                         if (!error) {
                                             // Now have the permission
                                             [self processPostingChekInWithPageID:FBPageID WithMessage:messag];
                                         } else {
                                             // Facebook SDK * error handling *
                                             // if the operation is not user cancelled
                                             if (error.fberrorCategory != FBErrorCategoryUserCancelled) {
                                                 [self presentAlertForError:error];
                                             }
                                         }
                                     }];
}

- (void)processPostingChekInWithPageID:(NSString *)FBPageID WithMessage:(NSString *)messag
{
    
    FBRequestConnection *newConnection = [[FBRequestConnection alloc] init];
    FBRequestHandler handler =
    ^(FBRequestConnection *connection, id result, NSError *error) {
        // output the results of the request
        [self requestCompleted:connection forFbID:@"me" result:result error:error];
    };
    NSString *message = [NSString stringWithFormat:@"Your Message Here"];
    FBRequest *request=[[FBRequest alloc] initWithSession:FBSession.activeSession graphPath:@"me/feed" parameters:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                                                   FBPageID,@"place",
                                                                                                                   message,@"message",
                                                                                                                   @"{'value':'EVERYONE'}",@"privacy",
                                                                                                                   nil] HTTPMethod:@"POST"];
    
    [newConnection addRequest:request completionHandler:handler];
    [self.requestConnection cancel];
    self.requestConnection = newConnection;
    [newConnection start];
}


// FBSample logic
// Report any results.  Invoked once for each request we make.
- (void)requestCompleted:(FBRequestConnection *)connection
                 forFbID:fbID
                  result:(id)result
                   error:(NSError *)error
{
    NSLog(@"request completed");
    
    // not the completion we were looking for...
    if (self.requestConnection &&
        connection != self.requestConnection)
    {
        NSLog(@"Request Sent But not compleated Yet");
        return;
    }
    
    // clean this up, for posterity
    self.requestConnection = nil;
    
    if (error)
    {
        NSLog(@"    error");
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        // error contains details about why the request failed
        [alert show];
    }
    else
    {
        NSLog(@"   ok");
        NSLog(@"%@",result);
        //[self doCheckIn];
        
    };
}
- (void) presentAlertForError:(NSError *)error {
    // Facebook SDK * error handling *
    // Error handling is an important part of providing a good user experience.
    // When fberrorShouldNotifyUser is YES, a fberrorUserMessage can be
    // presented as a user-ready message
    if (error.fberrorShouldNotifyUser) {
        // The SDK has a message for the user, surface it.
        [[[UIAlertView alloc] initWithTitle:@"Something Went Wrong"
                                    message:error.fberrorUserMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    } else {
        NSLog(@"unexpected error:%@", error);
    }
}


@end
