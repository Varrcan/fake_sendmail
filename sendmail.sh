#!/usr/bin/env bash

install() {

echo $PASSWORD | sudo -S bash -c 'echo "#!/usr/bin/env bash

prefix=\"/var/mail/sendmail/new\"
numPath=\"/var/mail/sendmail\"

if [ ! -f \$numPath/num ]; then
echo \"0\" > \$numPath/num
fi
num=\`cat \$numPath/num\`
num=\$((\$num + 1))
echo \$num > \$numPath/num

name=\"\$prefix/mail_\$num.txt\"
while read line
do
echo \$line >> \$name
done
chmod 777 \$name
chmod -x \$name
/bin/true
" > /home/varrcan/fakesendmail.sh'

echo $PASSWORD | sudo -S bash -c 'chmod +x /home/varrcan/fakesendmail.sh'
echo $PASSWORD | sudo -S bash -c 'chmod 777 -R /var/mail/sendmail'

#PHP=$( php -r 'print_r((float)phpversion());')
#echo $PHP

#sed '/test/d' myfile

}

start() {

	START_OPTION=$(zenity --list --title="Заглушка для sendmail" --column="#" --column="Action" --width=300 --height=200 \
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
	OUTPUT=$(zenity --forms --title="Установка Fake Sendmail" --text="Введите пароль root" --separator="," --add-entry="password" --width=300 --height=50)
	accepted=$?
	if [ $accepted = 0 ]; then
		PASSWORD=$(awk -F, '{print $1}' <<<$OUTPUT)
		start
	else
		exit
	fi

fi


