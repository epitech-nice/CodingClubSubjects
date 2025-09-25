--[[
    EPITECH PROJECT, 2024
    SuperMarioWorldIA
    File description:
    generation.lua
--]]

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
        console.log("mauvaise population je reprends la meilleur et ça redevient la base de la nouvelle pop")
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
