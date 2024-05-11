
COMPONENT=rabbitmq
source common.sh

if [ -z "$APP_RABBITMQ_PASSWORD" ]; then
  echo -e "\e[33m env variable APP_RABBITMQ_PASSWORD is needed\e[0m"
  exit 1
fi

echo Setup YUM Repos
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>>${LOG}
StatusCheck

echo Install RabbitMQ and ErLang
yum  install erlang -y &>>${LOG}
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash
yum install rabbitmq-server -y
StatusCheck

echo Start RabbitMQ Service
systemctl enable rabbitmq-server &>>${LOG} && systemctl start rabbitmq-server &>>${LOG}
StatusCheck

rabbitmqctl list_users | grep roboshop  &>>${LOG}
if [ $? -ne 0 ]; then
  echo Add App User in RabbitMQ
  rabbitmqctl add_user roboshop ${APP_RABBITMQ_PASSWORD} &>>${LOG} && rabbitmqctl set_user_tags roboshop administrator &>>${LOG} && rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>${LOG}
  StatusCheck
fi
