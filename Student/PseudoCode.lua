-- Définition des constantes
NOM_JEU = "Super Mario World (USA)"
NOM_SAVESTATE = "debut.state"
NOM_FICHIER_POPULATION = "gen idGen.pop"
TAILLE_FORM_W = 380
TAILLE_FORM_H = 385
TAILLE_TILE = 16
TAILLE_VUE_W = TAILLE_TILE * 11
TAILLE_VUE_H = TAILLE_TILE * 9
TAILLE_CAMERA_W = 256
TAILLE_CAMERA_H = 224
NB_TILE_W = TAILLE_VUE_W / TAILLE_TILE
NB_TILE_H = TAILLE_VUE_H / TAILLE_TILE
NB_SPRITE_MAX = 11
TAILLE_INPUT = 6
TAILLE_HIDDEN = 4
TAILLE_OUTPUT_W = 24
TAILLE_OUTPUT_H = 8
ENCRAGE_X_INPUT = 20
ENCRAGE_Y_INPUT = 50
ENCRAGE_X_HIDDEN = 100
ENCRAGE_Y_HIDDEN = 50
ENCRAGE_X_OUTPUT = 190
ENCRAGE_Y_OUTPUT = 50
ESPACE_Y_OUTPUT = TAILLE_OUTPUT_H + 5
NB_HIDDEN_PAR_LIGNE = 10
FITNESS_LEVEL_FINI = 1000000
NB_FRAME_RESET_BASE = 33
NB_FRAME_RESET_PROGRES = 300
NB_NEURONE_MAX = 100000
NB_INPUT = NB_TILE_W * NB_TILE_H
NB_OUTPUT = 8
NB_INDIVIDU_POPULATION = 100
EXCES_COEF = 0.50
POIDSDIFF_COEF = 0.92
DIFF_LIMITE = 1.00
CHANCE_MUTATION_RESET_CONNEXION = 0.25
POIDS_CONNEXION_MUTATION_AJOUT = 0.80
CHANCE_MUTATION_POIDS = 0.95
CHANCE_MUTATION_CONNEXION = 0.85
CHANCE_MUTATION_NEURONE = 0.39

-- Définition des boutons de la manette
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

-- Initialisation des variables
nbInnovation = 0
fitnessMax = 0
nbGeneration = 1
idPopulation = 1
marioBase = {}
niveauFini = false
lesAnciennesPopulation = {}
nbFrame = 0
nbFrameStop = 0
fitnessInit = 0
niveauFiniSauvegarde = false
lesEspeces = {}
laPopulation = {}

-- Fonction pour créer une population
function newPopulation()
    -- Créer une nouvelle population de reseaux de neurones
end

-- Fonction pour créer un neurone
function newNeurone()
    -- Créer un nouveau neurone
end

-- Fonction pour créer une connexion entre neurones
function newConnexion()
    -- Créer une nouvelle connexion entre neurones
end

-- Fonction pour créer un réseau de neurones
function newReseau()
    -- Créer un nouveau réseau de neurones
end

-- Fonction pour créer une espèce
function newEspece()
    -- Créer une nouvelle espèce
end

-- Fonction pour copier un objet
function copier(orig)
    -- Copier l'objet orig et renvoyer la copie
end

-- Fonction pour ajouter une connexion à un réseau de neurones
function ajouterConnexion(unReseau, entree, sortie, poids)
    -- Ajouter une connexion au réseau de neurones
end

-- Fonction pour ajouter un neurone à un réseau de neurones
function ajouterNeurone(unReseau, id, type, valeur)
    -- Ajouter un neurone au réseau de neurones
end

-- Fonction pour muter les poids des connexions dans un réseau de neurones
function mutationPoidsConnexions(unReseau)
    -- Muter les poids des connexions dans le réseau de neurones
end

-- Fonction pour ajouter une nouvelle connexion à un réseau de neurones
function mutationAjouterConnexion(unReseau)
    -- Ajouter une nouvelle connexion au réseau de neurones
end

-- Fonction pour ajouter un neurone entre deux connexions dans un réseau de neurones
function mutationAjouterNeurone(unReseau)
    -- Ajouter un neurone entre deux connexions dans le réseau de neurones
