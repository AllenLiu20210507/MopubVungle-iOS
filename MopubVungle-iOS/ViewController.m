//
//  ViewController.m
//  MopubVungle-iOS
//
//  Created by allen.liu on 2020/12/24.
//

#import "ViewController.h"
#import <UIKit/NSText.h>
#import <VungleSDK/VungleSDK.h>
#import "MoPub.h"
#import "MPMoPubConfiguration.h"
#import "MPRewardedVideo.h"
#import <VungleAdapterConfiguration.h>
#import "BannerViewController.h"
#import "Constants.h"

@interface ViewController ()<MPInterstitialAdControllerDelegate, MPRewardedVideoDelegate,VungleSDKDelegate>
@property (nonatomic, retain) MPInterstitialAdController *interstitial;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createView];
}

- (void)createView {
    float screenWidth = self.view.bounds.size.width;
    float x = screenWidth/2-100;
    float y = 100;
    float btnWidth = 200;
    float btnHeight = 50;
    
    UILabel *title = [[UILabel alloc] init];
    title.frame = CGRectMake(x, y - 50, btnWidth, btnHeight);
    title.text = @"Mopub + Vungle";
    title.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:title];
    
    UIButton *initBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    initBtn.frame = CGRectMake(x, y, btnWidth, btnHeight);
    [initBtn setTitle:@"init Mopub" forState:UIControlStateNormal];
    [initBtn addTarget:self action:@selector(initMopub) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *loadInterstitialBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    loadInterstitialBtn.frame = CGRectMake(x, y + 50, btnWidth, btnHeight);
    [loadInterstitialBtn setTitle:@"Load Interstitial" forState:UIControlStateNormal];
    [loadInterstitialBtn addTarget:self action:@selector(loadInterstitial) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *playIntersititalBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    playIntersititalBtn.frame = CGRectMake(x, y + 100, btnWidth, btnHeight);
    [playIntersititalBtn setTitle:@"Play Interstitial" forState:UIControlStateNormal];
    [playIntersititalBtn addTarget:self action:@selector(playInterstitial) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *loadRewardBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    loadRewardBtn.frame = CGRectMake(x, y + 150, btnWidth, btnHeight);
    [loadRewardBtn setTitle:@"Load Reward" forState:UIControlStateNormal];
    [loadRewardBtn addTarget:self action:@selector(loadReward) forControlEvents:UIControlEventTouchUpInside];

    UIButton *playRewardBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    playRewardBtn.frame = CGRectMake(x, y + 200, btnWidth, btnHeight);
    [playRewardBtn setTitle:@"Play Reward" forState:UIControlStateNormal];
    [playRewardBtn addTarget:self action:@selector(playReward) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *goBannerBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    goBannerBtn.frame = CGRectMake(x, y + 250, btnWidth, btnHeight);
    [goBannerBtn setTitle:@"Go Banner" forState:UIControlStateNormal];
    [goBannerBtn addTarget:self action:@selector(goBanner) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:initBtn];
    [self.view addSubview:loadInterstitialBtn];
    [self.view addSubview:playIntersititalBtn];
    [self.view addSubview:loadRewardBtn];
    [self.view addSubview:playRewardBtn];
    [self.view addSubview:goBannerBtn];
}

# pragma mark - mopub init, load & play
- (void)initMopub {
    [self initVungleSDK];
    
}


- (void)initVungleSDK {
   [[VungleSDK sharedSDK] performSelector:@selector(setPluginName:version:) withObject:@"mopub" withObject:[[[VungleAdapterConfiguration alloc] init] adapterVersion]];
   NSError * error = nil;
   // disable banner refresh(must)
   [[VungleSDK sharedSDK] disableBannerRefresh];
   // Optional. To set the user's consent status to opted in. To set opted out, please use VungleConsentDenied
   [[VungleSDK sharedSDK] updateConsentStatus:VungleConsentAccepted consentMessageVersion:@"Some Consent Message Version"];
   [[VungleSDK sharedSDK] startWithAppId:@"573420e780ab935b37000066" error:&error];
   [[VungleSDK sharedSDK] setDelegate:self];
}

#pragma mark - VungleSDKDelegate Methods
- (void) vungleSDKDidInitialize {
    MPMoPubConfiguration *sdkConfig = [[MPMoPubConfiguration alloc] initWithAdUnitIdForAppInitialization:rewardPlacement];
    /* Optional for Vungle early init
     NSMutableDictionary *configDictionary = [NSMutableDictionary dictionaryWithDictionary:@{ @"appId" : @"Your_Vungle_App_Id" }];
     [configDictionary setValue:@(50*1024) forKey:@"vngMinSpaceForInit"];
     [configDictionary setValue:@(50*1024) forKey:@"vngMinSpaceForAdLoad"];
     [sdkConfig setNetworkConfiguration:configDictionary forMediationAdapter:@"VungleAdapterConfiguration"];
     */
    [[MoPub sharedInstance] initializeSdkWithConfiguration:sdkConfig completion:^{
        NSLog(@"SDK initialization complete");
    }];
    
    self.interstitial = [MPInterstitialAdController
        interstitialAdControllerForAdUnitId:interstitialPlacement];
    /* Optional
    NSNumber *orientations = [NSNumber numberWithInt:1];
    NSString *ordinal = @"10";
    NSNumber *muted = [NSNumber numberWithBool:YES];

    NSDictionary *localExtras = @{@"ordinal" : ordinal ?: @"",
                                  @"muted" : muted ?: @"",
                                  @"orientations" : orientations ?: @""};

    self.interstitial.localExtras = localExtras;
     */
    self.interstitial.delegate = self;
    [MPRewardedVideo setDelegate:self forAdUnitId:rewardPlacement];
}
    

- (void)loadInterstitial {
    [self.interstitial loadAd];
}

- (void)playInterstitial {
    if (self.interstitial.ready) [self.interstitial showFromViewController:self];
}

- (void)loadReward {
    /* Optional
     VungleInstanceMediationSettings *settings = [[VungleInstanceMediationSettings alloc] init];
     settings.userIdentifier = @"VungleTestUser";
     settings.startMuted = YES;
     settings.orientations = @(1);
     settings.ordinal = 5;
      [MPRewardedVideo loadRewardedVideoAdWithAdUnitID:rewardPlacement withMediationSettings:@[settings]];
     */
    [MPRewardedVideo loadRewardedVideoAdWithAdUnitID:rewardPlacement withMediationSettings:nil];
}

- (void)playReward {
    [MPRewardedVideo presentRewardedVideoAdForAdUnitID:rewardPlacement fromViewController:self withReward:0];
}

- (void)goBanner {
    BannerViewController *bannerVC = [[BannerViewController alloc] init];
    [self presentViewController:bannerVC animated:YES completion:nil];
}

#pragma mark - Interstitial Delegate
- (void)interstitialDidLoadAd:(MPInterstitialAdController *)interstitial {
    NSLog(@"AdUnit ID: %@ interstitialDidLoadAd", interstitial.adUnitId);
}

- (void)interstitialDidFailToLoadAd:(MPInterstitialAdController *)interstitial
                          withError:(NSError *)error {
    NSLog(@"AdUnit ID: %@ interstitialDidFailToLoadAd with Error %@", interstitial.adUnitId, error.localizedDescription);
}

- (void)interstitialWillAppear:(MPInterstitialAdController *)interstitial {
    NSLog(@"AdUnit ID: %@ interstitialWillAppear", interstitial.adUnitId);
}

- (void)interstitialDidAppear:(MPInterstitialAdController *)interstitial {
    NSLog(@"AdUnit ID: %@ interstitialDidAppear", interstitial.adUnitId);
}

- (void)interstitialWillDisappear:(MPInterstitialAdController *)interstitial {
    NSLog(@"AdUnit ID: %@ interstitialWillDisappear", interstitial.adUnitId);
}

- (void)interstitialDidDisappear:(MPInterstitialAdController *)interstitial {
    NSLog(@"AdUnit ID: %@ interstitialDidDisappear", interstitial.adUnitId);
}

- (void)interstitialDidExpire:(MPInterstitialAdController *)interstitial {
    NSLog(@"AdUnit ID: %@ interstitialDidExpire", interstitial.adUnitId);
}

- (void)interstitialDidReceiveTapEvent:(MPInterstitialAdController *)interstitial {
    NSLog(@"AdUnit ID: %@ interstitialDidReceiveTapEvent", interstitial.adUnitId);
}

#pragma mark - reward delegate
- (void)rewardedVideoAdDidLoadForAdUnitID:(NSString *)adUnitID {
    NSLog(@"AdUnit ID: %@ rewardedVideoAdDidLoadForAdUnitID", adUnitID);
    BOOL playable = [MPRewardedVideo hasAdAvailableForAdUnitID:adUnitID];
    NSLog(@"AdUnit ID: %@ rewardedVideoAdDidLoadForAdUnitID %d", adUnitID, playable);
}

- (void)rewardedVideoAdDidFailToLoadForAdUnitID:(NSString *)adUnitID error:(NSError *)error{
    NSLog(@"AdUnit ID: %@ rewardedVideoAdDidFailToLoadForAdUnitID with error %@", adUnitID, error.localizedDescription);
}

- (void)rewardedVideoAdDidFailToPlayForAdUnitID:(NSString *)adUnitID error:(NSError *)error{
    NSLog(@"AdUnit ID: %@ rewardedVideoAdDidFailToPlayForAdUnitID with error %@", adUnitID, error.localizedDescription);
}

- (void)rewardedVideoAdWillAppearForAdUnitID:(NSString *)adUnitID{
    NSLog(@"AdUnit ID: %@ rewardedVideoAdWillAppearForAdUnitID", adUnitID);
}

- (void)rewardedVideoAdDidAppearForAdUnitID:(NSString *)adUnitID{
    NSLog(@"AdUnit ID: %@ rewardedVideoAdDidAppearForAdUnitID", adUnitId);
}

- (void)rewardedVideoAdWillDisappearForAdUnitID:(NSString *)adUnitID{
    NSLog(@"AdUnit ID: %@ rewardedVideoAdWillDisappearForAdUnitID", adUnitID);
}

- (void)rewardedVideoAdDidDisappearForAdUnitID:(NSString *)adUnitID{
    NSLog(@"AdUnit ID: %@ rewardedVideoAdDidDisappearForAdUnitID", adUnitID);
}

- (void)rewardedVideoAdShouldRewardForAdUnitID:(NSString *)adUnitID reward:(MPRewardedVideoReward *)reward{
    NSLog(@"AdUnit ID: %@ rewardedVideoAdShouldRewardForAdUnitID", adUnitID);
}
- (void)rewardedVideoAdDidExpireForAdUnitID:(NSString *)adUnitID{
    NSLog(@"AdUnit ID: %@ rewardedVideoAdDidExpireForAdUnitID", adUnitID);
}

- (void)rewardedVideoAdDidReceiveTapEventForAdUnitID:(NSString *)adUnitID{
    NSLog(@"AdUnit ID: %@ rewardedVideoAdDidReceiveTapEventForAdUnitID", adUnitID);
}

- (void)rewardedVideoAdWillLeaveApplicationForAdUnitID:(NSString *)adUnitID{
    NSLog(@"AdUnit ID: %@ rewardedVideoAdWillLeaveApplicationForAdUnitID", adUnitID);
}

- (void)didTrackImpressionWithAdUnitID:(NSString *)adUnitID impressionData:(MPImpressionData *)impressionData;{
    NSLog(@"AdUnit ID: %@ rewardedVideoAddidTrackImpressionWithAdUnitID", adUnitID);
}


@end
