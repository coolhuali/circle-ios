//
//  BRAlbumListViewController.m
//  ImagePicker
//
//  Created by mak on 03.04.13.
//  Copyright (c) 2013 BR. All rights reserved.
//

#import "BRAlbumListViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "BRAlbumImageCell.h"

@interface BRAlbumListViewController ()
@property (weak, nonatomic) UICollectionView *collectionView;
@property (strong) NSMutableArray *assets;
@property BOOL isLoadedAssets;

@end

static NSString *cellIdentifier = @"AlbumImagePickerCell";

@implementation BRAlbumListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.isLoadedAssets = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                               target:self
                                                                               action:@selector(dismiss)];
    self.navigationItem.rightBarButtonItem = closeItem;
    
    self.title = [self.assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    flowLayout.itemSize = CGSizeMake(70, 70);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds
                                                          collectionViewLayout:flowLayout];
    collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    collectionView.bounces = YES;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerClass:[BRAlbumImageCell class]
       forCellWithReuseIdentifier:cellIdentifier];
    
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    
    self.assets = [NSMutableArray array];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.isLoadedAssets == NO) {
        self.isLoadedAssets = YES;
        ALAssetsGroupEnumerationResultsBlock assetsEnumerationBlock = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if (result) {
                [self.assets addObject:result];
            }
        };
        
        ALAssetsFilter *onlyPhotosFilter = [ALAssetsFilter allPhotos];
        [self.assetsGroup setAssetsFilter:onlyPhotosFilter];
        [self.assetsGroup enumerateAssetsUsingBlock:assetsEnumerationBlock];
    }
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - collection

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BRAlbumImageCell *cell = (BRAlbumImageCell*)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier
                                                                                          forIndexPath:indexPath];
    ALAsset *asset = [self.assets objectAtIndex:indexPath.row];
    CGImageRef thumbnailImageRef = [asset thumbnail];
    UIImage *thumbnail = [UIImage imageWithCGImage:thumbnailImageRef];
    cell.imageView.image = thumbnail;
    cell.backgroundColor = [UIColor greenColor];
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ALAsset *asset = [self.assets objectAtIndex:indexPath.row];
    UIImage *currentImage = [self normalizeImageFromAsset:asset];
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickerController:captureImage:)]) {
        [self.delegate pickerController:self captureImage:currentImage];
    }
}

- (UIImage*)normalizeImageFromAsset:(ALAsset*)asset
{
    ALAssetRepresentation *representation = [asset defaultRepresentation];
    UIImage *currentImage = [UIImage imageWithCGImage:[representation fullResolutionImage]];
    ALAssetOrientation orientation = representation.orientation;
    if (orientation != ALAssetOrientationUp) {
        switch (orientation) {
            case ALAssetOrientationDown:
            case ALAssetOrientationDownMirrored:
                currentImage = [UIImage imageWithCGImage:currentImage.CGImage
                                                   scale:1
                                             orientation:UIImageOrientationDown];
                break;
                
            case ALAssetOrientationLeft:
            case ALAssetOrientationLeftMirrored:
                currentImage = [UIImage imageWithCGImage:currentImage.CGImage
                                                   scale:1
                                             orientation:UIImageOrientationLeft];
                break;
                
            case ALAssetOrientationRight:
            case ALAssetOrientationRightMirrored:
                currentImage = [UIImage imageWithCGImage:currentImage.CGImage
                                                   scale:1
                                             orientation:UIImageOrientationRight];
                break;
                
            default:
                break;
        }
    }
    return currentImage;
}

@end
