#!/bin/sh

# If a command fails then the deploy stops
set -e

printf "\033[0;32mDeploying updates to GitHub...\033[0m\n"

# Go To Public folder
cd public

# Cleanup to avoid dead files
rm -r ./blogpost ./categories ./css ./page ./posts ./tags ./index.html ./index.xml ./sitemap.xml ./favicon.ico

# Go To Main folder
cd ..

# Build the project.
hugo --gc --minify # if using a theme, replace with `hugo -t <YOURTHEME>`

# Go To Public folder
cd public

# Add changes to git.
git add .

# Commit changes.
msg="rebuilding site $(date)"
if [ -n "$*" ]; then
	msg="$*"
fi
git commit -m "$msg"

# Push source and build repos.
git push origin master
