//
//  OfflineViewController.m
//  TakeCommandPlatform
//
//  Created by jyd on 2017/12/13.
//  Copyright © 2017年 jyd. All rights reserved.
//

#import "OfflineViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
//#import "ChineseString.h"
#import "ZYPinYinSearch.h"
#import "OfflineMapViewController.h"
@interface OfflineViewController () <BMKMapViewDelegate, BMKOfflineMapDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

/** map */
@property (weak, nonatomic) IBOutlet BMKMapView *mapView;


/** offlineMap */
@property (nonatomic, strong) BMKOfflineMap *offlineMap;

/** 热门城市 */
@property (nonatomic, strong) NSArray *arrayHotCityData;

/** 全国支持离线地图的城市 */
@property (nonatomic, strong) NSArray *arrayOfflineCityData;

/** 本地下载的离线地图 */
@property (nonatomic, strong) NSMutableArray *arrayLocalDownloadMapInfo;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet UITableView *cityTableView;
@property (weak, nonatomic) IBOutlet UITableView *downloadTableView;

/** 中国城市 */
@property (nonatomic, strong) NSArray *chinaCityArray;



/** 临时 */
@property (nonatomic, strong) NSMutableArray *tempCityArray;

@end

@implementation OfflineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"离线地图";
    //初始化离线地图服务
   
    _offlineMap = [[BMKOfflineMap alloc]init];
    //获取热门城市
    _arrayHotCityData = [_offlineMap getHotCityList];
    //获取支持离线下载城市列表
    _arrayOfflineCityData = [_offlineMap getOfflineCityList];
    _tempCityArray = [[NSMutableArray alloc] init];
    for (BMKOLSearchRecord *item in _arrayOfflineCityData) {
        if ([item.cityName containsString:@"市"] || [item.cityName containsString:@"省"] || [item.cityName containsString:@"区"] || [item.cityName containsString:@"市"]) {
            [_tempCityArray addObject:item];
        }
    }
    _chinaCityArray = [NSArray arrayWithArray:_tempCityArray];
    
    //获取各城市离线地图更新信息
    _arrayLocalDownloadMapInfo = [NSMutableArray arrayWithArray:[_offlineMap getAllUpdateInfo]];
    //初始化Segment
    [self setupSegmentedControl];
    _mapView.delegate = self;
    _offlineMap.delegate = self;
    

}




- (void)setupSegmentedControl
{
    NSArray *arr = @[@"城市列表", @"已下载"];
    HMSegmentedControl *segmentedControl1 = [[HMSegmentedControl alloc] initWithSectionTitles: arr];
    segmentedControl1.backgroundColor = RGB(235, 236, 237);
    segmentedControl1.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
    segmentedControl1.segmentEdgeInset = UIEdgeInsetsMake(0, 10, 0, 10);
    segmentedControl1.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    segmentedControl1.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    segmentedControl1.selectionIndicatorColor = RGB(0, 101, 162);
    segmentedControl1.selectionIndicatorHeight = 2.0f;
    segmentedControl1.titleTextAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:14.0f],NSForegroundColorAttributeName : [UIColor blackColor]};
//    segmentedControl1.selectedTitleTextAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:14.0f],NSForegroundColorAttributeName : RGB(0, 184, 43) };
    segmentedControl1.verticalDividerWidth = 1.0f;
    [segmentedControl1 addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentedControl1];
    [self segmentedControlChangedValue:segmentedControl1];
}

- (void)segmentedControlChangedValue:(HMSegmentedControl *)sender
{
    switch (sender.selectedSegmentIndex) {
        case 0:
        {
            _cityTableView.hidden = NO;
            _downloadTableView.hidden = YES;
            _searchBar.hidden = NO;
            [_cityTableView reloadData];
        }
            break;
        case 1:
        {
            _searchBar.hidden = YES;
            _cityTableView.hidden = YES;
            _downloadTableView.hidden = NO;
           
            [_downloadTableView reloadData];
        }
            break;
            
        default:
            break;
    }

}



////城市输入框处理
//- (IBAction)textFiledReturnEditing:(UITextField *)sender {
//    [sender resignFirstResponder];
//}
////开始下载离线包
//- (IBAction)startDownload:(UIButton *)sender {
//    [_offlineMap start:[_cityId.text floatValue]];
//}
////停止下载离心包
//- (IBAction)stopDownload:(UIButton *)sender {
//    [_offlineMap pause:[_cityId.text floatValue]];
//}
////删除本地离线包
//- (IBAction)remove:(UIButton *)sender {
//    [_offlineMap remove:[_cityId.text floatValue]];
//}
////根据城市名检索城市id
//- (IBAction)search:(UIButton *)sender {
//    [_cityName resignFirstResponder];
//    //根据城市名获取城市信息，得到cityID
//    NSArray* city = [_offlineMap searchCity:_cityName.text];
//    if (city.count > 0) {
//        BMKOLSearchRecord* oneCity = [city objectAtIndex:0];
//        _cityId.text =  [NSString stringWithFormat:@"%d", oneCity.cityID];
//    }
//}



