//
//  SA1001MusicDownloadStatus.h
//  SLPTCP
//
//  Created by Michael on 2020/7/13.
//  Copyright © 2020 Martin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SA1001MusicDownloadStatus : NSObject

@property (nonatomic,assign) UInt8 downloadStatus;
@property (nonatomic,assign) UInt8 rate;

@end

NS_ASSUME_NONNULL_END
