#!/run/current-system/sw/bin/bash 
# @reboot push_script.sh

cd /etc/nixos/

# Check for changes
if [ -n "$(git status --porcelain)" ]; then
    current_date=$(date +"%Y-%m-%d")
    git add .
    git commit -m "${current_date}"
    git push
fi