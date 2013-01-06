//
//  HWAppDelegate.h
//  RemindMeAgain
//
//  Created by Kavan Puranik on 1/5/13.
//  Copyright (c) 2013 Kavan Puranik. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface HWAppDelegate : NSObject <NSApplicationDelegate, NSUserNotificationCenterDelegate>
{
    IBOutlet NSTextField *textField;
    IBOutlet NSTextField *textLabel;
}

- (IBAction)showtext:(id)sender;

- (IBAction)showNotification:(id)sender;

@end
