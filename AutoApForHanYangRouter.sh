#!/usr/bin/env bash

my_wifi_name="NeverEver"
my_wifi_password="NeverEver3344!"

hack_2_4G_wifi_name=("MERCURY_302" "OnePlus 3T")
hack_2_4G_wifi_mac=("50:3A:A0:04:AD:BC" "C0:EE:FB:F7:60:D6")
hack_2_4G_wifi_password=("154710561" "12345678")

hack_5G_wifi_name=()
hack_5G_wifi_mac=()
hack_5G_wifi_password=()

config_2_4G=
config_5G=

hack_2_4G_wifi_index=
hack_5G_wifi_index=

hack_wifi_frequency_band=

hack_wifi_name_now=
hack_wifi_mac_now=
hack_wifi_password_now=

hack_2_4G_wifi_number=${#hack_2_4G_wifi_name[@]}
hack_5G_wifi_number=${#hack_5G_wifi_name[@]}

check_network_status(){
    if ping -q -c 1 -W 1 www.baiadqwddqdu.com >/dev/null; then
      return 0
    else
      return 1
    fi
}

set_2_4G_wireless_connection(){
    config_2_4G="

config wifi-device  'ra0'
        option type     'rt2860v2'
        option hwmode   '11g'
        option channel  'auto'
        option txpower  '100'
        option htmode   'HT40'
        option country  'CN'

config wifi-iface
        option device   'ra0'
        option network  'lan'
        option mode 'ap'
        option wmm '1'
        option ssid '$my_wifi_name'
        option encryption 'psk-mixed'
        option key '$my_wifi_password'

config wifi-iface
        option device   'ra0'
        option network  'wwan'
        option mode 'sta'
        option wmm '1'
        option ssid '$1'
        option bssid '$2'
        option encryption 'psk2'
        option key '$3'
"
}

disable_2_4G_wireless_connection(){
    config_2_4G="

config wifi-device  'ra0'
        option type     'rt2860v2'
        option hwmode   '11g'
        option channel  'auto'
        option txpower  '100'
        option htmode   'HT40'
        option country  'CN'

config wifi-iface
        option device   'ra0'
        option network  'lan'
        option mode 'ap'
        option wmm '1'
        option ssid '$my_wifi_name'
        option encryption 'psk-mixed'
        option key '$my_wifi_password'
        option disabled '1'
"
}

set_5G_wireless_connection(){
    config_5G="

config wifi-device  'rai0'
        option type     'mt7612'
        option hwmode   '11a'
        option channel  'auto'
        option txpower  '100'
        option htmode   'VHT80'
        option country  'CN'
        option disabled '0'

config wifi-iface
        option device   'rai0'
        option network  'lan'
        option mode 'ap'
        option wmm '1'
        option ssid '$my_wifi_name'
        option encryption 'psk-mixed'
        option key '$my_wifi_password'

config wifi-iface
        option device   'ra0'
        option network  'wwan2'
        option mode 'sta'
        option wmm '1'
        option ssid '$1'
        option bssid '$2'
        option encryption 'psk2'
        option key '$3'
"
}

disable_5G_wireless_connection(){
    config_5G="

config wifi-device  'rai0'
        option type     'mt7612'
        option hwmode   '11a'
        option channel  'auto'
        option txpower  '100'
        option htmode   'VHT80'
        option country  'CN'
        option disabled '0'

config wifi-iface
        option device   'rai0'
        option network  'lan'
        option mode 'ap'
        option wmm '1'
        option ssid '$my_wifi_name'
        option encryption 'psk-mixed'
        option key '$my_wifi_password'
        option disabled '1'
"
}
init_data_from_file(){
    if [ ! -f "hack_2_4G_wifi_index.txt" ];then
        echo "0" > hack_2_4G_wifi_index.txt
        hack_2_4G_wifi_index=0
    else
        hack_2_4G_wifi_index=$(cat hack_2_4G_wifi_index.txt)
    fi
    if [ ! -f "hack_5G_wifi_index.txt" ];then
        echo "0" > hack_5G_wifi_index.txt
        hack_5G_wifi_index=0
    else
        hack_5G_wifi_index=$(cat hack_5G_wifi_index.txt)
    fi
    if [ ! -f "hack_wifi_frequency_band.txt" ];then
        echo "5G" > hack_wifi_frequency_band.txt
        hack_wifi_frequency_band="5G"
    else
        hack_wifi_frequency_band=$(cat hack_wifi_frequency_band.txt)
    fi
}

get_frequency_band_and_index(){
    if [ "$hack_wifi_frequency_band" = "5G" ];then
        hack_wifi_name_now=$hack_2_4G_wifi_name[hack_2_4G_wifi_index]
        hack_wifi_mac_now=$hack_2_4G_wifi_mac[hack_2_4G_wifi_index]
        hack_wifi_password_now=$hack_2_4G_wifi_password[hack_2_4G_wifi_index]
    else
        hack_wifi_name_now=$hack_5G_wifi_name[hack_5G_wifi_index]
        hack_wifi_mac_now=$hack_5G_wifi_mac[hack_5G_wifi_index]
        hack_wifi_password_now=$hack_5G_wifi_password[hack_5G_wifi_index]
    fi
    echo "$hack_2_4G_wifi_index" > hack_2_4G_wifi_index.txt
    echo "$hack_5G_wifi_index" > hack_5G_wifi_index.txt
    echo "$hack_wifi_frequency_band" > hack_wifi_frequency_band.txt
}

get_hack_wifi_info(){
    if [ "$hack_wifi_frequency_band" = "5G" ];then
        ((hack_5G_wifi_index++))
        if [ $hack_5G_wifi_index -ge $hack_5G_wifi_number ] ; then
            hack_2_4G_wifi_index=0
            hack_wifi_frequency_band="2.4G"
        fi
    else
        ((hack_2_4G_wifi_index++))
        if [ hack_2_4G_wifi_index -ge $hack_2_4G_wifi_number ] ; then
            hack_5G_wifi_index=0
            hack_wifi_frequency_band="5G"
        fi
    fi
}

change_connect_wifi(){
    get_frequency_band_and_index
    get_hack_wifi_info
    if [ "$hack_wifi_frequency_band" = "5G" ];then
        set_5G_wireless_connection $hack_wifi_name_now $hack_wifi_mac_now $hack_wifi_password_now
        disable_2_4G_wireless_connection
    else
        set_2_4G_wireless_connection $hack_wifi_name_now $hack_wifi_mac_now $hack_wifi_password_now
        disable_5G_wireless_connection
    fi
    echo "$config_2_4G$config_5G"> /etc/config/wireless
}

init_data_from_file
check_network_status
if [ $? -gt 0 ] ; then
    change_connect_wifi
fi