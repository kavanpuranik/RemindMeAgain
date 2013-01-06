//
//  HWAppDelegate.m
//  RemindMeAgain
//
//  Created by Kavan Puranik on 1/5/13.
//  Copyright (c) 2013 Kavan Puranik. All rights reserved.
//

#import "HWAppDelegate.h"

@implementation HWAppDelegate


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
}

- (IBAction)startStopReminder:(id)sender {
    if ([[startStopButton title] isEqualToString:@"Turn On"]){        
        [self startReminderTimer];
        [startStopButton setTitle:@"Turn Off"];
        [statusLabel setStringValue: @"Reminder is On"];
    } else {
        [self stopReminderTimer];
        [startStopButton setTitle:@"Turn On"];
        [statusLabel setStringValue: @"Reminder is Off"];
    }
    
}

- (void) startReminderTimer {
    
    // Cancel a preexisting timer.
    [self.repeatingTimer invalidate];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:5
                                                      target:self selector:@selector(startReminder:)
                                                    userInfo:[self userInfo] repeats:YES];
    
    self.repeatingTimer = timer;
    
    NSLog(@"Started Timer...");
    [statusLabel setStringValue: @"Reminder is turned on."];
}

- (void)startReminder:(NSTimer*)theTimer {
    NSDate *startDate = [[theTimer userInfo] objectForKey:@"StartDate"];
    NSLog(@"Timer started on %@", startDate);
    
    NSString* reminderText = [reminderTextField stringValue];
    
    NSUserNotification *notification = [[NSUserNotification alloc] init];
    notification.title = @"Remind Me";
    notification.informativeText = reminderText;
    notification.soundName = NSUserNotificationDefaultSoundName;
    [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
}

- (void) stopReminderTimer {
    [self.repeatingTimer invalidate];
    self.repeatingTimer = nil;
    NSLog(@"Ended Timer.");
}

- (NSDictionary *)userInfo {
    return @{ @"StartDate" : [NSDate date] };
}

- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center
     shouldPresentNotification:(NSUserNotification *)notification{
    return YES;
}

@end
