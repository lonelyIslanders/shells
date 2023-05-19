#!/bin/bash

# 列出当前目录下的所有zip文件
zip_files=($(ls *.zip))

# 如果没有zip文件则退出
if [ ${#zip_files[@]} -eq 0 ]; then
  echo "当前目录下没有zip文件"
  exit
fi

# 输出所有zip文件并让用户选择一个进行解压
for i in "${!zip_filesgit@github.com:user/repo2.git[@]}"; do
  echo "$i: ${zip_files[$i]}"
done
read -p "请选择要解压的文件（输入序号）: " selected_index

if ! [[ "$selected_index" =~ ^[0-9]+$ ]] || [ "$selected_index" -lt 0 ] || [ "$selected_index" -ge ${#zip_files[@]} ]; then
  echo "选择的序号无效"
  exit
fi


unzip "${zip_files[$selected_index]}"

unzipped_folder=$(basename "${zip_files[$selected_index]}" .zip)
cd "$unzipped_folder"


sub_dir=$(find . -maxdepth 1 -type d -not -name "." -not -name "__MACOSX" | head -n 1)
cd "$sub_dir"

# 如果vercel.json不存在，则创建并写入
if [ ! -f vercel.json ]; then
  touch vercel.json
  echo '{
  "rewrites": [
    {
      "source": "/(.*)",
      "destination": "/index.html"
    }
  ]
}' > vercel.json
fi

git init

declare -a remote_urls=("git@github.com:lonelyIslanders/shell-rep-test.git" "git@github.com:user/repo2.git" "git@github.com:user/repo3.git")
echo "预设的仓库地址:"
for i in "${!remote_urls[@]}"; do
  echo "$i: ${remote_urls[$i]}"
done
read -p "请选择要使用的仓库地址（输入序号）: " remote_index

if ! [[ "$remote_index" =~ ^[0-9]+$ ]] || [ "$remote_index" -lt 0 ] || [ "$remote_index" -ge ${#remote_urls[@]} ]; then
  echo "选择的序号无效"
  exit
fi

git remote add origin "${remote_urls[$remote_index]}"

git branch -M main
git add .
git commit -m "Initial commit"
git push --force origin main

