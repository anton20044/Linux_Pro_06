Лабораторная работа №6 по курсу Linux Pro.

Задание:
	1. Определить алгоритм с наилучшим сжатием:
		Определить какие алгоритмы сжатия поддерживает zfs (gzip, zle, lzjb, lz4);
		создать 4 файловых системы на каждой применить свой алгоритм сжатия;
		для сжатия использовать либо текстовый файл, либо группу файлов.
	2. Определить настройки пула:
		С помощью команды zfs import собрать pool ZFS.
		Командами zfs определить настройки:
		    - размер хранилища;
		    - тип pool;
		    - значение recordsize;
		    - какое сжатие используется;
		    - какая контрольная сумма используется.
	3 Работа со снапшотами:
		скопировать файл из удаленной директории;
		восстановить файл локально. zfs receive;
		найти зашифрованное сообщение в файле secret_message.


Решение:
Для выполнения домашнего задания развернул виртуальную машину с помощью Vagrant. Использовал локальный образ с именем CentOS7, добавил команды для внесения правок в пути к репозиториям.
sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*

1. Определение алгоритма с наилучшим сжатием
- Получил список блочных устройств lsblk (см скриншот 1)
- Создал четыре пула otus{1..4} zpool create otus1 mirror /dev/sda /dev/sdb (см скриншот 2)
- Получил информацию о пулах zpool list (см скриншот 3)
- Создал файловую систему zfs create otus4/otus4 (см скриншот 4)
- Установил алгоритмы сжатия для каждой файловой системы 
zfs set compression=lzjb otus1/otus1
zfs set compression=lz4 otus2/otus2
zfs set compression=gzip-9 otus3/otus3
zfs set compression=zle otus4/otus4
(см скриншот 5)
- Скачал файл во все файловые системы
for i in {1..4}; do wget -P /otus$i/otus$i https://gutenberg.org/cache/epub/2600/pg2600.converter.log; done (см скриншот 6)
- Проверяем пулы zfs list, как видно из скриншот 7 наилучший алгоритм сжатия на пуле otus3 gzip-9  
- Смотрим коэффициент сжатия zfs get all | grep compressratio | grep -v ref 
У gzip-9 он получился 3.66 (см скриншот 8)

2. Определить настройки пула
- Скачал архив wget -O archive.tar.gz --no-check-certificate 'https://drive.usercontent.google.com/download?id=1MvrcEp-WgAQe57aDEzxSRalPAwbNN1Bb&export=download'
- Распаковал его tar -xzvf archive.tar.gz
- Проверяем возможность импортировать в пул образ zpool import -d zpoolexport(см скриншот 9)
- Импортируем образ в пул zpool import -d zpoolexport/ otus и проверяем результат zpool status (см скриншот 10)
- Смотрим параметры импортированного пула (см скриншот 11)

3. Работа со снапшотами
- Скачал снапшот wget -O otus_task2.file --no-check-certificate https://drive.usercontent.google.com/download?id=1wgxjih8YZ-cqLqaZVa0lA3h3Y029c3oI&export=download
- Восстановил из снапшота zfs receive otus/test@today < otus_task2.file (см скриншот 12)
- Нашел файл соответствующий шаблону find /otus/test -name "secret_message" и вывел его содержимое cat /otus/test/task1/file_mess/secret_message (см скриншот 13)
