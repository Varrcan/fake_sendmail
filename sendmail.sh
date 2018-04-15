#!/usr/bin/env bash

reload_apache() {
echo $PASSWORD | sudo -S bash -c 'service apache2 restart'
}

install() {

INSTALL_OPTION=$(zenity --list --title="Заглушка для sendmail" --text="Как сохранять письма?" --column="#" --column="Action" --width=300 --height=200 \
	1 "В текстовом виде" \
	2 "В почтовом формате .eml")

	accepted=$?
	if [ $accepted = 0 ]; then
		if [ $INSTALL_OPTION = 1 ]; then
			echo $PASSWORD | sudo -S bash -c 'echo "#!/usr/bin/env bash
prefix=\"/var/mail/sendmail/new\"
date=\`date \+\%Y-\%m-\%d@\%H:\%M:\%S\`
name=\"\$prefix/\$date.txt\"
while read line
do
echo \"\$line\" >> \$name
done
chmod 666 \$name
chmod -x \$name
/bin/true
" > /usr/bin/fakesendmail.sh'
		fi

		if [ $INSTALL_OPTION = 2 ]; then
			echo $PASSWORD | sudo -S bash -c 'echo "#!/usr/bin/env bash
prefix=\"/var/mail/sendmail/new\"
date=\`date \+\%Y-\%m-\%d@\%H:\%M:\%S\`
name=\"\$prefix/\$date.eml\"
while IFS= read line
do
echo \"\$line\" >> \$name
done
chmod 666 \$name
chmod -x \$name
" > /usr/bin/fakesendmail.sh'
		fi
	else
		exit
	fi

echo $PASSWORD | sudo -S bash -c 'chmod +x /usr/bin/fakesendmail.sh'
echo $PASSWORD | sudo -S bash -c 'mkdir /var/mail/sendmail'
echo $PASSWORD | sudo -S bash -c 'mkdir /var/mail/sendmail/new'
echo $PASSWORD | sudo -S bash -c 'chmod 777 -R /var/mail/sendmail'

find /etc/php -name php.ini | while read files
    do
        echo $PASSWORD | sudo -S bash -c "cp '$files' '$files.bak'"
        echo $PASSWORD | sudo -S bash -c "sed -i '/sendmail_path/c sendmail_path=\/usr\/bin\/fakesendmail.sh' $files"
    done

QUESTION=$(zenity --question --text="Создать ярлык на рабочем столе?" --width=300)

	accepted=$?
	if [ $accepted = 0 ]; then
        username=$(whoami)

	    if [ -d '/home/'$username'/Рабочий стол/' ]; then
          ln -s '/var/mail/sendmail/new' '/home/'$username'/Рабочий стол/sendmail'
      fi
      if [ -d '/home/'$username'/Desktop/' ]; then
          ln -s '/var/mail/sendmail/new' '/home/'$username'/Desktop/sendmail'
      fi
	fi

reload_apache
zenity --info --width=300 --text "Заглушка для sendmail успешно установлена. Ваши письма теперь будут сохраняться в папку
/var/mail/sendmail/new/"

}

uninstall() {

find /etc/php -name php.ini | while read files
    do
        echo $PASSWORD | sudo -S bash -c "mv -f '$files.bak' '$files'"
    done

reload_apache
zenity --info --width=300 --text "Заглушка для sendmail успешно удалена"

}

start() {

	START_OPTION=$(zenity --list --title="Заглушка для sendmail" --text="Выберите действие" --column="#" --column="Action" --width=300 --height=200 \
	1 "Установить" \
	2 "Удалить")

	accepted=$?
	if [ $accepted = 0 ]; then
		if [ $START_OPTION = 1 ]; then
			install
		fi

		if [ $START_OPTION = 2 ]; then
			uninstall
		fi
	else
		exit
	fi
}

if [[ "$USER" != 'root' ]]; then
	OUTPUT=$(zenity --forms --title="Fake Sendmail" --text="Введите пароль root" --separator="," --add-password="")

	accepted=$?
	if [ $accepted = 0 ]; then
		PASSWORD=$(awk -F, '{print $1}' <<<$OUTPUT)
		start
	else
		exit
	fi

fi


