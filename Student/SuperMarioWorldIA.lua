--[[
	EPITECH PROJECT, 2024
	SuperMarioWorldIA
	File description:
	SuperMarioWorldIA.lua
--]]

-- Constantes
NOM_JEU = "Super Mario World (USA)"
NOM_SAVESTATE = "debut.state"
NOM_FICHIER_POPULATION = "gen idGen.pop" -- idGen sera remplacé par le nb de gen
TAILLE_FORM_W = 380
TAILLE_FORM_H = 385
TAILLE_TILE = 16                       -- Taille d'une tile DANS LE JEU
TAILLE_VUE_W = TAILLE_TILE * 11        -- Taille de ce que je vois le script
TAILLE_VUE_H = TAILLE_TILE * 9
TAILLE_CAMERA_W = 256                  -- Du jeu
TAILLE_CAMERA_H = 224
NB_TILE_W = TAILLE_VUE_W / TAILLE_TILE -- Nombre de tiles scannée par le réseau de neurone en longueur (ça fait 16)
NB_TILE_H = TAILLE_VUE_H / TAILLE_TILE -- Nombre de tiles scannée par le réseau de neurone en largeur  (ça fait 14)
NB_SPRITE_MAX = 11                     -- Dans SMW, il y a au maximum 12 sprites à l'écran en meme temps (en fait c'est 11+1 car 0 est un sprite), pour chaque type de sprite (à ne pas modifier)
TAILLE_INPUT = 6                       -- En pixel, uniquement pour l'affichage
TAILLE_HIDDEN = 4                      -- En pixel, uniquement pour l'affichage
TAILLE_OUTPUT_W = 24                   -- En pixel, uniquement pour l'affichage
TAILLE_OUTPUT_H = 8                    -- En pixel, uniquement pour l'affichage
ENCRAGE_X_INPUT = 20
ENCRAGE_Y_INPUT = 50
ENCRAGE_X_HIDDEN = 100
ENCRAGE_Y_HIDDEN = 50
ENCRAGE_X_OUTPUT = 190
ENCRAGE_Y_OUTPUT = 50
ESPACE_Y_OUTPUT = TAILLE_OUTPUT_H + 5 -- Entre chaque output l'espace qu'il y a
NB_HIDDEN_PAR_LIGNE = 10              -- Nombre de neurone hidden par ligne (affichage uniquement)
FITNESS_LEVEL_FINI = 1000000          -- Quand le level est fini, la fitness devient ça
NB_FRAME_RESET_BASE = 33              -- Si pendant x frames la fitness n'augmente pas comparé à celle du début, on relance (le jeu tourne à 30 fps au cas où)
NB_FRAME_RESET_PROGRES = 300          -- Si il a eu un progrés (diff de la fitness au lancement) on laisse le jeu tourner un peu + longtemps avant le reset
NB_NEURONE_MAX = 100000               -- Pour le reseau de neurone, hors input et output
NB_INPUT = NB_TILE_W * NB_TILE_H      -- Nombre de neurones input, c'est chaque case du jeu en fait
NB_OUTPUT = 8                         -- Nombre de neurones output, c'est à dire les touches de la manette
NB_INDIVIDU_POPULATION = 100          -- Nombre d'individus créés quand création d'une nouvelle population
-- Constante pour trier les especes des populations
EXCES_COEF = 0.50
POIDSDIFF_COEF = 0.92
DIFF_LIMITE = 1.00
-- Mutation
CHANCE_MUTATION_RESET_CONNEXION = 0.25 -- Pourcentage de chances que le poids de la connexion soit totalement reset
POIDS_CONNEXION_MUTATION_AJOUT = 0.80  -- Poids ajouté à la mutation de la connexion si pas CHANCE_MUTATION_RESET_CONNEXION. La valeur peut être passée negative
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

nbInnovation = 0                -- Nombre d'innovation global pour les connexions, important pour le reseau de neurone
fitnessMax = 0                  -- Fitness max atteinte
nbGeneration = 1                -- Pour suivre on est à la cb de generation
idPopulation = 1                -- Quel id de la population est en train de passer dans la boucle
marioBase = {}                  -- Position de mario a la base ça va me servir pour voir si il avance de sa position d'origine / derniere pos enregistrée
niveauFini = false
lesAnciennesPopulation = {}     -- Stock les anciennes population
nbFrame = 0                     -- Nombre de frame actuellement
nbFrameStop = 0                 -- Permettra de reset le jeu au besoin
fitnessInit = 0                 -- Fitness à laquelle le reseau actuel commence est init
niveauFiniSauvegarde = false
lesEspeces = {}
laPopulation = {}

-- Créé une population
function newPopulation()
	local population = {}
	for i = 1, NB_INDIVIDU_POPULATION, 1 do
		table.insert(population, newReseau())
	end
	return population
end

-- Créé un neurone
function newNeurone()
	local neurone = {}
	neurone.valeur = 0
	neurone.id = 0      -- Pas init si à 0, doit être == à l'indice du neurone dans lesNeurones du reseau
	neurone.type = ""
	return neurone
end

-- Créé une connexion
function newConnexion()
	local connexion = {}
	connexion.entree = 0
	connexion.sortie = 0
	connexion.actif = true
	connexion.poids = 0
	connexion.innovation = 0
	connexion.allume = false -- Pour le dessin, si true ça veut dire que le resultat de la connexion est different de 0
	return connexion
end

-- Créé un reseau de neurone
function newReseau()
	local reseau = {
		nbNeurone = 0, 	    -- Taille des neurones  rajouté par l'algo (hors input output du coup)
		fitness = 1,    	-- Beaucoup de division, pour eviter de faire l irreparable
		idEspeceParent = 0,
		lesNeurones = {},
		lesConnexions = {}
	}
	for j = 1, NB_INPUT, 1 do
		ajouterNeurone(reseau, j, "input", 1)
	end


	-- Ensuite, les outputs
	for j = NB_INPUT + 1, NB_INPUT + NB_OUTPUT, 1 do
		ajouterNeurone(reseau, j, "output", 0)
	end


	return reseau
end

