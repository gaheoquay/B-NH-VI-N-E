//
//  TripleDesEncrypt.h
//  Mongpod
//
//  Created by Mac mini 2014 on 1/25/16.
//  Copyright © 2016 TRAMS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSData+Base64.h"
#import "NSString+URLEncode.h"

@interface DataEncryption : NSObject
+ (NSData *)tripleDesEncryptString:(NSString *)input
                               key:(NSString *)key
                             error:(NSError **)error;
+ (NSString *) getMD5FromString:(NSString *) input;
+ (NSString *)base64Encode:(NSString *)plainText;
+ (NSString *)URLEncoding:(NSString *)plainText;
@end
