source common.sh

print_head "Configure nodeJS repo"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>{log_file}

print_head "Installing NodeJS"
yum install nodejs -y &>>{log_file}

print_head "Adding user roboshop"
useradd roboshop &>>{log_file}

print_head "Creating directory /app"
mkdir /app &>>{log_file}

print_head "Delete Old Content" &>>{log_file}
rm -rf /app/*

print_head "Downloading the catalogue code"
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>{log_file}
cd /app

print_head "Extracting the code"
unzip /tmp/catalogue.zip &>>{log_file}

print_head "Installing all the node libraries and dependencies"
npm install &>>{log_file}

print_head "Copy SystemD catalogue service file"
cp ${code_dir}/configs/catalogue.service /etc/systemd/system/catalogue.service &>>{log_file}

print_head " Reloading the System Background"
systemctl daemon-reload &>>{log_file}

print_head "Enabling the Catalogue Service"
systemctl enable catalogue &>>{log_file}

print_head "Starting the Catalogue Service"
systemctl restart catalogue &>>{log_file}

print_head "Copy MongoDB repo file"
cp ${code_dir}/configs/mongodb.repo /etc/yum.repos.d/mongo.repo &>>{log_file}

print_head "Install MongoDB Shell"
yum install mongodb-org-shell -y &>>{log_file}

print_head "Load the Schema into MongoDB Database"
mongo --host 172.31.9.108 </app/schema/catalogue.js &>>{log_file}