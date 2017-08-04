//
//  WebService.h
//  Sozooed
//
//  Created by Ravi on 01/06/17.
//  Copyright © 2017 Ravi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WebService : NSObject

@property (copy, nonatomic) void (^responseData)(NSDictionary *response, NSError *error);

//Api Call
+(void)callApiWithParameters:(NSDictionary *)parameters
                     apiName:(NSString *)apiName
                        type:(NSString *)type
                responseData:(void (^)(NSDictionary *response, NSError *error))responseData;

+ (BOOL)internetConnectionCheck;

@end
