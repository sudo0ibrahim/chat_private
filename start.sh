#!/usr/bin/env bash

clear

echo "welcome"

#sudo apt install tor
function start(){
  
  if [ ! -f "tor/save" ];then
    rm -r /etc/tor/torrc 
    cp torrc /etc/tor/torrc	
    touch save 2> /dev/null
  fi


  service tor start

}


function new_Group(){
	if [ -a "link_chat/save" ];then
	rm link_chat/password.txt
	rm link_chat/url.txt
	rm link_chat/save
	fi
	if [ -a "kernel_chat/save" ];then
	rm kernel_chat/password.json
	rm kernel_chat/save
	fi

	sudo cat /var/lib/tor/hidden_service/hostname >> link_chat/url.txt

	echo "new password group: "
	read password
	echo $password >> link_chat/password.txt
	echo "save" >> link_chat/save
	echo "save" >> kernel_chat/save
	echo {\"password\":\"$password\"} >> kernel_chat/password.json

	gnome-terminal  -- bash -c "cd kernel_chat/ && npm run dev"
	sleep 3
	gnome-terminal  -- bash -c "cd link_chat/ && ./read"
	gnome-terminal  -- bash -c "cd link_chat/ && ./send"

}


function group_entry(){
	if [ -a "link_chat/save" ];then
	rm link_chat/password.txt
	rm link_chat/url.txt
	rm link_chat/save
	fi
	echo "save" >> link_chat/save
	echo "url: "
	read url
	echo $url >> link_chat/url.txt
	echo "password group: "
	read password
	echo $password >> link_chat/password.txt
	gnome-terminal  -- bash -c "cd link_chat/ && ./read"
	gnome-terminal  -- bash -c "cd link_chat/ && ./send"

}



echo "[1] - New Group / [2] - group entry"



read chage

if [ $chage == "1" ];then
	start
	new_Group

elif [ $chage == "2" ];then
	start
	group_entry
fi

