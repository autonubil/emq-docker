#!/bin/sh
## EMQ docker image start script
# Huang Rui <vowstar@gmail.com>

## EMQ Base settings
# Base settings in /opt/emqttd/etc/emq.conf

if [ x"${EMQ_NAME}" = x ]
then
EMQ_NAME=$(hostname -s)
echo "EMQ_NAME=${EMQ_NAME}"
fi

if [ x"${EMQ_HOST}" = x ]
then
EMQ_HOST=$(cat /etc/hosts | grep $(hostname) | awk '{print $1}' | head -n 1)
echo "EMQ_HOST=${EMQ_HOST}"
fi

if [ x"${EMQ_NODE_NAME}" = x ]
then

#if [ x"${MESOS_TASK_ID}" = x ]
#then
EMQ_NODE_NAME="${EMQ_NAME}@${EMQ_HOST}"
#else
# EMQ_NODE_NAME="${MESOS_TASK_ID//./-}@${EMQ_HOST}"
#fi
echo "EMQ_NODE_NAME=${EMQ_NODE_NAME}"
fi
sed -i -e "s/^#*\s*node.name\s*=\s*.*@.*/node.name = ${EMQ_NODE_NAME}/g" /opt/emqttd/etc/emq.conf

if [ x"${EMQ_NODE_COOKIE}" = x ]
then
EMQ_NODE_COOKIE="emq_dist_cookie"
echo "EMQ_NODE_COOKIE=${EMQ_NODE_COOKIE}"
fi
sed -i -e "s/^#*\s*node.cookie\s*=\s*.*/node.cookie = ${EMQ_NODE_COOKIE}/g" /opt/emqttd/etc/emq.conf

if [ x"${EMQ_PROCESS_LIMIT}" = x ]
then
EMQ_PROCESS_LIMIT=2097152
echo "EMQ_PROCESS_LIMIT=${EMQ_PROCESS_LIMIT}"
fi
sed -i -e "s/^#*\s*node.process_limit\s*=\s*.*/node.process_limit = ${EMQ_PROCESS_LIMIT}/g" /opt/emqttd/etc/emq.conf

if [ x"${EMQ_MAX_PORTS}" = x ]
then
EMQ_MAX_PORTS=1048576
echo "EMQ_MAX_PORTS=${EMQ_MAX_PORTS}"
fi
sed -i -e "s/^#*\s*node.max_ports\s*=\s*.*/node.max_ports = ${EMQ_MAX_PORTS}/g" /opt/emqttd/etc/emq.conf

if [ x"${EMQ_LOG_CONSOLE}" = x ]
then
EMQ_LOG_CONSOLE="file"
echo "EMQ_LOG_CONSOLE=${EMQ_LOG_CONSOLE}"
fi
sed -i -e "s/^#*\s*log.console\s*=\s*.*/log.console = ${EMQ_LOG_CONSOLE}/g" /opt/emqttd/etc/emq.conf

if [ x"${EMQ_LOG_LEVEL}" = x ]
then
EMQ_LOG_LEVEL="error"
echo "EMQ_LOG_LEVEL=${EMQ_LOG_LEVEL}"
fi
sed -i -e "s/^#*\s*log.console.level\s*=\s*.*/log.console.level = ${EMQ_LOG_LEVEL}/g" /opt/emqttd/etc/emq.conf

if [ x"${EMQ_ALLOW_ANONYMOUS}" = x ]
then
EMQ_ALLOW_ANONYMOUS="true"
echo "EMQ_ALLOW_ANONYMOUS=${EMQ_ALLOW_ANONYMOUS}"
fi
sed -i -e "s/^#*\s*mqtt.allow_anonymous\s*=\s*.*/mqtt.allow_anonymous = ${EMQ_ALLOW_ANONYMOUS}/g" /opt/emqttd/etc/emq.conf

if [ x"${EMQ_TCP_PORT}" = x ]
then
EMQ_TCP_PORT=1883
echo "EMQ_TCP_PORT=${EMQ_TCP_PORT}"
fi
sed -i -e "s/^#*\s*mqtt.listener.tcp\s*=\s*.*/mqtt.listener.tcp = ${EMQ_TCP_PORT}/g" /opt/emqttd/etc/emq.conf

if [ x"${EMQ_TCP_ACCEPTORS}" = x ]
then
EMQ_TCP_ACCEPTORS=64
echo "EMQ_TCP_ACCEPTORS=${EMQ_TCP_ACCEPTORS}"
fi
sed -i -e "s/^#*\s*mqtt.listener.tcp.acceptors\s*=\s*.*/mqtt.listener.tcp.acceptors = ${EMQ_TCP_ACCEPTORS}/g" /opt/emqttd/etc/emq.conf

