code_dir=$(pwd)
log_file=/tmp/roboshop.log
rm -f ${log_file}

print_head()
{
  echo -e "\e[36m$1\e[0m"
  }

print_status(){
  if [ $1 -eq 0 ];then
    echo SUCCESS
  else
    echo FAILURE
    exit 1
  fi
}

NODEJS(){

  print_head "Configure nodeJS repo"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}
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

  print_head "Downloading the ${component} code"
  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${log_file}
  print_status $?
  cd /app

  print_head "Extracting the code"
  unzip /tmp/${component}.zip &>>${log_file}
  print_status $?

  print_head "Installing all the node libraries and dependencies"
  npm install &>>${log_file}
  print_status $?

  print_head "Copy SystemD ${component} service file"
  cp ${code_dir}/configs/${component}.service /etc/systemd/system/${component}.service &>>${log_file}
  print_status $?

  print_head " Reloading the System Background"
  systemctl daemon-reload &>>${log_file}
  print_status $?

  print_head "Enabling the ${component} Service"
  systemctl enable ${component} &>>${log_file}
  print_status $?

  print_head "Starting the ${component} Service"
  systemctl restart ${component} &>>${log_file}
  print_status $?

  print_head "Copy MongoDB repo file"
  cp ${code_dir}/configs/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${log_file}
  print_status $?

  print_head "Install MongoDB Shell"
  yum install mongodb-org-shell -y &>>${log_file}
  print_status $?

  print_head "Load the Schema into MongoDB Database"
  mongo --host 172.31.9.108 </app/schema/${component}.js &>>${log_file}
  print_status $?

}