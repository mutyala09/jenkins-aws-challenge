FROM openjdk:8-jdk-alpine
VOLUME /main-app
ADD target/spring-boot-rest-mongodb-0.0.1-SNAPSHOT.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar","/app.jar"]
