#!/bin/bash
# Script to fetch haproxy statuses for tribily monitoring systems
# Author: krish@toonheart.com
# License: GPLv2

# Set Variables
IPADDR="192.168.1.4"
PORT="8010"
DATE=`date +%Y%m%d`
#cd /opt/tribily/bin/
cd /tmp/
wget $IPADDR:$PORT/haproxy?stats/\;csv -O haproxy_stats_$DATE.csv -o /dev/null
#FILE="/opt/tribily/bin/haproxy_stats_$DATE.csv"
FILE="/tmp/haproxy_stats_$DATE.csv"

# User Defined Pools on HA
POOL1="GALAXY"

# Write the functions

# Status of Servers
#
function fend_status {
	grep "$POOL1" $FILE | grep FRONTEND | cut -f18 -d,
        }       

function bend_status {
	grep "$POOL1" $FILE | grep BACKEND | cut -f18 -d,
        }       


# Queue Informations
#
function qcur {
	grep "$POOL1" $FILE | grep BACKEND | cut -f3 -d,
	}

function qmax {
	grep "$POOL1" $FILE | grep BACKEND | cut -f4 -d,
	}


# Session Informations
#
function fend_scur {
	grep "$POOL1" $FILE | grep FRONTEND | cut -f5 -d,
	}

function fend_smax {
	grep "$POOL1" $FILE | grep FRONTEND | cut -f6 -d,
	}

function bend_scur {
	grep "$POOL1" $FILE | grep BACKEND | cut -f5 -d,
	}

function bend_smax {
	grep "$POOL1" $FILE | grep BACKEND | cut -f6 -d,
	}

function fend_stot {
	grep "$POOL1" $FILE | grep FRONTEND | cut -f8 -d,
	}

function bend_stot {
	grep "$POOL1" $FILE | grep BACKEND | cut -f8 -d,
	}


# Traffic Information
#
function bytes_in {
	grep "$POOL1" $FILE | grep FRONTEND | cut -f9 -d,
	}

function bytes_out {
	grep "$POOL1" $FILE | grep FRONTEND | cut -f10 -d,
	}


# Error Information
#
function err_req {
	grep "$POOL1" $FILE | grep FRONTEND | cut -f13 -d,
	}

function err_conn {
	grep "$POOL1" $FILE | grep BACKEND | cut -f14 -d,
	}

function err_resp {
	grep "$POOL1" $FILE | grep BACKEND | cut -f15 -d,
	}


# Warning Information
#
function warn_retr {
	grep "$POOL1" $FILE | grep BACKEND | cut -f16 -d,
	}

function warn_redis {
	grep "$POOL1" $FILE | grep BACKEND | cut -f17 -d,
	}


# Downtime Information
#
function down_cur {

	STATUS=`grep "$POOL1" $FILE | grep BACKEND | cut -f18 -d,`
	
	if [ "$STATUS" == "DOWN" ]
	then
		grep "$POOL1" $FILE | grep BACKEND | cut -f24 -d,
	else
		echo "0"	
	fi
	}

function down_tot {
	grep "$POOL1" $FILE | grep BACKEND | cut -f25 -d,
	}


# Uptime Information
#
function uptime_cur {

	STATUS=`grep "$POOL1" $FILE | grep BACKEND | cut -f18 -d,`
	
	if [ "$STATUS" == "UP" ]
	then
		grep "$POOL1" $FILE | grep BACKEND | cut -f24 -d,
	else
		echo "0"	
	fi
	}

# Run the requested function
$1

# Clean up
/bin/rm $FILE
