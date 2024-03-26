FROM ubuntu:latest
LABEL authors="https://github.com/K-scorpi"
EXPOSE 22
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
    auditd -y

# начало auditd 
#RUN auditctl -l
#RUN auditctl -D
# Добавление нового правила
#RUN auditctl -w /etc -p wa

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

# RUN bash /scripts/tuxresponse.sh  через 60 строку
    # aureport -f \
    # ausearch -tm cron

# docker build -t my_auto_image .
# docker run -t -d my_auto_image  Запуск в фоне 
# docker run -it my_auto_image   Запуск bash и терминалом