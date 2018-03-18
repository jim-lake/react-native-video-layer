'use strict';

import { NativeModules } from 'react-native';
import resolveAssetSource from 'react-native/Libraries/Image/resolveAssetSource';

const { RNVideoLayer } = NativeModules;

function play(arg,options) {
  let source = {};
  if (typeof arg == 'string') {
    source = {
      uri: arg,
    };
  } else {
    source = resolveAssetSource(arg) || {};
  }
  let uri = source.uri || '';
  if (uri && uri.match(/^\//)) {
    uri = `file://${uri}`;
  }

  const isNetwork = !!(uri && uri.match(/^https?:/));
  const isAsset = !!(uri && uri.match(/^(assets-library|file|content|ms-appx|ms-appdata):/));

  const src = {
    uri,
    isNetwork,
    isAsset,
    type: source.type || '',
    mainVer: source.mainVer || 0,
    patchVer: source.patchVer || 0,
  };
  options = options || {};
  RNVideoLayer.play(src,options);
}

export default {
  play,
  stop: RNVideoLayer.stop,
};
