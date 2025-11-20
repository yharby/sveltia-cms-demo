# Sveltia CMS Demo - Minimal GitHub Setup

A minimal working example of Sveltia CMS with GitHub backend.

## 🚀 Quick Start

### 1. Set Up GitHub OAuth (Required for Production)

You need a GitHub OAuth app to authenticate with your repository.

#### Option A: Create OAuth App via GitHub Web Interface

1. Go to https://github.com/settings/developers
2. Click **"New OAuth App"**
3. Fill in the details:
   - **Application name:** `Sveltia CMS - [Your Site Name]`
   - **Homepage URL:** `https://your-site.com` (or `http://localhost:8080` for local)
   - **Authorization callback URL:** `https://your-site.com/admin/` (or `http://localhost:8080/admin/`)
4. Click **"Register application"**
5. Copy the **Client ID**
6. Click **"Generate a new client secret"** and copy it

#### Option B: Create OAuth App via GitHub CLI

```bash
gh api -X POST /user/applications \
  -f name="Sveltia CMS Demo" \
  -f url="http://localhost:8080" \
  -f callback_url="http://localhost:8080/admin/"
```

#### Option C: Use Sveltia CMS OAuth Client (Easiest!)

Sveltia CMS provides a free OAuth client you can use:

**No setup needed!** Just use these credentials in production:
- Client ID: Provided by Sveltia (check their docs)
- Or use their hosted OAuth service

---

### 2. Local Development (No OAuth Needed!)

For local testing, you can use Sveltia CMS's **local repository** feature:

```bash
# 1. Clone this repository
git clone https://github.com/yharby/sveltia-cms-demo.git
cd sveltia-cms-demo

# 2. Start a local web server (choose one)

# Option A: Python
python3 -m http.server 8080 -d public

# Option B: Node.js (http-server)
npx http-server public -p 8080

# Option C: PHP
php -S localhost:8080 -t public

# 3. Open in Chrome/Edge (required for local repo feature)
# http://localhost:8080/admin/
```

**In the CMS:**
1. Click **"Work with Local Repository"**
2. Select this project's root folder
3. Edit content locally without pushing to GitHub!

---

### 3. Production Deployment

#### A. Deploy to Netlify (Recommended)

```bash
# 1. Install Netlify CLI
npm install -g netlify-cli

# 2. Deploy
netlify deploy --prod

# 3. Configure OAuth
# Go to: Site settings → Access control → OAuth
# Add your GitHub OAuth app credentials
```

#### B. Deploy to Cloudflare Pages

```bash
# 1. Install Wrangler
npm install -g wrangler

# 2. Deploy
wrangler pages deploy public
```

#### C. Deploy to GitHub Pages

```yaml
# .github/workflows/deploy.yml
name: Deploy to GitHub Pages

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Deploy to GitHub Pages
        uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./public
```

---

## 📁 Project Structure

```
sveltia-cms-demo/
├── public/
│   └── admin/
│       ├── index.html          # CMS interface
│       └── config.yml          # CMS configuration
├── content/
│   ├── blog/                   # Blog posts (Markdown)
│   ├── pages/                  # Pages (Markdown)
│   └── settings/
│       └── general.yml         # Site settings
├── static/
│   └── images/                 # Uploaded images
└── README.md
```

---

## 🎨 Content Collections

### Blog Posts
- Location: `content/blog/`
- Format: Markdown with YAML front matter
- Fields: title, date, author, description, featured_image, tags, body

### Pages
- Location: `content/pages/`
- Format: Markdown with YAML front matter
- Fields: title, description, body

### Site Settings
- Location: `content/settings/general.yml`
- Format: YAML
- Fields: site_title, site_description, site_url, logo

---

## 🔧 Configuration

### Backend (GitHub)

```yaml
backend:
  name: github
  repo: yharby/sveltia-cms-demo
  branch: main
```

### Media Storage

```yaml
media_folder: static/images    # Where files are stored
public_folder: /images          # Public URL path
```

