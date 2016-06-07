@import CoreLocation;
#import "TRApplicationController.h"
#import "TRWeatherController.h"
#import "TRLocationController.h"
#import "Tropos-Swift.h"
#import "Secrets.h"

@interface TRApplicationController ()

@property (nonatomic) TRWeatherController *weatherController;
@property (nonatomic) TRLocationController *locationController;

@end

@implementation TRApplicationController

- (instancetype)init
{
    self = [super init];
    if (!self) { return nil; }

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    self.rootViewController = [storyboard instantiateInitialViewController];

    self.weatherController = [TRWeatherController new];
    self.locationController = [TRLocationController new];
    self.courier = [[TRCourierClient alloc] initWithApiToken: TRCourierAPIToken];

    return self;
}

- (RACSignal *)performBackgroundFetch
{
    return [self.weatherController.updateWeatherCommand execute:self];
}

- (RACSignal *)localWeatherNotification
{
    RACCommand *command = self.weatherController.updateWeatherCommand;
    RACSignal *conditionsDescription = self.weatherController.conditionsDescription;

    RACSignal *updatedConditions = [[[command execute:self]
        catch:^(NSError *error) {
            BOOL disabled = [error.domain isEqualToString:RACCommandErrorDomain] && error.code == RACCommandErrorNotEnabled;
            if (!disabled) {
                return [RACSignal error:error];
            }

            return [[command.executing
                map:^(NSNumber *executing) {
                    if (executing.boolValue) {
                        return [conditionsDescription skip:1];
                    } else {
                        return conditionsDescription;
                    }
                }]
                switchToLatest];
        }]
        take:1];

    return [updatedConditions map:^(NSAttributedString *conditions) {
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.fireDate = [NSDate distantPast];
        notification.alertTitle = NSLocalizedString(@"TodayWeatherForecast", "");
        notification.alertBody = conditions.string;
        return notification;
    }];
}

- (void)setMinimumBackgroundFetchIntervalForApplication:(UIApplication *)application
{
    if ([self.locationController authorizationStatusEqualTo:kCLAuthorizationStatusAuthorizedAlways]) {
        [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    } else {
        [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalNever];
    }
}

@end
