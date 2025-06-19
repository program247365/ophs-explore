# OPHS Course Explorer - Makefile
# Default port for local development
PORT ?= 8000
HOST ?= localhost

# Default target (runs when you just type 'make')
.DEFAULT_GOAL := help

.PHONY: help serve open browse stop clean dev

help: ## 📚 Show this help message with all available tasks
	@echo "🎓 OPHS Course Explorer - Available Tasks"
	@echo "========================================="
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'
	@echo ""
	@echo "Examples:"
	@echo "  make serve    # Start the web server"
	@echo "  make browse   # Start server and open browser"
	@echo "  make dev      # Full development setup"

serve: ## 🌐 Start local web server to view the site
	@echo "🚀 Starting OPHS Course Explorer on http://$(HOST):$(PORT)"
	@echo "📝 Press Ctrl+C to stop the server"
	@echo ""
	@if command -v python3 >/dev/null 2>&1; then \
		python3 -m http.server $(PORT) --bind $(HOST); \
	elif command -v python >/dev/null 2>&1; then \
		python -m http.server $(PORT) --bind $(HOST); \
	else \
		echo "❌ Error: Python not found. Please install Python to run the web server."; \
		exit 1; \
	fi

open: ## 🔗 Open the site in your default browser (server must be running)
	@echo "🌐 Opening OPHS Course Explorer in your browser..."
	@if command -v open >/dev/null 2>&1; then \
		open "http://$(HOST):$(PORT)"; \
	elif command -v xdg-open >/dev/null 2>&1; then \
		xdg-open "http://$(HOST):$(PORT)"; \
	elif command -v start >/dev/null 2>&1; then \
		start "http://$(HOST):$(PORT)"; \
	else \
		echo "📋 Please manually open: http://$(HOST):$(PORT)"; \
	fi

browse: ## 🚀 Start server and automatically open browser
	@echo "🎯 Starting OPHS Course Explorer and opening browser..."
	@make open &
	@sleep 2
	@make serve

dev: browse ## 🛠️  Full development setup (alias for browse)

stop: ## ⛔ Instructions to stop the running server
	@echo "To stop the web server:"
	@echo "  Press Ctrl+C in the terminal where the server is running"
	@echo "  Or use: killall python3 (if using python3)"

clean: ## 🧹 Clean up any temporary files
	@echo "🧹 Cleaning up temporary files..."
	@find . -name "*.pyc" -delete 2>/dev/null || true
	@find . -name "__pycache__" -type d -exec rm -rf {} + 2>/dev/null || true
	@find . -name ".DS_Store" -delete 2>/dev/null || true
	@echo "✅ Cleanup complete"

check: ## ✅ Verify that index.html exists and is readable
	@echo "🔍 Checking OPHS Course Explorer files..."
	@if [ -f "index.html" ]; then \
		echo "✅ index.html found"; \
		if [ -r "index.html" ]; then \
			echo "✅ index.html is readable"; \
			echo "📊 File size: $$(wc -c < index.html) bytes"; \
		else \
			echo "❌ index.html is not readable"; \
			exit 1; \
		fi; \
	else \
		echo "❌ index.html not found in current directory"; \
		echo "📂 Current directory: $$(pwd)"; \
		echo "📋 Available files: $$(ls -la)"; \
		exit 1; \
	fi

install: ## 📦 Check and install dependencies (Python)
	@echo "📦 Checking dependencies for OPHS Course Explorer..."
	@if ! command -v python3 >/dev/null 2>&1 && ! command -v python >/dev/null 2>&1; then \
		echo "❌ Python not found. Please install Python 3.x"; \
		echo "📋 Visit: https://www.python.org/downloads/"; \
		exit 1; \
	else \
		echo "✅ Python is installed"; \
		if command -v python3 >/dev/null 2>&1; then \
			echo "🐍 Python version: $$(python3 --version)"; \
		else \
			echo "🐍 Python version: $$(python --version)"; \
		fi; \
	fi

info: ## ℹ️  Show project information and current status
	@echo "🎓 OPHS Course Explorer - Project Info"
	@echo "====================================="
	@echo "📂 Project Directory: $$(pwd)"
	@echo "🌐 Default Server URL: http://$(HOST):$(PORT)"
	@echo "📋 Main File: index.html"
	@echo ""
	@make check
	@echo ""
	@make install 