//
//  ContactViewController.m
//  TakeCommandPlatform
//
//  Created by jyd on 2018/3/22.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import "ContactViewController.h"
#import "UserLevelModel.h"
#import "ContactModel.h"
#import "ChineseString.h"
@interface ContactViewController ()
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *contactTableView;

/** dataArray */
@property (nonatomic, strong) NSMutableArray *dataArray;


/** chineseArray */
@property (nonatomic, strong) NSMutableArray *chineseArr;


/** sectionIndexTitlesArr */
@property (nonatomic, strong) NSArray *sectionIndexTitlesArr;

/** sectionArr */
@property (nonatomic, strong) NSArray *sectionArr;



@end

@implementation ContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Initial Methods

/** 视图初始化 */
- (void)setupUI
{
    
    
}

/** 加载数据 */
- (void)loadData
{
    [MBProgressHUD showMessage:@"正在获取..."];
    NSString *url = [NSString stringWithFormat:@"%@%@",kServiceAdress,REQUEST_URL_FINDUSERINFO];
    [NetworkManager POST:url parameters:@{@"id" : kUserId} success:^(id responseObject) {
        UserLevelModel *model = [UserLevelModel yy_modelWithJSON:responseObject];
        [self getContactModelWithUserLevelModel:model];
        [self getChineseData];
        [MBProgressHUD hideHUD];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
    }];
    
}
#pragma mark - Setter & Getter

#pragma mark - Target Mehtods

#pragma mark - Notification Method

#pragma mark - Private Method

/** 获取联系人数据 */
- (void)getContactModelWithUserLevelModel:(UserLevelModel *)model
{
    _dataArray = [NSMutableArray array];
    for (AccountInfo *account in model.parentInfo.accounts) {
        ContactModel *contact = [[ContactModel alloc] init];
        contact.userId = account.userid;
        contact.userName = model.parentInfo.orgname;
        contact.acccount = account.account;
        [_dataArray addObject:contact];
    }
    for (AccountInfo *account in model.info.accounts) {
        ContactModel *contact = [[ContactModel alloc] init];
        contact.userId = account.userid;
        contact.userName = model.info.orgname;
        contact.acccount = account.account;
        [_dataArray addObject:contact];
    }
    for (PatrolInfo *account in model.patrolAccount) {
        ContactModel *contact = [[ContactModel alloc] init];
        contact.userId = account.userid;
        contact.userName = account.username;
        contact.acccount = account.account;
        [_dataArray addObject:contact];
    }
    
    [self getContactWithSubInfo:model];
    

}

/** 获取下级用户 */
- (void)getContactWithSubInfo:(UserLevelModel *)model
{
    switch (model.info.lev) {
        case UserLevelCountry:
        {
            for (ProvinceSite *site in model.subInfos) {
                UserLevelModel *level = [[UserLevelModel alloc] init];
                level.info = site.info;
                level.subInfos = site.citySites;
                
                [self getContactWithInfo:level];
                [self getContactWithSubInfo:level];
            }
        }
            break;
            
        default:
            break;
    }
    
    if (model.schoolSite) {
        ContactModel *contact = [[ContactModel alloc] init];
        contact.userId = model.schoolSite.userid;
        contact.userName = model.schoolSite.sitename;
        contact.acccount = model.schoolSite.account;
        [_dataArray addObject:contact];
    } else {
        switch (model.info.lev) {
            case UserLevelCountry:
            {
                for (ProvinceSite *site in model.subInfos) {
                    UserLevelModel *level = [[UserLevelModel alloc] init];
                    level.info = site.info;
                    level.subInfos = site.citySites;
                    [self getContactWithInfo:level];
                    [self getContactWithSubInfo:level];
                }
            }
                break;
            case UserLevelProvince:
            {
               
                for (CitySite *site in model.subInfos) {
                    UserLevelModel *level = [[UserLevelModel alloc] init];
                    level.info = site.info;
                    level.subInfos = site.countrySites;
                    [self getContactWithInfo:level];
                    [self getContactWithSubInfo:level];
                }
            }
                break;
            case UserLevelCity:
            {
               
                for (CountySite *site in model.subInfos) {
                    UserLevelModel *level = [[UserLevelModel alloc] init];
                    level.info = site.info;
                    level.subInfos = site.schoolSites;
                    [self getContactWithInfo:level];
                    [self getContactWithSubInfo:level];
                }
            }
                break;
            case UserLevelCounty:
            {
                
                for (SchoolSite *site in model.subInfos) {
                    UserLevelModel *level = [[UserLevelModel alloc] init];
                    level.schoolSite = site;
                    [self getContactWithInfo:level];
                    [self getContactWithSubInfo:level];
                }
            }
                break;
                
            default:
                break;
        }
    }
}

/** 把下级用户变为本级用户 */
- (void)getContactWithInfo:(UserLevelModel *)model
{
    for (AccountInfo *account in model.info.accounts) {
        ContactModel *contact = [[ContactModel alloc] init];
        contact.userId = account.userid;
        contact.userName = model.info.orgname;
        contact.acccount = account.account;
        [_dataArray addObject:contact];
    }
}

/** 获取拼音 */
- (void)getChineseData
{
    _chineseArr = [NSMutableArray array];
    for (ContactModel *contact in _dataArray) {
        ChineseString * chinese = [[ChineseString alloc] init];
        chinese.idStr = contact.userId;
        chinese.hanzi = [NSString stringWithFormat:@"%@(%@)",contact.userName, contact.acccount];
        chinese.pinyinAllLetter = [NSString stringWithFormat:@"%@(%@)",contact.userName, contact.acccount];
        chinese.pinYin = [chinese.hanzi firstLettersForSort:YES];
        chinese.pinyinAllLetter = [chinese.hanzi pinyinForSort:YES];
        [_chineseArr addObject:chinese];
    }
    
    _sectionIndexTitlesArr = [ChineseString IndexArray:_chineseArr];
    _sectionArr     = [ChineseString LetterSortArray:_chineseArr];
     [_contactTableView reloadData];
}

/** 搜索用户 */
- (void)searchUser:(NSString *)text
{
    NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
    NSMutableArray *resultArr = [NSMutableArray array];
    
    for (ChineseString *item in _chineseArr) {
        
        NSRange hanziRange = [item.hanzi rangeOfString:text options:searchOptions range:NSMakeRange(0, item.hanzi.length)];
        
        NSRange pinyinRange = [item.pinYin rangeOfString:text options:searchOptions range:NSMakeRange(0, item.pinYin.length)];
        
        if (hanziRange.length || pinyinRange.length) {
            [resultArr addObject:item];
        }
        
    }

    _sectionIndexTitlesArr = [ChineseString IndexArray:resultArr];
    _sectionArr     = [ChineseString LetterSortArray:resultArr];
    [_contactTableView reloadData];
}


#pragma mark - Public Method

#pragma mark - UITableView Delegate & Datasource

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.sectionIndexTitlesArr;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.sectionIndexTitlesArr[section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionIndexTitlesArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.sectionArr[section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text =  ((ChineseString *)self.sectionArr[indexPath.section][indexPath.row]).hanzi;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}


#pragma mark — UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    
}


- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length) {
        [self searchUser:searchText];
    } else {
        [self getChineseData];
    }
}
#pragma mark - Other Delegate

@end