end

-- Fonction pour appliquer une mutation aléatoire à un réseau de neurones
function mutation(unReseau)
    -- Appliquer une mutation aléatoire au réseau de neurones
end

-- Place la population et la renvoie divisée dans un tableau 2D
function trierPopulation(laPopulation)
    lesEspeces = {}  -- Tableau pour stocker les espèces
    
    -- Crée la première espèce et ajoute un individu
    ajouterIndividuNouvelleEspece(lesEspeces, copier(laPopulation[fin de la population]))

    -- Parcoure chaque individu de la population
    pour chaque individu de 1 à (taille de la population - 1)
        trouvé = faux  -- Variable pour suivre si l'individu a été placé dans une espèce existante
        
        -- Parcoure chaque espèce
        pour chaque espèce dans lesEspeces
            indice = nombre aléatoire entre 1 et taille de la population de l'espèce
            rep = lesEspeces[espèce].lesReseaux[indice]
            
            -- Vérifie si l'individu peut être ajouté à cette espèce
            si getScore(laPopulation[individu], rep) < DIFF_LIMITE alors
                ajouter un individu à lesEspeces[espèce].lesReseaux (copie de laPopulation[individu])
                trouvé = vrai
                quitter la boucle
            fin si
        fin pour
        
        -- Si l'individu n'a pas été ajouté à une espèce existante, crée une nouvelle espèce
        si trouvé == faux alors
            créer une nouvelle espèce
            ajouter un individu à lesEspeces[dernière espèce créée].lesReseaux (copie de laPopulation[individu])
        fin si
    fin pour

    retourner lesEspeces
fin fonction

-- Autres fonctions (getDiffPoids, getDisjoint, getScore, genererPoids, sigmoid, feedForward, crossover, choisirParent, nouvelleGeneration, getNomFichierSauvegarde, sauvegarderPopulation) doivent également être converties en pseudocode.


fonction getDiffPoids(unReseau1, unReseau2):
    nbConnexion = 0
    total = 0
    pour chaque connexion de unReseau1:
        pour chaque connexion de unReseau2:
            si même innovation alors:
                nbConnexion = nbConnexion + 1
                total = total + valeur absolue(unReseau1.poids - unReseau2.poids)
            fin si
        fin pour
    fin pour
    
    si nbConnexion == 0 alors retourner 100000
    retourner total / nbConnexion
fin fonction

fonction getDisjoint(unReseau1, unReseau2):
    nbPareil = 0
    pour chaque connexion de unReseau1:
        pour chaque connexion de unReseau2:
            si même innovation alors:
                nbPareil = nbPareil + 1
            fin si
        fin pour
    fin pour
    
    retourner (taille de unReseau1.connexions + taille de unReseau2.connexions - 2 * nbPareil)
fin fonction

fonction getScore(unReseauTest, unReseauRep):
    excèsCoef = EXCES_COEF
    poidsDiffCoef = POIDSDIFF_COEF
    disjoint = getDisjoint(unReseauTest, unReseauRep)
    maxConnexions = max(taille de unReseauTest.connexions + taille de unReseauRep.connexions, 1)
    
    retourner (excèsCoef * disjoint) / maxConnexions + (poidsDiffCoef * getDiffPoids(unReseauTest, unReseauRep))
fin fonction

fonction genererPoids():
    var = 1
    si nombre aléatoire >= 0.5 alors var = -1
    retourner var
fin fonction

fonction sigmoid(x):
    resultat = x / (1 + valeur absolue(x))
    si resultat >= 0.5 alors retourner vrai
    retourner faux
fin fonction

fonction feedForward(unReseau):
    pour chaque connexion de unReseau.connexions:
        si connexion.estActive alors:
            avantTraitement = unReseau.neurones[connexion.sortie].valeur
            unReseau.neurones[connexion.sortie].valeur = (unReseau.neurones[connexion.entree].valeur * connexion.poids) + unReseau.neurones[connexion.sortie].valeur
            
            si avantTraitement ≠ unReseau.neurones[connexion.sortie].valeur alors:
                connexion.allume = vrai
            sinon:
                connexion.allume = faux
            fin si
        fin si
    fin pour
fin fonction

