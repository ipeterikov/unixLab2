#!/bin/sh

# Функция для поиска первого доступного имени файла
searchName() {
    i=1
    while true; do
        # Преобразование числа в строку с ведущими нулями
        file=$(printf "%03d" $i) 
        if [ ! -e "/shareVol/$file" ]; then 
            printf "%03d" $i 
            break
        fi
        i=$((i+1)) 
    done
}

# Функция записи в файл индентификатора контейнера и порядкового номера файла
idContFile() {
    local file=$1
    
    # Генерация случайного идентификатора из 10 символов
    local id=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 10) 

    # Вывод идентификатора контейнера и порядкового номера файла
    echo "Container id: $id, Filename: $file"
    
    # Запись идентификатора контейнера и порядкового номера файла  
    echo "$id-$file" > "/shareVol/$file"

}

# Функция удаления файла
deleteFile() {
    local file=$1
    echo "Deleted $file"
 
    rm "/shareVol/$file" 
}

while true; do
    # Блокировка файла
    exec 5>/shareVol/lockfile
    flock -x 5

    file=$(searchName)
    idContFile "$file"
    
    # Снятие блокировки
    exec 5<&-
    sleep 1
    deleteFile "$file"

    echo
    sleep 1 
    
done
