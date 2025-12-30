# Vijay Mourya - Portfolio Website

Personal portfolio website for Vijay Mourya - Senior DevOps & Infrastructure Reliability Engineer

**Live Site:** [vijayrmourya.github.io](https://vijayrmourya.github.io)

---

## Features

- 📚 **Dynamic Medium Posts** - Automatically fetched from Medium RSS feed
- 🎓 **Course Certificates** - Auto-generated from PDF files
- 🎨 **Modern UI** - Dark theme with responsive design
- ⚡ **Static Site** - Fast loading with client-side rendering

---

## Tech Stack

- HTML, CSS, JavaScript (Vanilla)
- Python 3.11 (automation scripts)
- GitHub Actions (CI/CD)
- GitHub Pages (hosting)

---

## Local Development

```bash
# Clone repository
git clone https://github.com/vijayrmourya/vijaymourya-master.git
cd vijaymourya-master

# Start local server
python3 -m http.server 8000

# Open browser at http://localhost:8000
```

---

## Adding New Certificates

```bash
# Add PDF to appropriate folder
cp ~/Downloads/cert.pdf assets/certificates/AWS/

# Commit and push
git add assets/certificates/
git commit -m "Add new certification"
git push

# GitHub Actions automatically updates the website
```

---

## Automation

Two GitHub Actions workflows run automatically:

1. **Medium Posts** - Daily at 6:00 AM UTC
   - Fetches latest posts from Medium RSS
   - Updates `assets/medium_posts.json`

2. **Certificates** - Daily at 12:00 PM UTC + on PDF changes
   - Scans PDFs in `assets/certificates/`
   - Updates `assets/certificates.json`

---

## Project Structure

```
vijaymourya-master/
├── *.html              # Website pages
├── scripts.js          # Dynamic content rendering
├── styles.css          # Styling
├── assets/             # Images, certificates, generated data
├── tools/              # Python automation scripts
└── .github/workflows/  # GitHub Actions
```

---

## Configuration

**Medium Posts:** Edit `.github/workflows/fetch_medium.yml`
```yaml
env:
  MEDIUM_USERNAME: vjmourya
  MAX_POSTS: '6'
```

**Certificate Categories:** Edit `tools/generate_certificates.py`

---

## License

© 2025 Vijay Mourya. All rights reserved.

---

**Built with HTML, CSS, JavaScript, Python & GitHub Actions**

