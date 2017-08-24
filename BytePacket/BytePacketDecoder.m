//
//  BytePacketDecoder.m
//  ToolsKit
//
//  Created by Flame Grace on 2017/8/24.
//  Copyright © 2017年 hello. All rights reserved.
//

#import "BytePacketDecoder.h"

@interface BytePacketDecoder()

@property (strong, nonatomic) NSMutableData *bufferData;

@end

@implementation BytePacketDecoder
@synthesize delegate = _delegate;
@synthesize packetClass = _packetClass;


- (void)setPacketClass:(Class)packetClass
{
    if(![packetClass isSubclassOfClass:[BytePacket class]])
    {
        return;
    }
    _packetClass = packetClass;
}

- (void)receiveNewBufferData:(NSData *)newBuffer
{
    @synchronized (self) {
        if(!newBuffer||newBuffer.length == 0)
        {
            return;
        }
        [self.bufferData appendData:newBuffer];
        NSData *data = [NSData dataWithData:self.bufferData];
        [self decodeNewPacketInBufferData:data];
    }
}



- (void)decodeNewPacketInBufferData:(NSData *)bufferData
{
    BytePacket *packet = [[self.packetClass alloc] init];
    NSData *headerData = [packet packHead];
    NSInteger find = [ByteTransfrom findData:headerData firstPositionInData:bufferData];
    if(find == -1)
    {
        [self.bufferData replaceBytesInRange:NSMakeRange(0, bufferData.length) withBytes:NULL length:0];
        return;
    }
    NSError *error = nil;
    if([packet decodeWithError:&error])
    {
        if([self.delegate respondsToSelector:@selector(bytePacketDecoder:decodeNewPacket:)])
        {
            [self.delegate bytePacketDecoder:self decodeNewPacket:packet];
        }
        
        return;
    }
    //如果因为数据长度不够而解码出错，读取的指针,下一次从find位置开始读
    if(error.code == BytePacketLackDataErrorCode)
    {
        return;
    }
    else
    {
        [self.bufferData replaceBytesInRange:NSMakeRange(0, bufferData.length) withBytes:NULL length:0];
        return;
    }
}

- (NSMutableData *)bufferData
{
    if(!_bufferData)
    {
        _bufferData = [[NSMutableData alloc]init];
    }
    return _bufferData;
}

@end
