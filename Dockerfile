FROM ubuntu
#установим рабочий каталог
WORKDIR /lab
#копируем файл в контейнер
COPY file.sh /lab/file.sh
#установим права на выполнение файла в контейнере
RUN chmod +x /lab/file.sh
#том
VOLUME ["/shareVol"]
#запуск файла при запуске контейнера
CMD ["/lab/file.sh"]
