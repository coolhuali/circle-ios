//
// DemoTableHeaderView.h
//
// @author Shiki
//

#import <UIKit/UIKit.h>


@interface DemoTableHeaderView : UIView {
    
  UILabel *title;
  UIActivityIndicatorView *activityIndicator;
}

@property (nonatomic, strong) IBOutlet UILabel *title;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
