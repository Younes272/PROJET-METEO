#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Structure de l'AVL
typedef struct Noeud {
    int valeur; // Valeur de la première colonne du fichier CSV
    char ligne[1024]; // Ligne entière du fichier CSV
    int height;
    struct Noeud* left;
    struct Noeud* right;
}Noeud;

int max(int a, int b) {
    return (a > b) ? a : b;
}

int height(Noeud* node) {
    if (node == NULL) {
        return 0;
    }
    return node->height;
}

int getBalance(Noeud* node) {
    if (node == NULL) {
        return 0;
    }
    return height(node->left) - height(node->right);
}

Noeud* rightRotate(Noeud* node) {
    Noeud* leftChild = node->left;
    Noeud* rightSubTree = leftChild->right;
    leftChild->right = node;
    node->left = rightSubTree;
    node->height = max(height(node->left), height(node->right)) + 1;
    leftChild->height = max(height(leftChild->left), height(leftChild->right)) + 1;
    return leftChild;
}

Noeud* leftRotate(Noeud* node) {
    Noeud* rightChild = node->right;
    Noeud* leftSubTree = rightChild->left;
    rightChild->left = node;
    node->right = leftSubTree;
    node->height = max(height(node->left), height(node->right)) + 1;
    rightChild->height = max(height(rightChild->left), height(rightChild->right)) + 1;
    return rightChild;
}

// Fonction pour parcourir l'AVL en ordre croissant
void Infixe(Noeud* node, FILE* output) {
    if(node == NULL) return;
    Infixe(node->left, output);
    fprintf(output, "%s\n", node->ligne);
    Infixe(node->right,output);
}



// Fonction pour insérer une nouvelle valeur dans l'AVL
Noeud* insert(Noeud* arbre, int value, char* line) {
    // Cas de base : noeud vide
    if(arbre == NULL) {
        Noeud* newNode = (Noeud*) malloc(sizeof(Noeud));
        newNode->valeur = value;
        strcpy(newNode->ligne, line);
        newNode->height = 1;
        newNode->left = NULL;
        newNode->right = NULL;
        return newNode;
    }
    if(value == arbre->valeur) {
    arbre->right = insert(arbre->right, value, line);
    }
    else if(value < arbre->valeur) {
        arbre->left = insert(arbre->left, value, line);
    } else if(value > arbre->valeur) {
        arbre->right = insert(arbre->right, value, line);
    } 
    // Met à jour la hauteur de chaque noeud
    arbre->height = 1 + max(height(arbre->left), height(arbre->right));

    // Vérifie si l'arbre est déséquilibré et effectue les rotations nécessaires
    int balance = getBalance(arbre);
    if(balance > 1 && value < arbre->left->valeur) {
        return rightRotate(arbre);
    }
    if(balance < -1 && value > arbre->right->valeur) {
        return leftRotate(arbre);
    }
    if(balance > 1 && value > arbre->left->valeur) {
        arbre->left = leftRotate(arbre->left);
        return rightRotate(arbre);
    }
    if(balance < -1 && value < arbre->right->valeur) {
        arbre->right = rightRotate(arbre->right);
        return leftRotate(arbre);
    }

    return arbre;
}


int main(int argc, char *argv[]) {
  if (argc < 2) {
    printf("Usage: %s <csv_file>\n", argv[0]);
    return 1;
  }

  char *filename = argv[1];
  FILE *file = fopen(filename, "r");
  if (!file) {
    printf("Erreur ouverture fichier: %s\n", filename);
    return 1;
  }
    Noeud* arbre = NULL;
    // Lit les données du fichier ligne par ligne
    char tab[1024];
    while(fgets(tab, sizeof(tab), file)) {
        // Sépare les données de la ligne en colonnes
        char* column = strtok(tab, ",");

        // Convertit la première colonne en entier
        int value = atoi(column);

        // Insère la valeur dans l'AVL
        arbre = insert(arbre, value, tab);
    }
    fclose(file);
    FILE* output = fopen("sorted.csv", "w");
    if(output == NULL) {
        printf("Erreur : impossible d'ouvrir le fichier sorted.csv\n");
        return 1;
    }
    //Infixe(arbre, output);
    //affiche dans l'ordre croissant
    Infixe(arbre,output);
    return 0;
}
