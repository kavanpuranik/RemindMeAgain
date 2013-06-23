#import "PanelController.h"
#import "BackgroundView.h"
#import "StatusItemView.h"
#import "MenubarController.h"

#define OPEN_DURATION .15
#define CLOSE_DURATION .1

#define POPUP_HEIGHT 350
#define MENU_ANIMATION_DURATION .1

#pragma mark -

@implementation PanelController

@synthesize backgroundView = _backgroundView;
@synthesize delegate = _delegate;

#pragma mark -

- (id)initWithDelegate:(id<PanelControllerDelegate>)delegate
{
    self = [super initWithWindowNibName:@"StatusBarPopup"];
    if (self != nil)
    {
        _delegate = delegate;
    }
    return self;
}

- (void)dealloc
{
}

#pragma mark -

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // Make a fully skinned panel
    NSPanel *panel = (id)[self window];
    [panel setAcceptsMouseMovedEvents:YES];
    [panel setLevel:NSPopUpMenuWindowLevel];
    [panel setOpaque:NO];
    [panel setBackgroundColor:[NSColor clearColor]];
    
    // Resize panel
    NSRect panelRect = [[self window] frame];
    panelRect.size.height = POPUP_HEIGHT;
    [[self window] setFrame:panelRect display:NO];
    
    // Tab selection
    [tabView setDelegate: self];
    NSTabViewItem *firstTabView = [self->tabView tabViewItemAtIndex:0];
    NSTabViewItem *secondTabView = [self->tabView tabViewItemAtIndex:1];
    [secondTabView setView: [firstTabView view]];
    
    [startStopButton setAction:@selector(startStopReminder)];
    [quitButton setAction:@selector(quitApplication)];    
    [statusLabel setHidden:TRUE];
}

#pragma mark - Public accessors

- (BOOL)hasActivePanel
{
    return _hasActivePanel;
}

- (void)setHasActivePanel:(BOOL)flag
{
    if (_hasActivePanel != flag)
    {
        _hasActivePanel = flag;
        
        if (_hasActivePanel)
        {
            [self openPanel];
        }
        else
        {
            [self closePanel];
        }
    }
}

#pragma mark - NSWindowDelegate

- (void)windowWillClose:(NSNotification *)notification
{
    self.hasActivePanel = NO;
}

- (void)windowDidResignKey:(NSNotification *)notification;
{
    if ([[self window] isVisible])
    {
        self.hasActivePanel = NO;
    }
}

- (void)windowDidResize:(NSNotification *)notification
{
    NSWindow *panel = [self window];
    NSRect statusRect = [self statusRectForWindow:panel];
    NSRect panelRect = [panel frame];
    
    CGFloat statusX = roundf(NSMidX(statusRect));
    CGFloat panelX = statusX - NSMinX(panelRect);
    
    self.backgroundView.arrowX = panelX;
    
}

#pragma mark - NSTabView

- (void)tabView:(NSTabView *)tabView willSelectTabViewItem:(NSTabViewItem *)tabViewItem
{
    NSString *tabViewItemId = [tabViewItem identifier];
    
    NSLog(@"tabViewItemId  %@ ", tabViewItemId);

    if ([tabViewItemId isEqualToString: @"1"])
    {
        

    } else if ([tabViewItemId isEqualToString: @"2"])
    {
        
        
    } else if ([tabViewItemId isEqualToString: @"3"])
    {
        
        [reminderTextField setHidden:FALSE];
    }
}

#pragma mark - Keyboard

- (void)cancelOperation:(id)sender
{
    self.hasActivePanel = NO;
}

#pragma mark - Public methods

