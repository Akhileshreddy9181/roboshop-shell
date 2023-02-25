code_dir=$(pwd)
log_file=/tmp/roboshop.log
rm -f ${log_file}

print_head()
{
  echo -e "\e[37m$1\e[0m"
  }


print_head "Installing nginx"
yum install nginx -y &>>${log_file}


print_head "Removing nginx default web content"
rm -rf /usr/share/nginx/html/* &>>${log_file}


print_head "Downloading front-end code to temp dir"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${log_file}
cd /usr/share/nginx/html


print_head "Extracting the zipped code"
unzip /tmp/frontend.zip &>>${log_file}


print_head "Copying nginx conf file"
cp ${code_dir}/configs/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${log_file}


print_head "ENabling and Restarting the nginx"
systemctl enable nginx &>>${log_file}
systemctl restart nginx &>>${log_file}

print_head "\e[35mStatus of nginx service"
systemctl status nginx &>>${log_file}

