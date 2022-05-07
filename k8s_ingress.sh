#!/bin/bash
. "$(dirname "$0")/k8s_core.sh"

# $1: {namespace_keyword} namespace 的匹配关键字，可以不填；
# $2: {ingress_keyword} ingress 的匹配关键字，可以不填；
# $3: {ingress_index} ingress index，可以不填，值从 1 开始；

namespace_keyword=$1
ingress_keyword=$2
ingress_index=$3

k8s_core "ingress" "get" "${namespace_keyword}" "${ingress_keyword}" "${ingress_index}"
