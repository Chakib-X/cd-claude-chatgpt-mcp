# Health Dashboard (personal iOS app)

A personal, sideloaded-only SwiftUI app that brings together Apple Health/Fitness
data, annual Neko Health screening results, and daily logging (nutrition,
supplements, hydration, alcohol, wellness journal) into one dashboard, with
weekly goals tied back to your Neko baseline.

This code was authored without access to Xcode/macOS, so the project is
generated from a declarative manifest ([XcodeGen](https://github.com/yonaskolb/XcodeGen))
rather than a hand-written `.xcodeproj`. You'll generate and build the actual
Xcode project on your Mac following the steps below.

## One-time Mac setup

1. **Install Xcode** from the Mac App Store (Xcode 16.x recommended — supports
   the iOS 17/18 SDKs this project targets). Launch it once to finish license
   acceptance and component installation.
2. **Install Homebrew** if you don't have it:
   ```sh
   curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | /bin/bash
   ```
3. **Install XcodeGen**:
   ```sh
   brew install xcodegen
   ```
4. **Get the code onto your Mac**:
   ```sh
   git clone <this-repo-url>
   cd cd-claude-chatgpt-mcp
   git checkout claude/ios-health-fitness-dashboard-y02uyr
   ```
5. **Set your own bundle identifier.** Open `project.yml` and replace
   `com.example.healthdashboard` with something only you own, e.g.
   `com.janedoe.healthdashboard` (a free Apple ID needs a globally unique
   bundle ID to sign with).
6. **Generate the Xcode project**:
   ```sh
   xcodegen generate
   ```
   This creates `HealthDashboard.xcodeproj` (gitignored — regenerate any time
   from `project.yml`).
7. **Open it**: `open HealthDashboard.xcodeproj`.
8. **Add your Apple ID as a signing team**, if you haven't already: Xcode menu
   → Settings → Accounts → "+" → sign in with your personal Apple ID.
9. Select the `HealthDashboard` target → **Signing & Capabilities**:
   - Set **Team** to your personal account. `CODE_SIGN_STYLE` is already set to
     Automatic, so Xcode manages the provisioning profile.
   - Click **"+ Capability"** → add **HealthKit**.
   - Do **not** add iCloud/CloudKit — Apple restricts that capability to paid
     Developer Program teams, and a free personal Apple ID can't enable it
     (Xcode will show an error if you try). This app stores data locally only.
10. **Connect your iPhone** via USB (or wireless debugging on the same
    network), and trust the Mac on the phone if prompted.
11. Select your iPhone as the run destination in Xcode's device dropdown.
12. **Build & run** (Cmd+R). On first install, the phone will refuse to open
    the app with an "Untrusted Developer" warning.
13. On the iPhone: **Settings → General → VPN & Device Management** → tap your
    developer profile → **Trust**.
14. Run again from Xcode (Cmd+R) — the app should now launch.
15. Grant HealthKit permissions when the in-app prompt appears.

## Important: free Apple ID signing expires every 7 days

Because this uses free/personal Apple ID signing (no paid Apple Developer
Program membership), the app's signature expires after **7 days** — the icon
will grey out and refuse to open. To keep using it:

- Reconnect your iPhone to your Mac, open the project in Xcode, and press
  Cmd+R again. No code changes needed — it's just a re-sign and reinstall.
- **Your data is not lost** as long as you don't delete the app. Xcode's
  Cmd+R re-signs and reinstalls in place over the existing app (same bundle
  ID, same device), which preserves its local SwiftData store. Data is
  local-only on this device — it won't sync to other devices or survive
  deleting the app, since CloudKit sync requires a paid Apple Developer
  Program account (see note above).

## What's in the app

- **Dashboard** — today's/this-week's activity (steps, energy, workouts from
  Apple Health), nutrition/hydration/alcohol/supplement totals, trend charts,
  and alignment against your latest Neko Health baseline.
- **Log** — one-screen, 1-2 tap logging: favorite foods + manual entry for
  meals, one-tap water/drink logging, today's supplement checklist.
- **Goals** — weekly targets, optionally linked to a Neko baseline metric, with
  live progress tracking.
- **Journal** — daily energy/mood, workout soreness vs. other pain (with
  location & severity), and free-text notes.
- **More** — import/view Neko Health PDF screenings, manage your favorite
  foods and recurring supplements, and HealthKit connection status.

## Project layout

```
project.yml                  XcodeGen manifest — edit this, not the .xcodeproj
Sources/HealthDashboard/      All Swift source, organized by feature
Resources/HealthDashboard/    Info.plist, entitlements, asset catalog
```

After editing `project.yml` (e.g. changing the bundle ID), re-run
`xcodegen generate` to regenerate the Xcode project.
