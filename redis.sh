
COMPONENT=redis
source common.sh

echo "Install Redis Repo"
dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>$LOG
StatusCheck

echo "Enable Redis Repo 6.2"
dnf module enable redis:remi-6.2 -y &>>$LOG
StatusCheck

echo "Install Redis"
yum install redis -y &>>$LOG
StatusCheck

echo Update Redis Listen Address
sed -i 's/127.0.0.1/0.0.0.0/' /etc/redis.conf /etc/redis/redis.conf &>>${LOG}
StatusCheck

echo Start Redis Service
systemctl enable redis &>>${LOG} && systemctl restart redis &>>${LOG}
StatusCheck

