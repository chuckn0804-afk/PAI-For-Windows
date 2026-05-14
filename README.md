# PAI for Windows

**Personal AI Infrastructure — Windows / WSL2 Edition**

PAI is a self-hosted, locally-running AI operating system that runs Claude as your personal digital assistant. This repo packages PAI for Windows users running WSL2, with setup scripts, skill packs, and a local dashboard.

## What You Get

- **FRIDAY** (or your own named DA) — a Claude-powered assistant that runs 24/7 on your machine
- **Pulse** — a local web dashboard at `http://localhost:31337` with chat, observability, and health monitoring
- **Telegram integration** — message your assistant from your phone
- **Skills** — composable AI workflows (research, writing, security audits, and more)
- **Memory system** — your assistant remembers context across sessions

## Requirements

- Windows 10/11 with WSL2
- Ubuntu 22.04+ (WSL distro)
- [Bun](https://bun.sh) runtime
- [Claude Code](https://claude.ai/code) (provides the AI engine)

## Quick Start

```bash
# 1. Clone the repo
git clone https://github.com/chuckn0804-afk/PAI-For-Windows.git
cd PAI-For-Windows

# 2. Run the setup script
bash scripts/setup.sh

# 3. Start the Pulse daemon
systemctl --user start pulse

# 4. Open the dashboard
# Navigate to http://localhost:31337 in your browser
```

## Project Structure

```
PAI-For-Windows/
├── scripts/          # Setup and maintenance scripts
│   ├── setup.sh      # One-shot installer
│   └── update.sh     # Pull latest PAI updates
├── skills/           # AI skill packs (composable workflows)
│   ├── SKILL.md      # Skill system documentation
│   └── FindSources.md # Research skill
├── config/           # Example configuration files
│   └── pulse.toml    # Pulse daemon config template
└── docs/             # Extended documentation
    └── LAN-Access.md # Expose Pulse to your local network
```

## LAN Access

Pulse can be exposed to your home network so you can chat from any device:

```bash
# Add to ~/.claude/.env
PAI_PULSE_BIND_ALL=1
systemctl --user restart pulse
```

Then access from any device at `http://<your-wsl-ip>:31337`.

## Windows Firewall

To allow LAN access through the Windows firewall, run in elevated PowerShell:

```powershell
New-NetFirewallRule -DisplayName "PAI Pulse" -Direction Inbound -Protocol TCP -LocalPort 31337 -Action Allow
```

## Skills

Skills are composable AI workflows that extend what your assistant can do. Drop `.md` workflow files into the `skills/` directory and they become available automatically.

See [skills/SKILL.md](skills/SKILL.md) for authoring documentation.

## Contributing

PRs welcome. See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## License

MIT — see [LICENSE](LICENSE)
