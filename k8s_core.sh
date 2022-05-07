#!/bin/bash
# 入参数：
# $1: {type} k8s 对应的资源类型：pod, deployment, service, ingress 等；
# $2: {action} k8s 对应的操作：exec, restart, update, get 等;
# $3: {namespace_keyword} namespace 的匹配关键字，可以不填；
# $4: {item_keyword} item 的匹配关键字，可以不填；
# $5: {item_index} item index，可以不填，值从 1 开始；
# 流程：
# 1. 如果 {namespace_keyword} 不填，列出所有的 namespaces；
# 2. 如果 {namespace_keyword} 已填，{item_keyword} 不填，并且匹配的 namespace 不只一个，列出所有匹配的 namespaces；
# 3. 如果 {namespace_keyword} 已填，{item_keyword} 不填，并且匹配的 namespace 只有一个，列出匹配的 namespace 下的所有 items；
# 4. 如果 {namespace_keyword} 已填，{item_keyword} 已填，并且匹配的 namespace 只有一个，列出该 namespace 下匹配的 items；
# 5. 如果 {namespace_keyword} 已填，{item_keyword} 已填，并且匹配的 namespace 只有一个，该 namespace 下匹配的 item 只有一个，则进入到 item 当中；
# 6. 如果 {item_index} 为 0，则展示 item 状态不进入 item

function k8s_core() {
    declare -r type=$1
    declare -r action=$2
    declare -r namespace_keyword=$3
    declare -r item_keyword=$4
    item_index=$5

    # 根据关键字匹配 namespaces
    namespaces="$(kubectl get ns | awk 'NR>1' | grep -i "${namespace_keyword}" | awk '{print $1}')"

    # 没有找到任何合适的 namespace
    [[ ! "${namespaces}" ]] && echo "no namespace like $1" && exit

    # 打印匹配的 namespaces
    echo "namespaces:"
    echo "${namespaces}"
    echo ""

    # 匹配多个 namespaces 退出
    match_size="$(wc -l <<< "${namespaces}")"
    (( "${match_size}" > 1 )) && exit

    # 根据关键字匹配 items
    namespace="${namespaces}"
    items="$(kubectl get "${type}" -n "${namespace}" | grep -i "${item_keyword}")"

    # 没有找到任何合适的 items
    [[ -z "${items}" ]] && echo "no ${type} like ${item_keyword} in ${namespace}" && exit

    # 打印匹配的 items 
    echo "${type}:"
    echo "${items}"
    echo ""

    # 如果匹配到多个 items，并且没有指定 item index 则退出
    match_size="$(wc -l <<< "${items}")"
    (( "${match_size}" > 1 )) && [[ ! "${item_index}" ]] && exit

    # 根据 item_index 进入到对应的 item 里，如果不填则 index 为 1
    [[ ! "${item_index}" ]] && item_index=1
    item="$(echo "${items}" | awk 'NR=='"${item_index}"' {print $1}')"

    # 如果 index 没有找到对应的 item 则退出。因此可以通过，填写 index 为 0 来查看 item 状态
    [[ ! "${item}" ]] && exit

    k8s_action "${type}" "${action}" "${namespace}" "${item}"
}

function k8s_action() {
    # $1: {type} k8s 对应的资源类型：pod, deployment, service, ingress 等；
    # $2: {action} k8s 对应的操作：exec, restart, update, get 等;
    # $2: {namespace} namespace 的匹配关键字，可以不填；
    # $3: {item} item 的匹配关键字，可以不填；
    if [[ "${action}" == "exec" ]]; then
	echo "command:"
	echo "kubectl exec ${item} -n ${namespace} -it -- bash"
	echo ""
	kubectl exec "${item}" -n "${namespace}" -it -- bash
	exit
    fi

    if [[ "${action}" == "restart" ]]; then
	echo "command:"
	echo "kubectl rollout restart ${type} ${item} -n ${namespace}"
	echo ""
	kubectl rollout restart "${type}" "${item}" -n "${namespace}"
	echo "kubectl rollout status ${type} ${item} -n ${namespace}"
	echo ""
	kubectl rollout status "${type}" "${item}" -n "${namespace}"
	exit
    fi

    if [[ "${action}" == "debug" ]]; then
	echo "command:"
	echo "kubectl -n ${namespace} port-forward ${item} 8000:8000"
	echo ""
	kubectl -n "${namespace}" port-forward "${item}" 8000:8000
	exit
    fi
    
    if [[ "${action}" == "get" ]]; then
	echo "command:"
	echo "kubectl get ${type} ${item} -o yaml -n ${namespace}"
	echo ""
	kubectl get "${type}" "${item}" -o yaml -n "${namespace}"
	exit
    fi


}

