#!/bin/bash
. "$(dirname "$0")/k8s_core.sh"

# $1: {resource_type} pod, deployment, service etc.
# $2: {namespace_keyword} namespace 的匹配关键字，可以不填；
# $3: {pod_keyword} item 的匹配关键字，可以不填；
# $4: {pod_index} item index，可以不填，值从 1 开始；

resource_type=$1
namespace_keyword=$2
keyword=$3
index=$4

k8s_core "${resource_type}" "edit" "${namespace_keyword}" "${keyword}" "${index}"
