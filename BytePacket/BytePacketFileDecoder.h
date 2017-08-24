//
//  BytePacketDecoder.h
//  LanP2P
//
//  Created by Flame Grace on   16/11/22.
//  Copyright © 2016年 hello. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BytePacketDecoder.h"


@interface BytePacketFileDecoder : BytePacketDecoder 


//存储buffer数据的文件位置
@property (strong, nonatomic) NSString * bufferFilePath;

//每次读取buffer文件的长度,默认每次读取1M
@property (assign, nonatomic) NSInteger readBufferLength;


@end
