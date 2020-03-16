#!/bin/sh

# Disable automatic period substitution
defaults write -g NSAutomaticPeriodSubstitutionEnabled -bool false

# # Disable smart quotes
# defaults write -g NSAutomaticQuoteSubstitutionEnabled -bool false

# Enable smart dashes
defaults write -g NSAutomaticDashSubstitutionEnabled -bool true

