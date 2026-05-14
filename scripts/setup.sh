#!/usr/bin/env bash
# PAI for Windows — one-shot setup script
# Usage: bash scripts/setup.sh

set -euo pipefail

echo "=== PAI for Windows Setup ==="
echo ""

# Check WSL
if ! grep -qi microsoft /proc/version 2>/dev/null; then
  echo "Warning: this script is designed for WSL2. Proceeding anyway..."
fi

# Check Bun
if ! command -v bun &>/dev/null; then
  echo "Installing Bun..."
  curl -fsSL https://bun.sh/install | bash
  export PATH="$HOME/.bun/bin:$PATH"
fi
echo "✓ Bun $(bun --version)"

# Check Claude Code
if ! command -v claude &>/dev/null; then
  echo ""
  echo "Claude Code is required but not installed."
  echo "Install it from: https://claude.ai/code"
  exit 1
fi
echo "✓ Claude Code $(claude --version 2>/dev/null || echo 'installed')"

# Create PAI directory structure
PAI_DIR="$HOME/.claude/PAI"
mkdir -p "$PAI_DIR/MEMORY" "$PAI_DIR/USER/Config" "$PAI_DIR/PULSE/logs" "$PAI_DIR/PULSE/state"

echo "✓ PAI directory structure created at $PAI_DIR"

# Copy config template if not present
CONFIG_DEST="$HOME/.claude/PAI/USER/Config/PAI_CONFIG.yaml"
if [ ! -f "$CONFIG_DEST" ]; then
  cp config/pulse.toml.example "$HOME/.claude/PAI/PULSE/PULSE.toml" 2>/dev/null || true
  echo "✓ Config template copied — edit $CONFIG_DEST to customize"
fi

# Install systemd service for Pulse
SERVICE_DIR="$HOME/.config/systemd/user"
mkdir -p "$SERVICE_DIR"

cat > "$SERVICE_DIR/pulse.service" << 'EOF'
[Unit]
Description=PAI Pulse — personal AI daemon (port 31337)
After=network.target

[Service]
Type=simple
WorkingDirectory=%h/.claude/PAI/PULSE
ExecStart=%h/.bun/bin/bun run pulse.ts
Environment=PAI_PULSE_BIND_ALL=1
Restart=on-failure
RestartSec=5
StandardOutput=append:%h/.claude/PAI/PULSE/logs/pulse.log
StandardError=append:%h/.claude/PAI/PULSE/logs/pulse.log

[Install]
WantedBy=default.target
EOF

systemctl --user daemon-reload
systemctl --user enable pulse
echo "✓ Pulse systemd service installed and enabled"

echo ""
echo "=== Setup complete ==="
echo ""
echo "Start Pulse:    systemctl --user start pulse"
echo "Dashboard:      http://localhost:31337"
echo "Logs:           tail -f ~/.claude/PAI/PULSE/logs/pulse.log"
