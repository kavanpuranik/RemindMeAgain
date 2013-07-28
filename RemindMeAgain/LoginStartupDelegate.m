//
//  LoginStartup.m
//  RemindMeAgain
//
//  Created by Kavan Puranik on 7/27/13.
//  Copyright (c) 2013 Kavan Puranik. All rights reserved.
//

#import "LoginStartupDelegate.h"
#import <ServiceManagement/ServiceManagement.h>
#import <ServiceManagement/SMLoginItem.h>

@implementation LoginStartupDelegate

static NSString const *kLoginHelperBundleIdentifier = @"com.penguintastic.RemindMeAgainLoginHelperApp";

- (void) enable
{
    if (!SMLoginItemSetEnabled((__bridge CFStringRef)kLoginHelperBundleIdentifier, true)) {
        NSLog(@"Login Startup enable failed");
    }
}

- (void) disable
{
    if (!SMLoginItemSetEnabled((__bridge CFStringRef)kLoginHelperBundleIdentifier, false)) {
        NSLog(@"Login Startup disable failed");
    }
}

- (BOOL) isEnabled
{
    NSArray *jobs = (__bridge NSArray *)SMCopyAllJobDictionaries(kSMDomainUserLaunchd);
    if (jobs == nil) {
        return NO;
    }
    
    if ([jobs count] == 0) {
        CFRelease((__bridge CFArrayRef)jobs);
        return NO;
    }
    
    BOOL onDemand = NO;
    for (NSDictionary *job in jobs) {
        //NSLog(@"job key %@", [job objectForKey:@"Label"]);
        if ([kLoginHelperBundleIdentifier isEqualToString:[job objectForKey:@"Label"]]) {

            NSLog(@"found job key %@", [job objectForKey:@"Label"]);
            onDemand = [[job objectForKey:@"OnDemand"] boolValue];
            break;
        }
    }
    
    CFRelease((__bridge CFArrayRef)jobs);
    return onDemand;
}

@end
