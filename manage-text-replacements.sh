#!/usr/bin/env bash

_file="text-replacements.plist"

case $1 in
  import)
    set -ex
    /usr/libexec/PlistBuddy -c "Delete NSUserDictionaryReplacementItems" ~/Library/Preferences/.GlobalPreferences.plist
    /usr/libexec/PlistBuddy -c "Add NSUserDictionaryReplacementItems array" ~/Library/Preferences/.GlobalPreferences.plist
    /usr/libexec/PlistBuddy -c "Merge $_file NSUserDictionaryReplacementItems" ~/Library/Preferences/.GlobalPreferences.plist
    ;;
  export)
    set -x
    /usr/libexec/PlistBuddy -x -c "Print NSUserDictionaryReplacementItems" ~/Library/Preferences/.GlobalPreferences.plist > $_file
    ;;
  *)
    exit 1
    ;;
esac
