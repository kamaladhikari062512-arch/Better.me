# Better Me — Personal Growth Tracker

A lightweight installable PWA made for your six-month self-improvement plan.

## Features
- Daily habit checklist and 180-day journey counter
- Six-month roadmap
- Skill focus and weekly hours tracker
- Fitness, sleep, weight and nutrition notes
- NPR 50 daily spending tracker
- Daily reflection journal
- Copyable AI-coach prompt for ChatGPT
- Local device storage, offline caching, and JSON data export

## Install on Android (free)
A PWA must be served from an HTTPS website to be installable. The easiest route:
1. Create a free account at GitHub.
2. Create a new public repository, e.g. `better-me-tracker`.
3. Upload all files from this folder to the repository root.
4. In the repository, open **Settings → Pages**.
5. Under Build and deployment, choose **Deploy from a branch**, select `main` and `/ (root)`, then Save.
6. Wait for GitHub Pages to publish. Open the published HTTPS link in Chrome on your Android phone.
7. Tap **Install app** if shown, or Chrome menu (⋮) → **Add to Home screen** / **Install app**.

You can also deploy this folder using Netlify Drop (drag the folder contents into the Netlify deploy page) or another HTTPS static host.

## Run locally
Open `index.html` in a desktop browser to test the tracker. Browser installation/offline features require HTTPS or localhost.

## Data and privacy
Your tracker data is stored in localStorage in the browser on that device. It is not synced to the cloud and is not automatically sent to ChatGPT. Use **Export my data** regularly to create a backup. Clearing browser data or changing phones may erase your records unless you export and restore them manually.

## AI coach
The AI Coach tab creates a prompt you can copy into ChatGPT. It does not call an AI API automatically. No API key is required.
