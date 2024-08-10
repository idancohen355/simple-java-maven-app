here is the dockerfile:
FROM maven:3.9.2-eclipse-temurin-17 as builder
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
COPY --from=builder /app/target/my-app-*.jar /app/my-app.jar
ENTRYPOINT ["java", "-jar", "/app/my-app.jar"]
