#!/bin/bash
#echo  "ce script est $0"
# Récupérer le chemin complet du script
script_path=$(realpath "$0")
echo -n "Entrez le nom du fichier à trier : "
read  str
# Récupérer le répertoire du script (sans le nom du script)
script_dir=$(dirname "$script_path")
make
# Récupération des arguments
#ARGUMENTS=$(getopt --o $OPTIONS -- "$@")
#echo $ARGUMENTS
echo  " nombre arguments $#"
possibilities="-t1 -t2 -t3 -p1 -p2 -p3 -w -r -h -m --avl --tab -d"
ct=0
c=0

#Initialisation des options temperatures et pression 
temperature=0
if [[ "$@" =~ "-t1" ]]; then  echo "temperature 1..."; temperature=1;((c++,ct++)); fi
if [[ "$@" =~ "-t2" ]]; then  echo "temperature 2..."; temperature=2;((c++,ct++)); fi
if [[ "$@" =~ "-t3" ]]; then  echo "temperature 3..."; temperature=3;((c++,ct++)); fi
if [ $ct -gt 1 ]; then    echo "un seul mode temperature  permis "; exit; fi

cpre=0
pression=0
if [[ "$@" =~ "-p1" ]]; then  echo "pression 1..."; pression=1;((c++,cpre++)); fi
if [[ "$@" =~ "-p2" ]]; then  echo "pression 2..."; pression=2;((c++,cpre++)); fi
if [[ "$@" =~ "-p3" ]]; then  echo "pression 3..."; pression=3;((c++,cpre++)); fi
if [ $cpre -gt 1 ]; then  echo "un seul mode pression  permis "; exit; fi

#initialisation des options vent altitude et humidité
wind=0
if [[ "$@" =~ "-w" ]]; then  echo "fichier vents..."; wind=1;((c++)); fi
height=0
if [[ "$@" =~ "-h" ]]; then  echo "fichier altitude..."; height=1;((c++)); fi
moisture=0
if [[ "$@" =~ "-m" ]]; then  echo "fichier humidité..."; moisture=1;((c++)); fi

if [ $c == 0 ]; then    echo "vous devez renseigner un mode"; exit; fi


#Initialisation des filtres par region
c=0
region=""
if [[ "$@" =~ "-F" ]]; then  region="F";((c++)); fi
if [[ "$@" =~ "-G" ]]; then  region="G";((c++)); fi
if [[ "$@" =~ "-S" ]]; then  region="S";((c++)); fi
if [[ "$@" =~ "-A" ]]; then  region="A";((c++)); fi
if [[ "$@" =~ "-O" ]]; then  region="O";((c++)); fi
if [[ "$@" =~ "-Q" ]]; then  region="Q";((c++)); fi
if [ $c -gt 1 ]; then    echo "une seule region  permise  "; exit; fi

c=0
option=""

#Initialisation des types de tri en c
c=0
tri="avl"
if [[ "$@" =~ "--tab" ]]; then tri="tab";((c++)); fi
if [[ "$@" =~ "--abr" ]]; then tri="abr";((c++)); fi
if [[ "$@" =~ "--avl" ]]; then tri="avl";((c++)); fi
if [[ "$@" =~ "-r" ]]; then   echo "tri inversé"; tri="avlr"; fi
if [ $c -gt 1 ]; then  echo "une seule option de tri permise  "; exit; fi

tail -n +2 $str > filtre.csv #permet d'enlever l entete du fichier csv


#FILTRAGE PAR REGION
if [[ $region == "F" ]]; then
echo "Veuillez patienter..."
tail -n +2 $str > meteo0.csv
awk -F';' '$15 ~ /^[01-95]/ && $15 < 96000 {print}' meteo0.csv > filtre.csv
echo "filtre France metropolitaine  appliqué!" ; fi


if [[ $region == "G" ]]; then

echo "Veuillez patienter..."
tail -n +2 $str > meteo0.csv
awk -F';' '$15 ~ /^973/ {print}' meteo0.csv > filtre.csv
echo "filtre Guyane appliqué!" ; fi

if [[ $region == "S" ]]; then
echo "Veuillez patienter..."
tail -n +2 $str > meteo0.csv
awk -F';' '$15 ~ /^975/ {print}' meteo0.csv > filtre.csv
echo "filtre Saint-Pierre et Miquelon appliqué!" ; fi

