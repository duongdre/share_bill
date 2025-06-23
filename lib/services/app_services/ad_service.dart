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
      return 'ca-app-pub-1043369734957041/3817987701';
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
      return 'ca-app-pub-1043369734957041~2572338736';
    } else if (Platform.isIOS) {
      return 'YOUR_IOS_REWARDED_AD_UNIT_ID';
    }
    throw UnsupportedError('Unsupported platform');
  }

  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;
  bool _isInterstitialAdReady = false;
  bool _isRewardedAdReady = false;
  bool _isLoadingInterstitialAd = false;
  bool _isLoadingRewardedAd = false;

  // Counters to control ad frequency
  int _billAddedCount = 0;
  int _screenNavigationCount = 0;

  // Ad frequency settings - reduced for testing
  static const int _showAdAfterBillsAdded = 2; // Show ad after every 2 bills added (reduced for testing)
  static const int _showAdAfterNavigations = 3; // Show ad after every 3 screen navigations (reduced for testing)

  /// Initialize the Mobile Ads SDK
  static Future<void> initialize() async {
    try {
      final InitializationStatus status = await MobileAds.instance.initialize();
      print('✅ Google Mobile Ads SDK initialized successfully');
      print('📊 AdMob initialization complete');

      // Optional: Print adapter statuses if available
      if (status.adapterStatuses.isNotEmpty) {
        print('📊 Adapter statuses:');
        status.adapterStatuses.forEach((key, value) {
          print('   $key: ${value.description}');
        });
      }
    } catch (e) {
      print('❌ Failed to initialize Google Mobile Ads SDK: $e');
    }
  }

  /// Load interstitial ad with retry logic
  void loadInterstitialAd() {
    if (_isLoadingInterstitialAd) {
      print('⏳ Already loading interstitial ad...');
      return;
    }

    if (_interstitialAd != null) {
      print('✅ Interstitial ad already loaded');
      return;
    }

    _isLoadingInterstitialAd = true;
    print('🔄 Loading interstitial ad...');

    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          print('✅ Interstitial ad loaded successfully!');
          _interstitialAd = ad;
          _isInterstitialAdReady = true;
          _isLoadingInterstitialAd = false;
          _setInterstitialAdCallbacks();
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('❌ Interstitial ad failed to load: ${error.message}');
          print('   Error code: ${error.code}');
          print('   Error domain: ${error.domain}');
          _interstitialAd = null;
          _isInterstitialAdReady = false;
          _isLoadingInterstitialAd = false;

          // Retry loading after 30 seconds
          Future.delayed(const Duration(seconds: 30), () {
            print('🔄 Retrying interstitial ad load...');
            loadInterstitialAd();
          });
        },
      ),
    );
  }

  /// Load rewarded ad with retry logic
  void loadRewardedAd() {
    if (_isLoadingRewardedAd) {
      print('⏳ Already loading rewarded ad...');
      return;
    }

    if (_rewardedAd != null) {
      print('✅ Rewarded ad already loaded');
      return;
    }

    _isLoadingRewardedAd = true;
    print('🔄 Loading rewarded ad...');

    RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          print('✅ Rewarded ad loaded successfully!');
          _rewardedAd = ad;
          _isRewardedAdReady = true;
          _isLoadingRewardedAd = false;
          _setRewardedAdCallbacks();
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('❌ Rewarded ad failed to load: ${error.message}');
          print('   Error code: ${error.code}');
          print('   Error domain: ${error.domain}');
          _rewardedAd = null;
          _isRewardedAdReady = false;
          _isLoadingRewardedAd = false;

          // Retry loading after 30 seconds
          Future.delayed(const Duration(seconds: 30), () {
            print('🔄 Retrying rewarded ad load...');
            loadRewardedAd();
          });
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
        // Preload next ad immediately
        loadInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('❌ Interstitial ad failed to show: ${error.message}');
        ad.dispose();
        _interstitialAd = null;
        _isInterstitialAdReady = false;
        // Try to load a new ad
        loadInterstitialAd();
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
        print('❌ Rewarded ad failed to show: ${error.message}');
        ad.dispose();
        _rewardedAd = null;
        _isRewardedAdReady = false;
        // Try to load a new ad
        loadRewardedAd();
      },
    );
  }

  /// Show interstitial ad if ready
  Future<bool> showInterstitialAd() async {
    print('🎯 Attempting to show interstitial ad...');
    print('   Ad ready: $_isInterstitialAdReady');
    print('   Ad object: ${_interstitialAd != null}');

    if (_isInterstitialAdReady && _interstitialAd != null) {
      try {
        await _interstitialAd!.show();
        return true;
      } catch (e) {
        print('❌ Error showing interstitial ad: $e');
        return false;
      }
    } else {
      print('❌ Interstitial ad not ready - loading new ad...');
      loadInterstitialAd(); // Try to load if not ready
      return false;
    }
  }

  /// Show rewarded ad if ready
  Future<bool> showRewardedAd({Function? onRewardEarned}) async {
    print('🎯 Attempting to show rewarded ad...');
    print('   Ad ready: $_isRewardedAdReady');
    print('   Ad object: ${_rewardedAd != null}');

    if (_isRewardedAdReady && _rewardedAd != null) {
      try {
        await _rewardedAd!.show(
          onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
            print('🎉 User earned reward: ${reward.amount} ${reward.type}');
            onRewardEarned?.call();
          },
        );
        return true;
      } catch (e) {
        print('❌ Error showing rewarded ad: $e');
        return false;
      }
    } else {
      print('❌ Rewarded ad not ready - loading new ad...');
      loadRewardedAd(); // Try to load if not ready
      return false;
    }
  }

  /// Call this when a bill is added successfully
  void onBillAdded() {
    _billAddedCount++;
    print('📊 Bills added count: $_billAddedCount');
    print('📊 Will show ad after: $_showAdAfterBillsAdded bills');

    if (_billAddedCount >= _showAdAfterBillsAdded) {
      print('🎯 Triggering ad after bill added!');
      _billAddedCount = 0; // Reset counter
      showInterstitialAd();
    }
  }

  /// Call this when navigating between major screens
  void onScreenNavigation() {
    _screenNavigationCount++;
    print('📊 Screen navigation count: $_screenNavigationCount');
    print('📊 Will show ad after: $_showAdAfterNavigations navigations');

    if (_screenNavigationCount >= _showAdAfterNavigations) {
      print('🎯 Triggering ad after screen navigation!');
      _screenNavigationCount = 0; // Reset counter
      showInterstitialAd();
    }
  }

  /// Manual trigger for testing
  void triggerTestAd() {
    print('🧪 Manual ad trigger for testing');
    showInterstitialAd();
  }

  /// Check if interstitial ad is ready
  bool get isInterstitialAdReady => _isInterstitialAdReady;

  /// Check if rewarded ad is ready
  bool get isRewardedAdReady => _isRewardedAdReady;

  /// Check if ads are loading
  bool get isLoadingInterstitialAd => _isLoadingInterstitialAd;
  bool get isLoadingRewardedAd => _isLoadingRewardedAd;

  /// Get ad status for debugging
  String get adStatus {
    return '''
📊 Ad Service Status:
   Interstitial: ${_isInterstitialAdReady ? '✅ Ready' : '❌ Not Ready'} ${_isLoadingInterstitialAd ? '(Loading...)' : ''}
   Rewarded: ${_isRewardedAdReady ? '✅ Ready' : '❌ Not Ready'} ${_isLoadingRewardedAd ? '(Loading...)' : ''}
   Bills Count: $_billAddedCount/$_showAdAfterBillsAdded
   Nav Count: $_screenNavigationCount/$_showAdAfterNavigations
''';
  }

  /// Dispose ads
  void dispose() {
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
    _interstitialAd = null;
    _rewardedAd = null;
    _isInterstitialAdReady = false;
    _isRewardedAdReady = false;
    _isLoadingInterstitialAd = false;
    _isLoadingRewardedAd = false;
  }

  /// Preload both types of ads
  void preloadAds() {
    print('🚀 Preloading ads...');
    loadInterstitialAd();
    loadRewardedAd();
  }

  /// Force reload ads (useful for debugging)
  void forceReloadAds() {
    print('🔄 Force reloading all ads...');
    dispose();
    preloadAds();
  }
}