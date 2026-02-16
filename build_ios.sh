#!/bin/bash

# 🍎 iOS Build Automation Script
# Run this script on macOS to build IPA

echo "🚀 Starting iOS Build Process..."
echo "=================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo -e "${RED}❌ Error: This script must run on macOS${NC}"
    exit 1
fi

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}❌ Flutter not found. Please install Flutter first.${NC}"
    echo "Visit: https://docs.flutter.dev/get-started/install/macos"
    exit 1
fi

# Check if CocoaPods is installed
if ! command -v pod &> /dev/null; then
    echo -e "${YELLOW}⚠️  CocoaPods not found. Installing...${NC}"
    sudo gem install cocoapods
fi

# Clean previous builds
echo -e "${YELLOW}🧹 Cleaning previous builds...${NC}"
flutter clean

# Get dependencies
echo -e "${YELLOW}📦 Getting Flutter dependencies...${NC}"
flutter pub get

# Install iOS pods
echo -e "${YELLOW}📱 Installing iOS dependencies (CocoaPods)...${NC}"
cd ios
pod install --repo-update
cd ..

# Check for connected devices
echo -e "${YELLOW}🔍 Checking for iOS devices/simulators...${NC}"
flutter devices

# Ask user what to build
echo ""
echo "Select build option:"
echo "1) Build for Simulator (Debug)"
echo "2) Build IPA (Release)"
echo "3) Run on connected device"
echo "4) Open in Xcode"
read -p "Enter choice (1-4): " choice

case $choice in
    1)
        echo -e "${GREEN}🏗️  Building for iOS Simulator...${NC}"
        flutter build ios --debug --simulator
        echo -e "${GREEN}✅ Build complete!${NC}"
        echo "Run: flutter run -d ios-simulator"
        ;;
    2)
        echo -e "${GREEN}🏗️  Building Release IPA...${NC}"
        flutter build ipa --release

        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✅ IPA Build Successful!${NC}"
            echo ""
            echo "📂 IPA Location:"
            echo "   build/ios/ipa/family_travel_app.ipa"
            echo ""
            echo "Next steps:"
            echo "1. Upload to TestFlight"
            echo "2. Distribute via App Store"
            echo "3. Install on device via Xcode"
        else
            echo -e "${RED}❌ Build failed. Check errors above.${NC}"
        fi
        ;;
    3)
        echo -e "${GREEN}🏃 Running on device...${NC}"
        flutter run --release
        ;;
    4)
        echo -e "${GREEN}🔧 Opening in Xcode...${NC}"
        open ios/Runner.xcworkspace
        echo ""
        echo "In Xcode:"
        echo "1. Select Team (Apple Developer Account)"
        echo "2. Product > Archive"
        echo "3. Distribute App"
        ;;
    *)
        echo -e "${RED}❌ Invalid choice${NC}"
        exit 1
        ;;
esac

echo ""
echo "=================================="
echo -e "${GREEN}🎉 Process Complete!${NC}"

