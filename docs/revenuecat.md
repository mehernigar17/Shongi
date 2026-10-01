# Shongi Plus — RevenueCat entitlement for the Doctors section

The Doctors section, doctor profile sheet, and booking UI require the RevenueCat
`shongi_plus` entitlement. Firebase UID is the RevenueCat App User ID. Other
features stay free. No health records are sent to RevenueCat.

## Dashboard configuration

- Project: Shongi (`projb37bf2a4`), per Project Settings → General.
- Entitlement: `shongi_plus` (`entldbf5ed1de7`).
- Test Store product: `shongi_plus_monthly`, monthly, USD 2.99, no trial.
- Current offering: `default` (`ofrnga1f9b9cf7b`).
- Package: `$rc_monthly`, attached to the test product.
- Published paywall: **Shongi Plus Doctors — Test Store** (`wf021df8b7b65d4e52`).
  https://app.revenuecat.com/projects/648c241e/paywalls/wf021df8b7b65d4e52/builder

The test price is a development placeholder, not a production pricing decision.
The published demo explicitly says no real charge and has no Terms/Privacy
buttons because hosted legal pages have not been supplied. Add genuine links
and remove the demo label before connecting production products.

## Run

Normal Android/iOS debug runs use Shongi's public Test Store SDK key automatically.
No special launch arguments are required. Release builds never use this fallback.
The ignored `config/revenuecat.local.json` can override the public SDK keys.
For another checkout, copy `config/revenuecat.example.json` to that filename and
fill in the SDK key from RevenueCat > API keys. Never place secret API keys here.

```sh
flutter run
flutter run --dart-define-from-file=config/revenuecat.local.json
flutter test test/subscription_service_test.dart
```

RevenueCat purchases/paywalls are enabled on Android and iOS. Web and desktop
show an unavailable state and do not grant access. Missing configuration fails
closed without blocking startup or free features. Release builds ignore the
Test Store key and reject test keys placed in the production fields.

## Identity and access

`SubscriptionService` serializes identity changes and SDK operations. Signing out
immediately removes access locally. The SDK retains the last identified account
while signed out, but cannot purchase, restore, or manage until Firebase signs
in again. Direct `logIn(nextUid)` avoids creating anonymous identities between
accounts. Results from an older account cannot unlock the new one.

Access is refreshed on resume, after purchases/restores and CustomerInfo updates.
Restore and Customer Center are available in Profile. SDK failures show a retry
state and never grant access. Configure the desired restore/transfer behavior
in RevenueCat before launch and test two Firebase users sharing a store account.

These are client UI gates. If doctor data or appointment writes must be protected
against modified clients, add trusted RevenueCat webhook/API verification and
Firestore rules/server enforcement. Do not trust client-written premium flags.

## Before production

1. Create the Google Play/App Store app and real subscription products; connect
   store credentials to RevenueCat and attach the products to `shongi_plus` and
   the monthly package in `default`.
2. Supply the matching public SDK keys in the Android/iOS fields of a separate
   release configuration; never submit a Test Store build.
3. Set final package identifiers, Firebase configuration and release signing.
   iOS needs macOS/Xcode and a provisioned store app for validation.
4. Add real hosted Terms and Privacy URLs to the paywall, configure Customer
   Center, verify store disclosures and approve production pricing.
5. Verify the doctor directory content before selling it. PDF export is still a
   placeholder; consultation fees and confirmed provider appointments are not
   included in this subscription.
6. Test successful purchase, dismissal, failed payment, restore/reinstall,
   expiration, renewal, offline behavior and account switching in store sandbox.

For a demo, sign in, select Health > Doctor, purchase in the Test Store dialog,
and verify the report/directory unlock. Profile offers restore and management.

## Verification performed

- Eight automated configuration/service/widget tests passed (debug key fallback,
  release key isolation, unsupported platforms, identity isolation, late purchase
  results, dismissal, restore, expiration, retry, and protected rendering).
- Targeted analyzer checks passed. The existing capitalized booking filename
  still triggers the repository's file-naming lint when that file is included.
- Android debug APK built successfully and installed on the connected Samsung.
- RevenueCat initialized with the signed-in Firebase UID and Test Store key.
- A plain `flutter run` build was installed and successfully loaded the monthly
  product and published paywall from RevenueCat. The earlier missing-key startup
  issue is fixed by the debug-only public Test Store fallback.
- The user completed the simulated Test Store purchase on the Samsung phone
  and confirmed that Doctors unlocked successfully.
- iOS was not built on this Windows host.
