//
//  TestBytePacket.m
//  Demo
//
//  Created by Flame Grace on 2017/11/8.
//  Copyright © 2017年 com.flamegrace. All rights reserved.
//

#import "TestBytePacket.h"

@implementation TestBytePacket

- (NSData *)packHead
{
    Byte byte[] =  {0xAF,0xAB};
    return [NSData dataWithBytes:byte length:2];
}

- (BOOL)decodeWithError:(NSError *__autoreleasing *)error
{
    NSInteger length = self.encodeData.length;
    if(length< 6)
    {
        if(error != NULL)
        {
            *error = [NSError errorWithDomain:BytePacketErrorDomain code:BytePacketLackDataErrorCode userInfo:@{NSLocalizedDescriptionKey:@"Encode data lack!"}];
        }
        return NO;
    }
    NSInteger current = 0;
    NSInteger find = [ByteTransfrom findData:[self packHead] firstPositionInData:self.encodeData];
    current = find + 2;
    if(find == -1)
    {
        if(error != NULL)
        {
            *error = [NSError errorWithDomain:BytePacketErrorDomain code:BytePacketDefaultErrorCode userInfo:@{NSLocalizedDescriptionKey:@"Encode data did not contain head data!"}];
        }
        return NO;
    }
    
    //获取json字符串的长度
    Byte *jsonLengthByte = (Byte *)[ByteTransfrom substr:self.encodeData start:current length:4];
    current += 4;
    int jsonLength = [ByteTransfrom lowBytesToInt:jsonLengthByte];
    
    //获取json字符串
    Byte *jsonByte = (Byte *)[ByteTransfrom substr:self.encodeData start:current length:jsonLength];
    current += jsonLength;
    NSData *jsonData = [[NSData alloc]initWithBytes:jsonByte length:jsonLength];
    
    NSError *jsonError;
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&jsonError];
    if(jsonError)
    {
        if(error != NULL)
        {
            *error = [NSError errorWithDomain:BytePacketErrorDomain code:BytePacketDefaultErrorCode userInfo:@{NSLocalizedDescriptionKey:@"Json serialization failed!"}];
        }
        return NO;
    }
    self.jsonDic = jsonDic;
    self.encodeLength = length;
    return YES;
}

- (BOOL)encodeWithError:(NSError *__autoreleasing *)error
{
    if(!self.jsonDic)
    {
        if(error != NULL)
        {
            *error = [NSError errorWithDomain:BytePacketErrorDomain code:BytePacketDefaultErrorCode userInfo:@{NSLocalizedDescriptionKey:@"JsonDic is NULL!"}];
        }
        return NO;
    }
    NSUInteger codeLen = 0;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.jsonDic options:NSJSONWritingPrettyPrinted error:nil];
    if(!jsonData||(jsonData && jsonData.length == 0))
    {
        if(error != NULL)
        {
            *error = [NSError errorWithDomain:BytePacketErrorDomain code:BytePacketDefaultErrorCode userInfo:@{NSLocalizedDescriptionKey:@"JsonDic is bad data!"}];
        }
        return NO;
    }
    NSMutableData *encodeBuffer = [[NSMutableData alloc]init];
    [encodeBuffer appendData:[self packHead]];
    codeLen += 2;
    int jsonLength = (int)[jsonData length];
    //总长度
    Byte *jsonLengthByte = (Byte *)&jsonLength;
    [encodeBuffer appendBytes:jsonLengthByte length:4];
    codeLen += 4;
    [encodeBuffer appendData:jsonData];
    codeLen += jsonLength;
    
    self.encodeData = [NSData dataWithData:encodeBuffer];
    self.encodeLength = codeLen;
    
    return YES;
}



@end
