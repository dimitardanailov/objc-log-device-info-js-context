//
//  DeviceInformationCollector.m
//  LogDeviceInfoJsContext
//
//  Created by Dimitar Danailov on 7/14/17.
//  Copyright © 2017 Dimitar Danailov. All rights reserved.
//

#import <sys/utsname.h>
#import <mach/mach.h>
#import <UIKit/UIKit.h>
#import "DeviceInformationCollector.h"

#include <stdio.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <ifaddrs.h>
#include <net/if.h>
#include <netdb.h>

#import "IpAddress.h"

@interface DeviceInformationCollector()
@property (strong, nonatomic) NSMutableArray *ipAddresses;
@end

@implementation DeviceInformationCollector

@synthesize deviceId = _deviceId;
@synthesize deviceName = _deviceName;
@synthesize username = _username;
@synthesize deviceSystem = _deviceSystem;
@synthesize deviceSystemVersion = _deviceSystemVersion;
@synthesize ipAddress = _ipAddress;

- (instancetype) init
{
    self = [super init];
    
    if (self) {
        self.deviceId = [self deviceId];
        self.deviceName = [self deviceName];
        self.username = [self username];
        self.deviceSystem = [self deviceSystem];
        self.deviceSystemVersion = [self deviceSystemVersion];
        
        // Ip addresses information
        self.ipAddresses = [self ipAddresses];
        
        self.ipAddress = [DeviceInformationCollector convertIpAddressesToString:_ipAddresses];
    }
    
    return self;
}

/*! Source: https://stackoverflow.com/questions/5468629/device-id-from-an-iphone-app
 * \returns information about device imei
 */
- (NSString *) deviceId {
    NSString *uniqueIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    return uniqueIdentifier;
}

/*! Source: https://stackoverflow.com/questions/11197509/ios-how-to-get-device-make-and-model
 * \returns information about device imei
 */
- (NSString *) deviceName {
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
}

- (NSString *) username {
    return NSUserName();
}

- (NSString *) deviceSystem {
    return [UIDevice currentDevice].systemName;
}

- (NSString *) deviceSystemVersion {
    return [UIDevice currentDevice].systemVersion;
}

- (NSMutableArray *)ipAddresses {
    if (!_ipAddresses) _ipAddresses = [DeviceInformationCollector getIpAddresses];
    
    return _ipAddresses;
}

/*!
 * Getting a List of All IP Addresses in Apple's Technical Note TN1145 mentions 3 methods for getting the status of the network interfaces:
 *
 * - System Configuration Framework
 * - Open Transport API
 * - BSD sockets
 *
 * Source: https://stackoverflow.com/questions/12690622/detect-any-connected-network
 * \returns a collection with all possible network ip addresses
 */
+ (NSMutableArray *) getIpAddresses
{
    NSMutableArray *ipAddresses = [[NSMutableArray alloc] init];
    
    struct ifaddrs *allInterfaces;
    
    // Get list of all interfaces on the local machine:
    if (getifaddrs(&allInterfaces) == 0) {
        struct ifaddrs *interface;
        
        // For each interface ...
        for (interface = allInterfaces; interface != NULL; interface = interface->ifa_next) {
            unsigned int flags = interface->ifa_flags;
            struct sockaddr *addr = interface->ifa_addr;
            
            // Check for running IPv4, IPv6 interfaces. Skip the loopback interface.
            if ((flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING)) {
                if (addr->sa_family == AF_INET || addr->sa_family == AF_INET6) {
                    
                    // Convert interface address to a human readable string:
                    char host[NI_MAXHOST];
                    getnameinfo(addr, addr->sa_len, host, sizeof(host), NULL, 0, NI_NUMERICHOST);
                    
                    
                    
                    // NSString *string = "interface:%s, address:%s\n", interface->ifa_name, host;
                    printf("interface:%s, address:%s\n", interface->ifa_name, host);
                    
                    IpAddress *ip = [[IpAddress alloc] init];
                    ip.interface = [NSString stringWithFormat:@"%s" , interface->ifa_name];
                    ip.host = [NSString stringWithFormat:@"%s" , host];
                    
                    [ipAddresses addObject:ip];
                }
            }
        }
    }
    
    freeifaddrs(allInterfaces);
    
    return ipAddresses;
}

/*!
 * Method is receiving collection with Network IP addresses and convert them in sting wiht f
 *
 * Source: https://stackoverflow.com/questions/12690622/detect-any-connected-network
 * \returns string with network data
 */
+ (NSMutableString *) convertIpAddressesToString:(NSMutableArray *)ipAddresses {
    NSMutableString *networkData = [[NSMutableString alloc]init];
    
    for (IpAddress *ip in ipAddresses) {
        // Generate interface information
        [networkData appendString:[NSString stringWithFormat:@"interface:%@, address:%@ | ", ip.interface, ip.host]];
    }
    
    return networkData;
}

@end
