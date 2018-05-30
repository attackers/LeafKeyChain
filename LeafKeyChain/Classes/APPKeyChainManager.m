//
//  APPKeyChainManager.m
//  ProjectSub
//
//  Created by OS X10_12_6 on 2018/5/29.
//  Copyright © 2018年 OS X10_12_6. All rights reserved.
//

#import "APPKeyChainManager.h"
#define keyChainService @"ProjectSub1"

@implementation APPKeyChainManager
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

/**
 添加账号,如果账号不存在，直接返回NO
 
 @param account 要添加的账号
 @param password 要添加的账号密码
 @return 返回是否添加成功
 */
+ (BOOL)addAccount:(NSString*)account pwd:(NSString*)password {
    
    BOOL ok = [APPKeyChainManager isAccountForService:account];
    
    if (!ok) {
        return NO;
    }
    
    NSMutableDictionary *query = [NSMutableDictionary dictionaryWithDictionary:[APPKeyChainManager dictionaryFormat]];
    
    
    NSData *pwd = [password dataUsingEncoding:NSUTF8StringEncoding];
    [query setObject:pwd forKey:(__bridge id)kSecValueData];
    
    [query setObject:account forKey:(__bridge id)kSecAttrAccount];
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)query, NULL);
    if (status == noErr) {
        return YES;
    }
    return NO;
}

/**
 更新用户密码
 
 @param account 账号
 @param pwd 要修改的密码
 @return 返回是否修改成功
 */
+ (BOOL)updataAccount:(NSString*)account password:(NSString*)pwd {
    
    NSMutableDictionary *query = [NSMutableDictionary dictionary];
    [query setObject:account forKey:(__bridge id)kSecAttrAccount];
    [query setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    [query setObject:keyChainService forKey:(__bridge id)kSecAttrService];
    
    NSMutableDictionary *update = [NSMutableDictionary dictionary];
    [update setObject:[pwd dataUsingEncoding:NSUTF8StringEncoding] forKey:(__bridge id)kSecValueData];
    
    OSStatus status = SecItemUpdate((__bridge CFDictionaryRef)query, (__bridge CFDictionaryRef)update);
    if (status == noErr) {
        return YES;
    }
    return NO;
}

/**
 判断这个用户是否存在
 
 @param account 传入要判断的用户名
 @return 如果查询到，则返回YES，默认返回NO
 */
+ (BOOL)isAccountForService:(NSString*)account {
    
    NSMutableDictionary *query = [NSMutableDictionary dictionaryWithDictionary:[APPKeyChainManager dictionaryFormat]];
    
    [query setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    [query setObject:account forKey:(__bridge id)kSecAttrAccount];
    CFTypeRef result;
    OSStatus status = SecItemCopyMatching((CFDictionaryRef)query, &result);
    if (status == noErr) {
        return YES;
    }
    return NO;
}


/**
 删除用户
 
 @param account 删除的对象账号
 @return 删除成功返回YES，默认返回NO
 */
+ (BOOL)deleteAccount:(NSString*)account {
    NSMutableDictionary *query = [NSMutableDictionary dictionary];
    [query setObject:keyChainService forKey:(__bridge id)kSecAttrService];
    [query setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    [query setObject:account forKey:(__bridge id)kSecAttrAccount];
    OSStatus status = SecItemDelete((CFDictionaryRef)query);
    if (status == noErr) {
        [self isAccountForService:account];
        
        return YES;
    }
    return NO;
}

/**
 查找当前service下的所有数据

 @return 返回查询结果
 */
+ (NSArray*)allAccount {
    NSMutableDictionary *query = [NSMutableDictionary dictionaryWithDictionary:[APPKeyChainManager dictionaryFormat]];
    [query setObject:(__bridge id)kSecMatchLimitAll forKey:(__bridge id)kSecMatchLimit];
    CFTypeRef reslut = NULL;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, &reslut);
    if (status == noErr) {
        return  (__bridge NSArray*)reslut;
    }
    return nil;
}

/**
 查找当前service下的指定用户信息
 
 @return 返回查询结果
 */
+ (NSDictionary*)accountForService:(NSString*)account {
    NSMutableDictionary *query = [NSMutableDictionary dictionaryWithDictionary:[APPKeyChainManager dictionaryFormat]];
    [query setObject:account forKey:(__bridge id)kSecAttrAccount];
    [query setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    CFTypeRef reslut = NULL;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, &reslut);
    if (status == noErr) {
        
        return (__bridge NSDictionary*)reslut;
    }
    return nil;
}


/**
用于保存设备UUID

@param identity 用于做数据存储的识别
@param UUID 存储UUID
@return 返回是否添加成功
*/
+ (BOOL)addIdentity:(NSString*)identity pwd:(NSString*)UUID {
    return  [APPKeyChainManager addAccount:identity pwd:UUID];
}

/**
 查找当前service下的指定identity信息
 
 @return 返回查询结果
 */
+ (NSDictionary*)identityForService:(NSString*)identity {
    return  [APPKeyChainManager accountForService:identity];
}


/**
 增加、查找通用字典参数
 
 @return 返回通用字典
 */
+ (NSMutableDictionary*)dictionaryFormat{
    
    NSMutableDictionary *query = [NSMutableDictionary dictionary];
    
    /**
     只有在不锁屏且应用处于活动中才有效
     */
    [query setObject:(__bridge id)kSecAttrAccessibleWhenUnlocked forKey:(__bridge id)kSecAttrAccessible];
    
    /**
     使用通用的密码方案存储
     */
    [query setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    
    /**
     设置服务名，这个通常为唯一的一个
     */
    [query setObject:keyChainService forKey:(__bridge id)kSecAttrService];
    
    /**
     设置返回的数值类型，为Data类型
     */
    [query setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    
    /**
     返回条目的引用，根据条目所属类别，返回值类型可能是：SecKeychainItemRef, SecKeyRef,SecCertificateRef, SecIdentityRef.
     */
    [query setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnRef];
    return query;
}


@end
