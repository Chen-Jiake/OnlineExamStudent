# OnlineExamStudent
在线考试系统——学生考试界面

## 将项目部署到阿里云
1. 执行npm run build打包
2. 把node_modules、static、.nuxt、package.json和Dockerfile文件上传到服务器
3. 执行docker build -t exam-student . 生成镜像
4. 执行docker run -d -p 8011:8011 --name exam-student exam-student 运行容器
