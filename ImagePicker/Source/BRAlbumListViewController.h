//
//  BRAlbumListViewController.h
//  ImagePicker
//
//  Created by mak on 03.04.13.
//  Copyright (c) 2013 BR. All rights reserved.
//

#import "BRAbstractPickerViewController.h"

@class ALAssetsGroup;

@interface BRAlbumListViewController : BRAbstractPickerViewController <UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong) ALAssetsGroup *assetsGroup;

@end
