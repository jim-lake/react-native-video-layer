
# react-native-video-layer

## Getting started

`$ npm install react-native-video-layer --save`

### Mostly automatic installation

`$ react-native link react-native-video-layer`

### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-video-layer` and add `RNVideoLayer.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNVideoLayer.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

#### Android

1. Open up `android/app/src/main/java/[...]/MainActivity.java`
  - Add `import com.reactlibrary.RNVideoLayerPackage;` to the imports at the top of the file
  - Add `new RNVideoLayerPackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':react-native-video-layer'
  	project(':react-native-video-layer').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-video-layer/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      compile project(':react-native-video-layer')
  	```

#### Windows
[Read it! :D](https://github.com/ReactWindows/react-native)

1. In Visual Studio add the `RNVideoLayer.sln` in `node_modules/react-native-video-layer/windows/RNVideoLayer.sln` folder to their solution, reference from their app.
2. Open up your `MainPage.cs` app
  - Add `using Video.Layer.RNVideoLayer;` to the usings at the top of the file
  - Add `new RNVideoLayerPackage()` to the `List<IReactPackage>` returned by the `Packages` method


## Usage
```javascript
import RNVideoLayer from 'react-native-video-layer';

// TODO: What to do with the module?
RNVideoLayer;
```
  