-- Créé une espece (un regroupement de reseaux, d'individus)
function newEspece()
	local espece = {
		nbEnfant = 0, 		-- Combien d'enfant cette espece a créé
		fitnessMoyenne = 0, -- Fitness moyenne de l'espece
		fitnessMax = 0, 	-- Fitness max atteinte par l'espece
		lesReseaux = {}
	}                 		-- Tableau qui regroupe les reseaux}

	return espece
end

-- Copie un truc et renvoie le truc copié
-- J'ai copié ce code d'ici http://lua-users.org/wiki/CopyTable c vrai en +
function copier(orig)
	local orig_type = type(orig)
	local copy
	if orig_type == 'table' then
		copy = {}
		for orig_key, orig_value in next, orig, nil do
			copy[copier(orig_key)] = copier(orig_value)
		end
		setmetatable(copy, copier(getmetatable(orig)))
	else -- Number, string, boolean, etc
		copy = orig
	end
	return copy
end

-- Ajoute une connexion a un reseau de neurone
function ajouterConnexion(unReseau, entree, sortie, poids)
	-- Test pour voir si tout va bien et que les neurones de la connexion existent bien
	if unReseau.lesNeurones[entree].id == 0 then
		console.log("connexion avec l'entree " .. entree .. " n'est pas init ?")
	elseif unReseau.lesNeurones[sortie].id == 0 then
		console.log("connexion avec la sortie " .. sortie .. " n'est pas init ?")
	else
		local connexion = newConnexion()
		connexion.actif = true
		connexion.entree = entree
		connexion.sortie = sortie
		connexion.poids = genererPoids()
		connexion.innovation = nbInnovation
		table.insert(unReseau.lesConnexions, connexion)
		nbInnovation = nbInnovation + 1
	end
end

-- Ajoute un neurone a un reseau de neurone, fait que pour les neurones qui doivent exister
function ajouterNeurone(unReseau, id, type, valeur)
	if id ~= 0 then
		local neurone = newNeurone()
		neurone.id = id
		neurone.type = type
		neurone.valeur = valeur
		table.insert(unReseau.lesNeurones, neurone)
	else
		console.log("ajouterNeurone doit pas etre utilise avec un id == 0")
	end
end

-- Modifie les connexions d'un reseau de neurone
function mutationPoidsConnexions(unReseau)
	for i = 1, #unReseau.lesConnexions, 1 do
		if unReseau.lesConnexions[i].actif then
			if math.random() < CHANCE_MUTATION_RESET_CONNEXION then
				unReseau.lesConnexions[i].poids = genererPoids()
			else
				if math.random() >= 0.5 then
					unReseau.lesConnexions[i].poids = unReseau.lesConnexions[i].poids - POIDS_CONNEXION_MUTATION_AJOUT
				else
					unReseau.lesConnexions[i].poids = unReseau.lesConnexions[i].poids + POIDS_CONNEXION_MUTATION_AJOUT
				end
			end
		end
	end
end

