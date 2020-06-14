#!/bin/bash
#
# ディスク使用量チェックスクリプト
#
# usage: disk_usage.bash
# ディスク使用量が　THRESHOLD(%)を超えたら警告
THRESHOLD="60"

# 引数: なし

print_disk_usage (){
    # df コマンドのオプション
    local DF_OPTIONS="-k -l"
    local line used

    df ${DF_OPTIONS} | 
    (
        # ヘッダ行をそのまま表示
        read line
        echo "${line}"
        while read line; do
            # "デバイス" "総容量" "使用中" "空き容量" "使用率" ---
            set -- ${line}
            
            case "$1" in
                # 実存する（仮想でない）デバイスのみ対象
                /* )
                
                used=${5%%"%"*}
                
                if [ ${used} -ge ${THRESHOLD} ]; then
                    echo "${line}"
                fi
                ;;
            esac
        done
    )
}

output=$(print_disk_usage)
lines=$(echo "${output}" | wc -l)

if [ ${lines} -gt 1 ]; then
    echo "${output}"
fi