fonction crossover(unReseau1, unReseau2):
    leReseau = newReseau()
    leBon = newReseau()
    leNul = newReseau()

    leBon = unReseau1
    leNul = unReseau2
    si leBon.fitness < leNul.fitness alors:
        leBon = unReseau2
        leNul = unReseau1
    
    leReseau = copier(leBon)

    pour chaque connexion de leReseau.connexions:
        pour chaque connexion de leNul.connexions:
            si même innovation alors:
                si nombre aléatoire > 0.5 alors:
                    leReseau.connexion = leNul.connexion
                fin si
            fin si
        fin pour
    fin pour

    leReseau.fitness = 1
    retourner leReseau
fin fonction

fonction choisirParent(uneEspece):
    si taille de uneEspece == 0 alors afficher "uneEspece vide dans choisir parent ??"
    
    si taille de uneEspece == 1 alors retourner copie de uneEspece[1]
    
    fitnessTotal = 0
    pour chaque individu de uneEspece:
        fitnessTotal = fitnessTotal + individu.fitness
    fin pour
    
    limite = nombre aléatoire entre 0 et fitnessTotal
    total = 0
    pour chaque individu de uneEspece:
        total = total + individu.fitness
        si total >= limite alors retourner copie de individu
    fin pour
    
    afficher "Impossible de trouver un parent ?"
    retourner nul
fin fonction

fonction nouvelleGeneration(laPopulation, lesEspeces):
    laNouvellePopulation = newPopulation()
    nbIndividuACreer = NB_INDIVIDU_POPULATION
    indiceNouvelleEspece = 1

    fitnessMaxPop = 0
    fitnessMaxAncPop = 0
    ancienPlusFort = newReseau()

    pour chaque individu de laPopulation:
        si fitnessMaxPop < individu.fitness alors:
            fitnessMaxPop = individu.fitness
        fin si
    fin pour

    si taille de lesAnciennesPopulation > 0 alors:
        pour chaque anciennePopulation dans lesAnciennesPopulation:
            pour chaque individu dans anciennePopulation:
                si fitnessMaxAncPop < individu.fitness alors:
                    fitnessMaxAncPop = individu.fitness
                    ancienPlusFort = copie de individu
                fin si
            fin pour
        fin pour
    fin si

    si fitnessMaxAncPop > fitnessMaxPop alors:
        pour chaque espèce dans lesEspeces:
            pour chaque individu dans espèce.lesReseaux:
                espèce.lesReseaux = copie de ancienPlusFort
            fin pour
        fin pour
        afficher "Mauvaise population, je reprends la meilleure et ça redevient la base de la nouvelle population"
        afficher ancienPlusFort
    fin si
    
    ajouter laPopulation à lesAnciennesPopulation

    nbIndividuTotal = 0
    fitnessMoyenneGlobal = 0
    leMeilleur = newReseau()
    
    pour chaque espèce dans lesEspeces:
        espèce.fitnessMoyenne = 0
        espèce.fitnessMax = 0
        pour chaque individu dans espèce.lesReseaux:
            espèce.fitnessMoyenne = espèce.fitnessMoyenne + individu.fitness
            fitnessMoyenneGlobal = fitnessMoyenneGlobal + individu.fitness
            nbIndividuTotal = nbIndividuTotal + 1
            
            si espèce.fitnessMax < individu.fitness alors:
                espèce.fitnessMax = individu.fitness
                si leMeilleur.fitness < individu.fitness alors:
                    leMeilleur = copie de individu
                fin si
            fin si
        fin pour
        espèce.fitnessMoyenne = espèce.fitnessMoyenne / taille de espèce.lesReseaux
    fin pour
    
    si leMeilleur.fitness == FITNESS_LEVEL_FINI alors:
        pour chaque espèce dans lesEspeces:
            pour chaque individu dans espèce.lesReseaux:
                espèce.lesReseaux = copie de leMeilleur
            fin pour
        fitnessMoyenneGlobal = leMeilleur.fitness
    fin si
    
    fitnessMoyenneGlobal = fitnessMoyenneGlobal / nbIndividuTotal
    trier lesEspeces par fitnessMax décroissant

    pour chaque espèce dans lesEspeces:
        nbIndividuEspece = arrondir_sup(taille de espèce.lesReseaux * espèce.fitnessMoyenne / fitnessMoyenneGlobal)
        nbIndividuACreer = nbIndividuACreer - nbIndividuEspece

        si nbIndividuACreer < 0 alors:
            nbIndividuEspece = nbIndividuEspece + nbIndividuACreer
            nbIndividuACreer = 0
        fin si

        espèce.nbEnfant = nbIndividuEspece

        pour chaque individu de 1 à nbIndividuEspece:
            si indiceNouvelleEspece > NB_INDIVIDU_POPULATION alors quitter la boucle
            unReseau = crossover(choisirParent(espèce.lesReseaux), choisirParent(espèce.lesReseaux))

            si fitnessMoyenneGlobal ≠ FITNESS_LEVEL_FINI alors:
                mutation(unReseau)
            fin si

            unReseau.idEspeceParent = indiceNouvelleEspece
            ajouter unReseau à laNouvellePopulation
            unReseau.fitness = 1
            indiceNouvelleEspece = indiceNouvelleEspece + 1
        fin pour

        si indiceNouvelleEspece > NB_INDIVIDU_POPULATION alors quitter la boucle
    fin pour

    pour chaque espèce dans lesEspeces:
        si espèce.nbEnfant == 0 alors supprimer espèce
    fin pour

    retourner laNouvellePopulation
