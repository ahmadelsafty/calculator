FROM openjdk:11-jre-slim

WORKDIR /app

COPY target/calculator-1.0.jar app.jar

ENTRYPOINT ["java", "-jar", "app.jar"]