//离线地图delegate，用于获取通知
- (void)onGetOfflineMapState:(int)type withState:(int)state
{
    
    if (type == TYPE_OFFLINE_UPDATE) {
        //id为state的城市正在下载或更新，start后会毁掉此类型
        BMKOLUpdateElement* updateInfo;
        updateInfo = [_offlineMap getUpdateInfo:state];
        NSLog(@"城市名：%@,下载比例:%d",updateInfo.cityName,updateInfo.ratio);
        [_cityTableView reloadData];
    }
    if (type == TYPE_OFFLINE_NEWVER) {
        //id为state的state城市有新版本,可调用update接口进行更新
        BMKOLUpdateElement* updateInfo;
        updateInfo = [_offlineMap getUpdateInfo:state];
        NSLog(@"是否有更新%d",updateInfo.update);
    }
    if (type == TYPE_OFFLINE_UNZIP) {
        //正在解压第state个离线包，导入时会回调此类型
    }
    if (type == TYPE_OFFLINE_ZIPCNT) {
        //检测到state个离线包，开始导入时会回调此类型
        NSLog(@"检测到%d个离线包",state);
        if(state==0)
        {
            [self showImportMesg:state];
        }
    }
    if (type == TYPE_OFFLINE_ERRZIP) {
        //有state个错误包，导入完成后会回调此类型
        NSLog(@"有%d个离线包导入错误",state);
    }
    if (type == TYPE_OFFLINE_UNZIPFINISH) {
        NSLog(@"成功导入%d个离线包",state);
        //导入成功state个离线包，导入成功后会回调此类型
        [self showImportMesg:state];
    }
    
}
//导入提示框
- (void)showImportMesg:(int)count
{
    NSString* showmeg = [NSString stringWithFormat:@"成功导入离线地图包个数:%d", count];
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"导入离线地图" message:showmeg delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
    [myAlertView show];
}

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    //不区分大小写 | 忽略 "-" 符号的比较
    if (searchText.length == 0) {
        _chinaCityArray = _tempCityArray;
        [_cityTableView reloadData];
        return;
    }
   
    [ZYPinYinSearch searchByPropertyName:@"cityName" withOriginalArray:_tempCityArray searchText:searchBar.text success:^(NSArray *results) {
        _chinaCityArray = results;
        [_cityTableView reloadData];
    } failure:^(NSString *errorMessage) {
        
    }];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_searchBar resignFirstResponder];
}

#pragma mark UITableView delegate


//定义每个section中有几行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView == _cityTableView)
    {
        return [_chinaCityArray count];
    }
    else
    {
        return [_arrayLocalDownloadMapInfo count];
    }
    
    
}
//定义cell样式填充数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"OfflineMapCityCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        
    }
    if(tableView == _cityTableView)
    {
        BMKOLSearchRecord* item = [_chinaCityArray objectAtIndex:indexPath.row];
        //转换包大小
        NSString *packSize = [self getDataSizeString:item.size];
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@(%@)", item.cityName, packSize];
        
        UILabel *sizelabel =[[UILabel alloc] initWithFrame:CGRectMake(250, 0, 60, 40)];
        sizelabel.autoresizingMask =UIViewAutoresizingFlexibleLeftMargin;
        sizelabel.text = @"下载";
        sizelabel.backgroundColor = [UIColor clearColor];
        cell.detailTextLabel.text = @"下载";
        for (BMKOLUpdateElement *download in _arrayLocalDownloadMapInfo) {
            if (download.cityID == item.cityID) {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"已下载:%d", download.ratio];
            }
        }
        
    }
    else
    {
        if(_arrayLocalDownloadMapInfo!=nil&&_arrayLocalDownloadMapInfo.count>indexPath.row)
        {
            BMKOLUpdateElement* item = [_arrayLocalDownloadMapInfo objectAtIndex:indexPath.row];
            //是否可更新
            if(item.update)
            {
                cell.textLabel.text = [NSString stringWithFormat:@"%@————%d(可更新)", item.cityName,item.ratio];
            }
            else
            {
                cell.textLabel.text = [NSString stringWithFormat:@"%@————%d", item.cityName,item.ratio];
            }
        }
        else
        {
            cell.textLabel.text = @"";
        }
        
    }
    
    return cell;
}