fin fonction

fonction getNomFichierSauvegarde():
    str = remplacer(NOM_FICHIER_POPULATION, "idGen", nbGeneration) + "_" + obtenirDateActuelle("%Y%m%d%H%M%S")
    retourner str
fin fonction

fonction sauvegarderPopulation(laPopulation, estFini):
    chemin = getNomFichierSauvegarde()

    si estFini alors:
        chemin = "FINI " + chemin
    fin si

    fichier = ouvrir(chemin, "w+")

    écrire fichier, nbGeneration
    écrire fichier, nbInnovation

    pour chaque individu de laPopulation:
        sauvegarderUnReseau(individu, fichier)
    fin pour

    lePlusFort = newReseau()

    pour chaque individu de laPopulation:
        si lePlusFort.fitness < individu.fitness alors:
            lePlusFort = copie de individu
        fin si
    fin pour

    si taille de lesAnciennesPopulation > 0 alors:
        pour chaque anciennePopulation dans lesAnciennesPopulation:
            pour chaque individu dans anciennePopulation:
                si lePlusFort.fitness < individu.fitness alors:
                    lePlusFort = copie de individu
                fin si
            fin pour
        fin pour
    fin si

    sauvegarderUnReseau(lePlusFort, fichier)
    fermer fichier

    afficher "Sauvegarde terminée dans le fichier " + chemin
fin fonction


fonction chargerPopulation(chemin):
    si chemin ne se termine pas par ".pop" alors
        afficher "Le fichier " + chemin + " n'est pas du bon format (.pop)."
        retourner nul
    fin si

    laPopulation = {}
    fichier = ouvrir(chemin, "r")

    nbGeneration = lireNombre(fichier)
    nbInnovation = lireNombre(fichier)
    
    pour i de 1 à NB_INDIVIDU_POPULATION faire
        ajouter chargerUnReseau(fichier) à laPopulation
        laPopulation[i].fitness = 1
    fin pour

    lesAnciennesPopulation = {}
    insérer copie de laPopulation dans lesAnciennesPopulation
    lesAnciennesPopulation[1][1] = chargerUnReseau(fichier)

    si lesAnciennesPopulation[1][1].fitness == FITNESS_LEVEL_FINI alors
        pour i de 1 à NB_INDIVIDU_POPULATION faire
            laPopulation[i] = copie de lesAnciennesPopulation[1][1]
        fin pour
    fin si
    
    fermer fichier
    retourner laPopulation
fin fonction