- (NSRect)statusRectForWindow:(NSWindow *)window
{
    NSRect screenRect = [[[NSScreen screens] objectAtIndex:0] frame];
    NSRect statusRect = NSZeroRect;
    
    StatusItemView *statusItemView = nil;
    if ([self.delegate respondsToSelector:@selector(statusItemViewForPanelController:)])
    {
        statusItemView = [self.delegate statusItemViewForPanelController:self];
    }
    
    if (statusItemView)
    {
        statusRect = statusItemView.globalRect;
        statusRect.origin.y = NSMinY(statusRect) - NSHeight(statusRect);
    }
    else
    {
        statusRect.size = NSMakeSize(STATUS_ITEM_VIEW_WIDTH, [[NSStatusBar systemStatusBar] thickness]);
        statusRect.origin.x = roundf((NSWidth(screenRect) - NSWidth(statusRect)) / 2);
        statusRect.origin.y = NSHeight(screenRect) - NSHeight(statusRect) * 2;
    }
    return statusRect;
}

- (void)openPanel
{
    NSWindow *panel = [self window];
    
    NSRect screenRect = [[[NSScreen screens] objectAtIndex:0] frame];
    NSRect statusRect = [self statusRectForWindow:panel];

    NSRect panelRect = [panel frame];
    panelRect.origin.x = roundf(NSMidX(statusRect) - NSWidth(panelRect) / 2);
    panelRect.origin.y = NSMaxY(statusRect) - NSHeight(panelRect);
    
    if (NSMaxX(panelRect) > (NSMaxX(screenRect) - ARROW_HEIGHT))
        panelRect.origin.x -= NSMaxX(panelRect) - (NSMaxX(screenRect) - ARROW_HEIGHT);
    
    [NSApp activateIgnoringOtherApps:NO];
    [panel setAlphaValue:0];
    [panel setFrame:statusRect display:YES];
    [panel makeKeyAndOrderFront:nil];
    
    NSTimeInterval openDuration = OPEN_DURATION;
    
    NSEvent *currentEvent = [NSApp currentEvent];
    if ([currentEvent type] == NSLeftMouseDown)
    {
        NSUInteger clearFlags = ([currentEvent modifierFlags] & NSDeviceIndependentModifierFlagsMask);
        BOOL shiftPressed = (clearFlags == NSShiftKeyMask);
        BOOL shiftOptionPressed = (clearFlags == (NSShiftKeyMask | NSAlternateKeyMask));
        if (shiftPressed || shiftOptionPressed)
        {
            openDuration *= 10;
            
            if (shiftOptionPressed)
                NSLog(@"Icon is at %@\n\tMenu is on screen %@\n\tWill be animated to %@",
                      NSStringFromRect(statusRect), NSStringFromRect(screenRect), NSStringFromRect(panelRect));
        }
    }
    
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:openDuration];
    [[panel animator] setFrame:panelRect display:YES];
    [[panel animator] setAlphaValue:1];
    [NSAnimationContext endGrouping];
    
    [self initFormFields];
    
    // Default cursor to reminder text field
    [reminderTextField selectText:self];
    [[reminderTextField currentEditor] setSelectedRange:NSMakeRange([[reminderTextField stringValue] length], 0)];
    
    NSLog(@"opening panel");
}

- (void)closePanel
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:[reminderTextField stringValue] forKey:@"reminderText"];
    [prefs setInteger:[self getReminderPeriod] forKey:@"reminderPeriod"];
    [prefs synchronize];
    
    NSLog(@"closing panel");
    
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:CLOSE_DURATION];
    [[[self window] animator] setAlphaValue:0];
    [NSAnimationContext endGrouping];
    
    dispatch_after(dispatch_walltime(NULL, NSEC_PER_SEC * CLOSE_DURATION * 2), dispatch_get_main_queue(), ^{
        
        [self.window orderOut:nil];
    });
}

- (void)initFormFields {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *reminderText = [prefs stringForKey:@"reminderText"];
    if (reminderText == nil){
        reminderText = @"Get up. Take a Deep Breath. Stretch your legs.";
    }
    [reminderTextField setStringValue:reminderText];
    
    NSInteger reminderPeriodInMinutes = [prefs integerForKey:@"reminderPeriod"];
    if (reminderPeriodInMinutes == 0){
        reminderPeriodInMinutes = 30;
    }
    [self setReminderPeriod:reminderPeriodInMinutes];
}

