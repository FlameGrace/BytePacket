//
//  ByteTransfrom.m
//
//  Created by Flame Grace on 16/11/4.
//  Copyright © 2016年 hello. All rights reserved.
//

#import "ByteTransfrom.h"

@implementation ByteTransfrom

+ (Byte *)convertByte:(Byte *)soc length:(NSInteger)len
{
    if(len<1||soc == NULL)
    {
        return nil;
    }
    Byte *d = (Byte *)malloc(len);
    for (int i = 0; i < len; ++i) {
        d[i] = soc[len - i -1];
    }
    NSData *data = [NSData dataWithBytes:d length:len];
    free(d);
    return data.bytes;
}

+ (Byte *)shortIntToHighBytes:(short)num
{
    Byte *res = &num;
    return [self convertByte:res length:2];
}

+ (Byte *)intToHighBytes:(int)num
{
    Byte *res = &num;
    return [self convertByte:res length:4];
}

+ (Byte *)floatToHighBytes:(float)num
{
    Byte *res = &num;
    return [self convertByte:res length:4];
}

+ (Byte *)longToHighBytes:(long)num
{
    Byte *res = &num;
    return [self convertByte:res length:8];
}

+ (Byte *)doubleToHighBytes:(double)num
{
    Byte *res = &num;
    return [self convertByte:res length:8];
}

+ (short)oneBytesToShortInt:(Byte *)byte
{
    short number = (short) ((byte[0] & 0xff));
    return number;
}

+ (short)lowBytesToShortInt:(Byte *)byte
{
    short number = (short) (((byte[0] & 0xff)) | (byte[1] & 0xff) << 8);
    return number;
}

+ (short)highBytesToShortInt:(Byte *)byte
{
    
    short number = (short) (((byte[0] & 0xff)  << 8) | (byte[1] & 0xff));
    return number;
}

+ (int)lowBytesToInt:(Byte*)byte
{
    int value;
    value = (int) ((byte[0] & 0xFF)
                   | ((byte[1] & 0xFF)<<8)
                   | ((byte[2] & 0xFF)<<16)
                   | ((byte[3] & 0xFF)<<24));
    return value;
}

+ (int)highBytesToInt:(Byte *)byte
{
    int value;
    value = (int) (((byte[0] & 0xFF)<<24)
                   |((byte[1] & 0xFF)<<16)
                   |((byte[2] & 0xFF)<<8)
                   |(byte[3] & 0xFF));
    return value;
}

+ (float)lowBytesToFloat:(Byte *)byte
{
    float res = 0;
    int n = sizeof(float);
    char *bytes = (char *)byte;
    memcpy(&res, bytes, n);
    return res;
}

+ (float)highBytesToFloat:(Byte *)byte
{
    Byte *res = [self convertByte:byte length:4];
    return [self lowBytesToFloat:res];
}

+ (long)lowBytesToLong:(Byte *)byte
{
    long res = 0;
    int n = sizeof(long);
    char *bytes = (char *)byte;
    memcpy(&res, bytes, n);
    return res;
}

+ (long)highBytesToLong:(Byte *)byte
{
    long num = 0;
    for (int i = 0; i < 8; ++i) {
        num <<= 8;
        num |= (byte[i] & 0xff);
    }
    return num;
}


+ (double)lowBytesToDouble:(Byte *)byte
{
    double res = 0;
    int n = sizeof(double);
    char *bytes = (char *)byte;
    memcpy(&res, bytes, n);
    return res;
}

+ (double)highBytesToDouble:(Byte *)byte
{
    Byte *res = [self convertByte:byte length:8];
    return [self lowBytesToDouble:res];
}

+ (NSInteger)findData:(NSData *)find firstPositionInData:(NSData *)data
{
    char *findChar = (char *)[find bytes];
    char *dataChar = (char *)[data bytes];
    NSInteger i, j;
    for (i=0; i<data.length ; i++)
    {
        if(dataChar[i]!=findChar[0])
            continue;
        j = 0;
        while(j< find.length && i+j < data.length)
        {
            j++;
            if(findChar[j] - dataChar[i+j] != 0)
            {
                break;
            }
            
        }
        
        if(j == find.length)
        {
            return i;
        }
    }
    
    return -1;
}



+ (NSArray <NSNumber *> *)findData:(NSData *)find positionsInData:(NSData *)data
{
    NSMutableArray *positions = [[NSMutableArray alloc]init];
    char *findChar = (char *)[find bytes];
    char *dataChar = (char *)[data bytes];
    NSInteger i, j;
    for (i=0; i<data.length ; i++)
    {
        if(dataChar[i]!=findChar[0])
            continue;
        j = 0;
        while(j< find.length && i+j < data.length)
        {
            j++;
            if(findChar[j]!=dataChar[i+j])
            {
                break;
            }
            
        }
        
        if(j+1 == find.length)
        {
            [positions addObject:[NSNumber numberWithInteger:i]];
        }
    }
    if(positions.count < 1)
    {
        return nil;
    }
    return [NSArray arrayWithArray:positions];
}


+ (char *)substr:(NSData *)src start:(NSInteger)start length:(NSInteger)length
{
    NSData *rangeData = [self subdata:src start:start length:length];
    return (char *)[rangeData bytes];
}



+ (NSData *)subdata:(NSData *)data start:(NSInteger)start length:(NSInteger)length
{
    if(start < 0 || start > data.length || start + length >data.length)
    {
        return nil;
    }
    NSData *rangeData = [data subdataWithRange:NSMakeRange(start, length)];
    return rangeData;
}

@end
