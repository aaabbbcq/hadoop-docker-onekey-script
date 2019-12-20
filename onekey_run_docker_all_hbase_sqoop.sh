#!/bin/bash
echo '========================================'
echo 'Big Data Analysis and Processing Course By leidj@cqupt.edu.cn'
echo '========================================'
echo 'sleeping 10s for starting'
sleep 10s
file1=centos7.zip
file2=hadoop-docker-centos7
echo 'starting add image speed============>'
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://XXXXXXXXX.mirror.aliyuncs.com"]
}
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker
echo 'end add image speed============>'
yum -y install yum-utils
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install -y docker-ce-18.03.1.ce
systemctl enable docker
systemctl start docker
yum install -y docker-compose
echo 'cleaning images=============>'
docker stop $(docker ps -aq)
docker rm $(docker ps -aq)
docker rmi -f $(docker images -aq)
if test -f "$file1"; then
    rm -f $file1
fi
if test -d "$file2"; then 
    rm -rf $file2
fi
yum install -y wget
wget https://github.com/aaabbbcq/hadoop-docker/archive/centos7.zip
chmod 777 centos7.zip
unzip centos7.zip
cd hadoop-docker-centos7/
docker pull mysql:5.7
docker pull centos:7
docker pull twinsen/os-jvm:centos6-openjdk8
docker pull twinsen/hadoop:2.7.2
docker pull twinsen/hive:2.1.1
docker pull twinsen/spark:2.3.0
docker pull twinsen/hbase:1.2.5
docker pull leidj/sqoop:1.0.2
docker pull twinsen/zookeeper:3.4.10
docker network create hadoop-docker
docker-compose up -d
echo 'sleeping 10s for service up'
sleep 10s
docker-compose exec hbase-master hdfs namenode -format
docker-compose exec hbase-master schematool -dbType mysql -initSchema
echo 'sleeping 10s for creating table'
sleep 10s
docker-compose exec hbase-master jar cv0f /code/spark-libs.jar -C /root/spark/jars/ .
docker-compose exec hbase-master start-dfs.sh
docker-compose exec hbase-master hadoop fs -mkdir -p /user/spark/share/lib/
docker-compose exec hbase-master hadoop fs -put /code/spark-libs.jar /user/spark/share/lib/
docker-compose exec hbase-master stop-dfs.sh
docker-compose exec hbase-master start-dfs.sh
docker-compose exec hbase-master start-yarn.sh
docker-compose exec hbase-master start-all.sh
docker-compose exec hbase-master start-hbase.sh
docker-compose exec hbase-master /bin/bash

