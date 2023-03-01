source common.sh

roboshop_passwd=$1

if [ -z "${roboshop_passwd}" ]; then
  echo -e "\e[31mMissing RoboShop App User Password Argument\e[0m"
  exit 1
    fi

component="dispatch"
golamg