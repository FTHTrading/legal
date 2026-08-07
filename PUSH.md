# Pushing this repo to github.com/FTHTrading/legal

This working directory is ready to push. From this directory (`C:\Users\Kevan\legal-repo\`):

```powershell
git init
git add .
git commit -m "Initial commit — legal-ops public documentation site"
git branch -M main
git remote add origin https://github.com/FTHTrading/legal.git
git push -u origin main
```

## Then enable GitHub Pages

1. Go to https://github.com/FTHTrading/legal/settings/pages
2. Under **Build and deployment**:
   - Source: **Deploy from a branch**
   - Branch: **main** / **`/ (root)`**
3. Click **Save**
4. Wait ~30 seconds; site publishes to:

**https://fthtrading.github.io/legal/**

## Verify

Once Pages reports "Your site is live at ...", run:

```powershell
Invoke-WebRequest -Uri https://fthtrading.github.io/legal/ | Select-Object -ExpandProperty StatusCode
# 200 = live
```

Also spot-check the `_ds/` CSS loads (this is why `.nojekyll` is in the root):

```powershell
Invoke-WebRequest -Uri https://fthtrading.github.io/legal/_ds/tokens.css | Select-Object -ExpandProperty StatusCode
# 200 = design system loading correctly
```

## Preview locally before pushing

```powershell
cd C:\Users\Kevan\legal-repo
python -m http.server 8080
# Then open http://localhost:8080/ in your browser
```

or with Node:

```powershell
npx --yes http-server -p 8080 .
```

## File inventory

```
.
├── .nojekyll                            (required — makes _ds/ serve)
├── index.html                           (main single-page site)
├── README.md                            (GitHub repo landing)
├── LICENSE                              (MIT)
├── NOTICE-NOT-LEGAL-ADVICE.md           (UPL discipline)
├── PUSH.md                              (this file)
├── _ds/
│   ├── tokens.css                       (color palette + typography)
│   ├── layout.css                       (sidebar TOC + hero)
│   ├── components.css                   (cards, tables, badges, callouts)
│   └── print.css                        (PDF export stylesheet)
└── _assets/
    └── spv-input.example.json           (sample SPV-in-a-Box input)
```
