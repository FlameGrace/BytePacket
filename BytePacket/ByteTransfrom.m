//
//  ByteHandle.m
//  p2p
//
//  Created by Flame Grace on 16/11/4.
//  Copyright © 2016年 hello. All rights reserved.
//

#import "ByteTransfrom.h"

@implementation ByteTransfrom

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

+(int)highBytesToInt:(Byte*)byte
{
    int number = 0;
    NSData * testData =[NSData dataWithBytes:byte length:4];
    for (int i = 0; i < [testData length]; i++)
    {
        if (byte[i] >= 0)
        {
            number = number + byte[i];
        } else
        {
            number = number +256 + byte[i];
        }
        number = number * 256;
        if (byte[3] >= 0)
        {
            number = number + byte[3];
        } else
        {
            number = number + 256 + byte[3];
        }
        
    }
    return number;
}

+ (int)lowBytesToInt:(Byte *)byte
{
    int number = 0;
    NSData * testData =[NSData dataWithBytes:byte length:4];
    for (int i = 0; i < [testData length]; i++)
    {
        if (byte[[testData length]-i] >= 0)
        {
            number = number + byte[[testData length]-i];
        } else
        {
            number = number + 256 + byte[[testData length]-i];
        }
        number = number * 256;
    }
    if (byte[0] >= 0)
    {
        number = number + byte[0];
    } else {
        number = number + 256 + byte[0];
    }
    return number;
}

+ (long)lowBytesToLong:(Byte *)byte
{
    long s = 0;
    long s0 = byte[0] & 0xff;// 最低位
    long s1 = byte[1] & 0xff;
    long s2 = byte[2] & 0xff;
    long s3 = byte[3] & 0xff;
    long s4 = byte[4] & 0xff;// 最低位
    long s5 = byte[5] & 0xff;
    long s6 = byte[6] & 0xff;
    long s7 = byte[7] & 0xff; // s0不变
    s1 <<= 8;
    s2 <<= 16;
    s3 <<= 24;
    s4 <<= 8 * 4;
    s5 <<= 8 * 5;
    s6 <<= 8 * 6;
    s7 <<= 8 * 7;
    s = s0 | s1 | s2 | s3 | s4 | s5 | s6 | s7;
    return s;
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


+ (char *)substr:(char *)src start:(NSInteger)start length:(NSInteger)length
{
    
    char* pch=src;
    //定义一个字符指针，指向传递进来的ch地址。
    char* subch=(char*)calloc(sizeof(char),length+1);
    //通过calloc来分配一个length长度的字符数组，返回的是字符指针。
    int i;
    //只有在C99下for循环中才可以声明变量，这里写在外面，提高兼容性。
    pch=pch+start;
    //是pch指针指向pos位置。
    for(i=0;i<length;i++)
    {
        subch[i]=*(pch++);
        //循环遍历赋值数组。
    }
    subch[length]='\0';//加上字符串结束符。
    return subch;       //返回分配的字符数组地址。
    
    
//    
//    
//    NSData *rangeData = [data subdataWithRange:NSMakeRange(start, length)];
//    return (Byte *)[rangeData bytes];
}



+ (Byte *)subdata:(NSData *)data start:(NSInteger)start length:(NSInteger)length
{
    if(start < 0 || start > data.length || start + length >data.length)
    {
        return nil;
    }
    NSData *rangeData = [data subdataWithRange:NSMakeRange(start, length)];
    return (Byte *)[rangeData bytes];
}

@end
