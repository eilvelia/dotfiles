#!/usr/bin/env bash

_file=~/dotfiles/text-replacements.plist

case $1 in
  import)
    if ! test -r "$_file"; then
      echo "File '$_file' not found."
      exit 1
    fi
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