- (void) startStopReminder {
    if ([[startStopButton title] isEqualToString:@"Turn On"]){
        [self startReminderTimer];
        [startStopButton setTitle:@"Turn Off"];
        [statusLabel setHidden:FALSE];      
        [reminderMinutePeriodField setEnabled:FALSE];
        [reminderHourPeriodField setEnabled:FALSE];
    } else {
        [self stopReminderTimer];
        [startStopButton setTitle:@"Turn On"];
        [statusLabel setStringValue: @" "];
        [reminderMinutePeriodField setEnabled:TRUE];
        [reminderHourPeriodField setEnabled:TRUE];
    }
}

- (void) startReminderTimer {
    
    // Cancel any preexisting timer
    [self.repeatingTimer invalidate];
    
    self.repeatingTimer = [NSTimer scheduledTimerWithTimeInterval: 60
                                                      target:self selector:@selector(startReminder:)
                                                    userInfo:[self userInfo] repeats:YES];
    
    self.minutesRemainingForNextReminder = [self getReminderPeriod];
    [self displayNextReminderMessage];
    NSLog(@"Started Timer...");
}

- (void)startReminder:(NSTimer*)theTimer {
    
    self.minutesRemainingForNextReminder --;
    NSLog(@"minutesRemainingForNextReminder: %ld ", self.minutesRemainingForNextReminder);
    
    if (self.minutesRemainingForNextReminder > 0){
        
       [self displayNextReminderMessage];
       return;
    }
    
    self.minutesRemainingForNextReminder = [self getReminderPeriod];
    [self displayNextReminderMessage];
    
   // NSDate *startDate = [[theTimer userInfo] objectForKey:@"StartDate"];
   // NSLog(@"Notifying at %@", startDate);
    NSString* reminderText = [reminderTextField stringValue];
    
    NSUserNotification *notification = [[NSUserNotification alloc] init];
    notification.title = @"Remind Me";
    notification.informativeText = reminderText;
    notification.soundName = NSUserNotificationDefaultSoundName;
    notification.hasActionButton = FALSE;
    [notification setOtherButtonTitle: @"Close"];
    [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
}

- (void) stopReminderTimer {
    [self.repeatingTimer invalidate];
    self.repeatingTimer = nil;
    NSLog(@"Stopping timer.");
}

- (NSDictionary *)userInfo {
    return @{ @"StartDate" : [NSDate date] };
}

- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center
     shouldPresentNotification:(NSUserNotification *)notification{
    return YES;
}

- (NSInteger)getReminderPeriod {
    NSInteger minutes = [reminderMinutePeriodField integerValue];
    NSInteger hours = [reminderHourPeriodField integerValue];
    minutes = hours * 60 + minutes;
    NSLog(@"Reminder is set to %ld minutes", minutes);
    return minutes;
}

- (void)setReminderPeriod:(NSInteger)reminderPeriodInMinutes {
    NSLog(@"Reminder in minutes is %ld", reminderPeriodInMinutes);
    NSInteger hours = reminderPeriodInMinutes / 60;
    NSInteger minutes = reminderPeriodInMinutes % 60;
    [reminderHourPeriodField setIntegerValue:hours];
    [reminderMinutePeriodField setIntegerValue:minutes];
}

- (void)displayNextReminderMessage {
    NSInteger hours = self.minutesRemainingForNextReminder / 60;
    NSInteger minutes = self.minutesRemainingForNextReminder % 60;
    
    if (hours > 0){
        [statusLabel setStringValue: [NSString stringWithFormat:@"Next reminder in %ld hr %ld min", hours, minutes]];
    } else {
        [statusLabel setStringValue: [NSString stringWithFormat:@"Next reminder in %ld min", minutes]];
    }
}

- (void) quitApplication {
    [NSApp terminate:self];
}

@end
