
#import <AVFoundation/AVFoundation.h>
#import "AVKit/AVKit.h"
#import <React/RCTBridgeModule.h>
#import <React/RCTConvert.h>

@interface VideoLayer : NSObject

+ (VideoLayer *)sharedInstance;

- (BOOL)play:(NSDictionary *)source;
- (void)stop;

- (void)playerItemDidReachEnd:(NSNotification *)notification;

@end

@implementation VideoLayer {
  AVPlayer *_player;
  AVPlayerLayer *_playerLayer;
  BOOL _isObserverSet;
}

static VideoLayer *_videoLayer;

+ (VideoLayer *)sharedInstance {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
      _videoLayer = [[VideoLayer alloc] init];
  });
  return _videoLayer;
}

- (AVPlayerItem *)playerItemForSource:(NSDictionary *)source {
  bool isNetwork = [RCTConvert BOOL:[source objectForKey:@"isNetwork"]];
  bool isAsset = [RCTConvert BOOL:[source objectForKey:@"isAsset"]];
  NSString *uri = [source objectForKey:@"uri"];
  NSString *type = [source objectForKey:@"type"];

  AVPlayerItem *item = nil;
  if ([uri length] > 0) {
    NSURL *url = (isNetwork || isAsset) ?
      [NSURL URLWithString:uri] :
      [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:uri ofType:type]];

    if (isNetwork) {
      NSDictionary *options = nil;
      if (@available(iOS 8.0, *)) {
        NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
        options = @{AVURLAssetHTTPCookiesKey : cookies};
      }
      AVURLAsset *asset = [AVURLAsset URLAssetWithURL:url options:options];
      item = [AVPlayerItem playerItemWithAsset:asset];
    } else if (isAsset) {
      AVURLAsset *asset = [AVURLAsset URLAssetWithURL:url options:nil];
      item = [AVPlayerItem playerItemWithAsset:asset];
    } else {
      item = [AVPlayerItem playerItemWithURL:url];
    }
  }

  return item;
}

- (BOOL)play:(NSDictionary *)source {
  AVPlayerItem *item = [self playerItemForSource:source];

  if (item != nil) {
    if (_player == nil) {
      _player = [AVPlayer playerWithPlayerItem:item];
      _player.actionAtItemEnd = AVPlayerActionAtItemEndNone;

      UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
      _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
      _playerLayer.frame = keyWindow.frame;
      _playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
      [keyWindow.layer insertSublayer:_playerLayer atIndex:0];

      [_player seekToTime:kCMTimeZero];
      [_player play];
    } else {
      [_player replaceCurrentItemWithPlayerItem:item];
      [_player seekToTime:kCMTimeZero];
      [_player play];
    }
    if (_isObserverSet) {
      [[NSNotificationCenter defaultCenter] removeObserver:self];
      _isObserverSet = false;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self
      selector:@selector(playerItemDidReachEnd:)
      name:AVPlayerItemDidPlayToEndTimeNotification
      object:[_player currentItem]];
    _isObserverSet = true;
  }
  return item != nil;
}

- (void)stop {
  if (_isObserverSet) {
    _isObserverSet = false;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
  }
  [_player pause];
  [_playerLayer removeFromSuperlayer];
  _playerLayer = nil;
  _player = nil;
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
  [_player seekToTime:kCMTimeZero];
  [_player play];
}

@end

@interface RNVideoLayer : NSObject <RCTBridgeModule>

@end

@implementation RNVideoLayer

- (dispatch_queue_t)methodQueue {
    return dispatch_get_main_queue();
}
RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(play:(NSDictionary *)source) {
  [[VideoLayer sharedInstance] play:source];
}

RCT_EXPORT_METHOD(stop) {
  [[VideoLayer sharedInstance] stop];
}

@end
