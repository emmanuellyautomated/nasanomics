cd /vagrant

# Setup Filebeat
sudo apt-get -y install apt-transport-https 
sudo echo "deb https://packages.elastic.co/beats/apt stable main" |  sudo tee -a /etc/apt/sources.list.d/beats.list
sudo apt-get -y update
sudo apt-get -y install filebeat
sudo wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
#---- Configure Filebeat

# Setup Python3, etc.
sudo apt-get -y install python3.4-dev python3-pip virtualenv git libevent-dev
sudo echo "alias python=\"python3\"" >> ~vagrant/.bashrc
source ~vagrant/.bashrc

# Import app
mkdir /var/www
mkdir /var/www/nasanomics
export PYTHONPATH=/var/www/nasanomics
/bin/bash -c "rsync -av \
    --exclude='/vagrant/vps/packer' \
    --exclude='/vagrant/vps/vagrant' \
    /vagrant/ /var/www/nasanomics"

# Setup virtualenv
cd /var/www/nasanomics
make venv
source /var/www/nasanomics/venv/bin/activate
make install

# UWSGI Setup
sudo apt-get -y install uwsgi uwsgi-plugin-python3
mkdir /var/www/run
chown www-data:www-data /var/www/run
touch /var/log/uwsgi/emperor.log
chown www-data:www-data /var/log/uwsgi/emperor.log
touch /var/log/uwsgi/app/nasanomics.log
chown www-data:www-data /var/log/uwsgi/app/nasanomics.log
cp /vagrant/vps/vagrant/uwsgi.conf /etc/init
cp /vagrant/vps/vagrant/uwsgi_config.ini /etc/uwsgi/apps-available/
ln -s /etc/uwsgi/apps-available/uwsgi_config.ini /etc/uwsgi/apps-enabled

# NGINX Setup
sudo apt-get -y install nginx
rm /etc/nginx/sites-enabled/default
cp /vagrant/vps/vagrant/nginx_config /etc/nginx/sites-available/
ln -s /etc/nginx/sites-available/nginx_config /etc/nginx/sites-enabled

# Start UWSGI, NGINX, and Redis
sudo apt-get -y install redis-server
sudo /etc/init.d/nginx restart
sudo /etc/init.d/uwsgi restart
sudo /etc/init.d/redis-server restart
