# PowerShell UDP Relay Script

## Overview
This PowerShell script sets up a UDP client to listen for packets on a local port, forwards them to a remote server, and sends any received response back to the original sender. It's useful in scenarios where there is a need to relay UDP packets between clients and servers, especially in networks with complex routing requirements.

## Usage

1. Clone the repository or download the `UDPRelay.ps1` script to your local machine.
2. Open PowerShell. You can do this by searching for PowerShell in the Windows start menu or by pressing `Win + X` and selecting Windows PowerShell.
3. Navigate to the directory containing the `UDPRelay.ps1` script.
4. Run the script with the required parameters:

```powershell
PS > .\UDPRelay.ps1 -localPort <local-port> -remoteIP <remote-ip> -remotePort <remote-port>
```

Replace `<local-port>`, `<remote-ip>`, and `<remote-port>` with your own values.

### Parameters

- `localPort`: The local port on which the script listens for incoming UDP packets.
- `remoteIP`: The IP address of the remote server to which the script forwards UDP packets.
- `remotePort`: The port of the remote server to which the script forwards UDP packets.

## Example

```powershell
PS > .\UDPRelay.ps1 -localPort 2456 -remoteIP "10.8.0.6" -remotePort 2456
```

This command will start the script, set it to listen on local port 2456, and forward UDP packets to the remote server at IP `10.8.0.6` on port `2456`.