# 🚀 FAST Delivery — Deployment Guide

Complete guide to deploy the FAST Delivery application to production.

---

## Quick Deploy Options

### Option 1: Vercel (Recommended — Fastest)

#### Step 1: Push to GitHub
```bash
git remote add origin https://github.com/YOUR_USERNAME/fast-delivery.git
git push -u origin main
```

#### Step 2: Connect to Vercel
1. Go to [vercel.com/new](https://vercel.com/new)
2. Import your GitHub repository
3. Vercel auto-detects Next.js — no config needed
4. Add environment variable: `DATABASE_URL` = `file:./db/custom.db`
5. Click **Deploy**

#### Step 3: Seed the Database
After deployment, visit: `https://your-app.vercel.app/api/seed`
This populates the database with demo data.

---

### Option 2: Docker (Self-Hosted)

```bash
# Build and run
docker-compose up -d

# Or build manually
docker build -t fast-delivery .
docker run -p 3000:3000 fast-delivery

# Seed the database
curl -X POST http://localhost:3000/api/seed
```

---

### Option 3: VPS / Cloud Server

```bash
# Clone the repo
git clone https://github.com/YOUR_USERNAME/fast-delivery.git
cd fast-delivery

# Install dependencies
npm install

# Generate Prisma client
npx prisma generate

# Build for production
npm run build

# Start the server
npm run start

# Seed the database (in another terminal)
curl -X POST http://localhost:3000/api/seed
```

---

### Option 4: Railway / Render (PaaS)

1. Connect your GitHub repo
2. Set build command: `npm run build`
3. Set start command: `npm run start`
4. Add env var: `DATABASE_URL`
5. Deploy

---

## GitHub Actions CI/CD

The `.github/workflows/ci-cd.yml` file provides:

- **On every push**: Lint + Type Check + Build Test
- **On push to main**: Auto-deploy to Vercel production
- **On Pull Requests**: Deploy preview

### Required GitHub Secrets
| Secret | Description |
|--------|-------------|
| `VERCEL_TOKEN` | Your Vercel API token (from vercel.com/account/tokens) |

---

## Environment Variables

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `DATABASE_URL` | Yes | `file:./db/custom.db` | Prisma database connection |

---

## Demo Credentials

| Role | Phone | Password |
|------|-------|----------|
| Customer (Dharsan) | 9876543210 | pass123 |
| Shop Owner (Rajesh) | 9876543211 | pass123 |
| Super Admin | 9876543212 | admin123 |

---

## API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | /api/seed | Seed database with demo data |
| POST | /api/auth/login | User authentication |
| GET | /api/products | List products (filter by category, shopId, search) |
| GET/POST/DELETE | /api/cart | Cart CRUD |
| GET/POST/PATCH | /api/orders | Order management |
| GET | /api/fleet | Drone fleet + stats |
| GET | /api/analytics | Revenue, metrics, top shops |
| GET | /api/shop/dashboard | Shop owner dashboard |
| GET/POST | /api/chat | AI assistant (real LLM) |
