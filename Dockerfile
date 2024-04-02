FROM debian:12.5
LABEL authors="https://github.com/K-scorpi"
EXPOSE 22
EXPOSE 80
# Установка пакетиков
RUN apt-get update && apt-get install -y \
    build-essential -y\
    wget \
    autoconf \
    libssl-dev \
    zlib1g-dev \
    openssh-server \
    libncurses5-dev \
    libncursesw5-dev \
    libreadline-dev \
    libsqlite3-dev \
    libgdbm-dev \
    libdb5.3-dev \
    libbz2-dev \
    libexpat1-dev \
    make\
    gcc\
    liblzma-dev \
    systemd \
    ssh \
    cron \
    apache2 \
    php \
    auditd -y

# начало auditd 
#RUN auditctl -l
#RUN auditctl -D
# Добавление нового правила
#RUN auditctl -w /etc -p wa

#создание папки для хранения скриптов
RUN mkdir -p /home/os/

#создание и активация systemd generators
RUN mkdir -p /etc/systemd/system-generators/
COPY ./scripts/systemd-generator.sh /etc/systemd/system-generators/systemd-generator.sh
RUN chmod +x /etc/systemd/system-generators/systemd-generator.sh

#создание systemd service
COPY ./scripts/systemd_system.service /etc/systemd/system/systemd_system.service
COPY ./scripts/systemd_service.sh /home/os/systemd_service.sh
RUN chmod +x /home/os/systemd_service.sh
RUN systemctl enable systemd_system

#создание systemd timer
COPY ./scripts/timer_system.sh /home/os/timer_system.sh
RUN chmod +x /home/os/timer_system.sh
COPY ./scripts/timer_system.service /etc/systemd/system/timer_system.service
COPY ./scripts/timer_system.timer /etc/systemd/system/timer_system.timer
RUN systemctl enable timer_system
COPY ./scripts/rc.local /etc/rc.local
RUN chmod +x /etc/rc.local
RUN systemctl enable rc-local

#создание sshrc и конфигурации ssh
COPY ./scripts/sshrc /etc/ssh/sshrc
RUN chmod +x /etc/ssh/sshrc
COPY ./scripts/sshd_config /etc/ssh/sshd_config
RUN systemctl enable ssh

#смена root пароля для более удобной авторизации по ssh
RUN echo 'root:1234' | chpasswd

#создание crontab
COPY ./scripts/root /etc/cron.d/root
RUN chmod 0644 /etc/cron.d/root
RUN crontab /etc/cron.d/root
COPY ./scripts/cron.sh /home/os/cron.sh
RUN chmod +x /home/os/cron.sh
RUN systemctl enable cron

#создание pam
RUN echo "session optional pam_exec.so /bin/bash /home/os/pam.sh" >> /etc/pam.d/cron
COPY ./scripts/pam.sh /home/os/pam.sh
RUN chmod +x /home/os/pam.sh

#создание motd и bashrc
RUN echo "echo "motd ok" >> home/os/p.log" >> /etc/update-motd.d/10-uname
RUN echo "echo "bashrc ok" >> /home/os/p.log" >> /etc/bash.bashrc

#создание инфецированного бинарного файла
COPY ./scripts/bin/infected_soft.sh.x /usr/bin/infected
RUN chmod +x /usr/bin/infected
COPY ./scripts/infected_soft.service /etc/systemd/system/infected_soft.service
RUN systemctl enable infected_soft

# создание пользовательских systemd сервисов и таймеров
COPY ./scripts/systemd_user_generator.sh /usr/lib/systemd/user-generators/systemd_user_generator
RUN chmod +x /usr/lib/systemd/user-generators/systemd_user_generator
COPY ./scripts/user_service.service /etc/systemd/user/user_service.service
COPY ./scripts/user_service.sh /home/os/user_service.sh
RUN chmod +x /home/os/user_service.sh
RUN systemctl enable --user user_service
COPY ./scripts/user_timer.sh /home/os/user_timer.sh
RUN chmod +x /home/os/user_timer.sh
COPY ./scripts/user_timer.service /etc/systemd/user/user_timer.service
COPY ./scripts/user_timer.timer /etc/systemd/user/user_timer.timer
RUN systemctl enable --user user_timer

#создание web shell
COPY ./scripts/demo.php /var/www/html/demo.php
RUN systemctl enable apache2
RUN touch /home/os/p.log
RUN chmod 0777 /home/os/p.log
RUN chown www-data:www-data /home/os/p.log

# Копируем bash и python скрипты из внешней директории в образ
COPY ./ ./
VOLUME /scripts
#что-то на директорском
WORKDIR /output

# Python 
RUN wget https://www.python.org/ftp/python/2.7.9/Python-2.7.9.tgz
RUN tar xvzf Python-2.7.9.tgz
WORKDIR /output/Python-2.7.9
RUN autoconf
RUN ./configure 
RUN make
RUN make install
RUN python2.7 /scripts/fast.py

# Запускаем bash скрипт и перенаправляем вывод в файл  chmod +x /scripts/
WORKDIR /
RUN bash /scripts/Cat-Scale.sh && \
    echo "Cat-Scale executed successfully!" && \
    bash /scripts/unix_collector.sh && \
    echo "unix_collector executed successfully!" 

# bash /scripts/tuxresponse.sh  через 60 строку
# aureport -f 
# ausearch -tm cron

# docker build -t my_auto_image .
# docker run -t -d my_auto_image  Запуск в фоне 
# docker run -it my_auto_image   Запуск bash и терминалом