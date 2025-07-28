.PHONY: tunnel clean

tunnel: clean
	@echo "🚇 Starting cloudflared tunnel..."
	@touch .env.local
	@docker compose up -d cloudflared
	@echo "⏳ Waiting for tunnel URL (this may take 30-60 seconds)..."
	@timeout=60; \
	while [ $$timeout -gt 0 ]; do \
		TUNNEL_URL=$$(docker compose logs cloudflared 2>&1 | grep -o 'https://[^[:space:]]*\.trycloudflare\.com' | tail -1); \
		if [ -n "$$TUNNEL_URL" ]; then \
			echo "✅ Tunnel URL: $$TUNNEL_URL"; \
			echo "WEBHOOK_URL=$$TUNNEL_URL/" > .env.local; \
			echo "📝 Created .env.local with WEBHOOK_URL=$$TUNNEL_URL/"; \
			echo "🎉 Ready! Run 'docker compose up -d' to start n8n"; \
			exit 0; \
		fi; \
		sleep 2; \
		timeout=$$((timeout-2)); \
		printf "."; \
	done; \
	echo ""; \
	echo "❌ Timeout waiting for tunnel URL. Check logs:"; \
	docker compose logs cloudflared; \
	echo ""; \
	echo "💡 Try running 'make tunnel' again or check if cloudflared is working properly"

clean:
	@echo "🧹 Cleaning up..."
	@docker compose down
	@rm -f .env.local
	@echo "✅ Cleanup complete"
