# Step 1
FROM ubuntu:18.04
LABEL VENDOR=Precognox \
  PRODUCT=Evaluation-load-test \
  Version=1.0.0
# Step 2
ARG JMETER_VERSION="5.5"
ARG CMDRUNNER_JAR_VERSION="2.2.1"
ARG JMETER_PLUGINS_MANAGER_VERSION="1.6"
ENV JMETER_HOME /opt/apache-jmeter-${JMETER_VERSION}
ENV JMETER_LIB_FOLDER ${JMETER_HOME}/lib/
ENV JMETER_PLUGINS_FOLDER ${JMETER_LIB_FOLDER}ext/
# Step 3:
# Download some required package
WORKDIR ${JMETER_HOME}
RUN apt-get -y update \
  && apt-get -y upgrade \
  && apt-get -y install p7zip-full p7zip-rar \
  && apt-get install -y --no-install-recommends \
  git \
  openjdk-8-jre-headless \
  && apt-get -y install apt-utils \
  && apt-get install -y wget gnupg curl \
  && apt-get -y install jq \
  && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - 
# Step 4:
# Download Apache JMeter
RUN wget https://dlcdn.apache.org//jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz
RUN tar -xzf apache-jmeter-${JMETER_VERSION}.tgz
RUN mv apache-jmeter-${JMETER_VERSION}/* /opt/apache-jmeter-${JMETER_VERSION}
RUN rm -r /opt/apache-jmeter-${JMETER_VERSION}/apache-jmeter-${JMETER_VERSION}
# Step 5:
# Download Command Runner and move it to lib folder
WORKDIR ${JMETER_LIB_FOLDER}
RUN wget https://repo1.maven.org/maven2/kg/apc/cmdrunner/${CMDRUNNER_JAR_VERSION}/cmdrunner-${CMDRUNNER_JAR_VERSION}.jar
# Step 6:
# Download JMeter Plugins manager and move it to lib/ext folder
WORKDIR ${JMETER_PLUGINS_FOLDER}
RUN wget https://repo1.maven.org/maven2/kg/apc/jmeter-plugins-manager/${JMETER_PLUGINS_MANAGER_VERSION}/jmeter-plugins-manager-${JMETER_PLUGINS_MANAGER_VERSION}.jar
# Step 7:
WORKDIR ${JMETER_LIB_FOLDER}
RUN java  -jar cmdrunner-2.2.1.jar --tool org.jmeterplugins.repository.PluginManagerCMD install-all-except jpgc-hadoop,jpgc-oauth,ulp-jmeter-autocorrelator-plugin,ulp-jmeter-videostreaming-plugin,ulp-jmeter-gwt-plugin,tilln-iso8583
# Step 8:
WORKDIR ${JMETER_HOME}
# Step 9:
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV PATH="$JAVA_HOME/bin:${PATH}"
RUN update-ca-certificates
# Step 10:
# Copying the test files
COPY ./evaluate-load-test.zip /opt/apache-jmeter-${JMETER_VERSION}/bin
RUN 7z x /opt/apache-jmeter-${JMETER_VERSION}/bin/evaluate-load-test.zip -o/opt/apache-jmeter-${JMETER_VERSION}/bin/
RUN rm -rf /opt/apache-jmeter-${JMETER_VERSION}/bin/evaluate-load-test.zip
RUN cd /opt/apache-jmeter-${JMETER_VERSION}/bin/evaluate-load-test
RUN chmod +x /opt/apache-jmeter-${JMETER_VERSION}/bin/evaluate-load-test/evaluate-load-test-runner-v2.sh