FROM openjdk:8-jdk as jdk
COPY . /tmp/shopizer/
RUN rm /tmp/shopizer/sm-core/src/test/java/com/salesmanager/test/catalog/ProductTest.java
RUN cd /tmp/shopizer && \
    ./mvnw clean install

FROM tomcat:jre8
VOLUME /tmp
RUN rm -rf /usr/local/tomcat/webapps/ROOT && \
    mkdir -p /usr/local/tomcat/files
COPY --from=jdk /tmp/shopizer/sm-shop/target/ROOT.war /usr/local/tomcat/webapps/
COPY --from=jdk /tmp/shopizer/sm-shop/SALESMANAGER.h2.db /usr/local/tomcat/
COPY --from=jdk /tmp/shopizer/sm-shop/files/ /usr/local/tomcat/files/
ENV JAVA_OPTS="-Xmx1024m"
CMD ["catalina.sh", "run"]
EXPOSE 8080
