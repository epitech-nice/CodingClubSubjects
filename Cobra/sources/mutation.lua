--[[
    EPITECH PROJECT, 2024
    SuperMarioWorldIA
    File description:
    main.lua
--]]

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
                    -- Si on en est là, c'est que la connexion peut se faire, juste à tester si y pas deja une connexion
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
        console.log("impossible de recreer une connexion")
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
            -- il peut être classé
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

    -- oui ça marche
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
            -- si 2 connexions partagent la meme innovation, la connexion du nul peut venir la remplacer
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
        -- Si la somme des fitness cumulés depasse total, on renvoie l'espece qui a fait depasser la limite
        if total >= limite then
            return copier(uneEspece[i])
        end
    end
    console.log("impossible de trouver un parent ?")
    return nil
end
