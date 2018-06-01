//
//  UserModel.m
//  TakeCommandPlatform
//
//  Created by jyd on 2017/12/12.
//  Copyright © 2017年 jyd. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper
{
    return @{@"userId" : @"id"};
}

- (LoginState)loginState
{
    switch (_state) {
        case LoginStateFail:
            _loginState = LoginStateFail;
            break;
        case LoginStateSuccess:
            _loginState = LoginStateSuccess;
            break;
            
        default:
            break;
    }
    return _loginState;
}

- (UserLevel)userLevel
{
    switch (_userlev) {
        case UserLevelCountry:
            _userLevel = UserLevelCountry;
            break;
        case UserLevelProvince:
            _userLevel = UserLevelProvince;
            break;
        case UserLevelCity:
            _userLevel = UserLevelCity;
            break;
        case UserLevelCounty:
            _userLevel = UserLevelCounty;
            break;
        case UserLevelExamSite:
            _userLevel = UserLevelExamSite;
            break;
        case UserLevelExaminer:
            _userLevel = UserLevelExaminer;
            break;
            
        default:
            break;
    }
    return _userLevel;
}

@end
