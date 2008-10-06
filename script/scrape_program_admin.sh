#!/bin/bash
#
#Funksjonalitet: Offline kopi av site/program med presentasjoner
# Som ansvarlig for en sal
# Ønsker jeg å ha alle lyntalepresentasjoner i salen lett tilgjengelige
# Slik at bytte mellom lyntalene kan skje på noen få sekunder
#
# Scenario: Åpne en presentasjon i programmet
#   Gitt at auditoriet har 12 lyntaler med PDF vedlegg A-L på torsdag
#   Og at jeg har en nettleser som viser kopi av programmet
#   Når jeg følger lenken til presentasjon for lyntale nr 4 i auditoriet torsdag
#   Så skal jeg få opp vedlegg D i Acrobat
# 
# Usage:
# $0 adminname adminpassword
#
# Note: currently hardcoded to scrape smidig2008 program...
#
USERNAME=$1
PASSWORD=$2

if [ $# -ne 2 ]; then
  echo "Invalid number of arguments"
  echo "Usage: $0 adminname adminpassword"
  exit
fi

rm -r tmp/
mkdir -p tmp/

wget \
    --save-cookies tmp/cookies \
    --keep-session-cookies \
    -O tmp/login \
    http://smidig.no/admin/program/44 \
    > /dev/null

AUTH_TOKEN=`grep authenticity_token tmp/login | sed -e 's/.*<input .* value=\"\(.*\)\".*\/>.*/\1/'`
echo authenticity_token=$AUTH_TOKEN

wget \
    --load-cookies tmp/cookies \
    --save-cookies tmp/cookies \
    --keep-session-cookies \
    --post-data "user[login]=$USERNAME&user[password]=$PASSWORD&authenticity_token=$AUTH_TOKEN" \
    -p -r -N -l 1 -k --no-remove-listing \
    http://smidig.no/admin/login \
    > /dev/null

# work-around https://savannah.gnu.org/bugs/?21392
grep "http://smidig"  smidig.no/admin/program/44  | sed -e 's/.*\(http:\/\/smidig.no\/[^ ]*\)\".*/\1/' | sort -u > tmp/pages
wget -r -i tmp/pages

# fix some other URLs
mv smidig.no/admin/program/44  smidig.no/admin/program/44.old
cat smidig.no/admin/program/44.old | sed 's/=\"http:\/\/smidig.no/=\"smidig.no/' > smidig.no/admin/program/44

