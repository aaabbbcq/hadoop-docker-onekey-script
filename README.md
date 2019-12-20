# hadoop-docker-onekey-script
using onekey script to build hadoop platform in docker. The server is Huawei Cloud Service. Os is centos 7.4.x.

step 1 download the script "onekey_run_docker_all_hbase_sqoop.sh"

[root@ecs-5afa-0014 ~]wget https://raw.githubusercontent.com/aaabbbcq/hadoop-docker-onekey-script/master/onekey_run_docker_all_hbase_sqoop.sh

step 2 grant the execute to the script "onekey_run_docker_all_hbase_sqoop.sh"

[root@ecs-5afa-0014 ~]#chmod 770 onekey_run_docker_all_hbase_sqoop.sh

step 3 replace the speedup code for aliyun using your own speedup code in the script, "XXXXXXXXX" is the code.

sudo tee /etc/docker/daemon.json <<-'EOF'
{
      "registry-mirrors": ["https://XXXXXXXXX.mirror.aliyuncs.com"]
}
EOF

step 4 execute the script "onekey_run_docker_all_hbase_sqoop.sh"

[root@ecs-5afa-0014 ~]#./onekey_run_docker_all_hbase_sqoop.sh
