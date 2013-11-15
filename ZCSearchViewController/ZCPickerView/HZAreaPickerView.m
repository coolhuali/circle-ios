//
//  HZAreaPickerView.m
//  areapicker
//
//  Created by Cloud Dai on 12-9-9.
//  Copyright (c) 2012年 clouddai.com. All rights reserved.
//

#import "HZAreaPickerView.h"
#import <QuartzCore/QuartzCore.h>
#import "ZCObjects.h"
#import "ZCDefine.h"

@class ZCResearchViewController;
@interface HZAreaPickerView () <UIPickerViewDelegate>
{
    NSArray *provinces, *cities, *areas;
}
@end

@implementation HZAreaPickerView

@synthesize delegate=_delegate;
@synthesize pickerStyle=_pickerStyle;
@synthesize locate=_locate;
@synthesize locatePicker = _locatePicker;



-(HZLocation *)locate
{
    if (_locate == nil) {
        _locate = [[HZLocation alloc] init];
    }
    
    return _locate;
}

- (id)initWithStyle:(HZAreaPickerStyle)pickerStyle delegate:(id<HZAreaPickerDelegate>)delegate
{
    
    self = [[[NSBundle mainBundle] loadNibNamed:@"HZAreaPickerView" owner:self options:nil] objectAtIndex:0];
    if (self) {

        self.backgroundColor=KCOLOR_TABLE;

        self.locatePicker.frame=CGRectMake(self.locatePicker.frame.origin.x, self.locatePicker.frame.origin.y, self.locatePicker.frame.size.width, KRECT_PICKER.size.height);
        
        self.pickerStyle = pickerStyle;
        self.delegate = delegate;
        
        self.locatePicker.dataSource = self;
        self.locatePicker.delegate = self;
        //加载数据
        if (self.pickerStyle == HZAreaPickerWithStateAndCityAndDistrict) {
            provinces = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area.plist" ofType:nil]];
            cities = [[provinces objectAtIndex:0] objectForKey:@"cities"];
            
            self.locate.state = [[provinces objectAtIndex:0] objectForKey:@"state"];
            self.locate.city = [[cities objectAtIndex:0] objectForKey:@"city"];
            
            areas = [[cities objectAtIndex:0] objectForKey:@"areas"];
            if (areas.count > 0) {
                self.locate.district = [areas objectAtIndex:0];
            } else{
                self.locate.district = @"";
            }
            
        } else{
            provinces = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"city.plist" ofType:nil]];
            cities = [[provinces objectAtIndex:0] objectForKey:@"cities"];
            self.locate.state = [[provinces objectAtIndex:0] objectForKey:@"state"];
            self.locate.city = [cities objectAtIndex:0];
        }

    }
    
    return self;
    
}



