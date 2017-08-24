//
//  SocketProtocol.h
//  LanP2P
//
//  Created by Flame Grace on 16/11/16.
//  Copyright © 2016年 hello. All rights reserved.
//

#import <Foundation/Foundation.h>



typedef NS_ENUM(NSInteger, BytePacketErrorCode){
    
    BytePacketDefaultErrorCode = -2, //解码或编码过程中时数据出现普通错误
    BytePacketNotFoundHeadByteErrorCode = -1, //没有找到头数据
    BytePacketLackDataErrorCode, //解码时已完成解码，但最终因当前数据不足而失败
};

#define BytePacketErrorDomain @"com.leapmotor.bytePacketErrorDomain"


@protocol BytePacketProtocol <NSObject>


//自定义的头数据
- (NSData *)packHead;
//解码
- (BOOL)decodeWithError:(NSError **)error;
//编码
- (BOOL)encodeWithError:(NSError **)error;




@end



