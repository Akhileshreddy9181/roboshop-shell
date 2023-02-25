code_dir=$(pwd)

echo -e "\e[35mInstalling nginx\e[0m"
yum install nginx -y


echo -e "\e[35mRemoving nginx default web content\e[0m"
rm -rf /usr/share/nginx/html/*


echo -e "\e[35mDownloading front-end code to temp dir\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip
cd /usr/share/nginx/html


echo -e "\e[35mExtracting the zipped code\e[0m"
unzip /tmp/frontend.zip


echo -e "\e[35mCopying nginx conf file\e[0m"
cp ${code_dir}/configs/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf


echo -e "\e[35mENabling and Restarting the nginx\e[0m"
systemctl enable nginx
systemctl restart nginx

echo -e "\e[35mStatus of nginx service\e[0m"
systemctl status nginx