---

## 🌍 Sign In Options

### 1. **GitHub OAuth** (Production)
- Requires OAuth app setup
- Best for deployed sites
- Multiple users supported

### 2. **Personal Access Token** (Quick Setup)
- No OAuth app needed
- Good for personal projects
- Single user only

**To use PAT:**
1. Go to https://github.com/settings/tokens
2. Generate new token (classic)
3. Select scopes: `repo`
4. Copy the token
5. In CMS, click "Sign in with GitHub PAT"
6. Paste your token

### 3. **Local Repository** (Development)
- No authentication needed
- Chrome/Edge only
- Perfect for local testing

---

## 📝 Creating Your First Post

### Via CMS Interface

1. Open http://localhost:8080/admin/
2. Sign in (PAT or local repo)
3. Click **"Blog Posts"** → **"New Blog Post"**
4. Fill in the fields:
   - Title: "My First Post"
   - Date: [Today's date]
   - Author: "Your Name"
   - Description: "This is my first blog post"
   - Content: Write your post in Markdown
5. Click **"Save"**
6. Commit is automatically created!

### Manually (Git)

Create `content/blog/2025-11-20-my-first-post.md`:

```markdown
---
title: My First Post
date: 2025-11-20T10:00:00.000Z
author: Your Name
description: This is my first blog post
tags:
  - tutorial
  - getting-started
---

# Hello World!

This is my first blog post using **Sveltia CMS**.

## Features I Love

- Easy to use
- Git-based
- Fast and lightweight
- Mobile-friendly
```

---

## 🎯 Next Steps

### 1. Customize Collections

Edit `public/admin/config.yml` to add/modify collections:

```yaml
collections:
  - name: products
    label: Products
    folder: content/products
    create: true
    fields:
      - { name: title, label: Product Name, widget: string }
      - { name: price, label: Price, widget: number }
      - { name: image, label: Product Image, widget: image }
      - { name: description, label: Description, widget: markdown }
```

### 2. Add Geospatial Data

```yaml
fields:
  - name: location
    label: Location
    widget: map
    type: Point
    decimals: 7
```

### 3. Enable i18n

```yaml
i18n:
  structure: multiple_folders
  locales: [en, es, fr]
  default_locale: en

collections:
  - name: blog
    i18n: true
    fields:
      - { name: title, label: Title, widget: string, i18n: true }
```

---

## 🔍 Troubleshooting

### CMS shows "Config not found"
- Check that `public/admin/config.yml` exists
- Verify web server is serving from `public/` directory

### Can't sign in with GitHub
- For local testing, use "Work with Local Repository"
- For production, verify OAuth app credentials
- Try using Personal Access Token

### Files not appearing in CMS
- Check `folder` paths in config.yml
- Ensure files have proper front matter
- Verify file extensions match collection format

### Local repository not working
- Use Chrome or Edge (Firefox/Safari not supported)
- Ensure you selected the project root folder
- Check browser console for errors

---

## 📚 Resources

- **Sveltia CMS Docs:** https://github.com/sveltia/sveltia-cms
- **Configuration Reference:** See comparison docs in this repo
- **GitHub Backend:** https://docs.github.com/en/developers/apps
- **OAuth Setup:** https://github.com/sveltia/sveltia-cms-auth

---

## 🎉 Features Demonstrated

- ✅ GitHub backend integration
- ✅ Multiple collection types
- ✅ File and folder collections
- ✅ Markdown content editing
- ✅ Image uploads
- ✅ List fields (tags)
- ✅ Date/time fields
- ✅ Local repository workflow

---

## 💡 Tips

1. **Use local repository** for development (no GitHub commits needed)
2. **Use PAT** for quick personal projects (no OAuth setup)
3. **Use OAuth** for production with multiple users
4. **Test locally first** before deploying
5. **Commit often** - all changes are version controlled

---

**Repository:** https://github.com/yharby/sveltia-cms-demo
**Created with:** Sveltia CMS 0.118.1 (Beta)
