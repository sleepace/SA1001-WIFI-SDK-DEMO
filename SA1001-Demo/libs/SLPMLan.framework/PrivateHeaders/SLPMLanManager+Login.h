//
//  SLPMLanManager+Login.h
//  Sleepace
//
//  Created by Shawley on 27/06/2017.
//  Copyright © 2017 com.medica. All rights reserved.
//

#import "SLPMLanManager.h"
#import "SLPMLanCommonHeads.h"

@interface SLPMLanManager (Login)

- (BOOL)loginMLanDeviceWithDeviceName:(NSString *)deviceName deviceType:(SLPDeviceTypes)deviceType completion:(void(^)(SLPDeviceLoginReturnCodes returnCode))completion;

@end
