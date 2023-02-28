source common.sh

my_sql_root_passwd=$1
if [ -z "${my_sql_root_passwd}" ];then
  echo -e "\e[31mMissing MySQL root Password Argument\e[0m"
  exit 1
  fi
print_status $?

print_head "Disabling MySQL 8 repo"
dnf module disable mysql -y &>>${log_file}
print_status $?

print_head "Setting up MySQL repo"
cp ${code_dir}/configs/mysql.repo /etc/yum.repos.d/mysql.repo &>>${log_file}
print_status $?


print_head "Installing MySQL"
yum install mysql-community-server -y &>>${log_file}
print_status $?


print_head "Enabling MySQL service"
systemctl enable mysqld &>>${log_file}
print_status $?


print_head "Starting MySQL service"
systemctl restart mysqld &>>${log_file}
print_status $?


print_head "Setting Root Password for MySQL"
echo show databases | mysql -uroot -p${my_sql_root_passwd}
if [ $? -ne 0 ]; then
   mysql_secure_installation --set-root-pass ${my_sql_root_passwd} &>>${log_file}
   fi

print_status $?