fonction sauvegarderUnReseau(unReseau, fichier):
    écrire unReseau.nbNeurone dans fichier
    écrire taille de unReseau.lesConnexions dans fichier
    écrire unReseau.fitness dans fichier
    
    pour chaque neurone de unReseau.lesNeurones faire
        écrire neurone.id dans fichier
    fin pour
    
    pour chaque connexion de unReseau.lesConnexions faire
        actif = 1
        si connexion.actif n'est pas vrai alors
            actif = 0
        fin si
        écrire actif dans fichier
        écrire connexion.entree dans fichier
        écrire connexion.sortie dans fichier
        écrire connexion.poids dans fichier
        écrire connexion.innovation dans fichier
    fin pour
fin fonction

fonction chargerUnReseau(fichier):
    unReseau = newReseau()
    nbNeurone = lireNombre(fichier)
    nbConnexion = lireNombre(fichier)
    unReseau.fitness = lireNombre(fichier)
    unReseau.nbNeurone = nbNeurone
    unReseau.lesConnexions = []
    
    pour i de 1 à nbNeurone faire
        neurone = newNeurone()
        neurone.id = lireNombre(fichier)
        neurone.valeur = 0
        neurone.type = "hidden"
        ajouter neurone à unReseau.lesNeurones
    fin pour
    
    pour i de 1 à nbConnexion faire
        connexion = newConnexion()
        actif = lireNombre(fichier)
        connexion.entree = lireNombre(fichier)
        connexion.sortie = lireNombre(fichier)
        connexion.poids = lireNombre(fichier)
        connexion.innovation = lireNombre(fichier)
        
        si actif == 1 alors
            connexion.actif = vrai
        sinon
            connexion.actif = faux
        fin si
        
        ajouter connexion à unReseau.lesConnexions
    fin pour
    
    retourner unReseau
fin fonction

fonction majReseau(unReseau, marioBase):
    mario = getPositionMario()
    
    si non niveauFini et memory.readbyte(0x0100) == 12 alors
        unReseau.fitness = FITNESS_LEVEL_FINI
        niveauFini = vrai
    sinon si marioBase.x < mario.x alors
        unReseau.fitness = unReseau.fitness + (mario.x - marioBase.x)
        marioBase.x = mario.x
    fin si
    
    lesInputs = getLesInputs()
    
    pour i de 1 à NB_INPUT faire
        unReseau.lesNeurones[i].valeur = lesInputs[i]
    fin pour
fin fonction

fonction getLesInputs():
    lesInputs = []
    
    pour i de 1 à NB_TILE_W faire
        pour j de 1 à NB_TILE_H faire
            lesInputs[getIndiceLesInputs(i, j)] = 0
        fin pour
    fin pour
    
    lesSprites = getLesSprites()
    
    pour chaque sprite dans lesSprites faire
        input = convertirPositionPourInput(sprite)
        
        si input.x > 0 et input.x < (TAILLE_VUE_W / TAILLE_TILE) + 1 alors
            lesInputs[getIndiceLesInputs(input.x, input.y)] = -1
        fin si
    fin pour
    
    lesTiles = getLesTiles()
    
    pour i de 1 à NB_TILE_W faire
        pour j de 1 à NB_TILE_H faire
            indice = getIndiceLesInputs(i, j)
            
            si lesTiles[indice] n'est pas 0 alors
                lesInputs[indice] = lesTiles[indice]
            fin si
        fin pour
    fin pour
    
    retourner lesInputs
fin fonction

fonction getLesSprites():
    lesSprites = []
    
    pour i de 0 à NB_SPRITE_MAX faire
        si memory.readbyte(0x14C8 + i) > 7 alors
            x = memory.readbyte(0xE4 + i) + memory.readbyte(0x14E0 + i) * 256
            y = math.floor(memory.readbyte(0xD8 + i) + memory.readbyte(0x14D4 + i) * 256)
            ajouter {x: x, y: y} à lesSprites
        fin si
    fin pour
    
    pour i de 0 à NB_SPRITE_MAX faire
        si memory.readbyte(0x170B + i) n'est pas 0 alors
            x = memory.readbyte(0x171F + i) + memory.readbyte(0x1733 + i) * 256
            y = math.floor(memory.readbyte(0x1715 + i) + memory.readbyte(0x1729 + i) * 256)
            ajouter {x: x, y: y} à lesSprites
        fin si
    fin pour
    
    retourner lesSprites
fin fonction


