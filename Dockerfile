FROM openjdk:8u181-jdk
COPY ./voter-service ./usr/local/voter-service
WORKDIR /usr/local/voter-service
RUN ./gradlew clean build -x test
EXPOSE 8099
CMD ["java", "-jar", "build/libs/voter-service-0.2.0.jar", "--spring.data.mongodb.host=voter-mongo"]