import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/foundation.dart';

class AdService {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();

  // Test Ad Unit IDs (replace with your actual Ad Unit IDs in production)
  static String get interstitialAdUnitId {
    if (kDebugMode) {
      // Test ad unit IDs
      if (Platform.isAndroid) {
        return 'ca-app-pub-3940256099942544/1033173712';
      } else if (Platform.isIOS) {
        return 'ca-app-pub-3940256099942544/4411468910';
      }
    }
    // Production ad unit IDs (replace with your actual IDs)
    if (Platform.isAndroid) {
      return 'YOUR_ANDROID_INTERSTITIAL_AD_UNIT_ID';
    } else if (Platform.isIOS) {
      return 'YOUR_IOS_INTERSTITIAL_AD_UNIT_ID';
    }
    throw UnsupportedError('Unsupported platform');
  }

  static String get rewardedAdUnitId {
    if (kDebugMode) {
      // Test ad unit IDs
      if (Platform.isAndroid) {
        return 'ca-app-pub-3940256099942544/5224354917';
      } else if (Platform.isIOS) {
        return 'ca-app-pub-3940256099942544/1712485313';
      }
    }
    // Production ad unit IDs (replace with your actual IDs)
    if (Platform.isAndroid) {
      return 'YOUR_ANDROID_REWARDED_AD_UNIT_ID';
    } else if (Platform.isIOS) {
      return 'YOUR_IOS_REWARDED_AD_UNIT_ID';
    }
    throw UnsupportedError('Unsupported platform');
  }

  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;
  bool _isInterstitialAdReady = false;
  bool _isRewardedAdReady = false;

  // Counters to control ad frequency
  int _billAddedCount = 0;
  int _screenNavigationCount = 0;

  // Ad frequency settings
  static const int _showAdAfterBillsAdded = 3; // Show ad after every 3 bills added
  static const int _showAdAfterNavigations = 5; // Show ad after every 5 screen navigations

  /// Initialize the Mobile Ads SDK
  static Future<void> initialize() async {
    await MobileAds.instance.initialize();
    print('✅ Google Mobile Ads SDK initialized');
  }

  /// Load interstitial ad
  void loadInterstitialAd() {
    if (_interstitialAd != null) {
      return; // Ad already loaded
    }

    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          print('✅ Interstitial ad loaded');
          _interstitialAd = ad;
          _isInterstitialAdReady = true;
          _setInterstitialAdCallbacks();
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('❌ Interstitial ad failed to load: $error');
          _interstitialAd = null;
          _isInterstitialAdReady = false;
        },
      ),
    );
  }

  /// Load rewarded ad
  void loadRewardedAd() {
    if (_rewardedAd != null) {
      return; // Ad already loaded
    }

    RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          print('✅ Rewarded ad loaded');
          _rewardedAd = ad;
          _isRewardedAdReady = true;
          _setRewardedAdCallbacks();
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('❌ Rewarded ad failed to load: $error');
          _rewardedAd = null;
          _isRewardedAdReady = false;
        },
      ),
    );
  }

  /// Set callbacks for interstitial ad
  void _setInterstitialAdCallbacks() {
    _interstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) {
        print('📱 Interstitial ad showed full screen content');
      },
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('📱 Interstitial ad dismissed');
        ad.dispose();
        _interstitialAd = null;
        _isInterstitialAdReady = false;
        // Preload next ad
        loadInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('❌ Interstitial ad failed to show: $error');
        ad.dispose();
        _interstitialAd = null;
        _isInterstitialAdReady = false;
      },
    );
  }

  /// Set callbacks for rewarded ad
  void _setRewardedAdCallbacks() {
    _rewardedAd?.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) {
        print('📱 Rewarded ad showed full screen content');
      },
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        print('📱 Rewarded ad dismissed');
        ad.dispose();
        _rewardedAd = null;
        _isRewardedAdReady = false;
        // Preload next ad
        loadRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        print('❌ Rewarded ad failed to show: $error');
        ad.dispose();
        _rewardedAd = null;
        _isRewardedAdReady = false;
      },
    );
  }

  /// Show interstitial ad if ready
  Future<bool> showInterstitialAd() async {
    if (_isInterstitialAdReady && _interstitialAd != null) {
      await _interstitialAd!.show();
      return true;
    } else {
      print('❌ Interstitial ad not ready');
      return false;
    }
  }

  /// Show rewarded ad if ready
  Future<bool> showRewardedAd({Function? onRewardEarned}) async {
    if (_isRewardedAdReady && _rewardedAd != null) {
      await _rewardedAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
          print('🎉 User earned reward: ${reward.amount} ${reward.type}');
          onRewardEarned?.call();
        },
      );
      return true;
    } else {
      print('❌ Rewarded ad not ready');
      return false;
    }
  }

  /// Call this when a bill is added successfully
  void onBillAdded() {
    _billAddedCount++;
    print('📊 Bills added count: $_billAddedCount');

    if (_billAddedCount >= _showAdAfterBillsAdded) {
      _billAddedCount = 0; // Reset counter
      showInterstitialAd();
    }
  }

  /// Call this when navigating between major screens
  void onScreenNavigation() {
    _screenNavigationCount++;
    print('📊 Screen navigation count: $_screenNavigationCount');

    if (_screenNavigationCount >= _showAdAfterNavigations) {
      _screenNavigationCount = 0; // Reset counter
      showInterstitialAd();
    }
  }

  /// Check if interstitial ad is ready
  bool get isInterstitialAdReady => _isInterstitialAdReady;

  /// Check if rewarded ad is ready
  bool get isRewardedAdReady => _isRewardedAdReady;

  /// Dispose ads
  void dispose() {
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
    _interstitialAd = null;
    _rewardedAd = null;
    _isInterstitialAdReady = false;
    _isRewardedAdReady = false;
  }

  /// Preload both types of ads
  void preloadAds() {
    loadInterstitialAd();
    loadRewardedAd();
  }
}