fonction getLesTiles():
    lesTiles = tableau_vide
    j = 1

    mario = getPositionMario()
    mario.x = mario.x - TAILLE_VUE_W / 2
    mario.y = mario.y - TAILLE_VUE_H / 2

    pour i de 1 à NB_TILE_W faire
        pour j de 1 à NB_TILE_H faire
            xT = arrondi_sup((mario.x + ((i - 1) * TAILLE_TILE)) / TAILLE_TILE)
            yT = arrondi_sup((mario.y + ((j - 1) * TAILLE_TILE)) / TAILLE_TILE)

            si xT > 0 et yT > 0 alors
                lesTiles[getIndiceLesInputs(i, j)] = lire_byte(
                    0x1C800 +
                    arrondi_inf(xT / TAILLE_TILE) *
                    0x1B0 +
                    yT * TAILLE_TILE +
                    xT % TAILLE_TILE)
            sinon
                lesTiles[getIndiceLesInputs(i, j)] = 0
            fin si
        fin pour
    fin pour

    retourner lesTiles
fin fonction

fonction getPositionMario():
    mario = {}
    mario.x = lire_s16_le(0x94)
    mario.y = lire_s16_le(0x96)
    retourner mario
fin fonction

fonction getPositionCamera():
    camera = {}
    camera.x = lire_s16_le(0x1462)
    camera.y = lire_s16_le(0x1464)
    retourner camera
fin fonction

fonction convertirPositionPourInput(position):
    mario = getPositionMario()
    positionT = {}
    mario.x = mario.x - TAILLE_VUE_W / 2
    mario.y = mario.y - TAILLE_VUE_H / 2

    positionT.x = arrondi_inf((position.x - mario.x) / TAILLE_TILE) + 1
    positionT.y = arrondi_inf((position.y - mario.y) / TAILLE_TILE) + 1

    retourner positionT
fin fonction

fonction appliquerLesBoutons(unReseau):
    lesBoutonsT = {}

    pour i de 1 à NB_OUTPUT faire
        lesBoutonsT[lesBoutons[i].nom] = sigmoid(unReseau.lesNeurones[NB_INPUT + i].valeur)
    fin pour

    si lesBoutonsT["P1 Left"] et lesBoutonsT["P1 Right"] alors
        lesBoutonsT["P1 Left"] = faux
    fin si

    set_les_boutons(lesBoutonsT)
fin fonction

fonction traitementPause():
    lesBoutons = get_les_boutons(1)

    si lesBoutons["P1 Start"] alors
        lesBoutons["P1 Start"] = faux
    sinon
        lesBoutons["P1 Start"] = vrai
    fin si

    set_les_boutons(lesBoutons)
fin fonction

fonction dessinerLesInfos(laPopulation, lesEspeces, nbGeneration):
    dessiner_rectangle(0, 0, 256, 40, "noir", "blanc")

    dessiner_texte(0, 4, "Generation " + nbGeneration + " Ind:" + idPopulation + " Nb Espece " +
        taille_de(lesEspeces) + "\nFitness:" +
        laPopulation[idPopulation].fitness + " (max = " + fitnessMax + ")", "noir")
fin fonction

