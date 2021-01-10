# OnlineExamStudent
在线考试系统——学生考试界面

## 简介
本项目在以下两个项目的基础上完成
1. https://github.com/hongfurui2014/exam_online_hongfurui
2. https://gitee.com/davz/yf-exam-lite

项目还包括了
1. [在线考试系统——后台管理界面](https://github.com/Chen-Jiake/OnlineExamAdmin)
2. [在线考试系统——后端](https://github.com/Chen-Jiake/OnlineExamServer)

使用vue和springcloud开发

## 如何将学生考试界面部署到阿里云
1. 执行npm run build打包
2. 把node_modules、static、.nuxt、package.json和Dockerfile文件上传到服务器
3. 执行docker build -t exam-student . 生成镜像
4. 执行docker run -d -p 8011:8011 --name exam-student exam-student 运行容器
