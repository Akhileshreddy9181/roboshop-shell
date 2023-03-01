source common.sh

roboshop_passwd=$1

if [ -z "${roboshop_passwd}" ]; then
  echo -e "\e[31mMissing RoboShop App User Password Argument\e[0m"
  exit 1
    fi

print_head "SetUp Erlang repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | sudo bash &>>${log_file}
print_status $?

print_head "Installing Erlang"
yum install erlang -y &>>${log_file}
print_status $?

print_head "SetUp RabbitMQ Server Repo"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>>${log_file}
print_status $?

print_head "Installing RabbitMQ Server"
yum install rabbitmq-server -y &>>${log_file}

print_head "Enable RabbitMQ service"
systemctl enable rabbitmq-server &>>${log_file}
print_status $?

print_head "Start RabbitMQ service"
systemctl restart rabbitmq-server &>>${log_file}
print_status $?

print_head "Add Application User"
echo rabbitmqctl list_users | grep roboshop &>>${log_file}
if [ $? -ne 0 ]; then
  rabbitmqctl add_user roboshop ${roboshop_passwd} &>>${log_file}
fi
print_status $?

print_head "SetUP Permissions for RoboShop User"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>${log_file}
print_status $?
