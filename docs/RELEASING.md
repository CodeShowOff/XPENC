# Releasing XPENC

How a version goes from code to a downloadable APK on the website.
Only maintainers do this; contributors never need to.

## Versioning

XPENC follows [Semantic Versioning](https://semver.org): `MAJOR.MINOR.PATCH`.

| Bump | When |
|---|---|
| **MAJOR** | Backup/DB format breaks compatibility, or the money model changes |
| **MINOR** | New feature (new screen, new bank template, new export format) |
| **PATCH** | Bug fix, parser fix, UI polish |

The Android `versionCode` is the `+N` build number in `pubspec.yaml` —
increment it on **every** release, it can never go backwards.

## The pipeline

```
bump version → commit → tag vX.Y.Z → push tag
        └─► GitHub Actions (.github/workflows/release.yml)
                ├─ tag == pubspec version?   (hard gate)
                ├─ flutter analyze + test    (116+ tests)
                ├─ flutter build apk --release --split-per-abi
                ├─ tool/verify_apk.sh        (libsqlite3.so gate — never skip)
                └─ GitHub Release: xpenc-arm64-v8a.apk · xpenc-armeabi-v7a.apk
                                   · xpenc-x86_64.apk · SHA256SUMS.txt
        └─► website Download buttons point at /releases/latest/download/…
            so they update automatically. Nothing to deploy.
```

## Step by step

1. **Bump the version** in `pubspec.yaml`:

   ```yaml
   version: 1.1.0+3   # name +buildNumber — bump BOTH appropriately
   ```

2. **Mirror it** in `AppInfo.version` / `AppInfo.buildNumber`
   (`lib/core/branding/app_info.dart`). `test/branding_test.dart` fails if they drift —
   run `flutter test test/branding_test.dart` to check.

3. **Update `CHANGELOG.md`** — move entries from `[Unreleased]` into a new
   `[X.Y.Z] — YYYY-MM-DD` section and update the compare links at the bottom.

4. **Commit and tag:**

   ```sh
   git add pubspec.yaml lib/core/branding CHANGELOG.md
   git commit -m "chore(release): v1.1.0"
   git tag v1.1.0
   git push origin master --tags
   ```

5. **Watch the action** — the *Release APK* workflow must go green. If
   `verify_apk.sh` fails, the release is not published; fix, delete the tag,
   re-tag.

6. **Verify** — https://github.com/CodeShowOff/XPENC/releases/latest should show
   the new tag with 4 assets, and the website's version badge (fetched from the
   GitHub API) updates by itself.

## Asset names are a contract

The website links to `releases/latest/download/xpenc-arm64-v8a.apk` (and
`…-armeabi-v7a.apk`). **Never rename the release assets** in
`release.yml` without updating `website/index.html` in the same PR.

## Website deployment

The site lives in `website/` and is deployed on Vercel as project
`CodeShowOff/XPENC`, production domain **https://github.com/CodeShowOff/XPENC** (custom domain;
`getxpenc.vercel.app` was the domain before this and still resolves to the
same deployment as Vercel's project domain). Deployment protection is
disabled on this project so the site is public.

To redeploy after editing the site:

```sh
cd website
vercel deploy --prod --yes
```

Optionally connect the repo in the Vercel dashboard (Root Directory: `website`,
Framework: Other, no build command) so pushes to `master` deploy automatically.

If the production domain ever changes, update the `og:url` / `og:image` meta
tags in `website/index.html` and the GitHub repo homepage.

## F-Droid Releases

F-Droid is configured to **automatically update** whenever you push a new `vX.Y.Z` tag to GitHub. 

For 99% of app updates, you **only** need to push to GitHub (as described in "Step by step" above). F-Droid runs a scheduled check, sees your new tag, bumps the metadata file automatically, and builds the new version. It even dynamically fetches the Flutter version you specify in your GitHub `.github/workflows/release.yml` so you never have to manually update it for F-Droid.

### When do you need to manually update F-Droid?

You only need to manually push to the `fdroiddata` repository (specifically your `add-xpenc` Merge Request) if you change:
1. **App Metadata**: You want to update the app description, add/change screenshots, or change the app icon or feature graphic.
2. **Build Process**: You added a new native dependency that requires a special F-Droid build flag, or you need to run custom `sed` scripts to remove non-free libraries.

**How to update F-Droid metadata manually (e.g. for new screenshots):**
1. Clone or open your `fdroiddata` fork.
2. Place graphics in `metadata/com.codeshowoff.xpenc/en-US/`:
   - Screenshots go in `phoneScreenshots/`
   - Icon goes in as `icon.png`
   - Feature graphic goes in as `featureGraphic.png`
3. Update `metadata/com.codeshowoff.xpenc.yml` if you want to force a specific version to build right now.
4. Commit and push to your branch:
   ```sh
   git add metadata/
   git commit -m "Update XPENC screenshots and icon"
   git push origin add-xpenc
   ```
5. F-Droid's CI will automatically run on your Merge Request and reviewers will merge it.
