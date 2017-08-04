//
//  WebService.h
//  Sozooed
//
//  Created by Ravi on 01/06/17.
//  Copyright © 2017 Ravi. All rights reserved.
//

#import "WebService.h"
#import "Reachability.h"

#define POST_REQUEST            @"POST"
#define GET_REQUEST             @"GET"

@implementation WebService

- (void)viewDidLoad
{
    [self viewDidLoad];
}

+ (void)callApiWithParameters:(NSDictionary *)parameters apiName:(NSString *)apiName type:(NSString *)type responseData:(void (^)(NSDictionary *, NSError *))responseData
{
    //Internet Connection Check Here!
    if ([type isEqualToString:POST_REQUEST])
    {
        if ([WebService internetConnectionCheck])
        {
            NSLog(@"==============  API URL  ====================");
            NSLog(@"%@",apiName);
            NSLog(@"=============================================");
            
            __block NSDictionary * dictResponse = nil;
            
            NSMutableURLRequest *request;
            
            if (parameters != nil)
            {
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:kNilOptions error:nil];
                // request = [NSMutableURLRequest requestWithURL:urlRequestString];
                request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:apiName] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
                [request setHTTPMethod:type];
                [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                [request setHTTPBody:jsonData];
            }
            
            NSURLSession *session = [NSURLSession sharedSession];
            [[session dataTaskWithRequest:request completionHandler:^(NSData *data , NSURLResponse *response , NSError *err)
              {
                  NSLog(@"==============  PARAMETER  ==================");
                  NSLog(@"%@",parameters);
                  NSLog(@"=============================================");
                  
                  dispatch_async(dispatch_get_main_queue(), ^{
                      
                      NSError *jsonError;
                      
                      if (data)
                      {
                          dictResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                          
                          NSLog(@"===============  RESPONSE  ==================");
                          NSLog(@"%@",dictResponse);
                          NSLog(@"=============================================");
                          
                      }
                      else if(err)
                      {
                          NSString *errorMsg;
                          if ([[err domain] isEqualToString:NSURLErrorDomain]) {
                              switch ([err code]) {
                                  case NSURLErrorTimedOut:
                                      //                                      [self connectionTimeOut];
                                      errorMsg = NSLocalizedString(@"NSURLErrorTimedOut", nil);
                                      break;
                                      
                                  default:
                                      errorMsg = [err localizedDescription];
                                      jsonError = err;
                                      break;
                              }
                          } else {
                              errorMsg = [err localizedDescription];
                              jsonError = err;
                          }
                      }
                      
                      if (responseData != NULL) {
                          responseData(dictResponse,jsonError);
                      }
                  });
              }]
             resume];
        }
        else
        {
            NSLog(@"There's no internet connection.");
        }
    }
    else
    {
        if ([WebService internetConnectionCheck])
        {
            __block NSDictionary * dictResponse = nil;
            
            NSString *apiNameConvert = [apiName stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
            NSLog(@"==============  API URL  ====================");
            NSLog(@"%@",apiNameConvert);
            NSLog(@"=============================================");
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:[NSURL URLWithString:apiNameConvert]];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [request setHTTPMethod:GET_REQUEST];
            
            NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
            [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    NSError *jsonError;
                    
                    if (data)
                    {
                        dictResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                        
                        NSLog(@"===============  RESPONSE  ==================");
                        NSLog(@"%@",dictResponse);
                        NSLog(@"=============================================");
                    }
                    else if(error)
                    {
                        NSString *errorMsg;
                        if ([[error domain] isEqualToString:NSURLErrorDomain]) {
                            switch ([error code]) {
                                case NSURLErrorTimedOut:
                                    //                                    [self connectionTimeOut];
                                    errorMsg = NSLocalizedString(@"NSURLErrorTimedOut", nil);
                                    break;
                                    
                                default:
                                    errorMsg = [error localizedDescription];
                                    jsonError = error;
                                    break;
                            }
                        } else {
                            errorMsg = [error localizedDescription];
                            jsonError = error;
                        }
                    }
                    
                    if (responseData != NULL) {
                        responseData(dictResponse,jsonError);
                    }
                });
            }] resume];
        }
        else
        {
            NSLog(@"There's no internet connection.");
        }
    }
    //If any request want to cancel then we can used this following method
    //[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(callApiWithParameters:apiName:type:loader:message:) object:nil];
}

+ (void)connectionTimeOut
{
    if (!self.isAlertViewShowing)
    {
        NSLog(@"There's no internet connection.");
    }
}

+ (BOOL)isAlertViewShowing {
    for (UIWindow* window in [UIApplication sharedApplication].windows) {
        NSArray* subviews = window.subviews;
        if ([subviews count] > 0){
            for (id view in subviews) {
                if ([view isKindOfClass:[UIAlertView class]]) {
                    return YES;
                }
            }
        }
    }
    return NO;
}

#pragma arguments
+ (BOOL)internetConnectionCheck
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}



@end