if [ x"${EMQ_TCP_MAX_CLIENTS}" = x ]
then
EMQ_TCP_MAX_CLIENTS=1000000
echo "EMQ_TCP_MAX_CLIENTS=${EMQ_TCP_MAX_CLIENTS}"
fi
sed -i -e "s/^#*\s*mqtt.listener.tcp.max_clients\s*=\s*.*/mqtt.listener.tcp.max_clients = ${EMQ_TCP_MAX_CLIENTS}/g" /opt/emqttd/etc/emq.conf

if [ x"${EMQ_SSL_PORT}" = x ]
then
#disable ssl if no port is given
echo "** Disable SSL listener"
sed -e "s/^\s*mqtt.listener.ssl/## mqtt.listener.ssl/g" /opt/emqttd/etc/emq.conf
else
echo "EMQ_SSL_PORT=${EMQ_SSL_PORT}"
  sed -i -e "s/^#*\s*mqtt.listener.ssl\s*=\s*.*/mqtt.listener.ssl = ${EMQ_SSL_PORT}/g" /opt/emqttd/etc/emq.conf

  if [ x"${EMQ_SSL_ACCEPTORS}" = x ]
  then
  EMQ_SSL_ACCEPTORS=32
  echo "EMQ_SSL_ACCEPTORS=${EMQ_SSL_ACCEPTORS}"
  fi
  sed -i -e "s/^#*\s*mqtt.listener.ssl.acceptors\s*=\s*.*/mqtt.listener.ssl.acceptors = ${EMQ_SSL_ACCEPTORS}/g" /opt/emqttd/etc/emq.conf

  if [ x"${EMQ_SSL_MAX_CLIENTS}" = x ]
  then
  EMQ_SSL_MAX_CLIENTS=500000
  echo "EMQ_SSL_MAX_CLIENTS=${EMQ_SSL_MAX_CLIENTS}"
  fi
  sed -i -e "s/^#*\s*mqtt.listener.ssl.max_clients\s*=\s*.*/mqtt.listener.ssl.max_clients = ${EMQ_SSL_MAX_CLIENTS}/g" /opt/emqttd/etc/emq.conf
fi

if [ x"${EMQ_HTTP_PORT}" = x ]
then
EMQ_HTTP_PORT=8083
echo "EMQ_HTTP_PORT=${EMQ_HTTP_PORT}"
fi
sed -i -e "s/^#*\s*mqtt.listener.http\s*=\s*.*/mqtt.listener.http = ${EMQ_HTTP_PORT}/g" /opt/emqttd/etc/emq.conf

if [ x"${EMQ_HTTP_ACCEPTORS}" = x ]
then
EMQ_HTTP_ACCEPTORS=64
echo "EMQ_HTTP_ACCEPTORS=${EMQ_HTTP_ACCEPTORS}"
fi
sed -i -e "s/^#*\s*mqtt.listener.http.acceptors\s*=\s*.*/mqtt.listener.http.acceptors = ${EMQ_HTTP_ACCEPTORS}/g" /opt/emqttd/etc/emq.conf

if [ x"${EMQ_HTTP_MAX_CLIENTS}" = x ]
then
EMQ_HTTP_MAX_CLIENTS=1000000
echo "EMQ_HTTP_MAX_CLIENTS=${EMQ_HTTP_MAX_CLIENTS}"
fi
sed -i -e "s/^#*\s*mqtt.listener.http.max_clients\s*=\s*.*/mqtt.listener.http.max_clients = ${EMQ_HTTP_MAX_CLIENTS}/g" /opt/emqttd/etc/emq.conf

if [ x"${EMQ_HTTPS_PORT}" = x ]
then
# remove https support if no port is given
echo "** Disable HTTPS listener"
sed -e "s/^\s*mqtt.listener.https/## mqtt.listener.https/g" /opt/emqttd/etc/emq.conf
else
sed -i -e "s/^#*\s*mqtt.listener.https\s*=\s*.*/mqtt.listener.https = ${EMQ_HTTPS_PORT}/g" /opt/emqttd/etc/emq.conf
echo "EMQ_HTTPS_PORT=${EMQ_HTTPS_PORT}"
 if [ x"${EMQ_HTTPS_ACCEPTORS}" = x ]
 then
 EMQ_HTTPS_ACCEPTORS=32
 echo "EMQ_HTTPS_ACCEPTORS=${EMQ_HTTPS_ACCEPTORS}"
 fi
 sed -i -e "s/^#*\s*mqtt.listener.https.acceptors\s*=\s*.*/mqtt.listener.https.acceptors = ${EMQ_HTTPS_ACCEPTORS}/g" /opt/emqttd/etc/emq.conf

 if [ x"${EMQ_HTTPS_MAX_CLIENTS}" = x ]
 then
 EMQ_HTTPS_MAX_CLIENTS=1000000
 echo "EMQ_HTTPS_MAX_CLIENTS=${EMQ_HTTPS_MAX_CLIENTS}"
 fi
 sed -i -e "s/^#*\s*mqtt.listener.https.max_clients\s*=\s*.*/mqtt.listener.https.max_clients = ${EMQ_HTTPS_MAX_CLIENTS}/g" /opt/emqttd/etc/emq.conf
