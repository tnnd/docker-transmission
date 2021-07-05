#!/bin/sh

#更新软件包
apk update
#进入root目录
cd /root
#安装所需软件
apk add curl transmission-daemon

#安装timezone
apk add -U tzdata
#查看时区列表
ls /usr/share/zoneinfo
#拷贝需要的时区文件到localtime
cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
#查看当前时间
date

#初始化任务
/usr/bin/transmission-daemon
#延长20s
sleep 10s
#杀死任务
pkill transmission-daemon
#修改配置文件
cd /root/.config/transmission-daemon
curl -OL https://raw.githubusercontent.com/tnnd/sh/master/transmission/settings.json
sed -i "s%\"cache-size-mb\": 4%\"cache-size-mb\": 64%g" /root/.config/transmission-daemon/settings.json

#为了精简镜像，可以将tzdata删除了
apk del tzdata
apk del curl
#重命名配置文件目录，启动备用
mv /root/.config/transmission-daemon /root/.config/transmission-daemon.bak
mkdir -p /root/.config/transmission-daemon
echo '-----------------------------'
echo 'The installation is complete.'
echo '-----------------------------'
