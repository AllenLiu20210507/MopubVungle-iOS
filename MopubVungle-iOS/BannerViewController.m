//
//  BannerViewController.m
//  MopubVungle-iOS
//
//  Created by allen.liu on 2020/12/24.
//

#import "BannerViewController.h"

#import "MPAdView.h"
#import "Constants.h"
@interface BannerViewController ()<MPAdViewDelegate>
@property (nonatomic) MPAdView *bannerView, *mrecView;
@property (nonatomic) UIButton *loadBannerBtn, *loadMrecBtn, *closeBannerBtn, *closeMrecBtn;
@property (nonatomic) float btnPostionX;
@end

@implementation BannerViewController


- (void)viewDidLoad {
    [self createView];
    [super viewDidLoad];
}

- (void)createView {
    self.view.backgroundColor = UIColor.whiteColor;
    self.btnPostionX = (self.view.bounds.size.width - 320) / 2;
    
    self.loadBannerBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.loadBannerBtn.frame = CGRectMake(self.btnPostionX, 80, 320, 60);
    [self.loadBannerBtn setTitle:@"Load & Play Banner" forState:UIControlStateNormal];
    [self.loadBannerBtn addTarget:self action:@selector(loadBanner) forControlEvents:UIControlEventTouchUpInside];
    
    self.closeBannerBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.closeBannerBtn.frame = CGRectMake(self.btnPostionX, 120, 320, 60);
    [self.closeBannerBtn setTitle:@"Close Banner" forState:UIControlStateNormal];
    [self.closeBannerBtn addTarget:self action:@selector(closeBanner) forControlEvents:UIControlEventTouchUpInside];
    
    self.loadMrecBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.loadMrecBtn.frame = CGRectMake(self.btnPostionX, 280, 320, 60);
    [self.loadMrecBtn setTitle:@"Load & Play MREC" forState:UIControlStateNormal];
    [self.loadMrecBtn addTarget:self action:@selector(loadMrec) forControlEvents:UIControlEventTouchUpInside];
    
    self.closeMrecBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.closeMrecBtn.frame = CGRectMake(self.btnPostionX, 320, 320, 60);
    [self.closeMrecBtn setTitle:@"Close MREC" forState:UIControlStateNormal];
    [self.closeMrecBtn addTarget:self action:@selector(closeMrec) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.loadBannerBtn];
    [self.view addSubview:self.closeBannerBtn];
    [self.view addSubview:self.loadMrecBtn];
    [self.view addSubview:self.closeMrecBtn];
}

#pragma mark - load & play
- (void)createBanner {
    // Create MPAdView instance
    self.bannerView = [[MPAdView alloc] initWithAdUnitId:bannerPlacement];
    self.bannerView.delegate = self;
    self.bannerView.frame = CGRectMake(self.btnPostionX, 200, 320, kMPPresetMaxAdSize50Height.height);
    self.bannerView.backgroundColor = UIColor.orangeColor;
    [self.view addSubview:self.bannerView];
}

- (void)loadBanner {
    // automatically refreshes an ad unit at a time interval specified via the MoPub web interface
    [self createBanner];
    [self.bannerView loadAdWithMaxAdSize:kMPPresetMaxAdSize50Height];
    self.loadBannerBtn.enabled = NO;
    self.loadMrecBtn.enabled = NO;
}

- (void)closeBanner {
   if (self.bannerView) {
       [self.bannerView removeFromSuperview];
       self.bannerView.delegate = nil;
       self.bannerView = nil;
       self.loadBannerBtn.enabled = YES;
       self.loadMrecBtn.enabled = YES;
   }
}

- (void)createMrec {
    self.mrecView = [[MPAdView alloc] initWithAdUnitId:mrecPlacement];
    self.mrecView.delegate = self;
    self.mrecView.frame = CGRectMake(self.btnPostionX, 400, 300, 250);
    self.mrecView.backgroundColor = UIColor.orangeColor;
    [self.view addSubview:self.mrecView];
}

- (void)loadMrec {
    // automatically refreshes an ad unit at a time interval specified via the MoPub web interface
    [self createMrec];
    [self.mrecView loadAdWithMaxAdSize:kMPPresetMaxAdSize250Height];
    self.loadBannerBtn.enabled = NO;
    self.loadMrecBtn.enabled = NO;
}

- (void)closeMrec {
    if (self.mrecView) {
        [self.mrecView removeFromSuperview];
        self.mrecView.delegate = nil;
        self.mrecView = nil;
        self.loadBannerBtn.enabled = YES;
        self.loadMrecBtn.enabled = YES;
    }
}

#pragma mark - MPAdView Delegate
- (void)adViewDidLoadAd:(MPAdView *)view adSize:(CGSize)adSize {
    NSLog(@"Adunit :%@adViewDidLoadAd",view.adUnitId);
}

- (void)adView:(MPAdView *)view didFailToLoadAdWithError:(NSError *)error {
    NSLog(@"Adunit :%@ didFailToLoadAdWithError:%@",view.adUnitId, error.localizedDescription);
}

- (void)willPresentModalViewForAd:(MPAdView *)view {
    // Vungle do not have this callback yet
    NSLog(@"Adunit :%@ willPresentModalViewForAd", view.adUnitId);
}

- (void)didDismissModalViewForAd:(MPAdView *)view {
    // Vungle do not have this callback yet
    NSLog(@"Adunit :%@ didDismissModalViewForAd", view.adUnitId);
}

- (void)willLeaveApplicationFromAd:(MPAdView *)view {
    // Vungle do not have this callback yet
    NSLog(@"Adunit :%@ willLeaveApplicationFromAd", view.adUnitId);
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
