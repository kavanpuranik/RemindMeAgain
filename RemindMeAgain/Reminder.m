//
//  Reminder.m
//  RemindMeAgain
//
//  Created by Kavan Puranik on 6/25/13.
//  Copyright (c) 2013 Kavan Puranik. All rights reserved.
//

#import "Reminder.h"

@implementation Reminder

- (void) start
{
    // Cancel any preexisting timer
    [self.repeatingTimer invalidate];
    
    self.minutesRemainingForNextReminder = self.reminderPeriod;
    self.repeatingTimer = [NSTimer scheduledTimerWithTimeInterval: 60 /* TODO always set this back to 60 seconds before checking-in */
                                                           target:self selector:@selector(startReminder:)
                                                         userInfo:[self userInfo] repeats:YES];
}

- (void) stop
{
    if (self.repeatingTimer)
    {
        [self.repeatingTimer invalidate];
        self.repeatingTimer = nil;
        NSLog(@"Stopping timer.");
    }
}

- (void)startReminder:(NSTimer*)theTimer
{    
    self.minutesRemainingForNextReminder --;
    NSLog(@"minutesRemainingForNextReminder: %ld ", self.minutesRemainingForNextReminder);
    
    if (self.minutesRemainingForNextReminder > 0)
    {
        self.onReminderPeriodDecremented(self);
        return;
    }
    
    self.onReminderPeriodDecremented(self);
    self.onReminderPeriodFinished(self);
    self.minutesRemainingForNextReminder = self.reminderPeriod;
}

- (NSDictionary *)userInfo
{
    return @{ @"StartDate" : [NSDate date] };
}

@end
