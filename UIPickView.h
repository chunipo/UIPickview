//
//  QTMCarRegionPickerView.h
//  QianTuMei
//
//  Created by weiyuxiang on 2018/4/18.
//  Copyright © 2018年 luwei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    province   =   0,
    city       =   1,
    districts  =   2,
}returnType;

@protocol QTMCarRegionPickerViewDelegate <NSObject>

- (void)hideSelectedOrSave:(BOOL)isSave withprovince:(NSString *)province andcity:(NSString *)city withdistrict:(NSString *)district;

@end

@interface QTMCarRegionPickerView : UIView

@property (nonatomic, weak) id<QTMCarRegionPickerViewDelegate>delegate;

@property (nonatomic, assign) returnType                      returnType;

/**列数*/
@property (nonatomic, assign) NSInteger           listNumber;
@property (nonatomic, strong) NSMutableArray      *firstArray;
@property (nonatomic, strong) NSMutableArray      *secondArray;
@property (nonatomic, strong) NSMutableArray      *thirdArray;
@property (nonatomic, copy)   NSString            *titleString;

@end
