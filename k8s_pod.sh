#!/bin/bash
. "$(dirname "$0")/k8s_core.sh"

# $1: {namespace_keyword} namespace 的匹配关键字，可以不填；
# $2: {pod_keyword} item 的匹配关键字，可以不填；
# $3: {pod_index} item index，可以不填，值从 1 开始；

namespace_keyword=$1
pod_keyword=$2
pod_index=$3

k8s_core "pod" "exec" "${namespace_keyword}" "${pod_keyword}" "${pod_index}"
