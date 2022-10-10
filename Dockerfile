# multi-stage build
# stage 1

FROM openjdk:11-slim as build

# add maintainer info (key,value)
LABEL maintainer="dasd412 <dasd412@naver.com>"

ARG JAR_FILE

COPY ${JAR_FILE} app.jar

# unpackage jar file
RUN mkdir -p target/dependency && (cd target/dependency; jar -xf /app.jar)

# stage 2
FROM openjdk:11-slim

# ADD volume pointing to /tmp
VOLUME /tmp

# Copy unpackaged application to new container
ARG DEPENDENCY=/target/dependency
COPY --from=build ${DEPENDENCY}/BOOT-INF/lib /app/lib
COPY --from=build ${DEPENDENCY}/META-INF /app/META-INF
COPY --from=build ${DEPENDENCY}/BOOT-INF/classes /app

ENTRYPOINT ["java","-cp","app:app/lib/*","com.optimagrowth.license.LicensingServiceApplication"]
