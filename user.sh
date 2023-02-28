source common.sh

print_head "Configure nodeJS repo"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash
print_status $?


print_head "Installing NodeJS"
yum install nodejs -y &>>${log_file}
print_status $?

print_head "Adding user roboshop"
id roboshop &>>${log_file}
if [ $? -ne 0 ];then
  useradd roboshop &>>${log_file}
  fi
print_status $?

print_head "Creating directory /app"
if [ ! -d  /app ];then
  mkdir /app &>>${log_file}
  fi
print_status $?

print_head "Delete Old Content" &>>${log_file}
rm -rf /app/*
print_status $?

print_head "Downloading the User code"
curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip
print_status $?
cd /app


print_head "Extracting the code"
unzip /tmp/user.zip &>>${log_file}
print_status $?

print_head "Installing all the node libraries and dependencies"
npm install &>>${log_file}
print_status $?

print_head "Copy SystemD user service file"
cp ${code_dir}/configs/user.service /etc/systemd/system/user.service &>>${log_file}
print_status $?

print_head " Reloading the System Background"
systemctl daemon-reload &>>${log_file}
print_status $?

print_head "Enabling the user Service"
systemctl enable user &>>${log_file}
print_status $?

print_head "Starting the user Service"
systemctl restart user &>>${log_file}
print_status $?

print_head "Copy MongoDB repo file"
cp ${code_dir}/configs/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${log_file}
print_status $?

print_head "Install MongoDB Shell"
yum install mongodb-org-shell -y &>>${log_file}
print_status $?

print_head "Load the Schema into MongoDB Database"
mongo --host 172.31.9.108 </app/schema/user.js &>>${log_file}
print_status $?