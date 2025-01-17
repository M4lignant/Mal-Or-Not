#!/bin/bash
function gatherIPIntel(){
#echo -e "${GREEN}[+] Gathering IP intel for $1\n"
		  	wget "https://api.ip2location.com/v2/?key=PVBY1DAVGY&ip=$1&package=WS24&format=json&addon=continent,country,region,city,geotargeting,country_groupings,time_zone_info&lang=en" --wait=3 -U 'Mozilla/5.0 (X11; Linux i686 (x86_64)) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/55.0.2883.75 Safari/537.36' --no-http-keep-alive --no-check-certificate --tries=1 -O test4.html > /dev/null 2>&1
		  	cat test4.html | anew apiGeo-Location > geo
		  	wget "https://ipqualityscore.com/api/json/ip/52euadgGvFpxYkflxorqnBTwGY8mEwMi/$1?strictness=0&allow_public_access_points=true&fast=true&lighter_penalties=true&mobile=true" --wait=3 -U 'Mozilla/5.0 (X11; Linux i686 (x86_64)) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/55.0.2883.75 Safari/537.36' --no-http-keep-alive --no-check-certificate --tries=1 -O log > /dev/null 2>&1
		  	echo "  IP Address: $1" > current_ip_intel
			cat current_ip_intel >>output
		  	cat log | jq | grep -E "proxy|vpn|tor|fraud" | grep -v "active" | tr -d '\"' | sed 's/,//g' | sed 's/_/ /g' | sed 's/\<\([[:lower:]]\)\([[:alnum:]]*\)/\u\1\2/g' | tee -a output
		  	cat geo | jq | grep -E '"country_name":|"city_name":|"zip_code":|"time_zone":|"isp":|"domain":|"region_name"|"latitude"|"longitude"' | sed 's/,//g'  | sed 's/"//g' | sed 's/\<\([[:lower:]]\)\([[:alnum:]]*\)/\u\1\2/g' | sed 's/_/ /g' | tee -a output
		  	intel=$(cat geo | jq | grep -E '"country_name":|"city_name":|"zip_code":|"time_zone":|"isp":|"domain":|"region_name"|"latitude"|"longitude"' | sed 's/,//g'  | sed 's/"//g' | awk -F ": " '{print $2}' | sed 's/[[:space:]]/_/g' | xargs)
		  lat=$(echo $intel | awk '{print $4}')
		  long=$(echo $intel | awk '{print $5}')
		  geoURL="https://www.gps-coordinates.net/latitude-longitude/$lat/$long/10/roadmap"
		    echo -e "  Geographical Location: $geoURL" | tee -a current_ip_intel
			cat current_ip_intel >>output
		    time=$(timedatectl | head -n 1 | awk -F ":" '{print $2":"$3":"$4}') 
		    echo "  Intel gathered at:$time" | tee -a current_ip_intel
			cat current_ip_intel >>output
			echo "\n">> output
rm apiGeo-Location geo test4.html log
}

ip=${1}
while getopts :i: fuzz_args; do 
	case $fuzz_args in
		i)
			#echo -e "\n\n[+]Enabling JS files recon for target subdomains..." #provide subdomain list
			iF=1
			ip=$OPTARG
			;;
		*)
			echo "Invalid flag usage!"
			exit 1
			;;
	esac
done
shift $((OPTIND-1))
if [[ $# -ne 0 ]] ; then
	usage
	echo -e "\n[~] Check usage. (above)"
else
	if [[ $iF -eq 1 ]] ; then
	gatherIPIntel "$ip"
	fi
fi