if [[ $region == "A" ]]; then
echo "Veuillez patienter..."
tail -n +2 $str > meteo0.csv
awk -F';' '$15 ~ /^971/ {print}' meteo0.csv > filtre.csv
awk -F';' '$15 ~ /^972/ {print}' meteo0.csv >> filtre.csv
awk -F';' '$15 ~ /^978/ {print}' meteo0.csv >> filtre.csv
awk -F';' '$15 ~ /^977/ {print}' meteo0.csv >> filtre.csv
echo "filtre Antilles appliqué!" ;fi


if [[ $region == "O" ]]; then
echo "Veuillez patienter..."
tail -n +2 $str > meteo0.csv
awk -F';' '$15 ~ /^974/ {print}' meteo0.csv > filtre.csv
awk -F';' '$15 ~ /^976/ {print}' meteo0.csv >> filtre.csv
echo "filtre Ocean Indien appliqué!" ; fi

if [[ $region == "Q" ]]; then
echo "Veuillez patienter..."
tail -n +2 $str > meteo0.csv
awk 'BEGIN {FS=";"}{if (($10<"-91") && ($10>"-59")) print }' meteo0.csv > filtre.csv
echo "filtre Antarctique appliqué!" ; fi

# traitement des dates -d
if [[ "$@" =~ "-d" ]]; then
        allparam=$@
        search="-d"
        i=${allparam%%$search*}
        p=${#i}
        param=${allparam:$p:24}
        date1=${param:3:10}
        date2=${param:14:10}
        sed 's/T/;/g' filtre.csv > ah.csv
        awk -F';' -v d1="$date1" -v d2="$date2" '$2 >= d1 && $2 <= d2 {print}' ah.csv > b.csv
	#awk -F';' '$2 ~ $2 >= "$date1" && $2 <= "$date2" {print}' ah.csv >b.csv
        sed 's/;\([^;]*\);/;\1T/' b.csv > filtre.csv;
fi


#traitement de -t1 à l'aide du shell et du c 
if [[ $temperature == 1 ]]; then
echo "(t1)Veuillez patienter..."
awk -F ";" '$11 != ""' filtre.csv > meteo1.tmp
sort -t, -k1,1 meteo1.tmp |awk -F';' '{if ($1!=p) {if (NR>1) print p,";",max; p=$1; max=$11} else {if ($11>max) max=$11}} END{print p,";",max}' > t1maxfinal.tmp
sort -t, -k1,1 meteo1.tmp |awk -F';' '{if ($1!=p) {if (NR>1) print p,";",max; p=$1; max=$11} else {if ($11<max) max=$11}} END{print p,";",max}' > t1minfinal.tmp
awk 'BEGIN{FS=";"}{date1[$1]+=$11;++date2[$1]}END{for (key in date1) print key,";",date1[key]/date2[key]}' meteo1.tmp > moy_date.tmp 
sort -t, -k1,1 moy_date.tmp > moy_datefinal.tmp
join -t ";" -1 1 -2 1 t1maxfinal.tmp t1minfinal.tmp > t1maxminpression.tmp
join -t ";" -1 1 -2 1 t1maxminpression.tmp moy_datefinal.tmp > fin.tmp
if [[ $tri == "abr" ]]; then
	./abr fin.tmp
echo "tri abr..." ;fi
if [[ $tri == "tab" ]]; then
	./tab fin.tmp
echo "tri tab..." ;fi
if [[ $tri == "avl" ]]; then
	./avl fin.tmp
	grep -v "^$" sorted.csv > sorted.tmp
	cat sorted.tmp > sorted.csv
echo "tri avl..." ;fi
if [[ $tri == "avlr" ]]; then
        ./avlr fin.tmp
        grep -v "^$" sorted.csv > sorted.tmp
        cat sorted.tmp > sorted.csv
echo "tri inversé..." ;fi
cat sorted.csv > trit1.csv
echo "resultat disponible dans le fichier trit1.csv"
echo "generation du graphique barre d'erreur"
gnuplot -e "filename='trit1.csv'" --persist errorbar.plt ;fi 

#traitement de -t2 à l'aide du shell et du c (il y a des prefiltrages qui permettent au c de bien fonctionner)
if [[ $temperature == 2 ]]; then
echo "(t2)Veuillez patienter..."
awk -F ";" '$11 != ""' filtre.csv > meteo1.tmp
awk 'BEGIN{FS=";"}{date1[$2]+=$11;++date2[$2]}END{for (key in date1) print key,";",date1[key]/date2[key]}' meteo1.tmp > moy_date.tmp
if [[ $tri == "abr" ]]; then
./abr moy_date.tmp
echo "tri abr..." ;fi
if [[ $tri == "avlr" ]]; then
sort -t ';' -k1nr moy_date.tmp > sorted.csv
echo "tri inversé..." ;fi
if [[ $tri == "avl" ]]; then
sort -t ';' -k1 moy_date.tmp > sorted.csv
echo "tri avl..." ;fi
if [[ $tri == "tab" ]]; then
./tab moy_date.tmp
echo "tri tab..." ;fi
cat  sorted.csv > trit2.csv
echo "resultat disponible dans le fichier trit2.csv"
echo "generation du graphique ligne simple"
gnuplot -e "filename='trit2.csv'" --persist simpleline2.plt   ; fi

#traitement de -t3 à l'aide du shell et du c 
if [[ $temperature == 3 ]]; then
echo "(t3)Veuillez patienter..."
sort -t ";" -k2,2 -k1,1 filtre.csv > tridatestation.tmp
cut -d ";" -f 1,2,11 tridatestation.tmp > trit3.csv
awk 'BEGIN{FS=";"}{print $0,";",substr($2,12,2)}' filtre.csv > h24.tmp
echo "resultat disponible dans le fichier trit3.csv"
echo "generation du graphique multiligne..."
gnuplot -e "filename='h24.tmp'" --persist multilignefinal.plt ; fi

#traitement de -p1 à l'aide du shell et du c 
if [[ $pression == 1 ]]; then
echo "(p1)Veuillez patienter..."
awk -F ";" '$7 != ""' filtre.csv > meteo1.tmp
sort -t, -k1,1 meteo1.tmp |awk -F';' '{if ($1!=p) {if (NR>1) print p,";",max; p=$1; max=$7} else {if ($7>max) max=$7}} END{print p,";",max}' > p1maxfinal.tmp
sort -t, -k1,1 meteo1.tmp |awk -F';' '{if ($1!=p) {if (NR>1) print p,";",max; p=$1; max=$7} else {if ($7<max) max=$7}} END{print p,";",max}' > p1minfinal.tmp
awk 'BEGIN{FS=";"}{date1[$1]+=$7;++date2[$1]}END{for (key in date1) print key,";",date1[key]/date2[key]}' meteo1.tmp > moy_pdate.tmp
sort -t, -k1,1 moy_pdate.tmp > moy_pdatefinal.tmp
join -t ";" -1 1 -2 1 p1maxfinal.tmp p1minfinal.tmp > p1maxminpression.tmp
join -t ";" -1 1 -2 1 p1maxminpression.tmp moy_pdatefinal.tmp > pfin.tmp
if [[ $tri == "abr" ]]; then
./abr pfin.tmp
echo "tri abr..." ;fi
if [[ $tri == "avl" ]]; then
./avl pfin.tmp
grep -v "^$" sorted.csv > sorted.tmp
cat sorted.tmp > sorted.csv
echo "tri avl..." ;fi
if [[ $tri == "avlr" ]]; then
        ./avlr pfin.tmp
        grep -v "^$" sorted.csv > sorted.tmp
        cat sorted.tmp > sorted.csv
echo "tri inversé..." ;fi
if [[ $tri == "tab" ]]; then
./tab pfin.tmp
echo "tri tab..." ;fi
cat sorted.csv > trip1.csv
echo "resultat disponible dans le fichier trip1.csv" 
echo "generation du graphique barre d'erreur..."
gnuplot -e "filename='trip1.csv'" --persist errorbar.plt ;fi

#traitement de -p2 à l'aide du shell et du c 
if [[ $pression == 2 ]]; then
echo "(p2)Veuillez patienter..."
awk -F ";" '$7 != ""' filtre.csv > pression.tmp
awk 'BEGIN{FS=";"}{date1[$2]+=$7;++date2[$2]}END{for (key in date1) print key,";",date1[key]/date2[key]}' pression.tmp > moypression.tmp
if [[ $tri == "abr" ]]; then
./abr moypression.tmp
echo "tri abr..." ;fi
if [[ $tri == "avlr" ]]; then
sort -t ';' -k1nr moypression.tmp > sorted.csv
echo "tri inversé...";fi
if [[ $tri == "avl" ]]; then
sort -t ';' -k1 moypression.tmp > sorted.csv
echo "tri avl..." ;fi
if [[ $tri == "tab" ]]; then
./tab moypression.tmp
echo "tri tab..." ;fi
cat sorted.csv > trip2.csv
echo "resultat disponible dans le fichier trip2.csv"
echo "generation du graphique ligne simple"
gnuplot -e "filename='trip2.csv'" --persist simpleline2.plt   ; fi

#traitement de -p3 à l'aide du shell et du c 
if [[ $pression == 3 ]]; then
echo "(p3)Veuillez patienter..."
sort -t ";" -k2,2 -k1,1 filtre.csv > tridatestationpression.tmp
cut -d ";" -f 1,2,7 tridatestationpression.tmp > trip3.csv
echo "resultat disponible dans le fichier trip3.csv"
awk 'BEGIN{FS=";"}{print $0,";",substr($2,12,2)}' filtre.csv > h24.tmp
echo "generation du graphique multiligne..."
gnuplot -e "filename='h24.tmp'" --persist multilignefinalpression.plt  ; fi

#traitement de -w à l'aide du shell et du c 
if [[ $wind == 1 ]]; then
echo "(w)Veuillez patienter..."
awk -F ";" '$4 != ""' filtre.csv > meteo1.tmp
awk 'BEGIN{FS=";"}{date1[$1]+=$4;++date2[$1]}END{for (key in date1) print key,";",date1[key]/date2[key]}' meteo1.tmp > dirmoy.tmp
awk 'BEGIN{FS=";"}{date1[$1]+=$5;++date2[$1]}END{for (key in date1) print key,";",date1[key]/date2[key]}' meteo1.tmp > vitessemoy.tmp
cut -d ";" -f 1,10 filtre.csv > coordonnees0.tmp
sed 's/,/;/g' coordonnees0.tmp > coordonnees1.tmp
sort -t ";" -k1 coordonnees1.tmp > coordonnees2.tmp
sort coordonnees2.tmp | uniq > coordonnees.tmp
join -t ";" -1 1 -2 1 dirmoy.tmp vitessemoy.tmp > dirvitmoy.tmp
echo $tri
if [[ $tri == "abr" ]]; then
./abr dirvitmoy.tmp
echo "tri abr..." ;fi
if [[ $tri == "avlr" ]]; then
        #./avlr dirvitmoy.tmp
        sort -t ";" -k1nr dirvitmoy.tmp > sorted.csv
	grep -v "^$" sorted.csv > sorted.tmp
        cat sorted.tmp > sorted.csv
echo "tri inversé..." ;fi
if [[ $tri == "avl" ]]; then
#./avl dirvitmoy.tmp
sort -t ";" -k1 dirvitmoy.tmp > sorted.csv 
       grep -v "^$" sorted.csv > sorted.tmp
        cat sorted.tmp > sorted.csv
echo "tri avl..." ;fi 
if [[ $tri == "tab" ]]; then
./tab dirvitmoy.tmp
echo "tri tab..." ;fi
cat sorted.csv > triwind.csv
sed 's/ ;/;/g' triwind.csv > triiiwind.tmp
sed 's/ ;/;/g' triiiwind.tmp > triiiiwind.tmp
sort -t ';' -k1 triiiiwind.tmp > triiwind.tmp
sed 's/ ;/;/g' coordonnees.tmp > coordonneees.tmp
join -t ";" -1 1 -2 1 triiwind.tmp coordonneees.tmp > gnuwind.csv
echo "resultat disponible dans le fichier triwind.csv"
gnuplot -e "filename='gnuwind.csv'" --persist wind.plt ;fi

#traitement de -h à l'aide du shell et du c 
if [[ $height == 1 ]]; then
echo "(h)Veuillez patienter..."
sort -t';' -k1 filtre.csv > resheight.tmp
awk -F ";" '!a[$1]++' resheight.tmp > resheight2.tmp
cut -d ";" -f 1,14 resheight2.tmp > resheightfinal.tmp
sort -t ';' -k2nr  resheightfinal.tmp > triheight.csv
cut -d ";" -f 1,10 filtre.csv > coordonnees0.tmp
sed 's/,/;/g' coordonnees0.tmp > coordonnees1.tmp
sort -t ";" -k1 coordonnees1.tmp > coordonnees2.tmp
sort coordonnees2.tmp | uniq > coordonnees.tmp
sed 's/ ;/;/g' coordonnees.tmp > coordonneees.tmp
sed 's/ ;/;/g' triheight.csv > triiheight.tmp
if [[ $tri == "abr" ]]; then
./abr triiheight.tmp
echo "tri abr..." ;fi
if [[ $tri == "avl" ]]; then
./avl triiheight.tmp
        grep -v "^$" sorted.csv > sorted.tmp
        cat sorted.tmp > sorted.csv
echo "tri avl..." ;fi
if [[ $tri == "avlr" ]]; then
        ./avlr triiheight.tmp
        grep -v "^$" sorted.csv > sorted.tmp
        cat sorted.tmp > sorted.csv
	sort -t ';' -k1nr coordonneees.tmp > coordonnees.tmp
echo "tri inversé..." ;fi
if [[ $tri == "tab" ]]; then
./tab triiheight.tmp
echo "tri tab..." ;fi
cat sorted.csv > triiiheight.tmp
join -t ";" -1 1 -2 1 triiiheight.tmp coordonnees.tmp > gnuheight.csv
gnuplot -e "filename='gnuheight.csv" --persist gnuheight.plt
echo "resultat disponible dans le fichier triheight.csv" ; fi

#traitement de -m à l'aide du shell et du c 
if [[ $moisture == 1 ]]; then
echo "(m)Veuillez patienter..."
awk -F ";" '$6 != ""' filtre.csv > meteo1.tmp
awk 'BEGIN {FS=";"}{date1[$1]=$6;date2[$1]=( date2[$1] < date1[$1] ? date1[$1] : date2[$1]) }END{for (key in date2) print key,";",date2[key]}' meteo1.tmp > maxmoisture.tmp
cut -d ";" -f 1,10 filtre.csv > coordonnees0.tmp
sed 's/,/;/g' coordonnees0.tmp > coordonnees1.tmp
sort -t ";" -k1 coordonnees1.tmp > coordonnees2.tmp
sort coordonnees2.tmp | uniq > coordonnees.tmp
sed 's/ ;/;/g' coordonnees.tmp > coordonneees.tmp
awk -F ";" '!a[$1]++' maxmoisture.tmp > maxmoisture2.tmp
sort -t ";" -k2nr maxmoisture2.tmp > trimoisture.csv
sed 's/ ;/;/g' trimoisture.csv > triimoisture.tmp
if [[ $tri == "abr" ]]; then
./abr triimoisture.tmp
echo "tri abr..." ;fi
if [[ $tri == "avl" ]]; then
./avl triimoisture.tmp
        grep -v "^$" sorted.csv > sorted.tmp
        cat sorted.tmp > sorted.csv
echo "tri avl..." ;fi
if [[ $tri == "avlr" ]]; then
        ./avlr triimoisture.tmp
        grep -v "^$" sorted.csv > sorted.tmp
        cat sorted.tmp > sorted.csv
	sort -t ';' -k1nr coordonneees.tmp >coordonnees.tmp
echo "tri inversé..." ;fi
if [[ $tri == "tab" ]]; then
./tab triimoisture.tmp
echo "tri tab..." ;fi
cat sorted.csv > triiimoisture.tmp
join -t ";" -1 1 -2 1 triiimoisture.tmp coordonnees.tmp > gnumoisture.csv
gnuplot -e "filename='gnumoisture.csv'" --persist gnuheight.plt
echo "resultat disponible dans le fichier trimoisture.csv" ; fi
#supression du fichier filtre pour les prochaines executions
rm filtre.csv



