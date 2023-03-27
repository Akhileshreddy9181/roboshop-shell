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

schema_setup(){

 if [ "${schema_type}" == "mongo" ]; then
    print_head "Copy MongoDB repo file"
    cp ${code_dir}/configs/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${log_file}
    print_status $?

    print_head "Install MongoDB Shell"
    yum install mongodb-org-shell -y &>>${log_file}
    print_status $?

    print_head "Load the Schema into MongoDB Database"
    mongo --host mongodb-dev.devopsa.online </app/schema/${component}.js &>>${log_file}
    print_status $?
  elif [ "${schema_type}" == "mysql" ]; then
    print_head "Installing MySQL CLient"
    yum install mysql -y &>>${log_file}
    print_status $?

    print_head "Load Schema"
    mysql -h mysql-dev.devopsa.online -uroot -p${mysql_root_passwd} < /app/schema/shipping.sql &>>${log_file}
    print_status $?
    fi
}

nodejs(){

  print_head "Configure nodeJS repo"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}
  print_status $?

  print_head "Installing NodeJS"
  yum install nodejs -y &>>${log_file}
  print_status $?

  app_prereq_setup

  print_head "Installing all the node libraries and dependencies"
  npm install &>>${log_file}
  print_status $?


  schema_setup

  systemd_setup

}

app_prereq_setup(){

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

    print_head "Delete Old Content"
    rm -rf /app/* &>>${log_file}
    print_status $?

    print_head "Downloading the ${component} code"
    curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip&>>${log_file}
    print_status $?
    cd /app

    print_head "Extracting the code"
    unzip /tmp/${component}.zip &>>${log_file}
    print_status $?

}

systemd_setup(){

  print_head "Setup SystemD Service"
   cp ${code_dir}/configs/${component}.service /etc/systemd/system/${component}.service &>>${log_file}
   print_status $?

 #setting password for payment service
  if [ ${component} == "payment" ]; then
   sed -i -e "s/ROBOSHOP_USER_PASSWORD/${roboshop_app_passwd}/" /etc/systemd/system/${component}.service &>>${log_file}
   fi

   #setting password for Dispatch Service
     if [ ${component} == "dispatch" ]; then
   sed -i -e "s/ROBOSHOP_USER_PASSWD_DIS/${roboshop_app_passwd}/" /etc/systemd/system/${component}.service &>>${log_file}
   fi


    print_head " Reloading the System Background"
    systemctl daemon-reload &>>${log_file}
    print_status $?

    print_head "Enabling the ${component} Service"
    systemctl enable ${component} &>>${log_file}
    print_status $?

    print_head "Starting the ${component} Service"
    systemctl restart ${component} &>>${log_file}
    print_status $?
}

java(){

  print_head "Installing Maven"
  yum install maven -y &>>${log_file}
  print_status $?

  #Calling function app_prereq_setup
  app_prereq_setup

  print_head "Maven Clean and download dependencies"
  mvn clean package &>>${log_file}
  mv target/${component}-1.0.jar ${component}.jar &>>${log_file}
  print_status $?

  #Schema Setup Function Calling
  schema_setup

  #SystemD setup function calling
  systemd_setup
}

python(){

  print_head "Installing Python"
  yum install python36 gcc python3-devel -y &>>${log_file}
  print_status $?

 #Calling function app_prereq_setup
 app_prereq_setup

 print_head "Install Python Dependencies"
 pip3.6 install -r requirements.txt &>>${log_file}
 print_status $?

 #SystemD setup function calling
   systemd_setup

}

golang(){

 print_head "Installing Golang"
 yum install golang -y &>>${log_file}
print_status $?

 #Calling function app_prereq_setup
  app_prereq_setup

  print_head "Installing Dependencies of Golang"
  go mod init dispatch &>>${log_file}
  go get &>>${log_file}
  print_status $?

  print_head "Building the Code "
  go build &>>${log_file}
  print_status $?


  #SystemD setup function calling
  systemd_setup
}