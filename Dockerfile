# 使用官方 OpenJDK 21 镜像作为基础镜像
FROM openjdk:21-jdk-slim

# 设置工作目录
WORKDIR /app

# 复制 Maven 包装器
COPY mvnw .
COPY .mvn .mvn
COPY mvnw.cmd .

# 复制 pom.xml
COPY pom.xml .

# 安装 Maven 并下载依赖（利用 Docker 层缓存）
RUN apt-get update && apt-get install -y maven
RUN ./mvnw dependency:go-offline -B

# 复制源代码
COPY src ./src

# 构建应用
RUN ./mvnw clean package -DskipTests -B

# 暴露端口
EXPOSE 8080

# 运行应用
CMD ["java", "-jar", "target/nginx-controller-1.0-SNAPSHOT.jar"]