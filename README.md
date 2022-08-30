# docker build --no-cache -t jmeter_base:latest -f Dockerfile .

<!-- # docker run -it jmeter_base:latest -->

# docker run -it -v {local-volume}:/opt/apache-jmeter-5.5/bin/result_output/ jmeter_base:latest

# cd bin

# git clone https://github.com/Kulcsar-David/evaluate-load-test.git

# cd evaluate-load-test

# chmod +x evaluate-load-test-runner-v2.sh

# ./evaluate-load-test-runner-v2.sh
