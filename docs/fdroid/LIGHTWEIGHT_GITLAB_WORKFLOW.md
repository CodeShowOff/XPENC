# Lightweight F-Droid Git Workflow

The official [`fdroid/fdroiddata`](https://gitlab.com/fdroid/fdroiddata) repository is massive: it tracks thousands of applications, over 100,000 commits, and gigabytes of git history. A standard `git clone` can download several gigabytes, take a long time, and consume huge local disk space.

This guide documents how to make quick changes, fix CI errors, and push updates to your F-Droid fork in seconds without downloading the full history.

---

## 1. Quick Shallow Clone (Recommended)

When you need to update metadata or fix assets on your fork's branch, clone **only the latest commit of that single branch**:

```bash
git clone --depth 1 --branch <your-branch> https://gitlab.com/<YourUsername>/fdroiddata.git
```

### Why this is fast:
- **`--depth 1`**: Downloads only the single latest commit snapshot. It skips years of commit history.
- **`--branch <your-branch>`**: Downloads only your target branch (e.g. `add-xpenc`), completely skipping `master`.

---

## 2. Ultra-Lightweight Sparse Checkout (Optional)

If you only want to download your app's specific metadata files and skip the other ~80,000 files in the repo:

```bash
# 1. Clone only tree references without blob content
git clone --depth 1 --filter=blob:none --sparse --branch <your-branch> https://gitlab.com/<YourUsername>/fdroiddata.git
cd fdroiddata

# 2. Only check out your app's files
git sparse-checkout set metadata/com.codeshowoff.xpenc.yml metadata/com.codeshowoff.xpenc/
```

---

## 3. Fixing Image EXIF Metadata (Common F-Droid CI Failure)

F-Droid's CI pipeline runs `tools/check-exif-in-images.sh`, which strips EXIF metadata and verifies `git diff --exit-code`. If your screenshots or icons contain any camera metadata, timestamps, or ICC profiles, the CI build will fail.

### How to strip EXIF cleanly before committing:

1. Install `exiftool` (e.g. via `winget install OliverBetz.ExifTool` or package manager).
2. Strip metadata losslessly:
   ```bash
   exiftool -all= metadata/com.codeshowoff.xpenc/en-US/phoneScreenshots/*.jpeg
   ```
3. Remove the automatic backup files:
   ```bash
   # Linux/macOS
   rm metadata/com.codeshowoff.xpenc/en-US/phoneScreenshots/*_original

   # Windows PowerShell
   Remove-Item metadata\com.codeshowoff.xpenc\en-US\phoneScreenshots\*_original
   ```
4. Verify no diff is produced when `exiftool` runs again:
   ```bash
   exiftool -all= metadata/com.codeshowoff.xpenc/en-US/phoneScreenshots/*.jpeg
   git status
   ```

---

## 4. Committing and Pushing to GitLab

Once your changes are made in the shallow clone:

```bash
git add metadata/com.codeshowoff.xpenc/
git commit -m "fix: strip EXIF metadata from screenshots"
git push origin <your-branch>
```

Pushing to your fork's branch will automatically trigger the new GitLab CI pipeline on your open Merge Request.

---

## 5. Cleaning Up Local Space

Because this is a disposable working clone, delete the folder after pushing:

```bash
# Linux/macOS
rm -rf fdroiddata

# Windows PowerShell
Remove-Item -Recurse -Force fdroiddata
```

This keeps your local machine completely clean while pushing fixes to GitLab effortlessly.
