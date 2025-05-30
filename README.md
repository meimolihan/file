# file 文件服务

* **jpg--CDN加速地址**    
**<https://cdn.jsdelivr.net/gh/meimolihan/file@v1.0.0/img/git-01.jpg>**

* **Markdown链接**
```markdown
## 博客封面
![](https://cdn.jsdelivr.net/gh/meimolihan/file@v1.0.0/img/git-01.jpg)

## 教程截图
![](https://cdn.jsdelivr.net/gh/meimolihan/file@v1.0.0/screenshot/git-001.jpg)
```

![](https://cdn.jsdelivr.net/gh/meimolihan/file@v1.0.0/img/git-01.jpg)

![](https://cdn.jsdelivr.net/gh/meimolihan/file@v1.0.0/screenshot/git-001.jpg)



> jsdelivr-CDN加速地址
>> `https://cdn.jsdelivr.net/gh/`  ## 免费CDN加速GitHub  
>> `meimolihan`  ## 用户名  
>> `file`  ## 项目名  
>> `img` ## 文件名  
>> `v1.0.0`   ## 标签名  
>> `git-01.jpg`  ## 文件名

---



# vercel 加速地址

```markdown
## 博客封面
![](http://file.meimolihan.eu.org/img/git-01.jpg)

## 教程截图
![](http://file.meimolihan.eu.org/screenshot/git-001.jpg)
```



![](http://file.meimolihan.eu.org/img/git-01.jpg)

![](http://file.meimolihan.eu.org/screenshot/git-001.jpg)

# file-tags-push.bat

> 用于将本地更新推送到指定Tags的windows的批处理文件。  
> 双击执行后会删除v1.0.0标签，然后重建v1.0.0标签，将更新推送到新建的v1.0.0便签，间接实现了更新内容保持便签不变。  
> 因为我需要保证标签不变，用于cdn加速文件服务。  
> 按需修改批处理中的`Git创库目录`和具体的`v1.0.0便签`。  
>> 下面是下载`file-tags-push.bat`的命令：

* **GitHub地址下载命令【cmd/ssh】**
```bash
wget -O file-tags-push.bat https://github.com/meimolihan/file/raw/refs/heads/main/tags-push/file-tags-push.bat
```

* **CDN加速地址下载命令【cmd/ssh】**  
```bash
wget -O file-tags-push.bat https://cdn.jsdelivr.net/gh/meimolihan/file@v1.0.0/tags-push/file-tags-push.bat
```

---

