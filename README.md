# n8n with Cloudflare Tunnel

Simple n8n setup with PostgreSQL and Cloudflare free tunnel for secure public access.

## Quick Start

### 1. Create Tunnel URL
```bash
make tunnel
```
This will:
- Start cloudflared and get a random tunnel URL
- Create `.env.local` with the `WEBHOOK_URL`
- Print the public URL

### 2. Start n8n
```bash
docker compose up -d
```

### 3. Access n8n
- **Local**: http://localhost:5678
- **Public**: https://random-words-1234.trycloudflare.com (from step 1)
- **Login**: admin / admin

## ⚠️ Important Warning

**If you stop or restart cloudflared, you will lose the tunnel URL!**

When this happens:
1. Run `make tunnel` again to get a new URL
2. Update your webhook URLs in existing workflows
3. Restart n8n: `docker compose restart n8n`

## Commands

- `make tunnel` - Create new tunnel URL and update `.env.local`
- `make clean` - Stop all services and remove config
- `docker compose up -d` - Start all services
- `docker compose logs cloudflared` - Check tunnel logs
- `docker compose down` - Stop all services

## Notes

- Tunnel URLs are temporary and change on restart
- Perfect for development and testing
- No Cloudflare account required
- SSL encryption included automatically