-- Ajoute une connexion entre 2 neurones pas déjà connecté entre eux
-- Ça peut ne pas marcher si aucun neurone n'est connectable entre eux (uniquement si beaucoup de connexion)
function mutationAjouterConnexion(unReseau)
	local liste = {}

	-- Randomisation + copies des neuronnes dans une liste
	for i, v in ipairs(unReseau.lesNeurones) do
		local pos = math.random(1, #liste + 1)
		table.insert(liste, pos, v)
	end

	-- La je vais lister tous les neurones et voir si une pair n'a pas de connexion; si une connexion peut être créée
	-- On la créée et on stop
	local traitement = false
	for i = 1, #liste, 1 do
		for j = 1, #liste, 1 do
			if i ~= j then
				local neurone1 = liste[i]
				local neurone2 = liste[j]

				if (neurone1.type == "input" and neurone2.type == "output") or
					(neurone1.type == "hidden" and neurone2.type == "hidden") or
					(neurone1.type == "hidden" and neurone2.type == "output") then
					-- si on en est là, c'est que la connexion peut se faire, juste à tester si y pas deja une connexion
					local dejaConnexion = false
					for k = 1, #unReseau.lesConnexions, 1 do
						if unReseau.lesConnexions[k].entree == neurone1.id
							and unReseau.lesConnexions[k].sortie == neurone2.id then
							dejaConnexion = true
							break
						end
					end

					if dejaConnexion == false then
						-- Nouvelle connexion, traitement terminé
						traitement = true
						ajouterConnexion(unReseau, neurone1.id, neurone2.id)
					end
				end
			end
			if traitement then
				break
			end
		end
		if traitement then
			break
		end
	end

	if traitement == false then
		console.log("Impossible de recreer une connexion")
	end
end

-- Ajoute un neurone (couche caché uniquement) entre 2 neurones déjà connecté. Ne peut pas marcher
-- Si il n'y a pas de connexion
function mutationAjouterNeurone(unReseau)
	if #unReseau.lesConnexions == 0 then
		log("Impossible d'ajouter un neurone entre 2 connexions si pas de connexion")
		return nil
	end

	if unReseau.nbNeurone == NB_NEURONE_MAX then
		console.log("Nombre de neurone max atteint")
		return nil
	end

	-- Randomisation de la liste des connexions
	local listeIndice = {}
	local listeRandom = {}

	-- Je créé une liste d'entier de 1 à la taille des connexions
	for i = 1, #unReseau.lesConnexions, 1 do
		listeIndice[i] = i
	end

	-- Je randomise la liste que je viens de créer dans listeRandom
	for i, v in ipairs(listeIndice) do
		local pos = math.random(1, #listeRandom + 1)
		table.insert(listeRandom, pos, v)
	end

	for i = 1, #listeRandom, 1 do
		if unReseau.lesConnexions[listeRandom[i]].actif then
			unReseau.lesConnexions[listeRandom[i]].actif = false
			unReseau.nbNeurone = unReseau.nbNeurone + 1
			local indice = unReseau.nbNeurone + NB_INPUT + NB_OUTPUT
			ajouterNeurone(unReseau, indice, "hidden", 1)
			ajouterConnexion(unReseau, unReseau.lesConnexions[listeRandom[i]].entree, indice, genererPoids())
			ajouterConnexion(unReseau, indice, unReseau.lesConnexions[listeRandom[i]].sortie, genererPoids())
			break
		end
	end
end

-- Appelle une des mutations aléatoirement en fonction des constantes
function mutation(unReseau)
	local random = math.random()
	if random < CHANCE_MUTATION_POIDS then
		mutationPoidsConnexions(unReseau)
	end
	if random < CHANCE_MUTATION_CONNEXION then
		mutationAjouterConnexion(unReseau)
	end
	if random < CHANCE_MUTATION_NEURONE then
		mutationAjouterNeurone(unReseau)
	end
end

-- Place la population et la renvoie divisée dans une tableau 2D
function trierPopulation(laPopulation)
	local lesEspeces = {}
	table.insert(lesEspeces, newEspece())

	-- La premiere espece créée et le dernier element de la premiere population
	-- Comme ça, j'ai déjà une première espèce créée
	table.insert(lesEspeces[1].lesReseaux, copier(laPopulation[#laPopulation]))

	for i = 1, #laPopulation - 1, 1 do
		local trouve = false
		for j = 1, #lesEspeces, 1 do
			local indice = math.random(1, #lesEspeces[j].lesReseaux)
			local rep = lesEspeces[j].lesReseaux[indice]
			-- Il peut être classé
			if getScore(laPopulation[i], rep) < DIFF_LIMITE then
				table.insert(lesEspeces[j].lesReseaux, copier(laPopulation[i]))
				trouve = true
				break
			end
		end

		-- Si pas trouvé, il faut créer une especes pour l'individu
		if trouve == false then
			table.insert(lesEspeces, newEspece())
			table.insert(lesEspeces[#lesEspeces].lesReseaux, copier(laPopulation[i]))
		end
	end

	return lesEspeces
end

-- Retourne la difference de poids de 2 réseaux de neurones (uniquement des memes innovations)
function getDiffPoids(unReseau1, unReseau2)
	local nbConnexion = 0
	local total = 0
	for i = 1, #unReseau1.lesConnexions, 1 do
		for j = 1, #unReseau2.lesConnexions, 1 do
			if unReseau1.lesConnexions[i].innovation == unReseau2.lesConnexions[j].innovation then
				nbConnexion = nbConnexion + 1
				total = total + math.abs(unReseau1.lesConnexions[i].poids - unReseau2.lesConnexions[j].poids)
			end
		end
	end

	-- Si aucune connexion en commun c'est qu'ils sont trop differents
	-- Puis si on laisse comme ça on va diviser par 0 et on va lancer mario maker
	if nbConnexion == 0 then
		return 100000
	end


	return total / nbConnexion
end

-- Retourne le nombre de connexion qui n'ont aucun rapport entre les 2 reseaux
function getDisjoint(unReseau1, unReseau2)
	local nbPareil = 0
	for i = 1, #unReseau1.lesConnexions, 1 do
		for j = 1, #unReseau2.lesConnexions, 1 do
			if unReseau1.lesConnexions[i].innovation == unReseau2.lesConnexions[j].innovation then
				nbPareil = nbPareil + 1
			end
		end
	end

	-- Oui ça marche
	return #unReseau1.lesConnexions + #unReseau2.lesConnexions - 2 * nbPareil
end

-- Permet d'obtenir le score d'un reseau de neurone, ce qui va le mettre dans une especes
-- Rien à voir avec le fitness
-- UnReseauRep et un reseau appartenant deja a une espece
-- Et reseauTest et le reseau qui va etre testé
function getScore(unReseauTest, unReseauRep)
	return (EXCES_COEF * getDisjoint(unReseauTest, unReseauRep)) /
		(math.max(#unReseauTest.lesConnexions + #unReseauRep.lesConnexions, 1))
		+ POIDSDIFF_COEF * getDiffPoids(unReseauTest, unReseauRep)
end

-- Genere un poids aléatoire (pour les connexions) egal à 1 ou -1
function genererPoids()
	local var = 1
	if math.random() >= 0.5 then
		var = var * -1
	end
	return var
end

-- Fonction d'activation
function sigmoid(x)
	local resultat = x / (1 + math.abs(x))
	if resultat >= 0.5 then
		return true
	end
	return false
end

-- Applique les connexions d'un réseau de neurone en modifiant la valeur des neurones de sortie
function feedForward(unReseau)
	-- Avant de continuer, je reset à 0 les neurones de sortie
	for i = 1, #unReseau.lesConnexions, 1 do
		if unReseau.lesConnexions[i].actif then
			unReseau.lesNeurones[unReseau.lesConnexions[i].sortie].valeur = 0
			unReseau.lesNeurones[unReseau.lesConnexions[i].sortie].allume = false
		end
	end


	for i = 1, #unReseau.lesConnexions, 1 do
		if unReseau.lesConnexions[i].actif then
			local avantTraitement = unReseau.lesNeurones[unReseau.lesConnexions[i].sortie].valeur
			unReseau.lesNeurones[unReseau.lesConnexions[i].sortie].valeur =
				unReseau.lesNeurones[unReseau.lesConnexions[i].entree].valeur *
				unReseau.lesConnexions[i].poids +
				unReseau.lesNeurones[unReseau.lesConnexions[i].sortie].valeur

			-- On ""allume"" le lien si la connexion a fait une modif
			if avantTraitement ~= unReseau.lesNeurones[unReseau.lesConnexions[i].sortie].valeur then
				unReseau.lesConnexions[i].allume = true
			else
				unReseau.lesConnexions[i].allume = false
			end
		end
	end
end

-- Retourne un melange des 2 reseaux de neurones
function crossover(unReseau1, unReseau2)
	local leReseau = newReseau()


	-- Quel est le meilleur des deux ?
	local leBon = newReseau()
	local leNul = newReseau()


	leBon = unReseau1
	leNul = unReseau2
	if leBon.fitness < leNul.fitness then
		leBon = unReseau2
		leNul = unReseau1
	end

	-- Le nouveau reseau va hériter de la majorité des attributs du meilleur
	leReseau = copier(leBon)

	-- Sauf pour les connexions où y a une chance que le nul lui donne ses genes
	for i = 1, #leReseau.lesConnexions, 1 do
		for j = 1, #leNul.lesConnexions, 1 do
			-- Si 2 connexions partagent la meme innovation, la connexion du nul peut venir la remplacer
			-- *seulement si nul est actif, sans ça ça créé des neurones hiddens inutiles*
			if leReseau.lesConnexions[i].innovation == leNul.lesConnexions[j].innovation and leNul.lesConnexions[j].actif then
				if math.random() > 0.5 then
					leReseau.lesConnexions[i] = leNul.lesConnexions[j]
				end
			end
		end
	end
	leReseau.fitness = 1
	return leReseau
end

-- Renvoie une copie d'un parent choisis dans une espece
function choisirParent(uneEspece)
	if #uneEspece == 0 then
		console.log("uneEspece vide dans choisir parent ??")
	end
	-- Il est possible que l'espece ne contienne qu'un seul reseau, dans ce cas là on va pas plus loin
	if #uneEspece == 1 then
		return uneEspece[1]
	end

	local fitnessTotal = 0
	for i = 1, #uneEspece, 1 do
		fitnessTotal = fitnessTotal + uneEspece[i].fitness
	end
	local limite = math.random(0, fitnessTotal)
	local total = 0
	for i = 1, #uneEspece, 1 do
		total = total + uneEspece[i].fitness
		-- si la somme des fitness cumulés depasse total, on renvoie l'espece qui a fait depasser la limite
		if total >= limite then
			return copier(uneEspece[i])
		end
	end
	console.log("Impossible de trouver un parent ?")
	return nil
end

-- Créé une nouvelle generation, renvoie la population créée
-- Il faut que les especes soit triée avant appel
function nouvelleGeneration(laPopulation, lesEspeces)
	local laNouvellePopulation = newPopulation()
	-- Nombre d'indivu à creer au total
	local nbIndividuACreer = NB_INDIVIDU_POPULATION
	-- Indice qui va servir à savoir OU en est le tab de la nouvelle espece
	local indiceNouvelleEspece = 1

	-- Il est possible que l'ancien meilleur ait un meilleur fitness
	-- Que celui de la nouvelle population (une mauvaise mutation ça arrive très souvent)
	-- Dans ce cas je le supprime par l'ancien meilleur histoire d'être SUR d'avoir des enfants
	-- Toujours du plus bon
	local fitnessMaxPop = 0
	local fitnessMaxAncPop = 0
	local ancienPlusFort = {}
	for i = 1, #laPopulation, 1 do
		if fitnessMaxPop < laPopulation[i].fitness then
			fitnessMaxPop = laPopulation[i].fitness
		end
	end
	-- On test que si il y a deja une ancienne population evidamment
	if #lesAnciennesPopulation > 0 then
		-- Je vais checker TOUTES les anciennes population pour la fitness la plus élevée
		-- Vu que les reseaux vont REmuter, il est possible qu'ils fassent moins bon !
		for i = 1, #lesAnciennesPopulation, 1 do
			for j = 1, #lesAnciennesPopulation[i], 1 do
				if fitnessMaxAncPop < lesAnciennesPopulation[i][j].fitness then
					fitnessMaxAncPop = lesAnciennesPopulation[i][j].fitness
					ancienPlusFort = lesAnciennesPopulation[i][j]
				end
			end
		end
	end

	if fitnessMaxAncPop > fitnessMaxPop then
		-- Comme ça je suis sur uqe le meilleur dominera totalement
		for i = 1, #lesEspeces, 1 do
			for j = 1, #lesEspeces[i].lesReseaux, 1 do
				lesEspeces[i].lesReseaux[j] = copier(ancienPlusFort)
			end
		end
		console.log("Mauvaise population je reprends la meilleur et ça redevient la base de la nouvelle pop")
		console.log(ancienPlusFort)
	end

	table.insert(lesAnciennesPopulation, laPopulation)

	-- Calcul fitness pour chaque espece
	local nbIndividuTotal = 0
	local fitnessMoyenneGlobal = 0 -- Fitness moyenne de TOUS les individus de toutes les especes
	local leMeilleur = newReseau() -- Je dois le remettre avant tout, on va essayer de trouver ou i lest
	for i = 1, #lesEspeces, 1 do
		lesEspeces[i].fitnessMoyenne = 0
		lesEspeces[i].lesReseaux.fitnessMax = 0
		for j = 1, #lesEspeces[i].lesReseaux, 1 do
			lesEspeces[i].fitnessMoyenne = lesEspeces[i].fitnessMoyenne + lesEspeces[i].lesReseaux[j].fitness
			fitnessMoyenneGlobal = fitnessMoyenneGlobal + lesEspeces[i].lesReseaux[j].fitness
			nbIndividuTotal = nbIndividuTotal + 1

			if lesEspeces[i].fitnessMax < lesEspeces[i].lesReseaux[j].fitness then
				lesEspeces[i].fitnessMax = lesEspeces[i].lesReseaux[j].fitness
				if leMeilleur.fitness < lesEspeces[i].lesReseaux[j].fitness then
					leMeilleur = copier(lesEspeces[i].lesReseaux[j])
				end
			end
		end
		lesEspeces[i].fitnessMoyenne = lesEspeces[i].fitnessMoyenne / #lesEspeces[i].lesReseaux
	end

	-- Si le level a été terminé au moins une fois, tous les individus deviennent le meilleur, on ne recherche plus de mutation là
	if leMeilleur.fitness == FITNESS_LEVEL_FINI then
		for i = 1, #lesEspeces, 1 do
			for j = 1, #lesEspeces[i].lesReseaux, 1 do
				lesEspeces[i].lesReseaux[j] = copier(leMeilleur)
			end
		end
		fitnessMoyenneGlobal = leMeilleur.fitness
	else
		fitnessMoyenneGlobal = fitnessMoyenneGlobal / nbIndividuTotal
	end

	-- Tri des especes pour que les meilleurs place leurs enfants avant tout
	table.sort(lesEspeces, function(e1, e2) return e1.fitnessMax > e2.fitnessMax end)

	-- Chaque espece va créer un certain nombre d'individu dans la nouvelle population en fonction de si l'espece a un bon fitness ou pas
	for i = 1, #lesEspeces, 1 do
		local nbIndividuEspece = math.ceil(#lesEspeces[i].lesReseaux * lesEspeces[i].fitnessMoyenne /
			fitnessMoyenneGlobal)
		nbIndividuACreer = nbIndividuACreer - nbIndividuEspece
		if nbIndividuACreer < 0 then
			nbIndividuEspece = nbIndividuEspece + nbIndividuACreer
			nbIndividuACreer = 0
		end
		lesEspeces[i].nbEnfant = nbIndividuEspece

		for j = 1, nbIndividuEspece, 1 do
			if indiceNouvelleEspece > NB_INDIVIDU_POPULATION then
				break
			end

			local unReseau = crossover(choisirParent(lesEspeces[i].lesReseaux), choisirParent(lesEspeces[i].lesReseaux))

			-- On stop la mutation à ce stade
			if fitnessMoyenneGlobal ~= FITNESS_LEVEL_FINI then
				mutation(unReseau)
			end

			unReseau.idEspeceParent = i
			laNouvellePopulation[indiceNouvelleEspece] = copier(unReseau)
			laNouvellePopulation[indiceNouvelleEspece].fitness = 1
			indiceNouvelleEspece = indiceNouvelleEspece + 1
		end
		if indiceNouvelleEspece > NB_INDIVIDU_POPULATION then
			break
		end
	end

	-- Si une espece n'a pas fait d'enfant, je la delete
	for i = 1, #lesEspeces, 1 do
		if lesEspeces[i].nbEnfant == 0 then
			lesEspeces[i] = nil
		end
	end

	return laNouvellePopulation
end

function getNomFichierSauvegarde()
	local str = NOM_FICHIER_POPULATION
	str = string.gsub(str, "idGen", nbGeneration) + "_" + os.date("%Y%m%d%H%M%S")
	return str
end

-- Sauvegarde la population actuelle dans le fichier getNomFichierSauvegarde()
-- Le dernier argument est reservé si le script detect que la population a terminée le niveau
function sauvegarderPopulation(laPopulation, estFini)
	chemin = getNomFichierSauvegarde()
	if estFini then
		chemin = "FINI " .. chemin
	end

	local fichier = io.open(chemin, "w+")
	io.output(fichier)

	-- Sauvegarde classique de la population
	io.write(nbGeneration .. "\n")
	io.write(nbInnovation .. "\n")
	for i = 1, #laPopulation, 1 do
		sauvegarderUnReseau(laPopulation[i], fichier)
	end

	-- Et là je sauvegarde le plus fort, c'est important pour pas perdre les progrés
	local lePlusFort = newReseau()
	for i = 1, #laPopulation, 1 do
		if lePlusFort.fitness < laPopulation[i].fitness then
			lePlusFort = copier(laPopulation[i])
		end
	end
	-- Check aussi dans l'ancienne population (si plus fort, il ne peut etre que là)
	if #lesAnciennesPopulation > 0 then
		for i = 1, #lesAnciennesPopulation, 1 do
			for j = 1, #lesAnciennesPopulation[i], 1 do
				if lePlusFort.fitness < lesAnciennesPopulation[i][j].fitness then
					lePlusFort = copier(lesAnciennesPopulation[i][j])
				end
			end
		end
	end
	sauvegarderUnReseau(lePlusFort, fichier)
	io.close(fichier)

	console.log("sauvegarde terminee au fichier " .. chemin)
end

-- Charge la population sauvegardé
-- Renvoie la nouvelle population ou nil si le chemin n'est pas celui d'un fichier pop
function chargerPopulation(chemin)
	-- Petit test pour voir si le fichier est ok
	local test = string.find(chemin, ".pop")
	local laPopulation = nil
	if test == nil then
		console.log("le fichier " .. chemin .. " n'est pas du bon format (.pop) je vais te monter en l'air ")
	else
		laPopulation = {}
		local fichier = io.open(chemin, "r")

		io.input(fichier)

		local totalNeurone = 0
		local totalConnexion = 0

		nbGeneration = io.read("*number")
		nbInnovation = io.read("*number")
		for i = 1, NB_INDIVIDU_POPULATION, 1 do
			table.insert(laPopulation, chargerUnReseau(fichier))
			laPopulation[i].fitness = 1
		end

		lesAnciennesPopulation = {} -- obligé !
		-- En mettant le plus fort ici, i lsera forcement lu dans nouvelleGeneration
		table.insert(lesAnciennesPopulation, copier(laPopulation))
		lesAnciennesPopulation[1][1] = chargerUnReseau(fichier)

		console.log("plus fort charge")
		console.log(lesAnciennesPopulation[1][1])
		-- Si le plus fort a fini le niveau, tous les individus de la population deviennent le plus fort
		if lesAnciennesPopulation[1][1].fitness == FITNESS_LEVEL_FINI then
			for i = 1, NB_INDIVIDU_POPULATION, 1 do
				laPopulation[i] = copier(lesAnciennesPopulation[1][1])
			end
		end
		io.close(fichier)
		console.log("chargement termine de " .. chemin)
	end

	return laPopulation
end

-- Sauvegarde un seul reseau
function sauvegarderUnReseau(unReseau, fichier)
	io.write(unReseau.nbNeurone .. "\n")
	io.write(#unReseau.lesConnexions .. "\n")
	io.write(unReseau.fitness .. "\n")
	for i = 1, unReseau.nbNeurone, 1 do
		local indice = NB_INPUT + NB_OUTPUT + i
		-- Pas besoin d'écrire le type, je ne sauvegarde que les hiddens
		-- *non plus la valeur, car c'est reset toutes les frames en fait
		io.write(unReseau.lesNeurones[indice].id .. "\n")
	end
	for i = 1, #unReseau.lesConnexions, 1 do
		-- Obligé car actif est un bool
		local actif = 1
		if unReseau.lesConnexions[i].actif ~= true then
			actif = 0
		end
		io.write(actif .. "\n" ..
			unReseau.lesConnexions[i].entree .. "\n" ..
			unReseau.lesConnexions[i].sortie .. "\n" ..
			unReseau.lesConnexions[i].poids .. "\n" ..
			unReseau.lesConnexions[i].innovation .. "\n")
	end
end

-- Charge un seul reseau
function chargerUnReseau(fichier)
	local unReseau = newReseau()
	local nbNeurone = io.read("*number")
	local nbConnexion = io.read("*number")
	unReseau.fitness = io.read("*number")
	unReseau.nbNeurone = nbNeurone
	unReseau.lesConnexions = {}
	for i = 1, nbNeurone, 1 do
		local neurone = newNeurone()
		neurone.id = io.read("*number")
		neurone.valeur = 0
		neurone.type = "hidden"

		table.insert(unReseau.lesNeurones, neurone)
	end

	for i = 1, nbConnexion, 1 do
		local connexion = newConnexion()

		local actif = io.read("*number")
		connexion.entree = io.read("*number")
		connexion.sortie = io.read("*number")
		connexion.poids = io.read("*number")
		connexion.innovation = io.read("*number")

		if actif == 1 then
			connexion.actif = true
		else
			connexion.actif = false
		end

		table.insert(unReseau.lesConnexions, connexion)
	end

	return unReseau
end

-- Mets à jour un réseau de neurone avec ce qu'il y a a l'écran. A appeler à chaque frame quand on en test un reseau
function majReseau(unReseau, marioBase)
	local mario = getPositionMario()

	-- Niveau fini ?
	if not niveauFini and memory.readbyte(0x0100) == 12 then
		unReseau.fitness = FITNESS_LEVEL_FINI -- comme ça l'espece de cette population va dominer les autres
		niveauFini = true
		-- Sinon augmentation de la fitness classique (quand mario va à gauche)
	elseif marioBase.x < mario.x then
		unReseau.fitness = unReseau.fitness + (mario.x - marioBase.x)
		marioBase.x = mario.x
	end

	-- Mise à jour des inputs
	lesInputs = getLesInputs()
	for i = 1, NB_INPUT, 1 do
		unReseau.lesNeurones[i].valeur = lesInputs[i]
	end
end

-- Renvoie l'indice du tableau lesInputs avec les coordonnées x y, peut être utilisé aussi pour acceder aux inputs du réseau de neurone
function getIndiceLesInputs(x, y)
	return x + ((y - 1) * NB_TILE_W)
end

-- Renvoie les inputs, sont créées en fonction d'où est mario
function getLesInputs()
	local lesInputs = {}
	for i = 1, NB_TILE_W, 1 do
		for j = 1, NB_TILE_H, 1 do
			lesInputs[getIndiceLesInputs(i, j)] = 0
		end
	end

	local lesSprites = getLesSprites()
	for i = 1, #lesSprites, 1 do
		local input = convertirPositionPourInput(getLesSprites()[i])
		if input.x > 0 and input.x < (TAILLE_VUE_W / TAILLE_TILE) + 1 then
			lesInputs[getIndiceLesInputs(input.x, input.y)] = -1
		end
	end

	local lesTiles = getLesTiles()
	for i = 1, NB_TILE_W, 1 do
		for j = 1, NB_TILE_H, 1 do
			local indice = getIndiceLesInputs(i, j)
			if lesTiles[indice] ~= 0 then
				lesInputs[indice] = lesTiles[indice]
			end
		end
	end

	return lesInputs
end

-- Retourne une liste de taille 10 max de la position (x, y) des sprites à l'écran. (sprite = mechant truc)
function getLesSprites()
	local lesSprites = {}
	local j = 1
	for i = 0, NB_SPRITE_MAX, 1 do
		-- Si 14C8+i est > 7 il est dans un etat considéré vivant, et si 0x167A == 0 c'est qu'il fait des dégats à Mario
		if memory.readbyte(0x14C8 + i) > 7 then
			-- Le sprite existe
			lesSprites[j] = {
				x = memory.readbyte(0xE4 + i) + memory.readbyte(0x14E0 + i) * 256,
				y = math.floor(memory.readbyte(0xD8 + i) + memory.readbyte(0x14D4 + i) * 256)
			}
			j = j + 1
		end
	end

	-- Ça c'est les extended sprites, c'est d'autres truc du jeu en gros
	for i = 0, NB_SPRITE_MAX, 1 do
		if memory.readbyte(0x170B + i) ~= 0 then
			lesSprites[j] = {
				x = memory.readbyte(0x171F + i) + memory.readbyte(0x1733 + i) * 256,
				y = math.floor(memory.readbyte(0x1715 + i) + memory.readbyte(0x1729 + i) * 256)
			}
			j = j + 1
		end
	end

	return lesSprites
end

-- Renvoie une table qui a la meme taille que lesInputs. On y accède de la meme façon
function getLesTiles()
	local lesTiles = {}
	local j = 1

	-- Les tiles vont etre affiché autour de mario
	mario = getPositionMario()
	mario.x = mario.x - TAILLE_VUE_W / 2
	mario.y = mario.y - TAILLE_VUE_H / 2

	for i = 1, NB_TILE_W, 1 do
		for j = 1, NB_TILE_H, 1 do
			local xT = math.ceil((mario.x + ((i - 1) * TAILLE_TILE)) / TAILLE_TILE)
			local yT = math.ceil((mario.y + ((j - 1) * TAILLE_TILE)) / TAILLE_TILE)

			if xT > 0 and yT > 0 then
				-- Plus d'info ici pour l'adresse memoire des blocs https://www.smwcentral.net/?p=section&a=details&id=21702
				lesTiles[getIndiceLesInputs(i, j)] = memory.readbyte(
					0x1C800 +
					math.floor(xT / TAILLE_TILE) *
					0x1B0 +
					yT * TAILLE_TILE +
					xT % TAILLE_TILE)
			else
				lesTiles[getIndiceLesInputs(i, j)] = 0
			end
		end
	end

	return lesTiles
end

-- Retourne la position de mario (x, y)
function getPositionMario()
	local mario = {}
	mario.x = memory.read_s16_le(0x94)
	mario.y = memory.read_s16_le(0x96)
	return mario
end

-- Retourne la position de la camera (x, y)
function getPositionCamera()
	local camera = {}
	camera.x = memory.read_s16_le(0x1462)
	camera.y = memory.read_s16_le(0x1464)

	return camera
end

-- Permet de convertir une position pour avoir les arguments x et y du tableau lesInputs
function convertirPositionPourInput(position)
	local mario = getPositionMario()
	local positionT = {}
	mario.x = mario.x - TAILLE_VUE_W / 2
	mario.y = mario.y - TAILLE_VUE_H / 2

	positionT.x = math.floor((position.x - mario.x) / TAILLE_TILE) + 1
	positionT.y = math.floor((position.y - mario.y) / TAILLE_TILE) + 1

	return positionT
end

-- Applique les boutons aux joypad de l'emulateur avec un reseau de neurone
function appliquerLesBoutons(unReseau)
	local lesBoutonsT = {}
	for i = 1, NB_OUTPUT, 1 do
		lesBoutonsT[lesBoutons[i].nom] = sigmoid(unReseau.lesNeurones[NB_INPUT + i].valeur)
	end

	-- C'est pour que droit est la prio sur la gauche
	if lesBoutonsT["P1 Left"] and lesBoutonsT["P1 Right"] then
		lesBoutonsT["P1 Left"] = false
	end
	joypad.set(lesBoutonsT)
end

function traitementPause()
	local lesBoutons = joypad.get(1)
	if lesBoutons["P1 Start"] then
		lesBoutons["P1 Start"] = false
	else
		lesBoutons["P1 Start"] = true
	end
	joypad.set(lesBoutons)
end

-- Dessine les informations actuelles
function dessinerLesInfos(laPopulation, lesEspeces, nbGeneration)
	gui.drawBox(0, 0, 256, 40, "black", "white")

	gui.drawText(0, 4, "Generation " .. nbGeneration .. " Ind:" .. idPopulation .. " Nb Espece " ..
		#lesEspeces .. "\nFitness:" ..
		laPopulation[idPopulation].fitness .. " (max = " .. fitnessMax .. ")", "black")
end

function dessinerUnReseau(unReseau)
	-- Je commence par les inputs
	local lesInputs = getLesInputs()
	local camera = getPositionCamera()
	local lesPositions = {} -- Va retenir toutes les positions des neurones affichées, ça sera plus facile pour les connexions

	for i = 1, NB_TILE_W, 1 do
		for j = 1, NB_TILE_H, 1 do
			local indice = getIndiceLesInputs(i, j)

			-- Le i - 1 et j - 1 c'est juste pour afficher les cases à la position x, y quand ils sont == 0
			local xT = ENCRAGE_X_INPUT + (i - 1) * TAILLE_INPUT
			local yT = ENCRAGE_Y_INPUT + (j - 1) * TAILLE_INPUT


			local couleurFond = "gray"
			if unReseau.lesNeurones[indice].valeur < 0 then
				couleurFond = "black"
			elseif unReseau.lesNeurones[indice].valeur > 0 then
				couleurFond = "white"
			end

			gui.drawRectangle(xT, yT, TAILLE_INPUT, TAILLE_INPUT, "black", couleurFond)

			lesPositions[indice] = {}
			lesPositions[indice].x = xT + TAILLE_INPUT / 2
			lesPositions[indice].y = yT + TAILLE_INPUT / 2
		end
	end

	-- Affichage du MARIO sur la grille, MARIO N'EST PAS UNE INPUT OUI C'EST POUR FAIRE JOLIE
	local mario = convertirPositionPourInput(getPositionMario())

	-- Je respecte la meme regle qu'au dessus
	mario.x = (mario.x - 1) * TAILLE_INPUT + ENCRAGE_X_INPUT
	mario.y = (mario.y - 1) * TAILLE_INPUT + ENCRAGE_Y_INPUT
	-- Mario est 2 fois plus grand que les autres sprites, car sa position est celle qu'il a quand il est grand
	gui.drawRectangle(mario.x, mario.y, TAILLE_INPUT, TAILLE_INPUT * 2, "black", "blue")

	for i = 1, NB_OUTPUT, 1 do
		local xT = ENCRAGE_X_OUTPUT
		local yT = ENCRAGE_Y_OUTPUT + ESPACE_Y_OUTPUT * (i - 1)
		local nomT = string.sub(lesBoutons[i].nom, 4)
		local indice = i + NB_INPUT

		if sigmoid(unReseau.lesNeurones[indice].valeur) then
			gui.drawRectangle(xT, yT, TAILLE_OUTPUT_W, TAILLE_OUTPUT_H, "white", "white")
		else
			gui.drawRectangle(xT, yT, TAILLE_OUTPUT_W, TAILLE_OUTPUT_H, "white", "black")
		end

		xT = xT + TAILLE_OUTPUT_W
		local strValeur = string.format("%.2f", unReseau.lesNeurones[indice].valeur)
		-- C'est pour afficher la valeur de l'input stv
		gui.drawText(xT, yT - 1, nomT -- .. "(" .. strValeur .. ")" --
		, "white", "black", 10)
		lesPositions[indice] = {}
		lesPositions[indice].x = xT - TAILLE_OUTPUT_W / 2
		lesPositions[indice].y = yT + TAILLE_OUTPUT_H / 2
	end

	for i = 1, unReseau.nbNeurone, 1 do
		local xT = ENCRAGE_X_HIDDEN +
			(TAILLE_HIDDEN + 1) * (i - (NB_HIDDEN_PAR_LIGNE * math.floor((i - 1) / NB_HIDDEN_PAR_LIGNE)))
		local yT = ENCRAGE_Y_HIDDEN + (TAILLE_HIDDEN + 1) * (math.floor((i - 1) / NB_HIDDEN_PAR_LIGNE))
		-- Tous les 10 j'affiche le restant des neuroens en dessous

		local indice = i + NB_INPUT + NB_OUTPUT
		gui.drawRectangle(xT, yT, TAILLE_HIDDEN, TAILLE_HIDDEN, "black", "white")

		lesPositions[indice] = {}
		lesPositions[indice].x = xT + TAILLE_HIDDEN / 2
		lesPositions[indice].y = yT + TAILLE_HIDDEN / 2
	end

	-- Affichage des connexions
	for i = 1, #unReseau.lesConnexions, 1 do
		if unReseau.lesConnexions[i].actif then
			local pixel = 0
			local alpha = 255
			local couleur
			if unReseau.lesConnexions[i].poids > 0 then
				pixel = 255
			end

			if not unReseau.lesConnexions[i].allume then
				alpha = 25
			end

			couleur = forms.createcolor(pixel, pixel, pixel, alpha)

			gui.drawLine(lesPositions[unReseau.lesConnexions[i].entree].x,
				lesPositions[unReseau.lesConnexions[i].entree].y,
				lesPositions[unReseau.lesConnexions[i].sortie].x,
				lesPositions[unReseau.lesConnexions[i].sortie].y,
				couleur)
		end
	end
end

event.onexit(function()
	console.log("Fin du script")
	gui.clearGraphics()
	forms.destroy(form)
end)

-- Pas le choix de passer comme ça pour activer la sauvegarde
function activerSauvegarde()
	sauvegarderPopulation(laPopulation, false)
end

-- Pareil pour le chargement
function activerChargement()
	chemin = forms.openfile()
	-- Possible que la fenetre soit fermée donc chemin nil
	if chemin ~= "" then
		local laPopulationT = chargerPopulation(chemin)
		if laPopulationT ~= nil then
			laPopulation = {}
			laPopulation = copier(laPopulationT)
			idPopulation = 1
			lancerNiveau()
		end
	end
end

-- Relance le niveau et reset tout pour le nouvel individu
function lancerNiveau()
	savestate.load(NOM_SAVESTATE)
	marioBase = getPositionMario()
	niveauFini = false
	nbFrameStop = 0
end



--[[
		Maintenant la partie du code qui va être executé au lancement du script
--]]


console.clear()


-- On regarde si c'est bien la bonne ROM
if gameinfo.getromname() ~= NOM_JEU then
	console.log("Mauvaise rom (actuellement " .. gameinfo.getromname() .. "), marche uniquement avec " .. nomJeu)
else
	console.log("Lancement du script")
	math.randomseed(os.time())

	lancerNiveau()

	form = forms.newform(TAILLE_FORM_W, TAILLE_FORM_H, "Informations")
	labelInfo = forms.label(form, "a maj", 0, 0, 350, 220)
	estAccelere = forms.checkbox(form, "Accelerer", 10, 220)
	estAfficheReseau = forms.checkbox(form, "Afficher reseau", 10, 240)
	estAfficheInfo = forms.checkbox(form, "Afficher bandeau", 10, 260)
	forms.button(form, "Pause", traitementPause, 10, 285)
	forms.button(form, "Sauvegarder", activerSauvegarde, 10, 315)
	forms.button(form, "Charger", activerChargement, 100, 315)

	laPopulation = newPopulation()

	for i = 1, #laPopulation, 1 do
		mutation(laPopulation[i])
	end

	for i = 2, #laPopulation, 1 do
		laPopulation[i] = copier(laPopulation[1])
		mutation(laPopulation[i])
	end

	lesEspeces = trierPopulation(laPopulation)
	laPopulation = nouvelleGeneration(laPopulation, lesEspeces)

	-- Boucle principale
	while true do
		-- Ça va permettre de suivre si pendant cette frame il y a du l'evolution
		local fitnessAvant = laPopulation[idPopulation].fitness
		nettoyer = true


		if forms.ischecked(estAccelere) then
			emu.limitframerate(false)
		else
			emu.limitframerate(true)
		end

		if forms.ischecked(estAfficheReseau) then
			dessinerUnReseau(laPopulation[idPopulation])
			nettoyer = false
		end

		if forms.ischecked(estAfficheInfo) then
			dessinerLesInfos(laPopulation, lesEspeces, nbGeneration)
			nettoyer = false
		end



		if nettoyer then
			gui.clearGraphics()
		end


		majReseau(laPopulation[idPopulation], marioBase)
		feedForward(laPopulation[idPopulation])
		appliquerLesBoutons(laPopulation[idPopulation])


		if nbFrame == 0 then
			fitnessInit = laPopulation[idPopulation].fitness
		end

		emu.frameadvance()
		nbFrame = nbFrame + 1


		if fitnessMax < laPopulation[idPopulation].fitness then
			fitnessMax = laPopulation[idPopulation].fitness
		end

		-- Si pas d'évolution ET que le jeu n'est pas en pause, on va voir si on reset ou pas
		if fitnessAvant == laPopulation[idPopulation].fitness and memory.readbyte(0x13D4) == 0 then
			nbFrameStop = nbFrameStop + 1
			local nbFrameReset = NB_FRAME_RESET_BASE
			-- Si il y a eu progrés ET QUE mario n'est pas MORT
			if fitnessInit ~= laPopulation[idPopulation].fitness and memory.readbyte(0x0071) ~= 9 then
				nbFrameReset = NB_FRAME_RESET_PROGRES
			end
			if nbFrameStop > nbFrameReset then
				nbFrameStop = 0
				lancerNiveau()
				idPopulation = idPopulation + 1
				-- Si on en est là, on va refaire une generation
				if idPopulation > #laPopulation then
					-- Je check avant tout si le niveau a pas été terminé
					if not niveauFiniSauvegarde then
						for i = 1, #laPopulation, 1 do
							-- Le niveau a été fini une fois,
							if laPopulation[i].fitness == FITNESS_LEVEL_FINI then
								sauvegarderPopulation(laPopulation, true)
								niveauFiniSauvegarde = true
								console.log("Niveau fini apres " .. nbGeneration .. " generation !")
							end
						end
					end
					idPopulation = 1
					nbGeneration = nbGeneration + 1
					lesEspeces = trierPopulation(laPopulation)
					laPopulation = nouvelleGeneration(laPopulation, lesEspeces)
					nbFrame = 0
					fitnessInit = 0
				end
			end
		else
			nbFrameStop = 0
		end

		-- Mise à jour du label actuel
		local str = "Generation " .. nbGeneration .. " Fitness maximal: " ..
			fitnessMax .. "\nInformations sur l'individu actuel :\n" ..
			"Id: " .. idPopulation .. "/" .. #laPopulation .. " Neurones: " ..
			#laPopulation[idPopulation].lesNeurones .. " Connexions: " ..
			#laPopulation[idPopulation].lesConnexions .. " Enfant de l'espece " ..
			laPopulation[idPopulation].idEspeceParent ..
			"\n\nInfos sur les especes: " ..
			"\nIl y a " .. #lesEspeces .. " espece(s) "
		for i = 1, #lesEspeces, 1 do
			str = str ..
				"\nEspece " ..
				i ..
				" a fait " ..
				lesEspeces[i].nbEnfant .. " enfant(s)" .. " (fitnessmax " .. lesEspeces[i].fitnessMax .. ") "
		end
		forms.settext(labelInfo, str)
	end
end
