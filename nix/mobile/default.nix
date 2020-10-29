{ config, lib, stdenvNoCC, callPackage, mkShell, status-go }:

let
  inherit (lib) catAttrs concatStrings optional unique;

  fastlane = callPackage ./fastlane { };

  android = callPackage ./android {
    status-go = status-go.mobile.android;
    status-go-android-all = status-go.shared.android-all;
    nim-status-android-all = status-go.nim-status.android-all;
  };

  ios = callPackage ./ios {
    inherit fastlane;
    status-go = status-go.mobile.ios;
    status-go-shared = status-go.shared.ios-all;
    status-go-nim-status = status-go.nim-status.ios-all;
  };

  selectedSources = [
    status-go.mobile.android
    status-go.mobile.ios
    fastlane
    android
    ios
  ];

in {
  shell = mkShell {
    inputsFrom = (catAttrs "shell" selectedSources);
  };

  # TARGETS
  inherit android ios fastlane;
}
