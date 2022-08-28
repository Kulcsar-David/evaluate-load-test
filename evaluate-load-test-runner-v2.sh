#!/bin/bash
curl http://192.168.1.237:8090/rs/match-config | jq '.matchConfigurations | .[] | .id' >./dataset.csv

export JVM_ARGS="-Dnashorn.args=--no-deprecation-warning"

# <run the test>

./jmeter -n -t ../test-files/first-wave_0-5-in-5.jmx
./jmeter -n -t ../test-files/second-wave_keep-5-in-5.jmx
./jmeter -n -t ../test-files/third-wave_5-10-in-5.jmx
./jmeter -n -t ../test-files/fourth-wave_keep-10-in-5.jmx
./jmeter -n -t ../test-files/fifth-wave_keep-5-in-5.jmx

# <generating html reports>

./jmeter -g /opt/apache-jmeter-5.5/bin/result_output/summary-report-log-1.csv -o /opt/apache-jmeter-5.5/bin/result_output/log-1_0to5in5
./jmeter -g /opt/apache-jmeter-5.5/bin/result_output/summary-report-log-2.csv -o /opt/apache-jmeter-5.5/bin/result_output/log-2_keep5in5
./jmeter -g /opt/apache-jmeter-5.5/bin/result_output/summary-report-log-3.csv -o /opt/apache-jmeter-5.5/bin/result_output/log-3_5to10in5
./jmeter -g /opt/apache-jmeter-5.5/bin/result_output/summary-report-log-4.csv -o /opt/apache-jmeter-5.5/bin/result_output/log-4_keep10in5
./jmeter -g /opt/apache-jmeter-5.5/bin/result_output/summary-report-log-5.csv -o /opt/apache-jmeter-5.5/bin/result_output/log-5_keep5in5

# ./JMeterPluginsCMD.sh --generate-csv test.csv --input-jtl results.jtl --plugin-type ResponseTimesOverTime
