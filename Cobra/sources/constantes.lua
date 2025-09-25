--[[
    EPITECH PROJECT, 2024
    SuperMarioWorldIA
    File description:
    constantes.lua
--]]

NOM_JEU = "Super Mario World (USA)"
NOM_SAVESTATE = "./Save/debut.state"
NOM_FICHIER_POPULATION = "gen idGen.pop"    -- idGen sera remplacé par le nb de gen
TAILLE_FORM_W = 380
TAILLE_FORM_H = 385

TAILLE_TILE = 16                       	    -- Taille d'une tile DANS LE JEU
TAILLE_VUE_W = TAILLE_TILE * 11        	    -- Taille de ce que je vois le script
TAILLE_VUE_H = TAILLE_TILE * 9
TAILLE_CAMERA_W = 256                  	    -- Du jeu
TAILLE_CAMERA_H = 224
NB_TILE_W = TAILLE_VUE_W / TAILLE_TILE 	    -- Nombre de tiles scannée par le réseau de neurone en longueur (ça fait 16)
NB_TILE_H = TAILLE_VUE_H / TAILLE_TILE 	    -- Nombre de tiles scannée par le réseau de neurone en largeur  (ça fait 14)
NB_SPRITE_MAX = 11                     	    -- Dans SMW, il y a au maximum 12 sprites à l'écran en meme temps (en fait c'est 11+1 car 0 est un sprite), pour chaque type de sprite (à ne pas modifier)

TAILLE_INPUT = 6                       	    -- En pixel, uniquement pour l'affichage
TAILLE_HIDDEN = 4                      	    -- En pixel, uniquement pour l'affichage
TAILLE_OUTPUT_W = 24                   	    -- En pixel, uniquement pour l'affichage
TAILLE_OUTPUT_H = 8                    	    -- En pixel, uniquement pour l'affichage
ENCRAGE_X_INPUT = 20
ENCRAGE_Y_INPUT = 50
ENCRAGE_X_HIDDEN = 100
ENCRAGE_Y_HIDDEN = 50
ENCRAGE_X_OUTPUT = 190
ENCRAGE_Y_OUTPUT = 50
ESPACE_Y_OUTPUT = TAILLE_OUTPUT_H + 5 	    -- Entre chaque output l'espace qu'il y a
NB_HIDDEN_PAR_LIGNE = 10              	    -- Nombre de neurone hidden par ligne (affichage uniquement)

FITNESS_LEVEL_FINI = 1000000          	    -- Quand le level est fini, la fitness devient ça
NB_FRAME_RESET_BASE = 33              	    -- Si pendQant x frames la fitness n'augmente pas comparé à celle du début, on relance (le jeu tourne à 30 fps au cas où)
NB_FRAME_RESET_PROGRES = 300          	    -- Si il a eu un progrés (diff de la fitness au lancement) on laisse le jeu tourner un peu + longtemps avant le reset
NB_NEURONE_MAX = 100000               	    -- Pour le reseau de neurone, hors input et output
NB_INPUT = NB_TILE_W * NB_TILE_H      	    -- Nb de neurones input, c'est chaque case du jeu en fait
NB_OUTPUT = 8                         	    -- Nb de neurones output, c'est à dire les touches de la manette
NB_INDIVIDU_POPULATION = 100          	    -- Nombre d'individus créés quand création d'une nouvelle population

-- Constante pour trier les especes des populations
EXCES_COEF = 0.50
POIDSDIFF_COEF = 0.92
DIFF_LIMITE = 1.00

-- Mutation
CHANCE_MUTATION_RESET_CONNEXION = 0.25      -- % de chance que le poids de la connexion soit totalement reset
POIDS_CONNEXION_MUTATION_AJOUT = 0.80       -- Poids ajouté à la mutation de la connexion si pas CHANCE_MUTATION_RESET_CONNEXION. La valeur peut être passée negative
CHANCE_MUTATION_POIDS = 0.95
CHANCE_MUTATION_CONNEXION = 0.85
CHANCE_MUTATION_NEURONE = 0.39

-- Doit correspondre aux inputs de la manette dans l'emulateur
lesBoutons = {
    { nom = "P1 A" },
    { nom = "P1 B" },
    { nom = "P1 X" },
    { nom = "P1 Y" },
    { nom = "P1 Up" },
    { nom = "P1 Down" },
    { nom = "P1 Left" },
    { nom = "P1 Right" }
}

nbInnovation = 0                            -- Nombre d'innovation global pour les connexions, important pour le reseau de neurone
fitnessMax = 0                              -- Fitness max atteinte
nbGeneration = 1                            -- Pour suivre on est à la cb de generation
idPopulation = 1                            -- Quel id de la population est en train de passer dans la boucle
marioBase = {}                              -- Position de mario a la base ça va me servir pour voir si il avance de sa position d'origine / derniere pos enregistrée
niveauFini = false
lesAnciennesPopulation = {}                 -- Stock les anciennes population
nbFrame = 0                                 -- Nb de frame actuellement
nbFrameStop = 0                             -- Permettra de reset le jeu au besoin
fitnessInit = 0                             -- Fitness à laquelle le reseau actuel commence est init
niveauFiniSauvegarde = false
lesEspeces = {}
laPopulation = {}
