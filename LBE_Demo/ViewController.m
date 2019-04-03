//
//  ViewController.m
//  LBE_Demo
//
//  Created by Seven on 2019/4/2.
//  Copyright © 2019年 LuoKeRen. All rights reserved.
//

#import "ViewController.h"
#import "LBE_Demo-Bridging-Header.h"
@interface ViewController ()
@property (nonatomic, strong) NSMutableArray *mArr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self readData];
}

- (void)readData {
    NSError *error;
    NSString *text = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"LBEData" ofType:@"txt"] encoding:NSUTF8StringEncoding error:&error];
    NSString *current = [text stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    [current enumerateLinesUsingBlock:^(NSString * _Nonnull line, BOOL * _Nonnull stop) {
        if ([line hasPrefix:@"AAAA"]) {
            @autoreleasepool {
                NSString *lbeString = [line substringWithRange:NSMakeRange(8, 300)];//前8位-2个16进制数对应设备信息不处理
                [lbeString enumerateSubstringsInRange:NSMakeRange(0, lbeString.length) options:NSStringEnumerationByWords usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
                    NSArray *currentArr = [self insertWhiteSpaceWithNum:substring];
                    NSLog(@"currentArr=%@",currentArr);
//                    [self.mArr addObjectsFromArray:currentArr];
                }];
                
            }
        }
    }];
    
    
}
- (NSMutableArray *)mArr {
    if (!_mArr) {
        _mArr = [NSMutableArray array];
    }
    return _mArr;
}

/**
 每隔四位16进制数->转成short类型

 @param string HexString
 @return short 数组
 */
-(NSArray *)insertWhiteSpaceWithNum:(NSString *)string{
    NSString *tempStr=string;
    NSInteger size =(tempStr.length / 4);
    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    for (int n = 0;n < size; n++){
        NSString *hexString = [tempStr substringWithRange:NSMakeRange(n*4, 4)];
        unsigned num = [self parseIntFromData:[self dataWithHexString:hexString]];
        short shortNum = ((short)num) / 3;
//        NSString *bianry = [self getBinaryByHex:hexString];
//        NSLog(@"hexString=%@",hexString);
//        NSLog(@"bianry=%@",bianry);
//        NSLog(@"num=%d",num);
//        NSLog(@"shortNum=%d",shortNum);
        [tempArr addObject:[NSString stringWithFormat:@"%d",shortNum]];
    }
    return tempArr;
}
/**
 2进制转int类型

 @param data 2进制
 @return int类型
 */
- (unsigned)parseIntFromData:(NSData *)data{
    NSString *dataDescription = [data description];
    NSString *dataAsString = [dataDescription substringWithRange:NSMakeRange(1, [dataDescription length]-2)];
    unsigned intData = 0;
    NSScanner *scanner = [NSScanner scannerWithString:dataAsString];
    [scanner scanHexInt:&intData];
    return intData;
}
/**
 16进制转NSData
 @param hexString 16进制
 @return NSData
 */
- (NSData *)dataWithHexString:(NSString *)hexString {
    const char *chars = [hexString UTF8String];
    int i = 0;
    NSUInteger len = hexString.length;
    
    NSMutableData *data = [NSMutableData dataWithCapacity:len / 2];
    char byteChars[3] = {'\0','\0','\0'};
    unsigned long wholeByte;
    
    while (i < len) {
        byteChars[0] = chars[i++];
        byteChars[1] = chars[i++];
        wholeByte = strtoul(byteChars, NULL, 16);
        [data appendBytes:&wholeByte length:1];
    }
    
    return data;
}
/**
 十六进制转换为二进制
 @param hex 16进制数
 @return 2进制数
 */
- (NSString *)getBinaryByHex:(NSString *)hex {
    
    NSMutableDictionary *hexDic = [[NSMutableDictionary alloc] initWithCapacity:16];
    [hexDic setObject:@"0000" forKey:@"0"];
    [hexDic setObject:@"0001" forKey:@"1"];
    [hexDic setObject:@"0010" forKey:@"2"];
    [hexDic setObject:@"0011" forKey:@"3"];
    [hexDic setObject:@"0100" forKey:@"4"];
    [hexDic setObject:@"0101" forKey:@"5"];
    [hexDic setObject:@"0110" forKey:@"6"];
    [hexDic setObject:@"0111" forKey:@"7"];
    [hexDic setObject:@"1000" forKey:@"8"];
    [hexDic setObject:@"1001" forKey:@"9"];
    [hexDic setObject:@"1010" forKey:@"A"];
    [hexDic setObject:@"1011" forKey:@"B"];
    [hexDic setObject:@"1100" forKey:@"C"];
    [hexDic setObject:@"1101" forKey:@"D"];
    [hexDic setObject:@"1110" forKey:@"E"];
    [hexDic setObject:@"1111" forKey:@"F"];
    
    NSString *binary = @"";
    for (int i=0; i<[hex length]; i++) {
        
        NSString *key = [hex substringWithRange:NSMakeRange(i, 1)];
        NSString *value = [hexDic objectForKey:key.uppercaseString];
        if (value) {
            
            binary = [binary stringByAppendingString:value];
        }
    }
    return binary;
}
/**
 二进制转换为十进制
 
 @param binary 二进制数
 @return 十进制数
 */
- (NSInteger)getDecimalByBinary:(NSString *)binary {
    
    NSInteger decimal = 0;
    for (int i=0; i<binary.length; i++) {
        
        NSString *number = [binary substringWithRange:NSMakeRange(binary.length - i - 1, 1)];
        if ([number isEqualToString:@"1"]) {
            
            decimal += pow(2, i);
        }
    }
    return decimal;
}

////将任意长度有符号16进制NSData类型转NSNumber（整形）
//-(NSNumber *)signedHexTurnString:(NSData *)data
//{
//        NSLog(@"%@", data);
//        if (!data)
//            {
//                    return nil;
//                }
//        //获取data的长度
//        NSInteger lenth = [data length];
//        //获取16进制最大值
//        NSString *maxHexString = [self headString:@"F" trilString:@"F" strLenth:lenth];
//        //获取16进制分界点
//        NSString *centerHexString = [self headString:@"8" trilString:@"0" strLenth:lenth];
//        //获取data字符串
//        NSString *string = [self convertDataToHexString:data];
//
//        if ([[self numberHexString:string] longLongValue] - [[self numberHexString:centerHexString] longLongValue] < 0) {
//                return [self numberHexString:string];
//            }
//        return [NSNumber numberWithLongLong:[[self numberHexString:string] longLongValue] - [[self numberHexString:maxHexString] longLongValue]];
//}

@end
