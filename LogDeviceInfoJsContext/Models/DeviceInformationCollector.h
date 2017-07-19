//
//  DeviceInformationCollector.h
//  LogDeviceInfoJsContext
//
//  Created by Dimitar Danailov on 7/14/17.
//  Copyright © 2017 Dimitar Danailov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol DeviceInformationCollectorJSExports <JSExport>

@property (strong, nonatomic) NSString *deviceId;
@property (strong, nonatomic) NSString *deviceName;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *deviceSystem;
@property (strong, nonatomic) NSString *deviceSystemVersion;
@property (strong, nonatomic) NSString *networkAdapters;

@end

@interface DeviceInformationCollector : NSObject<DeviceInformationCollectorJSExports>

@property (strong, nonatomic) NSString *deviceId;
@property (strong, nonatomic) NSString *deviceName;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *deviceSystem;
@property (strong, nonatomic) NSString *deviceSystemVersion;
@property (strong, nonatomic) NSString *networkAdapters;

+ (NSMutableArray *) getIpAddresses;

@end
