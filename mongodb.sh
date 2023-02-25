code_dir=$(pwd)
log_file=/tmp/roboshop.log
rm -f ${log_file}

print_head()
{
  echo -e "\e[34m$1\e[0m"
  }

print_head "Set up MongoDB repo"
cp ${code_dir}/configs/mongodb.repo /etc/yum.repos.d/mongo.repo

print_head "Install MongoDB"
yum install mongodb-org -y

print_head "Enable MongoDB"
systemctl enable mongod

print_head "Start MongoDB"
systemctl start mongod