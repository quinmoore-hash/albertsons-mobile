# Albertsons Mobile (demo replica)

A small SwiftUI replica of the Albertsons grocery app, built as an offline demo. Tabs: Home (for U card, Buy It Again, sale items), Search, Weekly Ad, Deals (digital coupons) and Cart. All data is in-memory sample data (`SampleData` in `Models.swift`); there is no backend.

## Build

The Xcode project is generated with [xcodegen](https://github.com/yonaskolb/XcodeGen) from `project.yml` and the generated `.xcodeproj` is committed.

```sh
brew install xcodegen
xcodegen generate            # after adding/removing source files
xcodebuild -project AlbertsonsMobile.xcodeproj -scheme AlbertsonsMobile \
  -destination 'platform=iOS Simulator,name=iPhone 17' build
```

## Layout

- `AlbertsonsMobile/AlbertsonsMobileApp.swift` – app entry and tab bar
- `AlbertsonsMobile/Models.swift` – `Product`, `Coupon`, `AdItem`, `AppStore` (cart + clipped coupons) and sample data
- `AlbertsonsMobile/SearchService.swift` – product search
- `AlbertsonsMobile/Views/` – one file per tab plus shared product views
- `docs/top-complaints.md` – the App Store review analysis this demo is based on