fi


if [ x"${EMQ_MAX_PACKET_SIZE}" = x ]
then
EMQ_MAX_PACKET_SIZE="64KB"
echo "EMQ_MAX_PACKET_SIZE=${EMQ_MAX_PACKET_SIZE}"
fi
sed -i -e "s/^#*\s*mqtt.max_packet_size\s*=\s*.*/mqtt.max_packet_size = ${EMQ_MAX_PACKET_SIZE}/g" /opt/emqttd/etc/emq.conf




if [ x"${EMQ_DIST_LISTEN_MAX}" = x ]
then
EMQ_DIST_LISTEN_MAX="6100"
echo "EMQ_DIST_LISTEN_MAX=${EMQ_DIST_LISTEN_MAX}"
fi
sed -i -e "s/^#*\s*node.dist_listen_max\s*=\s*.*/node.dist_listen_max = ${EMQ_DIST_LISTEN_MAX}/g" /opt/emqttd/etc/emq.conf



## EMQ Plugin load settings
# Plugins loaded by default

if [ x"${EMQ_LOADED_PLUGINS}" = x ]
then
EMQ_LOADED_PLUGINS="emq_recon,emq_dashboard,emq_mod_presence,emq_mod_retainer,emq_mod_subscription"
echo "EMQ_LOADED_PLUGINS=${EMQ_LOADED_PLUGINS}"
fi
# First, remove special char at header
# Next, replace special char to ".\n" to fit emq loaded_plugins format
echo $(echo "${EMQ_LOADED_PLUGINS}."|sed -e "s/^[^A-Za-z0-9_]\{1,\}//g"|sed -e "s/[^A-Za-z0-9_]\{1,\}/\.\n/g") > /opt/emqttd/data/loaded_plugins


if [ x"${EMQ_DASHBOARD_HTTP_PORT}" = x ]
then
EMQ_DASHBOARD_HTTP_PORT=9083
echo "EMQ_DASHBOARD_HTTP_PORT=${EMQ_DASHBOARD_HTTP_PORT}"
fi
sed -i -e "s/^#*\s*dashboard.listener.http\s*=\s*.*/dashboard.listener.http = ${EMQ_DASHBOARD_HTTP_PORT}/g" /opt/emqttd/etc/plugins/emq_dashboard.conf



echo
echo "Effective config:"
grep -v -E "^#*$" /opt/emqttd/etc/emq.conf | grep -v -E "^$"

grep -v -E "^#*$" /opt/emqttd/etc/plugins/emq_dashboard.conf | grep -v -E "^$"


## EMQ Plugins setting

## TODO: Add plugins settings

## EMQ Main script
# Start and run emqttd, and when emqttd crashed, this container will stop

/opt/emqttd/bin/emqttd start

# wait and ensure emqttd status is running
WAIT_TIME=0
while [ x$(/opt/emqttd/bin/emqttd_ctl status |grep 'is running'|awk '{print $1}') = x ]
do
    sleep 1
    echo '['$(date -u +"%Y-%m-%dT%H:%M:%SZ")']:waiting emqttd'
    WAIT_TIME=`expr ${WAIT_TIME} + 1`
    if [ ${WAIT_TIME} -gt 5 ]
    then
        echo '['$(date -u +"%Y-%m-%dT%H:%M:%SZ")']:timeout error'
        tail $(ls /opt/emqttd/log/*)
	exit 1
    fi
done

echo '['$(date -u +"%Y-%m-%dT%H:%M:%SZ")']:emqttd start'

# monitor emqttd is running, or the docker must stop to let docker PaaS know
# warning: never use infinite loops such as `` while true; do sleep 1000; done`` here
#          you must let user know emqtt crashed and stop this container,
#          and docker dispatching system can known and restart this container.
IDLE_TIME=0
while [ x$(/opt/emqttd/bin/emqttd_ctl status |grep 'is running'|awk '{print $1}') != x ]
do  
    IDLE_TIME=`expr ${IDLE_TIME} + 1`
    echo '['$(date -u +"%Y-%m-%dT%H:%M:%SZ")']:emqttd running'
    sleep 20
done

tail $(ls /opt/emqttd/log/*)

echo '['$(date -u +"%Y-%m-%dT%H:%M:%SZ")']:emqttd stop'
