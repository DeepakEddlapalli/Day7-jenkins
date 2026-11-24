
# ==================================
# STAGE 1: BUILDER
# ==================================

FROM maven:3.9-eclipse-temurin-17 AS builder

WORKDIR /app

# Copy Maven configuration
COPY pom.xml .

# Download Maven dependencies
RUN mvn dependency:go-offline

# Copy Java source code
COPY src ./src

# Compile and package the application
RUN mvn clean package -DskipTests


# ==================================
# STAGE 2: RUNTIME
# ==================================

FROM eclipse-temurin:17-jre AS runtime

WORKDIR /app

# Copy only the generated JAR from Stage 1
COPY --from=builder /app/target/jenkins-day7-1.0.0.jar app.jar

# Start Java application
ENTRYPOINT ["java", "-cp", "app.jar", "com.example.App"]

