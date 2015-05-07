#!/usr/bin/env bash

USER="ubuntu"

sudo apt-get update

cd ~

#
# Git
#
echo -e "\n======================= Git INSTALLATION =====================\n"
sudo apt-get -y install git

#
# Make
#
echo -e "\n======================= Make INSTALLATION =====================\n"
sudo apt-get -y install make

#
# gcc
#
echo -e "\n======================= gcc INSTALLATION =====================\n"
sudo apt-get -y install gcc

#
# daemon
#
echo -e "\n======================= daemon INSTALLATION =====================\n"
sudo apt-get -y install daemon

#
# Redis
#
echo -e "\n======================= Redis INSTALLATION =====================\n"
wget http://download.redis.io/redis-stable.tar.gz
tar xvzf redis-stable.tar.gz
cd redis-stable
sudo make
sudo make install

#
# Mysql
#
echo -e "\n======================= MySQl INSTALLATION =====================\n"
sudo debconf-set-selections <<< "mysql-server-5.5 mysql-server/root_password password foo"
sudo debconf-set-selections <<< "mysql-server-5.5 mysql-server/root_password_again password foo"

sudo apt-get install -y mysql-server-5.5 mysql-client libmysqlclient-dev
sudo mysqladmin -u root -pfoo password ''
mysql -u root -e "CREATE DATABASE IF NOT EXISTS paredao_bbb"

#
# Nginx
#
echo -e "\n======================= Nginx INSTALLATION =====================\n"
sudo apt-get install nginx

#
# RVM
#
echo -e "\n======================= RVM INSTALLATION =====================\n"
gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3
\curl -L https://get.rvm.io | bash -s stable
sudo addgroup rvm
sudo usermod -a -G rvm $USER
source /etc/profile.d/rvm.sh
source /home/$USER/.rvm/scripts/rvm
rvm use ruby-2.0.0-p353

#
# Ruby
#
echo -e "\n======================= Ruby2 INSTALLATION =====================\n"
rvm install ruby-2.0.0-p353
rvm alias create default ruby-2.0.0-p353
rvm use ruby-2.0.0-p353
rvm gemset use paredao-bbb --create

#
# Bundler
#
echo -e "\n======================= Bundler INSTALLATION =====================\n"
gem install bundler
bundle install

echo -e "\n======================= CONFIG DATABASE ==========================\n"
cp config/database.example.yml config/database.yml
rake db:create db:migrate db:seed
