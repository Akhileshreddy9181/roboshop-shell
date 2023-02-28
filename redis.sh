source common.sh

print_head "Installing the Redis Repo"
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>${log_file}
print_status $?

print_head "Enabling Redis 6.2 repo"
dnf module enable redis:remi-6.2 -y &>>${log_file}
print_status $?

print_head "Installing Redis Application"
yum install redis -y &>>${log_file}
print_status $?

print_head "Changing the default listen address to universal ip address"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf /etc/redis/redis.conf &>>${log_file}
print_status $?

print_head "Enabling the Redis service"
systemctl enable redis &>>${log_file}
print_status $?


print_head "Starting the Redis service"
systemctl restart redis &>>${log_file}
print_status $?
