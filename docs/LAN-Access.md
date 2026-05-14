# LAN Access — Expose Pulse to Your Home Network

By default Pulse binds to `127.0.0.1:31337` (localhost only). To access
the dashboard from your phone or other devices on the same network:

## 1. Enable bind-all in PAI

Add to `~/.claude/.env`:

```bash
PAI_PULSE_BIND_ALL=1
```

Restart Pulse:

```bash
systemctl --user restart pulse
```

## 2. Find your WSL IP

```bash
ip route get 1 | awk '{print $7; exit}'
```

## 3. Open the Windows Firewall

Run in **elevated PowerShell**:

```powershell
New-NetFirewallRule `
  -DisplayName "PAI Pulse" `
  -Direction Inbound `
  -Protocol TCP `
  -LocalPort 31337 `
  -Action Allow
```

## 4. Access from any device

Navigate to `http://<your-wsl-ip>:31337` from any browser on the same network.

## Security Note

Pulse has no authentication by default. Only expose it on trusted networks
(home LAN). Do not forward port 31337 through your router to the internet.
