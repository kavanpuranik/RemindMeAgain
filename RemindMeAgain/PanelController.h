#import "BackgroundView.h"
#import "StatusItemView.h"
#import "MinuteNumberField.h"
#import "Reminders.h"

@class PanelController;

@protocol PanelControllerDelegate <NSObject>

@optional

- (StatusItemView *)statusItemViewForPanelController:(PanelController *)controller;

@end

#pragma mark -

@interface PanelController : NSWindowController <NSWindowDelegate, NSUserNotificationCenterDelegate, NSTabViewDelegate>
{
    BOOL _hasActivePanel;
    
    __unsafe_unretained BackgroundView *_backgroundView;
    __unsafe_unretained id<PanelControllerDelegate> _delegate;
    
    __unsafe_unretained IBOutlet NSTabView *tabView;
    
    __unsafe_unretained IBOutlet NSTextField *reminderTextField;    
    __unsafe_unretained IBOutlet MinuteNumberField *reminderMinutePeriodField;
    __unsafe_unretained IBOutlet MinuteNumberField *reminderHourPeriodField;

    __unsafe_unretained IBOutlet NSTextField *statusLabelOne;
    __unsafe_unretained IBOutlet NSTextField *statusLabelTwo;
    
    __unsafe_unretained IBOutlet NSButton *startStopButton;
    __unsafe_unretained IBOutlet NSButton *quitButton;
    
    Reminders *reminders;
}

@property (nonatomic, unsafe_unretained) IBOutlet BackgroundView *backgroundView;

@property (nonatomic) BOOL hasActivePanel;
@property (nonatomic, unsafe_unretained, readonly) id<PanelControllerDelegate> delegate;

- (id)initWithDelegate:(id<PanelControllerDelegate>)delegate;

- (void)openPanel;
- (void)closePanel;

@end
