FROM ubuntu:20.04

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
    liblzma-dev
RUN apt-get clean
# auditd
RUN apt-get install auditd -y
# начало auditd /etc

#RUN auditctl -l

# Удаление правил, если требуется
#RUN auditctl -D

# Добавление нового правила
#RUN auditctl -w /etc -p wa

# Копируем bash и python скрипты из внешней директории в образ
#COPY Extract-Cat-Scale.sh /scripts/Extract-Cat-Scale.sh
#COPY Cat-Scale.sh /scripts/Cat-Scale.sh
#COPY unix_collector.sh /scripts/unix_collector.sh
#COPY .cmds.sh /scripts/.cmds.sh
#COPY .menu_en.sh /scripts/.menu_en.sh
#COPY tuxresponse.sh /scripts/tuxresponse.sh

#COPY fast.py /scripts/fast.py
COPY ./ ./
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
#--enable-optimizations
#RUN make altinstall
# Удаляем лишнее
#RUN rm -r /output/Python-2.7.17
#RUN rm /output/Python-2.7.17.tgz

# Запускаем bash скрипт и перенаправляем вывод в файл  chmod +x /scripts/
WORKDIR /
RUN bash /scripts/Cat-Scale.sh
RUN echo Cat-Scale
RUN bash /scripts/unix_collector.sh
RUN echo unix_collector
# RUN bash /scripts/tuxresponse.sh

RUN python2 /scripts/fast.py
#RUN echo fastIR_collector_linux

# Вывод auditd /etc
#RUN ausearch -f /etc
#RUN aureport -x

#Успешный успех
CMD ["echo", "Scripts executed successfully!"] 


# сборка 
# docker build -t my_auto_image .
# запуск
# docker run my_auto_image