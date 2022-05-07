#!/bin/bash
. "$(dirname "$0")/k8s_core.sh"

# $1: {namespace_keyword} namespace 的匹配关键字，可以不填；
# $2: {deployment_keyword} item 的匹配关键字，可以不填；
# $3: {deployment_index} item index，可以不填，值从 1 开始；

namespace_keyword=$1
deployment_keyword=$2
deployment_index=$3

image_version=$4

msg=`k8s_deployment.sh "${namespace_keyword}" "${deployment_keyword}" "${deployment_index}"`  

config_begin_num=`echo "${msg}"  | grep -n "apiVersion: apps/v1" | awk -F ':' '{print $1}'`

echo "${msg}" | awk "NR>=${config_begin_num} {print}" | sed -r 's/(image:.*:).*/\1'"${image_version}"'/g' | kubectl apply -f -

