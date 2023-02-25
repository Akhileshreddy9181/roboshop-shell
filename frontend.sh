code_dir=$(pwd)
log_file=/tmp/roboshop.log
rm -f ${log_file}

echo -e "\e[35mInstalling nginx\e[0m"
yum install nginx -y &>>${log_file}


echo -e "\e[35mRemoving nginx default web content\e[0m"
rm -rf /usr/share/nginx/html/* &>>${log_file}


echo -e "\e[35mDownloading front-end code to temp dir\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${log_file}
cd /usr/share/nginx/html


echo -e "\e[35mExtracting the zipped code\e[0m"
unzip /tmp/frontend.zip &>>${log_file}


echo -e "\e[35mCopying nginx conf file\e[0m"
cp ${code_dir}/configs/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${log_file}


echo -e "\e[35mENabling and Restarting the nginx\e[0m"
systemctl enable nginx &>>${log_file}
systemctl restart nginx &>>${log_file}

echo -e "\e[35mStatus of nginx service\e[0m"
systemctl status nginx &>>${log_file}



