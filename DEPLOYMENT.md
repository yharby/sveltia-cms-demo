# 🚀 Deployment Guide - Sveltia CMS Demo

Complete guide for deploying your Sveltia CMS to production with GitHub Pages (fully automated).

---

## 📋 Table of Contents

1. [Quick Deploy](#quick-deploy-3-steps)
2. [GitHub Pages (Automated)](#github-pages-automated-deployment)
3. [OAuth Setup](#oauth-authentication-setup)
4. [Alternative Hosting](#alternative-hosting-platforms)
5. [Troubleshooting](#troubleshooting)

---

## 🚀 Quick Deploy (3 Steps)

### **Everything is already automated! Just:**

```bash
# 1. Set up OAuth (guided wizard)
./setup-oauth.sh

# 2. Commit and push
git add .
git commit -m "Configure for production deployment"
git push

# 3. Wait for deployment (1-2 minutes)
# Check: https://github.com/yharby/sveltia-cms-demo/actions
```

**That's it!** Your site will be live at:
- **Site:** https://yharby.github.io/sveltia-cms-demo/
- **CMS Admin:** https://yharby.github.io/sveltia-cms-demo/admin/

---

## 🏗️ GitHub Pages (Automated Deployment)

### ✅ **Already Configured!**

This repository has **GitHub Actions** set up to automatically deploy to GitHub Pages whenever you push to the `main` branch.

### What's Automated:

- ✅ **GitHub Pages enabled** (via gh CLI)
- ✅ **GitHub Actions workflow** created (`.github/workflows/deploy.yml`)
- ✅ **Auto-deployment** on every push to `main`
- ✅ **HTTPS** enabled automatically
- ✅ **Custom domain** support (optional)

### Deployment Process:

1. **Push to GitHub:**
   ```bash
   git push origin main
   ```

2. **GitHub Actions runs automatically:**
   - Checks out your code
   - Deploys the `public/` folder
   - Updates GitHub Pages

3. **Site goes live:**
   - Usually takes 1-2 minutes
   - Check progress: https://github.com/yharby/sveltia-cms-demo/actions

### Monitor Deployment:

```bash
# Check deployment status
gh run list --limit 5

# View latest run
gh run view

# Watch deployment in real-time
gh run watch
```

---

## 🔐 OAuth Authentication Setup

### **Option 1: Automated Setup Script (Recommended)** ⭐

Run the included setup script:

```bash
./setup-oauth.sh
```

**What it does:**
- ✅ Opens GitHub OAuth app creation page
- ✅ Provides all required details pre-filled
- ✅ Guides you through the process
- ✅ Stores credentials securely (optional)
- ✅ Shows multiple integration options

**Details it provides:**
- **Application name:** Sveltia CMS - sveltia-cms-demo
- **Homepage URL:** https://yharby.github.io/sveltia-cms-demo
- **Authorization callback URL:** https://yharby.github.io/sveltia-cms-demo/admin/

---

### **Option 2: Sveltia's Free OAuth Service** (Easiest!) 🎉

**No GitHub OAuth app needed!**

1. **Uncomment this line** in `public/admin/config.yml`:
   ```yaml
   auth_endpoint: https://sveltia-cms-auth.cloudflare.dev
   ```

2. **That's it!** Sveltia provides free OAuth service.

**Pros:**
- ✅ No setup required
- ✅ Free forever
- ✅ Maintained by Sveltia team
- ✅ Works out of the box

**Cons:**
- ⚠️ Shared service (privacy-conscious users may prefer own OAuth app)

---

### **Option 3: Manual OAuth App Creation**

If the script doesn't work, create manually:

1. **Go to:** https://github.com/settings/applications/new

2. **Fill in:**
   ```
   Application name:      Sveltia CMS - sveltia-cms-demo
   Homepage URL:          https://yharby.github.io/sveltia-cms-demo
   Authorization callback URL: https://yharby.github.io/sveltia-cms-demo/admin/
   ```

3. **Click:** "Register application"

4. **Copy** Client ID

5. **Generate** new client secret and copy it

6. **Store credentials** (choose one):

   **A. GitHub Secrets (for workflows):**
   ```bash
   gh secret set OAUTH_CLIENT_ID --body "your-client-id"
   gh secret set OAUTH_CLIENT_SECRET --body "your-client-secret"
   ```

   **B. Netlify (if using Netlify hosting):**
   - Site settings → Access control → OAuth
   - Install GitHub provider
   - Enter credentials

   **C. Environment variables (other platforms):**
   ```
   OAUTH_CLIENT_ID=your-client-id
   OAUTH_CLIENT_SECRET=your-client-secret
   ```

---

## 🌐 Alternative Hosting Platforms

### **Netlify** (Recommended for Beginners)

**Automated deployment:**

```bash
# 1. Install Netlify CLI
npm install -g netlify-cli

# 2. Deploy (one command!)
netlify deploy --prod --dir=public

# 3. Configure OAuth
# Go to: Site settings → Access control → OAuth
# Add GitHub provider with your credentials
```

**Or connect GitHub repo:**
1. Go to https://app.netlify.com/
2. Click "Add new site" → "Import an existing project"
3. Select GitHub → `yharby/sveltia-cms-demo`
4. Build settings:
   - Build command: (leave empty)
   - Publish directory: `public`
5. Deploy!

**OAuth setup in Netlify:**
- Automatically handled!
- Or add manually in site settings

---

### **Cloudflare Pages**

**Automated deployment:**

```bash
# 1. Install Wrangler
npm install -g wrangler

# 2. Login
wrangler login

# 3. Deploy
wrangler pages deploy public --project-name sveltia-cms-demo

# 4. Configure OAuth (environment variables)
wrangler pages secret put OAUTH_CLIENT_ID
wrangler pages secret put OAUTH_CLIENT_SECRET
```

**Or connect GitHub repo:**
1. Go to https://dash.cloudflare.com/
2. Pages → Create a project
3. Connect to Git → Select repository
4. Build settings:
   - Build command: (none)
   - Build output: `public`
5. Deploy!

---

### **Vercel**

```bash
# 1. Install Vercel CLI
npm install -g vercel

# 2. Deploy
vercel --prod

# 3. Configure
# Vercel automatically detects static site
# Add OAuth credentials as environment variables
```

---

### **Custom Server / VPS**

```bash
# 1. Build/copy public folder to server
scp -r public/ user@yourserver:/var/www/sveltia-cms-demo/

# 2. Configure Nginx
server {
    listen 80;
    server_name your-domain.com;
    root /var/www/sveltia-cms-demo/public;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }

    # Admin area
    location /admin {
        try_files $uri $uri/ /admin/index.html;
    }
}

# 3. Enable HTTPS (required!)
sudo certbot --nginx -d your-domain.com
```

---

## 🎯 Post-Deployment Checklist

After deploying, verify everything works:

### ✅ **Site Access**
- [ ] Homepage loads: https://yharby.github.io/sveltia-cms-demo/
- [ ] Admin page loads: https://yharby.github.io/sveltia-cms-demo/admin/
- [ ] HTTPS is enabled (🔒 in browser)

### ✅ **CMS Functionality**
- [ ] CMS interface loads without errors
- [ ] Can sign in with GitHub
- [ ] Can view existing content
- [ ] Can create new content
- [ ] Can upload images
- [ ] Can save changes
- [ ] Changes commit to GitHub

### ✅ **OAuth Setup**
- [ ] OAuth app created on GitHub
- [ ] Credentials stored securely
- [ ] Callback URL matches deployed site
- [ ] Sign-in flow works

---

## 🔧 Configuration for Production

### Update Config for Your Domain

If using custom domain, edit `public/admin/config.yml`:

```yaml
backend:
  name: github
  repo: yharby/sveltia-cms-demo
  branch: main
  base_url: https://your-domain.com  # Change this

site_url: https://your-domain.com    # Change this
media_folder: static/images
public_folder: /images               # Remove repo name for custom domain
```

### Update OAuth Callback URL

If changing domain:
1. Go to https://github.com/settings/developers
2. Find your OAuth app
3. Update "Authorization callback URL"
4. Save changes

---

## 🚨 Troubleshooting

### GitHub Actions fails to deploy

**Check:**
```bash
# View error logs
gh run view --log-failed

# Check Pages settings
gh api repos/yharby/sveltia-cms-demo/pages
```

**Common fixes:**
- Ensure Pages is enabled: Repository Settings → Pages → Source: GitHub Actions
- Check workflow permissions: Settings → Actions → General → Workflow permissions → Read and write

---

### OAuth errors ("Authentication Aborted")

**Fixes:**
1. **Verify callback URL matches exactly:**
   - OAuth app: https://yharby.github.io/sveltia-cms-demo/admin/
   - Deployed site: Check what URL you're actually using

2. **Check COOP header** (if using custom server):
   ```nginx
   # Change from:
   Cross-Origin-Opener-Policy: same-origin
   # To:
   Cross-Origin-Opener-Policy: same-origin-allow-popups
   ```

3. **Use Sveltia's OAuth service** (bypass entirely):
   ```yaml
   auth_endpoint: https://sveltia-cms-auth.cloudflare.dev
   ```

---

### CMS loads but can't access content

**Fixes:**
1. **Check public_folder path:**
   - GitHub Pages: `/repo-name/images`
   - Custom domain: `/images`

2. **Verify backend config:**
   ```yaml
   backend:
     repo: yharby/sveltia-cms-demo  # Correct format
   ```

3. **Check browser console** for errors

---

### Images/media not loading

**Fix media paths in config.yml:**

For GitHub Pages (username.github.io/repo):
```yaml
public_folder: /sveltia-cms-demo/images
```

For custom domain:
```yaml
public_folder: /images
```

---

## 📊 Deployment Status

**Check deployment status anytime:**

```bash
# CLI
gh run list

# Web
https://github.com/yharby/sveltia-cms-demo/actions

# Status badge (add to README)
![Deploy](https://github.com/yharby/sveltia-cms-demo/actions/workflows/deploy.yml/badge.svg)
```

---

## 🔄 Continuous Deployment

**How it works:**

1. **Edit content** in CMS
2. **Save** → Commits to GitHub
3. **GitHub Actions** detects push
4. **Automatically deploys** to GitHub Pages
5. **Site updates** in 1-2 minutes

**No manual intervention needed!**

---

## 🎉 Success!

Your Sveltia CMS is now:
- ✅ Deployed to production
- ✅ Accessible at your live URL
- ✅ Auto-deploying on every change
- ✅ Secured with OAuth
- ✅ Ready for content editing

**Happy content creating!** 🚀

---

## 📚 Additional Resources

- **GitHub Pages Docs:** https://docs.github.com/pages
- **GitHub Actions:** https://docs.github.com/actions
- **Sveltia CMS:** https://github.com/sveltia/sveltia-cms
- **OAuth Apps:** https://docs.github.com/developers/apps/building-oauth-apps

---

**Deployed:** https://yharby.github.io/sveltia-cms-demo/
**Repository:** https://github.com/yharby/sveltia-cms-demo
**CMS Admin:** https://yharby.github.io/sveltia-cms-demo/admin/
