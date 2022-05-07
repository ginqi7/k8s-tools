#!/bin/bash
. "$(dirname "$0")/k8s_core.sh"

# $1: {namespace_keyword} namespace 的匹配关键字，可以不填；
# $2: {configMap_keyword} item 的匹配关键字，可以不填；
# $3: {configMap_index} item index，可以不填，值从 1 开始；

namespace_keyword=$1
configMap_keyword=$2
configMap_index=$3

k8s_core "configMap" "get" "${namespace_keyword}" "${configMap_keyword}" "${configMap_index}"
