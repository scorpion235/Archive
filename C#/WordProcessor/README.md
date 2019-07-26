Текстовый процессор
===================

Для реализации тестового задания использована СУБД Firebird Embedded (установка сервера не требуется)
WordProcessor\db\word_processor.fdb - скрипт создания структуры базы данных (накатывать не нужно)
WordProcessor\db\word_processor.sql - сама база данных

WordProcessor\dictionary\dictionary.txt - данные для словаря

WordProcessor\WordProcessor\WordProcessor.sln - проект на C# (среда разработки VS2017)

Параметры командной строки:
1) -create создание словаря
2) -update обновление словаря
3) -delete очистить словарь
