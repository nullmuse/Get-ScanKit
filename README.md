#Get-Scankit 

Network scanning module in powershell 

Adding TCP and UDP scanning shortly, currently NPing module available 

Features: 

-Modify timeout, ttl, fragment, and data of packet 

-Enter a range of IP addresses to scan (192.168.0.1-120) 

-Scan DNS name of target 

-"Murica Mode" 

#Usage 
PS> . .\Get-Scankit.ps1 

PS>NPing -Target www.google.com

#Options 

NPing options:

-Target (ip,host, ip): Accepts ip address, DNS name or range (format:1.1.1.1-111) 

-Count (integer): How many requests to send to the target, per target 

-Ttl (integer): Sets the time-to-live parameter on the packet 

-Frag ($true/$false): Sets the DontFragment parameter. Default is false 

-Timeout (integer): Sets the amount of time the tool will wait for a host reply

-Data (string): Data to send in the packet. 

-Delay: Delay between packet sends 

-Murica: Disable delay, and launch several scans in parallel. Very loud. Output will be displayed in graphical grid format

 
