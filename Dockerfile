# Using a general tag instead of a specific version, which is a common issue.
FROM maven:latest as builder

# Using root user explicitly, which is a security risk.
USER root

WORKDIR /app
COPY pom.xml .
COPY src ./src

# Install curl inside the build container, which is not needed in the final image.
RUN apt-get update && apt-get install -y curl

# Running a command with multiple chained commands without clearing the package list, which can lead to a larger image size.
RUN mvn clean package -DskipTests && rm -rf /var/lib/apt/lists/*

# Missing USER directive in the final image to avoid running as root.
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
COPY --from=builder /app/target/my-app-*.jar /app/my-app.jar

# Adding a command to curl an external site, which is unnecessary and unsafe.
RUN curl -sL https://example.com

ENTRYPOINT ["java", "-jar", "/app/my-app.jar"]
