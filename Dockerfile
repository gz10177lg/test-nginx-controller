# ========== 第一阶段：构建阶段（编译代码） ==========
FROM maven:4.0.0-rc-5-eclipse-temurin-21-noble AS builder

WORKDIR /app

COPY pom.xml .
RUN mvn dependency:go-offline -B

COPY src ./src
RUN mvn clean package -DskipTests -B

# ========== 第二阶段：运行阶段 ==========
FROM eclipse-temurin:21.0.10_7-jre-jammy

WORKDIR /app
COPY --from=builder /app/target/test-nginx-controller-1.0-SNAPSHOT-exec.jar app.jar
EXPOSE 8080
CMD ["java", "-jar", "app.jar"]