#pragma mark - PickerView lifecycle

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (self.pickerStyle == HZAreaPickerWithStateAndCityAndDistrict) {
        return 3;
    } else{
        return 2;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return [provinces count];
            break;
        case 1:
            return [cities count];
            break;
        case 2:
            if (self.pickerStyle == HZAreaPickerWithStateAndCityAndDistrict) {
                return [areas count];
                break;
            }
        default:
            return 0;
            break;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (self.pickerStyle == HZAreaPickerWithStateAndCityAndDistrict) {
        switch (component) {
            case 0:
                return [[provinces objectAtIndex:row] objectForKey:@"state"];
                break;
            case 1:
                return [[cities objectAtIndex:row] objectForKey:@"city"];
                break;
            case 2:
                if ([areas count] > 0) {
                    return [areas objectAtIndex:row];
                    break;
                }
            default:
                return  @"";
                break;
        }
    } else{
        switch (component) {
            case 0:
                return [[provinces objectAtIndex:row] objectForKey:@"state"];
                break;
            case 1:
                return [cities objectAtIndex:row];
                break;
            default:
                return @"";
                break;
        }
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (self.pickerStyle == HZAreaPickerWithStateAndCityAndDistrict) {
        switch (component) {
            case 0:
                cities = [[provinces objectAtIndex:row] objectForKey:@"cities"];
                [self.locatePicker selectRow:0 inComponent:1 animated:YES];
                [self.locatePicker reloadComponent:1];
                
                areas = [[cities objectAtIndex:0] objectForKey:@"areas"];
                [self.locatePicker selectRow:0 inComponent:2 animated:YES];
                [self.locatePicker reloadComponent:2];
                
                self.locate.state = [[provinces objectAtIndex:row] objectForKey:@"state"];
                self.locate.city = [[cities objectAtIndex:0] objectForKey:@"city"];
                if ([areas count] > 0) {
                    self.locate.district = [areas objectAtIndex:0];
                } else{
                    self.locate.district = @"";
                }
                break;
            case 1:
                areas = [[cities objectAtIndex:row] objectForKey:@"areas"];
                [self.locatePicker selectRow:0 inComponent:2 animated:YES];
                [self.locatePicker reloadComponent:2];
                
                self.locate.city = [[cities objectAtIndex:row] objectForKey:@"city"];
                if ([areas count] > 0) {
                    self.locate.district = [areas objectAtIndex:0];
                } else{
                    self.locate.district = @"";
                }
                break;
            case 2:
                if ([areas count] > 0) {
                    self.locate.district = [areas objectAtIndex:row];
                } else{
                    self.locate.district = @"";
                }
                break;
            default:
                break;
        }
    } else{
        switch (component) {
            case 0:
                cities = [[provinces objectAtIndex:row] objectForKey:@"cities"];
                [self.locatePicker selectRow:0 inComponent:1 animated:YES];
                [self.locatePicker reloadComponent:1];
                
                self.locate.state = [[provinces objectAtIndex:row] objectForKey:@"state"];
                self.locate.city = [cities objectAtIndex:0];
                break;
            case 1:
                self.locate.city = [cities objectAtIndex:row];
                break;
            default:
                break;
        }
    }
    
    if([self.delegate respondsToSelector:@selector(pickerDidChaneStatus:)]) {
        [self.delegate pickerDidChaneStatus:self];
    }

}


#pragma mark - animation

- (void)showInView:(UIView *) view
{
    self.frame = CGRectMake(KRECT_PICKER.origin.x, view.frame.size.height, self.frame.size.width, KRECT_PICKER.size.height);
    [view addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(KRECT_PICKER.origin.x, 380, self.frame.size.width, KRECT_PICKER.size.height);
        
    }];
    
}

- (void)cancelPicker
{
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.frame = CGRectMake(KRECT_PICKER.origin.x, 640, self.frame.size.width, KRECT_PICKER.size.height);
                     }
                     completion:^(BOOL finished){
                         [self removeFromSuperview];
                         
                     }];
    
}


-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row
forComponent:(NSInteger)component reusingView:(UIView *)view
{
    NSString *imgstr1 ;
    if (self.pickerStyle == HZAreaPickerWithStateAndCityAndDistrict) {
        switch (component) {
            case 0:
                imgstr1= [[provinces objectAtIndex:row] objectForKey:@"state"];
                break;
            case 1:
                imgstr1= [[cities objectAtIndex:row] objectForKey:@"city"];
                break;
            case 2:
                if ([areas count] > 0) {
                    imgstr1= [areas objectAtIndex:row];
                    break;
                }
            default:
                imgstr1=  @"";
                break;
        }
    } else{
        switch (component) {
            case 0:
                imgstr1= [[provinces objectAtIndex:row] objectForKey:@"state"];
                break;
            case 1:
                imgstr1= [cities objectAtIndex:row];
                break;
            default:
                imgstr1= @"";
                break;
        }
    }
    
    UILabel *mycom1;
    mycom1 = view ? (UILabel *) view : [[UILabel alloc] init];//WithFrame:CGRectMake(10, 0.0f, 60.0f, 30.0f)];
    mycom1.textAlignment=NSTextAlignmentCenter;
    mycom1.text = imgstr1;
    [mycom1 setFont:KFONT];
    mycom1.textColor=KCOLOR_FONT;
    mycom1.backgroundColor = [UIColor clearColor];
    return mycom1;
}
//-(float)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
//
//    return 30;
//}
@end
