CC = gcc
CFLAGS = -w

all: avl abr tab avlr

avl: TriAvl.c
	@$(CC) $(CFLAGS) -o avl TriAvl.c
	@echo "programme tri avl compilé!"
abr: TriAbr.c
	@$(CC) $(CFLAGS) -o abr TriAbr.c
	@echo "programme tri abr compilé!"
tab: tritab.c
	@$(CC) $(CFLAGS) -o tab tritab.c
	@echo "programme tri tableau compilé!"
avlr: TriDecroissant.c
	@$(CC) $(CFLAGS) -o avlr TriDecroissant.c

clean:
	@rm -f avl abr tab avlr
	@rm *.tmp
	@echo "fichiers temporaires et executables supprimés avec succès!"
