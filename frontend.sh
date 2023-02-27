#loading the common script
source common.sh


print_head "Installing nginx"
yum install nginx -y &>>${log_file}
print_status $?

print_head "Removing nginx default web content"
rm -rf /usr/share/nginx/html/* &>>${log_file}
print_status $?

print_head "Downloading front-end code to temp dir"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${log_file}
cd /usr/share/nginx/html
print_status $?

print_head "Extracting the zipped code"
unzip /tmp/frontend.zip &>>${log_file}
print_status $?

print_head "Copying nginx conf file"
cp ${code_dir}/configs/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${log_file}
print_status $?

print_head "ENabling and Restarting the nginx"
systemctl enable nginx &>>${log_file}
systemctl restart nginx &>>${log_file}
print_status $?

print_head "Status of nginx service"
systemctl status nginx &>>${log_file}
print_status $?
