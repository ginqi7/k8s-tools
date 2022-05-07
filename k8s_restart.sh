#!/bin/bash
. "$(dirname "$0")/k8s_core.sh"

# $1: {namespace_keyword} namespace 的匹配关键字，可以不填；
# $2: {deployment_keyword} item 的匹配关键字，可以不填；
# $3: {deployment_index} item index，可以不填，值从 1 开始；

namespace_keyword=$1
deployment_keyword=$2
deployment_index=$3

k8s_core "deployment" "restart" "${namespace_keyword}" "${deployment_keyword}" "${deployment_index}"


