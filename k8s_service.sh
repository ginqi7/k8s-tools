#!/bin/bash
. "$(dirname "$0")/k8s_core.sh"

# $1: {namespace_keyword} namespace 的匹配关键字，可以不填；
# $2: {service_keyword} service 的匹配关键字，可以不填；
# $3: {service_index} service index，可以不填，值从 1 开始；

namespace_keyword=$1
service_keyword=$2
service_index=$3

k8s_core "service" "get" "${namespace_keyword}" "${service_keyword}" "${service_index}"
