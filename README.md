# sabnzbd
Docker image linuxserver/sabnzbd + ffmpeg tools and sabnzbd validator script.  
Script can be used to fail any downloads that contain mkv files that fail mkv validation.  
Only the largest mkv file downloaded will be checked.  

# Script
To use script in sabnzbd settings configure the following  
Folders > Script Folder: /scripts  
Switches > User script can flag job as failed: enable  
Categories: Set Script to ffmpegvalidator on any categories you want to use script on.