source common.sh

mysql_root_passwd=$1

if [ "${mysql_root_passwd}" == "mysql" ]; then
  echo -e "\e[31mMissing MySQL root Password Argument\e[0m"
  exit 1
    fi
component=shipping
schema_type="mysql"
java "component"