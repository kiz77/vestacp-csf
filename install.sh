#!/bin/bash
# Made by Steven Sullivan
# Copyright Steven Sullivan Ltd
# Version: 1.0

if [ "x$(id -u)" != 'x0' ]; then
    echo 'Error: this script can only be executed by root'
    exit 1
fi

echo "Let's start..."

# Let's install CSF!
function InstallCSF()
{
	echo "Install CSF..."
	
	cd /usr/src
	rm -fv csf.tgz
	wget https://download.configserver.com/csf.tgz
	tar -xzf csf.tgz
	cd csf
	sh install.sh
}

# Let's install the Vesta / CSF script
function InstallVestaCPBashScript()
{
	echo "Install VestaCP Script..."
	
	cd /tmp
	wget -O /usr/local/vesta/bin/v-csf https://raw.githubusercontent.com/kiz77/vestacp-csf/master/v-csf.txt
	chmod 770 /usr/local/vesta/bin/v-csf
}

# Let's install the CSF Vesta UI!
function InstallVestaCPFrontEnd()
{
	echo "Install VestaCP Front..."
	
	cd /tmp
	mkdir /usr/local/vesta/web/list/csf
	wget https://raw.githubusercontent.com/kiz77/vestacp-csf/master/csf.zip
	unzip /tmp/csf.zip -d /usr/local/vesta/web/list/
	rm -f /tmp/csf.zip

	# Chmod files
	find /usr/local/vesta/web/list/csf -type d -exec chmod 755 {} \;
	find /usr/local/vesta/web/list/csf -type f -exec chmod 644 {} \;
	
	# Add the link to the panel.html file
	if grep -q 'CSF' /usr/local/vesta/web/templates/admin/panel.html; then
		echo 'Already there.'
	else
		sed -i '/<div class="l-menu clearfix noselect">/a <div class="l-menu__item <?php if($TAB == "CSF" ) echo "l-menu__item--active" ?>"><a href="/list/csf/"><?=__("CSF")?></a></div>' /usr/local/vesta/web/templates/admin/panel.html
	fi
}

InstallCSF
InstallVestaCPBashScript
InstallVestaCPFrontEnd
