//
//  NSString+URLEncode.m
//  Junggu
//
//  Created by trong on 12/11/15.
//  Copyright © 2015 TRAMS. All rights reserved.
//

#import "NSString+URLEncode.h"

@implementation NSString (URLEncode)
- (NSString *)URLEncodedString
{
  __autoreleasing NSString *encodedString;
  
  NSString *originalString = (NSString *)self;
  encodedString = (__bridge_transfer NSString * )
  CFURLCreateStringByAddingPercentEscapes(NULL,
                                          (__bridge CFStringRef)originalString,
                                          NULL,
                                          (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                          kCFStringEncodingUTF8);
  return encodedString;
}
- (NSString *)URLEncodedStringImage
{
    __autoreleasing NSString *encodedString;
    
    NSString *originalString = (NSString *)self;
    encodedString = (__bridge_transfer NSString * )
    CFURLCreateStringByAddingPercentEscapes(NULL,
                                            (__bridge CFStringRef)originalString,
                                            NULL,
                                            (CFStringRef)@"!*'();@&=+$,?%#[]",
                                            kCFStringEncodingUTF8);
    return encodedString;
}
@end
