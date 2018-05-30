//
//  APPKeyChainManager.h
//  ProjectSub
//
//  Created by OS X10_12_6 on 2018/5/29.
//  Copyright © 2018年 OS X10_12_6. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APPKeyChainManager : NSObject
/**
 增加、查找通用字典参数
 
 @return 返回通用字典
 */
+ (NSMutableDictionary*)dictionaryFormat;

/**
 删除用户
 
 @param account 删除的对象账号
 @return 删除成功返回YES，默认返回NO
 */
+ (BOOL)deleteAccount:(NSString*)account;

/**
 判断这个用户是否存在
 
 @param account 传入要判断的用户名
 @return 如果查询到，则返回YES，默认返回NO
 */
+ (BOOL)isAccountForService:(NSString*)account;

/**
 更新用户密码
 
 @param account 账号
 @param pwd 要修改的密码
 @return 返回是否修改成功
 */
+ (BOOL)updataAccount:(NSString*)account password:(NSString*)pwd;

/**
 添加账号,如果账号不存在，直接返回NO
 
 @param account 要添加的账号
 @param password 要添加的账号密码
 @return 返回是否添加成功
 */
+ (BOOL)addAccount:(NSString*)account pwd:(NSString*)password;

/**
 查找当前service下的所有数据
 
 @return 返回查询结果
 */
+ (NSArray*)allAccount;

/**
 查找当前service下的指定用户信息
 
 @return 返回查询结果
 */
+ (NSDictionary*)accountForService:(NSString*)account;

@end
