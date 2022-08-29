#!/bin/bash
curl http://192.168.1.237:8090/rs/match-config | jq '.matchConfigurations | .[] | .id' >./dataset.csv

HOME=/opt/apache-jmeter-5.5/bin

export JVM_ARGS="-Dnashorn.args=--no-deprecation-warning"

# <run the test>

$HOME/jmeter -n -t evaluate-load-test/first-wave_0-5-in-5.jmx
$HOME/jmeter -n -t evaluate-load-test/second-wave_keep-5-in-5.jmx
$HOME/jmeter -n -t evaluate-load-test/third-wave_5-10-in-5.jmx
$HOME/jmeter -n -t evaluate-load-test/fourth-wave_keep-10-in-5.jmx
$HOME/jmeter -n -t evaluate-load-test/fifth-wave_keep-5-in-5.jmx

# <generating html reports>

$HOME/jmeter -g $HOME/result_output/summary-report-log-1.csv -o $HOME/result_output/summary-report-log-1_0to5in5
$HOME/jmeter -g $HOME/result_output/summary-report-log-2.csv -o $HOME/result_output/summary-report-log-2_keep5in5
$HOME/jmeter -g $HOME/result_output/summary-report-log-3.csv -o $HOME/result_output/summary-report-log-3_5to10in5
$HOME/jmeter -g $HOME/result_output/summary-report-log-4.csv -o $HOME/result_output/summary-report-log-4_keep10in5
$HOME/jmeter -g $HOME/result_output/summary-report-log-5.csv -o $HOME/result_output/summary-report-log-5_keep5in5

# ./JMeterPluginsCMD.sh --generate-csv test.csv --input-jtl results.jtl --plugin-type ResponseTimesOverTime
