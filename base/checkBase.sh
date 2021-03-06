#!/bin/sh 
## script write by Julien ANCELIN/INRA julien.ancelin@inra.fr
##This script ping website and update résultat in database 
### create script & do: chmod +x ./checkBase.sh
#### create a cron job: crontab -e
#### add: */5 * * * *  home/centipede/checkBase.sh

RTCM='jancelin.ddns.xx'    ##DNS ou IP
PORT='9000'                 ##Port de diffusion
CONTAINER='sig_postgis'     ##container postgis
BASE='demo'                 ##base de données
TABLE='rtk.antenne'         ##table
PING='ping'                 ##champ boolean
DATE='ping_date'            ##champ timestamp with time zone
ID='id'                     ##champ Id de l'entité
IDVALUE='7'                 ##ID de la base

  if nc -z -w2 $RTCM $PORT ; then
      echo OK
      docker exec -d $CONTAINER su postgres -c "psql $BASE -c 'update $TABLE SET $PING= true, $DATE= LOCALTIMESTAMP(0)  where $ID = $IDVALUE;'"
  else
      echo DOWN
      docker exec -d $CONTAINER su postgres -c "psql $BASE -c 'update $TABLE SET $PING= false  where $ID = $IDVALUE;'"
  fi
