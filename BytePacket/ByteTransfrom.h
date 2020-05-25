//
//  ByteTransfrom.h
//
//  Created by Flame Grace on 16/11/4.
//  Copyright © 2016年 hello. All rights reserved.
//  字节数据转换、查找工具类，OC系统默认全部是小端

#import <Foundation/Foundation.h>

@interface ByteTransfrom : NSObject
/**
 short转大端字节码  2字节
 @param num short
 @return 字节码
 */
+ (Byte *)shortIntToHighBytes:(short)num;
/**
 int转大端字节码
 @param num int
 @return 字节码
 */
+ (Byte *)intToHighBytes:(int)num;
/**
 float转大端字节码
 @param num float
 @return 字节码
 */
+ (Byte *)floatToHighBytes:(float)num;
/**
 long转大端字节码
 @param num long
 @return 字节码
 */
+ (Byte *)longToHighBytes:(long)num;
/**
 double转大端字节码
 @param num double
 @return 字节码
 */
+ (Byte *)doubleToHighBytes:(double)num;
/**
 一个字节转short或int都一样，不分大小端
 @param byte 一个字节数据
 @return short
 */
+ (short)oneBytesToShortInt:(Byte *)byte;
/**
 小端2字节转short
 @param byte 2个字节数据
 @return short
 */
+ (short)lowBytesToShortInt:(Byte *)byte;
/**
 大端2字节转short
 @param byte 2个字节数据
 @return short
 */
+ (short)highBytesToShortInt:(Byte *)byte;
/**
 小端4字节转int
 @param byte 4个字节数据
 @return int
 */
+ (int)lowBytesToInt:(Byte *)byte;
/**
 大端4字节转int
 @param byte 4个字节数据
 @return int
 */
+ (int)highBytesToInt:(Byte*)byte;
/**
 小端4字节转float
 @param byte 4个字节数据
 @return float
 */
+ (float)lowBytesToFloat:(Byte *)byte;
/**
 大端4字节转float
 @param byte 4个字节数据
 @return float
 */
+ (float)highBytesToFloat:(Byte *)byte;
/**
 小端8字节转long
 @param byte 8个字节数据
 @return int
 */
+ (long)lowBytesToLong:(Byte *)byte;
/**
 大端8字节转long
 @param byte 8个字节数据
 @return int
 */
+ (long)highBytesToLong:(Byte *)byte;
/**
 小端8字节转double
 @param byte 8个字节数据
 @return double
 */
+ (double)lowBytesToDouble:(Byte *)byte;
/**
 大端8字节转double
 @param byte 8个字节数据
 @return double
 */
+ (double)highBytesToDouble:(Byte *)byte;
/**
 从data中查找指定字节的数据，并返回第一次出现的位置，-1代表未找到

 @param find sub data
 @param data source data
 @return position, -1: Not Found
 */
+ (NSInteger)findData:(NSData *)find firstPositionInData:(NSData *)data;

//从data数组中查找含有相应字节的子数组的位置，返回位置数组
+ (NSArray <NSNumber *> *)findData:(NSData *)find positionsInData:(NSData *)data;

/**
 从Data中截取部分字节数组
 @param data 被截取的数据
 @param start 起始位置
 @param length 截取长度
 @return 返回截取出的数据
 */
+ (NSData *)subdata:(NSData *)data start:(NSInteger)start length:(NSInteger)length;

//从字符串中截取部分字符串
+ (char *)substr:(NSData *)src start:(NSInteger)start length:(NSInteger)length;



@end
