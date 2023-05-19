#!/bin/bash
clear
cd /home/skynet/下载/TelegramTemp

# 加入选项0，删除所有文件
echo -e "\033[33m可用选项：\033[0m"
echo -e "\033[33m0: 删除所有文件\033[0m"
echo ""

# 将文件列表存储到数组中
readarray -t files < <(ls -t)

echo -e "\033[33m可用文件\033[0m"
for index in "${!files[@]}"
do
    echo "$((index+1)): ${files[index]}"
done

while true
do
    read -p "请选择文件序号：" fileIndex

#先判断是否是数字，不是直接拦截
if [[ "$fileIndex" =~ ^[0-9]+$ ]]; then
 #再判断选择是否为0，如果是，删除所有文件后退出脚本
    if [ "$fileIndex" -eq 0 ]; then
    sudo rm -r /home/skynet/下载/TelegramTemp/*
        exit 0
    fi

    #再判断输入的序号是否有效
    if [ "$fileIndex" -gt 0 ] && [ "$fileIndex" -le "${#files[@]}" ]; then
        break
    else
        echo -e "\033[31m无效序号，请重新输入\033[0m"
    fi
else
        echo -e "\033[31m无效序号，请重新输入\033[0m"
fi
done

fileName=${files[fileIndex-1]}

echo -e "\033[33m可用ip：\033[0m"
ips=("root@162.0.222.70" "root@shenshoudaolianmeng.com" "root@nftspt.ai" "root@nftpopen.ai" "root@pmpswap.net" "root@nuwa.live" "root@hylc.xyz" "root@192.64.115.37" "root@43.130.57.118" "root@spbad.asia")
for index in "${!ips[@]}"
do
    echo "$((index+1)): ${ips[index]}"
done
while true
do
    read -p "请选择ip序号：" ipIndex
    #判断是否是数字，否则拦截
    if [[ "$ipIndex" =~ ^[0-9]+$ ]]; then
    #再判断输入的序号是否有效
    if [ "$ipIndex" -gt 0 ] && [ "$ipIndex" -le "${#ips[@]}" ]; then
        selectedIp=${ips[ipIndex-1]}
        break
    else
        echo -e "\033[31m无效序号，请重新输入\033[0m"
    fi
    else
        echo -e "\033[31m无效序号，请重新输入\033[0m"
    fi
done

echo -e "\033[33m可用目标路径：\033[0m"
pathsWithHtml=($(ssh $selectedIp "ls -d /var/www/html/*/"))
for index in "${!pathsWithHtml[@]}"
do
    pathWithoutHtml=$(echo "${pathsWithHtml[index]}" | sed 's/\/var\/www\/html\///')
    echo "$((index+1)): ${pathWithoutHtml}"
done

while true
do
    read -p "请选择目标路径序号，或输入自定义路径：" pathIndex

    # 判断输入的序号是否有效
    if [[ "$pathIndex" =~ ^[0-9]+$ ]] && [ "$pathIndex" -gt 0 ] && [ "$pathIndex" -le "${#pathsWithHtml[@]}" ]; then
        selectedPath="/var/www/html/${pathsWithHtml[pathIndex-1]#"/var/www/html/"}"
        break
    elif [ -d "$pathIndex" ]; then
        selectedPath="$pathIndex"
        break
    else
        echo -e "\033[31m无效路径，请重新输入\033[0m"
    fi
done

cmd="scp '${fileName}' '${selectedIp}:${selectedPath}'"

echo -e "\033[32m 执行命令：$cmd \033[0m"
eval "$cmd"
ssh ${selectedIp} 
cd "${selectedPath}"
pwd
