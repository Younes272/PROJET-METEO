CC = gcc
CFLAGS = -w

all: avl abr tab avlr

avl: TRIAVLCROISSANTMERCI.c
	@$(CC) $(CFLAGS) -o avl TRIAVLCROISSANTMERCI.c
	@echo "programme tri avl compilé!"
abr: triabrr.c
	@$(CC) $(CFLAGS) -o abr triabrr.c
	@echo "programme tri abr compilé!"
tab: tritabreussi.c
	@$(CC) $(CFLAGS) -o tab tritabreussi.c
	@echo "programme tri tableau compilé!"
avlr: TRIAVLDECROISSANTMERCI.c
	@$(CC) $(CFLAGS) -o avlr TRIAVLDECROISSANTMERCI.c

clean:
	@rm -f avl abr tab avlr
	@rm *.tmp
	@echo "fichiers temporaires et executables supprimés avec succès!"
