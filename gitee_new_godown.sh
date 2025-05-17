#!/bin/bash

# 打印欢迎信息

echo "================= ================="

echo "* Gitee 创建新仓库后使用此脚本，创建仓库，初始化仓库，提交仓库"

echo "================= ================="

# 提示用户输入项目父目录路径

read -p "请输入项目父目录路径（默认为 /vol1/1000/home）: " base_dir

# 如果用户未输入路径，则使用默认路径

base_dir=${base_dir:-/vol1/1000/home}

# 创建父目录并检查是否成功

if mkdir -p "$base_dir"; then

    echo "项目父目录已创建：$base_dir"

else

    echo "无法创建项目父目录，请检查路径是否正确或是否有权限。"

    exit 1

fi

# 提示用户输入仓库名称

read -p "请输入仓库名称: " repo_name

# 检查仓库名称是否为空

if [[ -z "$repo_name" ]]; then

    echo "仓库名称不能为空，请重新运行脚本并输入有效的仓库名称。"

    exit 1

fi

# 创建仓库目录

repo_path="$base_dir/$repo_name"

if mkdir -p "$repo_path"; then

    echo "仓库目录已创建: $repo_path"

else

    echo "无法创建仓库目录，请检查路径是否正确或是否有权限。"

    exit 1

fi

# 进入仓库目录

cd "$repo_path" || exit 1

# 初始化 Git 仓库

git init

if [[ $? -eq 0 ]]; then

    echo "Git 仓库已初始化。"

else

    echo "Git 初始化失败，请检查 Git 是否已安装。"

    exit 1

fi

# 提示用户输入远程仓库地址

read -p "请输入远程仓库地址: " remote_url

# 添加远程仓库地址

git remote add origin "$remote_url"

if [[ $? -eq 0 ]]; then

    echo "远程仓库地址已添加。"

else

    echo "远程仓库地址添加失败，请检查输入的地址是否正确。"

    exit 1

fi

# 创建一个示例文件

echo "这是一个示例文件" > README.md

# 添加文件到暂存区并提交

git add .

git commit -m "Initial commit"

if [[ $? -eq 0 ]]; then

    echo "提交成功。"

else

    echo "提交失败，请检查 Git 配置是否正确。"

    exit 1

fi

# 推送代码到远程仓库

git push -u origin master

if [[ $? -eq 0 ]]; then

    echo "代码已成功推送到远程仓库。"

else

    echo "推送失败，请检查远程仓库地址和权限。"

    exit 1

fi

