source common.sh

print_head "Set up MongoDB repo"
cp ${code_dir}/configs/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${log_file}
print_status $?

print_head "Install MongoDB"
yum install mongodb-org -y &>>${log_file}
print_status $?

print_head "Updating the mongodb listen address "
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>${log_file}
print_status $?

print_head "Enable MongoDB"
systemctl enable mongod &>>${log_file}
print_status $?

print_head "Start MongoDB"
systemctl restart mongod &>>${log_file}
print_status $?