fonction dessinerUnReseau(unReseau):
    lesInputs = getLesInputs()
    camera = getPositionCamera()
    lesPositions = tableau_vide

    pour i de 1 à NB_TILE_W faire
        pour j de 1 à NB_TILE_H faire
            indice = getIndiceLesInputs(i, j)
            xT = ENCRAGE_X_INPUT + (i - 1) * TAILLE_INPUT
            yT = ENCRAGE_Y_INPUT + (j - 1) * TAILLE_INPUT
            couleurFond = "gris"

            si unReseau.lesNeurones[indice].valeur < 0 alors
                couleurFond = "noir"
            sinon si unReseau.lesNeurones[indice].valeur > 0 alors
                couleurFond = "blanc"
            fin si

            dessiner_rectangle(xT, yT, TAILLE_INPUT, TAILLE_INPUT, "noir", couleurFond)

            lesPositions[indice] = {}
            lesPositions[indice].x = xT + TAILLE_INPUT / 2
            lesPositions[indice].y = yT + TAILLE_INPUT / 2
        fin pour
    fin pour

    mario = convertirPositionPourInput(getPositionMario())
    mario.x = (mario.x - 1) * TAILLE_INPUT + ENCRAGE_X_INPUT
    mario.y = (mario.y - 1) * TAILLE_INPUT + ENCRAGE_Y_INPUT
    dessiner_rectangle(mario.x, mario.y, TAILLE_INPUT, TAILLE_INPUT * 2, "noir", "bleu")

    pour i de 1 à NB_OUTPUT faire
        xT = ENCRAGE_X_OUTPUT
        yT = ENCRAGE_Y_OUTPUT + ESPACE_Y_OUTPUT * (i - 1)
        nomT = sous_chaine(lesBoutons[i].nom, 4)
        indice = i + NB_INPUT

        si sigmoid(unReseau.lesNeurones[indice].valeur) alors
            dessiner_rectangle(xT, yT, TAILLE_OUTPUT_W, TAILLE_OUTPUT_H, "blanc", "blanc")
        sinon
            dessiner_rectangle(xT, yT, TAILLE_OUTPUT_W, TAILLE_OUTPUT_H, "blanc", "noir")
        fin si

        xT = xT + TAILLE_OUTPUT_W
        strValeur = format("%.2f", unReseau.lesNeurones[indice].valeur)
        dessiner_texte(xT, yT - 1, nomT, "blanc", "noir", 10)

        lesPositions[indice] = {}
        lesPositions[indice].x = xT - TAILLE_OUTPUT_W / 2
        lesPositions[indice].y = yT + TAILLE_OUTPUT_H / 2
    fin pour

    pour i de 1 à unReseau.nbNeurone faire
        xT = ENCRAGE_X_HIDDEN +
            (TAILLE_HIDDEN + 1) * (i - (NB_HIDDEN_PAR_LIGNE * arrondi_inf((i - 1) / NB_HIDDEN_PAR_LIGNE)))
        yT = ENCRAGE_Y_HIDDEN + (TAILLE_HIDDEN + 1) * (arrondi_inf((i - 1) / NB_HIDDEN_PAR_LIGNE))
        indice = i + NB_INPUT + NB_OUTPUT
        dessiner_rectangle(xT, yT, TAILLE_HIDDEN, TAILLE_HIDDEN, "noir", "blanc")

        lesPositions[indice] = {}
        lesPositions[indice].x = xT + TAILLE_HIDDEN / 2
        lesPositions[indice].y = yT + TAILLE_HIDDEN / 2
    fin pour

    pour i de 1 à taille_de(unReseau.lesConnexions) faire
        si unReseau.lesConnexions[i].actif alors
            pixel = 0
            alpha = 255
            couleur

            si unReseau.lesConnexions[i].poids > 0 alors
                pixel = 255
            fin si

            si non unReseau.lesConnexions[i].allume alors
                alpha = 25
            fin si

            couleur = créer_couleur(pixel, pixel, pixel, alpha)

            dessiner_ligne(lesPositions[unReseau.lesConnexions[i].entree].x,
                lesPositions[unReseau.lesConnexions[i].entree].y,
                lesPositions[unReseau.lesConnexions[i].sortie].x,
                lesPositions[unReseau.lesConnexions[i].sortie].y,
                couleur)
        fin si
    fin pour
fin fonction

lorsque le script se termine:
    afficher "Fin du script" dans la console
    effacer la GUI graphique
    détruire le formulaire (form)

fonction activerSauvegarde():
    sauvegarder la population (laPopulation, false)

fonction activerChargement():
    chemin = ouvrir_fichier()
    si chemin n'est pas vide alors
        laPopulationT = chargerPopulation(chemin)
        si laPopulationT n'est pas nulle alors
            laPopulation = copier(laPopulationT)
            idPopulation = 1
            lancerNiveau()
        fin si
    fin si

fonction lancerNiveau():
    charger l'état de sauvegarde (NOM_SAVESTATE)
    marioBase = getPositionMario()
    niveauFini = faux
    nbFrameStop = 0

effacer la console

si le nom de la ROM actuelle n'est pas égal à NOM_JEU alors
    afficher "Mauvaise rom (actuellement " + gameinfo.getromname() + "), marche uniquement avec " + nomJeu dans la console
