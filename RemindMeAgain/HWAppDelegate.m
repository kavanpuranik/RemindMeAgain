//
//  HWAppDelegate.m
//  RemindMeAgain
//
//  Created by Kavan Puranik on 1/5/13.
//  Copyright (c) 2013 Kavan Puranik. All rights reserved.
//

#import "HWAppDelegate.h"

@implementation HWAppDelegate


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
        
}

- (IBAction)startReminder:(id)sender
{
    NSString* value1 = [textField stringValue];
    [textLabel setStringValue: value1];
    
    // Cancel a preexisting timer.
    [self.repeatingTimer invalidate];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:5
                                                      target:self selector:@selector(showReminder:)
                                                    userInfo:[self userInfo] repeats:YES];
    self.repeatingTimer = timer;
    
    NSLog(@"Started Timer...");
}

- (IBAction)stopReminder:(id)sender {
    [self.repeatingTimer invalidate];
    self.repeatingTimer = nil;
    NSLog(@"Ended Timer.");
}

- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center
     shouldPresentNotification:(NSUserNotification *)notification{
    return YES;
}

- (void)showReminder:(NSTimer*)theTimer {
    NSDate *startDate = [[theTimer userInfo] objectForKey:@"StartDate"];
    NSLog(@"Timer started on %@", startDate);
    
    NSString* reminderText = [textField stringValue];
    [textLabel setStringValue: reminderText];
    
    NSUserNotification *notification = [[NSUserNotification alloc] init];
    notification.title = @"Remind Me";
    notification.informativeText = reminderText;
    notification.soundName = NSUserNotificationDefaultSoundName;
    [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
}

- (IBAction)showNotification:(id)sender{
    
    NSString* reminderText = [textField stringValue];
    [textLabel setStringValue: reminderText];
    
    NSUserNotification *notification = [[NSUserNotification alloc] init];
    notification.title = @"Remind Me";
    notification.informativeText = reminderText;
    notification.soundName = NSUserNotificationDefaultSoundName;
    [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
}

- (NSDictionary *)userInfo {
    return @{ @"StartDate" : [NSDate date] };
}

@end
