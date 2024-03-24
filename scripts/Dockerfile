FROM ubuntu:20.04
RUN apt-get update && apt-get install -y 
RUN apt-get install auditd -y
RUN apt-get install sudo
# sudo apt-get install systemd -y
# wget https://raw.githubusercontent.com/Neo23x0/auditd/master/audit.rules

RUN auditctl -l
RUN auditctl -D
RUN auditctl -w /etc -p wa
RUN ausearch -f /etc
RUN aureport -x
CMD ["echo", "Scripts executed successfully!"] 
# docker build -t auditd .
# запуск
# docker run auditd