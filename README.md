Sendmail-заглушка для Linux
=====================

#### Описание
Скрипт отладочной заглушки для получения почты, отправляемой функцией mail(). Все отправленные письма будут сохраняться в локальную папку.

Сохранение возможно в текстовом формате - открывается любым текстовым редактором, либо в почтовом формате eml - такой файл можно открыть, например, в программе Thunderbird

#### Установка:
1. Откройте консоль и вставьте код

	`wget --no-check-certificate https://raw.githubusercontent.com/varrcan/fake_sendmail/master/sendmail.sh && chmod +x ./sendmail.sh && ./sendmail.sh`
	
2. В появившемся окне введите root пароль
3. Выберите пункт "Установить"
4. Выберите формат сохраняемых писем (txt или eml)
3. Готово!

##### Тестировалось на ОС:
Ubuntu, Kubuntu, Linux Mint.
Возможна работа на любой Debian-подобной системе (требуется пакет zenity).
Корректная работа скрипта на других Linux дистрибутивах не гарантируется.



_Скрипт был написан для тестирования почты на локальной копии сайта. Использование на боевом сервере исключительно на свой страх и риск._


![screenshot3](http://share.varrcan.me/img1611201700d3.png)

![screenshot4](http://share.varrcan.me/img161120179c5f.png)
