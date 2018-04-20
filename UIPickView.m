//
//  QTMCarRegionPickerView.m
//  QianTuMei
//
//  Created by weiyuxiang on 2018/4/18.
//  Copyright © 2018年 luwei. All rights reserved.
//

#import "QTMCarRegionPickerView.h"
#import "CustomButton.h"

@interface QTMCarRegionPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource,QTMCarRegionPickerViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIPickerView   *regionPickerView;

/** 取消确定 */
@property (nonatomic, strong) UIView         *selectedBackgroudView;
@property (nonatomic, strong) CustomButton   *cancelButton;
@property (nonatomic, strong) CustomButton   *confirmButton;
@property (nonatomic, strong) UILabel        *titleLabel;

/** 城市，区域下标 */
@property (nonatomic, assign) NSInteger      provinceIndex;
@property (nonatomic, assign) NSInteger      cityIndex;
@property (nonatomic, assign) NSInteger      districtIndex;

/** 下端白线 */
@property (nonatomic, strong) UIView         *bottomLineView;

@property (nonatomic, strong) UIView         *orderView;

@end

@implementation QTMCarRegionPickerView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor colorWithRGB:0x80000000] colorWithAlphaComponent:0];
        [self setSublayout];
    }
    return self;
}

#pragma mark --action
/** tag  101取消  102确定 */
- (void)ButtonClick:(UIButton *)button{
    if (button.tag == 101) {
        [UIView animateWithDuration:0.3 animations:^{
            self.backgroundColor = [[UIColor colorWithRGB:0x80000000] colorWithAlphaComponent:0];
            _regionPickerView.frame = CGRectMake(0, SCREEN_HEIGHT+50, SCREEN_WIDTH, 160);
            _bottomLineView.frame = CGRectMake(0, self.regionPickerView.origin.y+self.regionPickerView.size.height, SCREEN_WIDTH, SCREEN_TabbarSafeBottomMargin);
            _selectedBackgroudView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 50);
            self.orderView.alpha = 0;
        } completion:^(BOOL finished) {
            if ([self.delegate respondsToSelector:@selector(hideSelectedOrSave:withprovince:andcity:withdistrict:)]) {
                [self.delegate hideSelectedOrSave:NO withprovince:[self saveData:0] andcity:[self saveData:1] withdistrict:[self saveData:2]];
            }
        }];
    }else if(button.tag == 102){

        [UIView animateWithDuration:0.3 animations:^{
            self.orderView.alpha = 0;
            self.backgroundColor = [[UIColor colorWithRGB:0x80000000] colorWithAlphaComponent:0];
            _regionPickerView.frame = CGRectMake(0, SCREEN_HEIGHT+50, SCREEN_WIDTH, 160);
            _bottomLineView.frame = CGRectMake(0, self.regionPickerView.origin.y+self.regionPickerView.size.height, SCREEN_WIDTH, SCREEN_TabbarSafeBottomMargin);
            _selectedBackgroudView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 50);
        } completion:^(BOOL finished) {
            if ([self.delegate respondsToSelector:@selector(hideSelectedOrSave:withprovince:andcity:withdistrict:)]) {
                [self.delegate hideSelectedOrSave:YES withprovince:[self saveData:0] andcity:[self saveData:1] withdistrict:[self saveData:2]];
            }
        }];
    }
}

- (void)setTitleString:(NSString *)titleString{
    _titleString = titleString;
    self.titleLabel.text = _titleString;
}

#pragma mark --pickViewdelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return self.listNumber;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return self.firstArray.count;
    }else if (component == 1){
        return self.secondArray.count;
    }else{
        return self.thirdArray.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    /** component列  row行 */
    if (component == 0) {
        return self.firstArray[row];
    }else if (component == 1){
        return self.secondArray[row];
    }else if(component == 2){
        return self.thirdArray[row];
    }else
        return @"请加入数据";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        self.provinceIndex = row;
        self.cityIndex = 0;
        self.districtIndex = 0;
        if (self.listNumber == 3) {
            [self.regionPickerView reloadComponent:1];
            [self.regionPickerView reloadComponent:2];
        }else if (self.listNumber == 2)[self.regionPickerView reloadComponent:1];
    }else if (component == 1){
        self.cityIndex = row;
        self.districtIndex = 0;
        if (self.listNumber == 3)[self.regionPickerView reloadComponent:2];
    }else _districtIndex = row;
    // 重置当前选中项
    [self resetPickerSelectRow];
    
}

//获取当前值
- (NSString *)saveData:(returnType)type{
    
    switch (type) {
        case 0:
            return self.firstArray[_provinceIndex];
            break;
        case 1:
            return self.secondArray[_cityIndex];
        case 2:
            return self.thirdArray[_districtIndex];
        default:
            break;
    }
}

//重写方法
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:16]];
    }
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

-(void)resetPickerSelectRow
{
    if (self.listNumber == 3){
        [self.regionPickerView selectRow:_provinceIndex inComponent:0 animated:YES];
        [self.regionPickerView selectRow:_cityIndex inComponent:1 animated:YES];
        [self.regionPickerView selectRow:_districtIndex inComponent:2 animated:YES];
    }else if (self.listNumber == 2){
        [self.regionPickerView selectRow:_provinceIndex inComponent:0 animated:YES];
        [self.regionPickerView selectRow:_cityIndex inComponent:1 animated:YES];
    }else [self.regionPickerView selectRow:_provinceIndex inComponent:0 animated:YES];
}
#pragma mark -- 手势
- (void)tap{
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [[UIColor colorWithRGB:0x80000000] colorWithAlphaComponent:0];
        _regionPickerView.frame = CGRectMake(0, SCREEN_HEIGHT+50, SCREEN_WIDTH, 160);
        _bottomLineView.frame = CGRectMake(0, self.regionPickerView.origin.y+self.regionPickerView.size.height, SCREEN_WIDTH, SCREEN_TabbarSafeBottomMargin);
        _selectedBackgroudView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 50);
        self.orderView.alpha = 0;
    } completion:^(BOOL finished) {
        if ([self.delegate respondsToSelector:@selector(hideSelectedOrSave:withprovince:andcity:withdistrict:)]) {
            [self.delegate hideSelectedOrSave:NO withprovince:[self saveData:0] andcity:[self saveData:1] withdistrict:[self saveData:2]];
        }
    }];
}

