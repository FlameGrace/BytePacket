//
//  BytePacket.m
//  LanP2P
//
//  Created by Flame Grace on 16/11/16.
//  Copyright © 2016年 hello. All rights reserved.
//

#import "BytePacket.h"
#import "ByteTransfrom.h"

@implementation BytePacket

+ (instancetype)packet
{
    return [[[self class] alloc]init];
}

+ (void)decodeInBufferData:(NSData *)bufferData withSuccessBlock:(BytePacketDecodeSuccessBlock)success failureBlock:(BytePacketDecodeFailureBlock)failure
{
    BytePacket *packet = [self packet];
    NSData *headerData = [packet packHead];
    NSInteger find = [ByteTransfrom findData:headerData firstPositionInData:bufferData];

    if(find == -1)
    {
        NSError *error = [NSError errorWithDomain:BytePacketErrorDomain code:BytePacketNotFoundHeadByteErrorCode userInfo:@{NSLocalizedDescriptionKey:@"没有找到头数据"}];
        failure(packet,find,error);
        return;
    }
    
    NSUInteger sumLength = bufferData.length;
    NSData *data = [bufferData subdataWithRange:NSMakeRange(find, (sumLength - find))];
    packet.encodeData = data;
    NSError *error;
    if([packet decodeWithError:&error])
    {
        success(packet,find);
    }
    else
    {
       failure(packet,find,error);
    }
}


- (NSData *)packHead
{
    return nil;
}

- (BOOL)decodeWithError:(NSError *__autoreleasing *)error
{
    return NO;
}

- (BOOL)encodeWithError:(NSError *__autoreleasing *)error
{
    return NO;
}



@end
