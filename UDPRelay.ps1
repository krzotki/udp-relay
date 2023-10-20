<#
.SYNOPSIS
This script listens for UDP packets on a specified local port and forwards them to a remote server, then sends the response back to the original sender.

.DESCRIPTION
The script sets up a UDP client to listen on a specified local port, receives messages, forwards them to a configured remote server, and then waits for a response from the server. If a response is received within a set timeout period, it's then sent back to the original client.

.PARAMETER localPort
The local port to listen on.

.PARAMETER remoteIP
The IP address of the remote server to forward packets to.

.PARAMETER remotePort
The port of the remote server to forward packets to.

.EXAMPLE
PS > .\UDPRelay.ps1 -localPort 2456 -remoteIP "10.8.0.6" -remotePort 2456
#>

using namespace System.Net
using namespace System.Net.Sockets
using namespace System.Text

param(
    [Parameter(Mandatory=$true)]
    [int]$localPort,

    [Parameter(Mandatory=$true)]
    [string]$remoteIP,

    [Parameter(Mandatory=$true)]
    [int]$remotePort
)

try {
    # Define the UDP client with the local endpoint
    $udpClient = New-Object UdpClient($localPort)

    # Buffer for incoming data
    $buffer = [Byte[]]::new(1024)

    # An endpoint to capture the client's address and port
    $sender = New-Object IPEndPoint([IPAddress]::Any, 0)

    Write-Host "Listening for UDP packets on port $localPort..."

    while ($true) {
        # Receive incoming data
        $receivedBytes = $udpClient.Receive([ref]$sender)
        $receivedData = [Encoding]::ASCII.GetString($receivedBytes)

        # Store client's endpoint
        $clientEndpoint = New-Object IPEndPoint($sender.Address, $sender.Port)

        # Forward the data to the remote server
        $udpClient.Send($receivedBytes, $receivedBytes.Length, $remoteIP, $remotePort)

        # Set a timeout for the response
        $udpClient.Client.ReceiveTimeout = 5000 # Timeout period in milliseconds

        try {
            # Receive the response from the server
            $serverResponseData = $udpClient.Receive([ref]$sender)
            $responseString = [Encoding]::ASCII.GetString($serverResponseData)

            # Send the response back to the original client
            $udpClient.Send($serverResponseData, $serverResponseData.Length, $clientEndpoint.Address.ToString(), $clientEndpoint.Port)
        } catch {
            Write-Host "No response received from server within the timeout period, or an error occurred."
        }
    }
} catch {
    Write-Host "An error occurred: $_"
} finally {
    $udpClient.Close()
}
