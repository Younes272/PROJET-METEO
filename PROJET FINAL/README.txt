README du projet meteo Younes Kaddache/ Elouan Ekoka / Nour Zaoui 
Pour executer le projet , il faut prealablement accorder les droits d'execution aux  fichiers , si cela n'est pas fait automatiquement
il faut donner le repertoire courant puis le nom du main programme et c'est après cela que l'on peut donner les options(-t1 -r -w -d --abr etc...)

EXEMPLE :
Si je suis dans le repertoire /home/projet/ , et que je veux utiliser l'option -t1 avec le filtre France metropolitaine , je dois ecrire dans le terminal :
/home/projet/main.sh -t1 -F

Probleme pour le -f (de nombreux bugs). Pour résoudre ce problème , le -f a été supprimé , et a la place , on demande le nom du fichier après l'execution de la commande.
EXEMPLE : 
/home/projet/main.sh -t1 -F
Entrez le nom de votre fichier :(c'est là qu'il faut entrer le nom du fichier)

si le makefile ne s'est pas bien compilé à l'execution du programme, il suffit d'écrire "make" dans le terminal, ce qui permettra de recompiler tous les programmes.
pour supprimer les fichiers temporaires et les executables , ecrire "make clean" dans le terminal