//是否允许table进行编辑操作
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(tableView== _cityTableView)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

//提交编辑列表的结果
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //删除poi
        if (tableView == _downloadTableView) {
            BMKOLUpdateElement* item = [_arrayLocalDownloadMapInfo objectAtIndex:indexPath.row];
            //删除指定城市id的离线地图
            [_offlineMap remove:item.cityID];
            //将此城市的离线地图信息从数组中删除
            [(NSMutableArray*)_arrayLocalDownloadMapInfo removeObjectAtIndex:indexPath.row];
            [_downloadTableView reloadData];
            
        }
        
    }
    
}
//表的行选择操作
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if(tableView == _downloadTableView)
    {
        
        BMKOLUpdateElement* item = [_arrayLocalDownloadMapInfo objectAtIndex:indexPath.row];
        //跳转到地图查看页面进行地图更新
        if(item.ratio==100)
        {
            //跳转到地图浏览页面
            OfflineMapViewController *offlineMapViewCtrl = [[OfflineMapViewController alloc] init];
            offlineMapViewCtrl.title = @"查看离线地图";
            offlineMapViewCtrl.cityId = item.cityID;
            offlineMapViewCtrl.offlineServiceOfMapview = _offlineMap;
            [self.navigationController pushViewController:offlineMapViewCtrl animated:YES];
            
        }
        else if(item.ratio<100)//弹出提示框
        {
//            _cityId.text = [NSString stringWithFormat:@"%d", item.cityID];
//            _cityName.text = item.cityName;
//            _downloadRatio.text = [NSString stringWithFormat:@"已下载:%d", item.ratio];
            UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该离线地图未完全下载，请继续下载！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
            [myAlertView show];
        }
        
    }
    else
    {
    
        BMKOLSearchRecord* item = [_chinaCityArray objectAtIndex:indexPath.row];
        [_offlineMap start: item.cityID];
        
        
    }
    
}

#pragma mark 包大小转换工具类（将包大小转换成合适单位）
-(NSString *)getDataSizeString:(int) nSize
{
    NSString *string = nil;
    if (nSize<1024)
    {
        string = [NSString stringWithFormat:@"%dB", nSize];
    }
    else if (nSize<1048576)
    {
        string = [NSString stringWithFormat:@"%dK", (nSize/1024)];
    }
    else if (nSize<1073741824)
    {
        if ((nSize%1048576)== 0 )
        {
            string = [NSString stringWithFormat:@"%dM", nSize/1048576];
        }
        else
        {
            int decimal = 0; //小数
            NSString* decimalStr = nil;
            decimal = (nSize%1048576);
            decimal /= 1024;
            
            if (decimal < 10)
            {
                decimalStr = [NSString stringWithFormat:@"%d", 0];
            }
            else if (decimal >= 10 && decimal < 100)
            {
                int i = decimal / 10;
                if (i >= 5)
                {
                    decimalStr = [NSString stringWithFormat:@"%d", 1];
                }
                else
                {
                    decimalStr = [NSString stringWithFormat:@"%d", 0];
                }
                
            }
            else if (decimal >= 100 && decimal < 1024)
            {
                int i = decimal / 100;
                if (i >= 5)
                {
                    decimal = i + 1;
                    
                    if (decimal >= 10)
                    {
                        decimal = 9;
                    }
                    
                    decimalStr = [NSString stringWithFormat:@"%d", decimal];
                }
                else
                {
                    decimalStr = [NSString stringWithFormat:@"%d", i];
                }
            }
            
            if (decimalStr == nil || [decimalStr isEqualToString:@""])
            {
                string = [NSString stringWithFormat:@"%dMss", nSize/1048576];
            }
            else
            {
                string = [NSString stringWithFormat:@"%d.%@M", nSize/1048576, decimalStr];
            }
        }
    }
    else    // >1G
    {
        string = [NSString stringWithFormat:@"%dG", nSize/1073741824];
    }
    
    return string;
}

//-(void)viewWillAppear:(BOOL)animated {
//    //    [_mapView viewWillAppear];
//    _mapView.delegate = self;
//    _offlineMap.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
//}
//
//-(void)viewWillDisappear:(BOOL)animated {
//    [_mapView viewWillDisappear];
//    _mapView.delegate = nil; // 不用时，置nil
//    _offlineMap.delegate = nil; // 不用时，置nil
//}
//
//- (void)dealloc {
//
//    if (_offlineMap != nil) {
//        _offlineMap = nil;
//    }
//    if (_mapView) {
//        _mapView = nil;
//    }
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
