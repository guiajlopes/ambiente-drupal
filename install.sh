#! /bin/bash
echo "Instalando git"
sudo apt-get install git-core unzip -y
echo "Digite seu nome de usuário do git"
read user
git config --global user.name $user
echo "Digite seu email do git"
read email
git config --global user.email $email


echo "Instalando DNS MASC"
sudo apt-get install dnsmasq
echo "Configurando DNS MASC"
sudo touch /etc/dnsmasq.d/local
sudo echo address=/l/127.0.0.1 >> /etc/dnsmasq.d/local
sudo sed -i 's/#prepend/prepend/' dhclient.conf
# echo "Resetando a rede do computador"
# sudo service network-manager restart


echo "Add channel pear.drush.org"
sudo pear channel-discover pear.drush.org
echo "Instalando drush"
sudo pear install drush/drush

echo "Instalando MYSQL SERVER"
sudo apt-get -y install mysql-server

echo "Instalando Nginx e PHP"
sudo apt-get install nginx-extras php5-fpm php5-curl php5-gd php5-mysql php5-xdebug -y
sudo apt-get install php5-mcrypt
sudo apt-get install php5-imagick

echo "Define www-data como um dos grupos do seu usuário."
sudo usermod -a -G www-data $USER

echo "Clonando o repositorio com o nginx para Drupal"
git clone --depth 1 https://github.com/Fidelix/nginx-drupal-dev.git /tmp/nginx-config

echo "Removendo configuração padrao do nginx"
sudo rm -rf /etc/nginx
echo "Movendo a nova configuração para /etc/nginx"
sudo mv /tmp/nginx-config /etc/nginx

echo "Escrevendo configurações nos arquivos de conf do nginx"
sudo sed -i -e s#{{UNIX_USER}}#$USER#g /etc/nginx/nginx.conf
sudo sed -i -e s#{{WEB_DIR}}#/www#g /etc/nginx/nginx.conf
sudo sed -i -e s#{{WEB_DIR}}#/www#g /etc/nginx/sites-available/example.dev
sudo chown -R $USER:www-data /etc/nginx

echo "Restartando nginx"
sudo service nginx restart

echo "Clonando PHP-FPM"
git clone --depth 1 https://github.com/Fidelix/php-fpm-dev.git /tmp/php-fpm-config

echo "Removendo configuração antiga"
sudo rm -rf /etc/php5/fpm 

echo "Movendo nova configuração"
sudo cp -R /tmp/php-fpm-config/fpm /etc/php5/fpm 
sudo rm -rf /tmp/php-fpm-config
echo "Escrevendo configurações"
sudo sed -i -e s#{{UNIX_USER}}#$USER#g /etc/php5/fpm/pool.d/www.conf
cd /etc/php5/fpm
sudo ln -s ../mods-available/ conf.d

echo "Restartando PHP-FPM"
sudo service php5-fpm restart

echo "Criando pagina do projeto"
sudo mkdir -p /www
sudo chown $USER:www-data /www
echo "Pasta dos projetos configuradas em /www"
echo "Necessario reiniciar o computador"








