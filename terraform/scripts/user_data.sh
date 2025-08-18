#!/bin/bash
# Install dependencies
yum update -y
yum install python3 git -y
pip3 install flask gunicorn

# Clone and run the app
git clone https://github.com/${github_repo}.git /var/www/flask-app
cd /var/www/flask-app
nohup python3 flask-app.py --host=0.0.0.0 --port=80 > /var/log/flask.log 2>&1 &