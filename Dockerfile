FROM ubuntu:20.04
LABEL authors="https://github.com/K-scorpi"
EXPOSE 6666
# Установка пакетиков
RUN apt-get update && apt-get install -y \
    build-essential -y\
    wget \
    autoconf \
    libssl-dev \
    zlib1g-dev \
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

# Запускаем bash скрипт и перенаправляем вывод в файл  chmod +x /scripts/
WORKDIR /
RUN bash /scripts/Cat-Scale.sh && \
    echo "Cat-Scale executed successfully!" && \
    bash /scripts/unix_collector.sh && \
    echo "unix_collector executed successfully!" && \
    python2 /scripts/fast.py

# RUN bash /scripts/tuxresponse.sh && \ python2 /scripts/fast.py && \ echo "fastIR_collector_linux"
# Вывод auditd /etc
#RUN ausearch -f /etc
#RUN aureport -x

CMD ["echo", "Scripts executed successfully!"] 

# docker build -t my_auto_image .
# docker run -t -P -d -v --name my_auto_image