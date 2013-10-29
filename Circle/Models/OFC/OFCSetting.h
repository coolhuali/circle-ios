//
//  OFCSetting.h
//  OpenFireClient
//
//  Created by CTI AD on 17/12/12.
//  Copyright (c) 2012 com.cti. All rights reserved.
//

#import <Foundation/Foundation.h>
@class OFCSetting;
@protocol OFCSettingDelegate <NSObject>
@required

- (void) customShouldReturn:(UITextField *)textField;
- (void) customBeginEditing:(UITextField *)textField;
- (void) customEndEditing:(UITextField *)textField;
- (void) setActiveTextField:(UITextField *)textField;
- (void) refreshView;
- (void) showDetailViewControllerClass:(OFCSetting *)setting viewControllerClass:(Class)viewControllerClass;
@end

@interface OFCSetting : NSObject
{
    NSString *title;
    NSString *description;
}
@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, strong, readonly) NSString *description;
@property (nonatomic, strong) NSString *imageName;
@property (nonatomic) SEL action;
@property (nonatomic, assign) id<OFCSettingDelegate> delegate;

- (id) initWithTitle:(NSString *)newTitle description:(NSString *)newDescription;


@end
