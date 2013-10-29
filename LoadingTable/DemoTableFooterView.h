//
// DemoTableFooterView.h
//
// @author Shiki
//

#import <UIKit/UIKit.h>


@interface DemoTableFooterView : UIView {
    
  UIActivityIndicatorView *activityIndicator;
  UILabel *infoLabel;
}

@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) IBOutlet UILabel *infoLabel;

@end
