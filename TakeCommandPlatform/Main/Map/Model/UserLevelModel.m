//
//  UserLevelModel.m
//  TakeCommandPlatform
//
//  Created by jyd on 2018/3/28.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import "UserLevelModel.h"

@implementation UserLevelModel

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper
{
    switch (kUserLevel) {
        case UserLevelCountry:
            return @{@"subInfos" : @"provinceSites"};
            break;
        case UserLevelProvince:
            return @{@"subInfos" : @"citySites"};
            break;
        case UserLevelCity:
            return @{@"subInfos" : @"countrySites"};
            break;
        case UserLevelCounty:
            return @{@"subInfos" : @"schoolSites"};
            break;
        default:
            break;
    }
    
    return @{@"" : @""};
}

- (NSArray *)patrolAccount
{
    NSArray *arr = [NSArray yy_modelArrayWithClass:[PatrolInfo class] json:_patrolAccount];
    return arr;
}



- (NSArray *)subInfos
{
    NSArray *arr;
    switch (_info.lev) {
        case UserLevelCountry:
            arr = [NSArray yy_modelArrayWithClass:[ProvinceSite class] json:_subInfos];
            break;
        case UserLevelProvince:
            arr = [NSArray yy_modelArrayWithClass:[CitySite class] json:_subInfos];
            break;
        case UserLevelCity:
            if ([_subInfos yy_modelSetWithJSON:[CountySite class]]) {
                
            }
            arr = [NSArray yy_modelArrayWithClass:[CountySite class] json:_subInfos];
            break;
        case UserLevelCounty:
            if (kUserLevel == UserLevelCounty) {
                NSMutableArray *temArray = [[NSMutableArray alloc] init];
                for (NSDictionary *dic in _subInfos) {
                    if (dic[@"schoolSite"]) {
                        [temArray addObject:dic[@"schoolSite"]];
                    } else {
                        [temArray addObjectsFromArray:_subInfos];
                        break;
                    }
                    
                }
                arr = [NSArray yy_modelArrayWithClass:[SchoolSite class] json:temArray];
            } else {
                arr = _subInfos;
            }
           
            break;

        default:
            break;
    }
    return arr;
}



@end


@implementation UserInfo

@end

@implementation ParentInfo

@end

@implementation BaseInfo

- (NSArray *)accounts
{
    NSArray *arr = [NSArray yy_modelArrayWithClass:[AccountInfo class] json:_accounts];
    return arr;
}

@end

@implementation AccountInfo

@end

@implementation PatrolInfo

@end

@implementation SchoolSite

@end

@implementation ProvinceSite





@end

@implementation CitySite

@end

@implementation CountySite

- (NSArray *)schoolSites
{
    NSMutableArray *temArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in _schoolSites) {
        if (dic[@"schoolSite"]) {
            [temArray addObject:dic[@"schoolSite"]];
        } else {
            [temArray addObjectsFromArray:_schoolSites];
            break;
        }
        
    }
    NSArray *arr = [NSArray yy_modelArrayWithClass:[SchoolSite class] json:temArray];
    return arr;
}



@end



