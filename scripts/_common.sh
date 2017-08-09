#!/bin/bash

#
# Extra helpers not implemeted yet in core
#

# Curl abstraction to help with POST requests to local pages (such as installation forms)
# See https://github.com/YunoHost/yunohost/pull/288
# $domain and $path_url should be defined externally (and correspond to the domain.tld and the /path (of the app?))
#
# example: ynh_local_curl "/install.php?installButton" "foo=$var1" "bar=$var2"
# 
# usage: ynh_local_curl "page_uri" "key1=value1" "key2=value2" ...
# | arg: page_uri    - Path (relative to $path_url) of the page where POST data will be sent
# | arg: key1=value1 - (Optionnal) POST key and corresponding value
# | arg: key2=value2 - (Optionnal) Another POST key and corresponding value
# | arg: ...         - (Optionnal) More POST keys and values
ynh_local_curl () {
	# Define url of page to curl
	full_page_url=https://localhost$path$1

	# Concatenate all other arguments with '&' to prepare POST data
	POST_data=""
	for arg in "${@:2}"
	do
		POST_data="${POST_data}${arg}&"
	done
	# (Remove the last character, which is an unecessary '&')
	POST_data=${POST_data::-1}

	# Curl the URL
	curl -kL -H "Host: $domain" --resolve $domain:443:127.0.0.1 --data "$POST_data" "$full_page_url" 2>&1
}