#pragma nark -- layout
- (void)setSublayout{
    [self.orderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        make.height.offset(SCREEN_HEIGHT);
    }];
    
    [self addSubview:self.selectedBackgroudView];
    [self addSubview:self.regionPickerView];
    [self addSubview:self.bottomLineView];
    
    
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.selectedBackgroudView);
        make.left.offset(20);
    }];

    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.selectedBackgroudView);
        make.right.offset(-20);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.selectedBackgroudView);
    }];
    
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    [self.orderView addGestureRecognizer:tap];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.orderView.alpha = 0.5;
        _regionPickerView.frame = CGRectMake(0, SCREEN_HEIGHT-SCREEN_TabbarSafeBottomMargin-160, SCREEN_WIDTH, 160);
        _bottomLineView.frame = CGRectMake(0, SCREEN_HEIGHT-SCREEN_TabbarSafeBottomMargin, SCREEN_WIDTH, SCREEN_TabbarSafeBottomMargin);
        _selectedBackgroudView.frame = CGRectMake(0, SCREEN_HEIGHT-SCREEN_TabbarSafeBottomMargin-self.regionPickerView.size.height-50, SCREEN_WIDTH, 50);
        self.backgroundColor = [[UIColor colorWithRGB:0x80000000] colorWithAlphaComponent:0.5];
    }];
}

#pragma mark --lazy load

- (UIPickerView *)regionPickerView{
    if (!_regionPickerView) {
        _regionPickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT+50, SCREEN_WIDTH, 160)];
        _regionPickerView.backgroundColor = White_Color;
        _regionPickerView.delegate = self;
        _regionPickerView.dataSource = self;
        _regionPickerView.showsSelectionIndicator = YES;
        
    }
    return _regionPickerView;
}

- (NSMutableArray *)jsonAllArray{
    if (!_jsonAllArray) {
        _jsonAllArray = @[].mutableCopy;
    }
    return _jsonAllArray;
}

- (NSInteger)provinceIndex{
    if (!_provinceIndex) {
        _provinceIndex = 0;
    }
    return _provinceIndex;
}

- (NSInteger)cityIndex{
    if (!_cityIndex) {
        _cityIndex = 0;
    }
    return _cityIndex;
}

- (NSInteger)districtIndex{
    if (!_districtIndex) {
        _districtIndex = 0;
    }
    return _districtIndex;
}

- (UIView *)bottomLineView{
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.regionPickerView.origin.y+self.regionPickerView.size.height, SCREEN_WIDTH, SCREEN_TabbarSafeBottomMargin)];
        _bottomLineView.backgroundColor = White_Color;
    
    }
    return _bottomLineView;
}

- (UIView *)selectedBackgroudView{
    if (!_selectedBackgroudView) {
        _selectedBackgroudView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 50)];
        _selectedBackgroudView.backgroundColor = UIColorFromRGB(0xeeeeee);
        
    }
    return _selectedBackgroudView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithText:@"城市选择" atColor:Black_Color atTextSize:16 ];
//        _titleLabel.center = self.selectedBackgroudView.center;
        [self.selectedBackgroudView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (CustomButton *)cancelButton{
    if (!_cancelButton) {
        _cancelButton = [CustomButton buttonWithTitle:@"取消" atTitleSize:15 atTitleColor:UIColorFromRGB(0xde4141) atTarget:self atAction:@selector(ButtonClick:)];
//        _cancelButton.frame = CGRectMake(20, 10, 50, 30);
        _cancelButton.tag = 101;
        [self.selectedBackgroudView addSubview:_cancelButton];
    }
    return _cancelButton;
}

- (CustomButton *)confirmButton{
    if (!_confirmButton) {
        _confirmButton = [CustomButton buttonWithTitle:@"确定" atTitleSize:15 atTitleColor:UIColorFromRGB(0xde4141) atTarget:self atAction:@selector(ButtonClick:)];
//        _confirmButton.frame = CGRectMake(SCREEN_WIDTH-20-50, 10, 50, 30);
        _confirmButton.tag = 102;
        [self.selectedBackgroudView addSubview:_confirmButton];
    }
    return _confirmButton;
}

- (UIView *)orderView{
    if (!_orderView) {
        _orderView = [[UIView alloc]init];
        _orderView.backgroundColor = [UIColor colorWithRGB:0x80000000];
        _orderView.alpha = 0;
        [self addSubview:_orderView];
    }
    return _orderView;
}

- (NSInteger)listNumber{
    if (!_listNumber) {
        _listNumber = 2;
    }
    return _listNumber;
}

- (NSMutableArray *)firstArray{
    if (!_firstArray) {
        _firstArray = @[@"第一列第一行",@"第一列第二行",@"第一列第三行"];
    }
    return _firstArray;
}

- (NSMutableArray *)secondArray{
    if (!_secondArray) {
        _secondArray = @[@"第二列第一行",@"第二列第二行",@"第二列第三行"];
    }
    return _secondArray;
}

- (NSMutableArray *)thirdArray{
    if (!_thirdArray) {
        _thirdArray = @[@"第三列第一行",@"第三列第二行",@"第三列第三行"];
    }
    return _thirdArray;
}

@end
