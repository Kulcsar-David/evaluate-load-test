#!/bin/bash
curl http://192.168.1.237:8090/rs/match-config | jq '.matchConfigurations | .[] | .id' >./dataset.csv

HOME=/opt/apache-jmeter-5.5/bin

export JVM_ARGS="-Dnashorn.args=--no-deprecation-warning"

# <run the test>

$HOME/jmeter -n -t evaluate-load-test/1st-wave-0-5-in-5.jmx
$HOME/jmeter -n -t evaluate-load-test/2nd-wave-keep-5-in-5.jmx
$HOME/jmeter -n -t evaluate-load-test/3rd-wave-0-10-in-5.jmx
$HOME/jmeter -n -t evaluate-load-test/4th-wave-keep-10-in-5.jmx
$HOME/jmeter -n -t evaluate-load-test/5th-wave-0-10-in-10.jmx

# <generating html reports>

$HOME/jmeter -g $HOME/result_output/summary-report-log-1.csv -o $HOME/result_output/summary-report-log-1_0to5in5
$HOME/jmeter -g $HOME/result_output/summary-report-log-2.csv -o $HOME/result_output/summary-report-log-2_keep5in5
$HOME/jmeter -g $HOME/result_output/summary-report-log-3.csv -o $HOME/result_output/summary-report-log-3_0to10in5
$HOME/jmeter -g $HOME/result_output/summary-report-log-4.csv -o $HOME/result_output/summary-report-log-4_keep10in5
$HOME/jmeter -g $HOME/result_output/summary-report-log-5.csv -o $HOME/result_output/summary-report-log-5_0to10in10

# ./JMeterPluginsCMD.sh --generate-csv test.csv --input-jtl results.jtl --plugin-type ResponseTimesOverTime
