//
//  Reminder.m
//  RemindMeAgain
//
//  Created by Kavan Puranik on 6/25/13.
//  Copyright (c) 2013 Kavan Puranik. All rights reserved.
//

#import "Reminder.h"

@implementation Reminder

- (id)initWithReminderId:(NSString*) reminderId withDescription:(NSString*) description
{
    self = [super init];
    if (self) {
        _description = description;
        _reminderId = reminderId;
    }
    return self;
}

- (void) start
{
    // Cancel any preexisting timer
    [self.repeatingTimer invalidate];
    
    self.minutesRemainingForNextReminder = self.reminderPeriod;
    self.repeatingTimer = [NSTimer scheduledTimerWithTimeInterval: 4 /* TODO always set this back to 60 seconds before checking-in */
                                                           target:self selector:@selector(trackReminder:)
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

- (void)trackReminder:(NSTimer*)theTimer
{    
    self.minutesRemainingForNextReminder --;
    NSLog(@"minutesRemainingForNextReminder: %ld ", self.minutesRemainingForNextReminder);
    
    if (self.minutesRemainingForNextReminder > 0)
    {
        self.onReminderPeriodUpdated(self);
        return;
    }
    
    self.onReminderPeriodUpdated(self);
    self.onReminderPeriodFinished(self);
    self.minutesRemainingForNextReminder = self.reminderPeriod;
    
    [NSTimer scheduledTimerWithTimeInterval: 2
                                     target:self selector:@selector(startReminder:)
                                   userInfo:[self userInfo] repeats:NO];
}

- (void)startReminder:(NSTimer*)theTimer
{
    self.onReminderPeriodUpdated(self);
}

- (BOOL) isRunning
{
   return [self.repeatingTimer isValid];
}

- (NSDictionary *)userInfo
{
    return @{ @"StartDate" : [NSDate date] };
}

@end