sinon
    afficher "Lancement du script" dans la console
    initialiser la graine aléatoire avec l'heure actuelle
    lancerNiveau()
    créer un formulaire (form) de taille TAILLE_FORM_W x TAILLE_FORM_H avec le titre "Informations"
    labelInfo = créer une étiquette dans le formulaire avec le texte "a maj" aux coordonnées (0, 0) et la taille (350, 220)
    estAccelere = créer une case à cocher "Accelerer" dans le formulaire aux coordonnées (10, 220)
    estAfficheReseau = créer une case à cocher "Afficher reseau" dans le formulaire aux coordonnées (10, 240)
    estAfficheInfo = créer une case à cocher "Afficher bandeau" dans le formulaire aux coordonnées (10, 260)
    créer un bouton "Pause" dans le formulaire avec la fonction traitementPause aux coordonnées (10, 285)
    créer un bouton "Sauvegarder" dans le formulaire avec la fonction activerSauvegarde aux coordonnées (10, 315)
    créer un bouton "Charger" dans le formulaire avec la fonction activerChargement aux coordonnées (100, 315)

    laPopulation = nouvellePopulation()

    pour i de 1 à la taille de laPopulation faire
        mutation(laPopulation[i])
    fin pour

    pour i de 2 à la taille de laPopulation faire
        laPopulation[i] = copier(laPopulation[1])
        mutation(laPopulation[i])
    fin pour

    lesEspeces = trierPopulation(laPopulation)
    laPopulation = nouvelleGeneration(laPopulation, lesEspeces)

    tant que vrai faire
        fitnessAvant = laPopulation[idPopulation].fitness
        nettoyer = vrai

        si est coché estAccelere alors
            désactiver la limitation de la fréquence d'images
        sinon
            activer la limitation de la fréquence d'images
        fin si

        si est coché estAfficheReseau alors
            dessinerUnReseau(laPopulation[idPopulation])
            nettoyer = faux
        fin si

        si est coché estAfficheInfo alors
            dessinerLesInfos(laPopulation, lesEspeces, nbGeneration)
            nettoyer = faux
        fin si

        si nettoyer alors
            effacer la GUI graphique
        fin si

        majReseau(laPopulation[idPopulation], marioBase)
        feedForward(laPopulation[idPopulation])
        appliquerLesBoutons(laPopulation[idPopulation])

        si nbFrame = 0 alors
            fitnessInit = laPopulation[idPopulation].fitness
        fin si

        avancer d'une frame
        nbFrame = nbFrame + 1

        si fitnessMax < laPopulation[idPopulation].fitness alors
            fitnessMax = laPopulation[idPopulation].fitness
        fin si

        si fitnessAvant == laPopulation[idPopulation].fitness et memory.readbyte(0x13D4) == 0 alors
            nbFrameStop = nbFrameStop + 1
            nbFrameReset = NB_FRAME_RESET_BASE

            si fitnessInit != laPopulation[idPopulation].fitness et memory.readbyte(0x0071) != 9 alors
                nbFrameReset = NB_FRAME_RESET_PROGRES
            fin si

            si nbFrameStop > nbFrameReset alors
                nbFrameStop = 0
                lancerNiveau()
                idPopulation = idPopulation + 1

                si idPopulation > taille de laPopulation alors
                    si non niveauFiniSauvegarde alors
                        pour i de 1 à taille de laPopulation faire
                            si laPopulation[i].fitness == FITNESS_LEVEL_FINI alors
                                sauvegarderPopulation(laPopulation, vrai)
                                niveauFiniSauvegarde = vrai
                                afficher "Niveau fini apres " + nbGeneration + " generation !" dans la console
                            fin si
                        fin pour
                    fin si

                    idPopulation = 1
                    nbGeneration = nbGeneration + 1
                    lesEspeces = trierPopulation(laPopulation)
                    laPopulation = nouvelleGeneration(laPopulation, lesEspeces)
                    nbFrame = 0
                    fitnessInit = 0
                fin si
            fin si
        sinon
            nbFrameStop = 0
        fin si

        mettre à jour le texte du labelInfo avec les informations actuelles
    fin tant que
fin si
