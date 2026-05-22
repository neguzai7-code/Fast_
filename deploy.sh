#!/bin/bash
# ═══════════════════════════════════════════════════════════════════════
# FAST Delivery — One-Click Deploy Script
# ═══════════════════════════════════════════════════════════════════════
set -e

echo "🚀 FAST Delivery — Deployment Script"
echo "═══════════════════════════════════════"

# ─── Check Prerequisites ──────────────────────────────────────────────
check_command() {
  if ! command -v $1 &> /dev/null; then
    echo "❌ $1 is not installed. Please install it first."
    echo "   Install: $2"
    exit 1
  fi
  echo "✅ $1 found"
}

check_command git "https://git-scm.com/downloads"
check_command node "https://nodejs.org/en/download/"

# ─── Choose Deployment Target ─────────────────────────────────────────
echo ""
echo "Choose deployment target:"
echo "  1) Vercel (Recommended — Free tier, auto-SSL, global CDN)"
echo "  2) GitHub Pages (Static only — API routes won't work)"
echo "  3) Docker (Self-hosted, full control)"
echo "  4) VPS / Cloud Server (Manual setup)"
echo ""
read -p "Enter choice [1-4]: " choice

case $choice in
  1)
    echo ""
    echo "═══ Vercel Deployment ═══"
    
    # Check if Vercel CLI is installed
    if ! command -v vercel &> /dev/null; then
      echo "Installing Vercel CLI..."
      npm install -g vercel
    fi
    
    # Login to Vercel
    echo ""
    echo "📝 You'll be redirected to Vercel's login page in your browser."
    echo "   Please complete the authentication there."
    echo ""
    vercel login
    
    # Deploy
    echo ""
    echo "🚀 Deploying to Vercel..."
    vercel deploy --prod
    
    echo ""
    echo "✅ Deployed to Vercel!"
    echo "   Don't forget to seed the database:"
    echo "   curl -X POST https://YOUR-APP.vercel.app/api/seed"
    ;;
    
  2)
    echo ""
    echo "═══ GitHub Pages Deployment ═══"
    echo "⚠️  Note: GitHub Pages only serves static files."
    echo "   API routes won't work. Use Vercel or Docker for full functionality."
    echo ""
    read -p "GitHub username: " gh_user
    read -p "Repository name [fast-delivery]: " repo_name
    repo_name=${repo_name:-fast-delivery}
    
    git remote add origin "https://github.com/$gh_user/$repo_name.git" 2>/dev/null || true
    git push -u origin main
    echo "✅ Pushed to GitHub. Enable Pages in repo Settings → Pages"
    ;;
    
  3)
    echo ""
    echo "═══ Docker Deployment ═══"
    
    if ! command -v docker &> /dev/null; then
      echo "❌ Docker is not installed. Install: https://docs.docker.com/get-docker/"
      exit 1
    fi
    
    echo "Building Docker image..."
    docker-compose up -d --build
    
    echo ""
    echo "Waiting for server to start..."
    sleep 5
    
    echo "Seeding database..."
    curl -s -X POST http://localhost:3000/api/seed
    
    echo ""
    echo "✅ FAST Delivery is running at http://localhost:3000"
    ;;
    
  4)
    echo ""
    echo "═══ VPS / Cloud Server Deployment ═══"
    
    # Install dependencies
    echo "Installing dependencies..."
    npm install
    
    # Generate Prisma client
    echo "Generating Prisma client..."
    npx prisma generate
    
    # Build
    echo "Building for production..."
    npm run build
    
    # Seed
    echo "Seeding database..."
    npm run start &
    SERVER_PID=$!
    sleep 5
    curl -s -X POST http://localhost:3000/api/seed
    kill $SERVER_PID 2>/dev/null
    
    echo ""
    echo "✅ Build complete! Start with: npm run start"
    echo "   Or use PM2 for process management:"
    echo "   npm install -g pm2"
    echo "   pm2 start npm --name 'fast-delivery' -- start"
    ;;
    
  *)
    echo "Invalid choice. Exiting."
    exit 1
    ;;
esac

echo ""
echo "═══════════════════════════════════════"
echo "🎉 FAST Delivery is deployed!"
echo ""
echo "Demo Credentials:"
echo "  Customer:    9876543210 / pass123"
echo "  Shop Owner:  9876543211 / pass123"  
echo "  Super Admin: 9876543212 / admin123"
echo "═══════════════════════════════════════"
