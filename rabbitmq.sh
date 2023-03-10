source common.sh

roboshop_passwd=$1
if [ -z "${roboshop_passwd}" ]; then
  echo -e "\e[31mMissing RabbitMQ App User Password argument\e[0m"
  exit 1
fi

print_head "Setup Erlang repos "
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash  &>>${log_file}
print_status $?

print_head "Setup RabbitMQ Repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash  &>>${log_file}
print_status $?

print_head "Install Erlang & RabbitMQ"
yum install rabbitmq-server erlang -y  &>>${log_file}
print_status $?


print_head "Enable RabbitMQ Service"
systemctl enable rabbitmq-server  &>>${log_file}
print_status $?

print_head "Start RabbitMQ Service"
systemctl start rabbitmq-server  &>>${log_file}
print_status $?

print_head "Add Application User"
rabbitmqctl list_users | grep roboshop &>>${log_file}
if [ $? -ne 0 ]; then
  rabbitmqctl add_user roboshop ${roboshop_passwd} &>>${log_file}
fi
print_status $?

print_head "Configure Permissions for App User"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"  &>>${log_file}
print_status $?