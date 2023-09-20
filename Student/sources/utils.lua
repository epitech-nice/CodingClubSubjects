--[[
    EPITECH PROJECT, 2024
    SuperMarioWorldIA
    File description:
    utils.lua
--]]

-- Copie quelque chose et le renvoie
function copier(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[copier(orig_key)] = copier(orig_value)
        end
        setmetatable(copy, copier(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function getNomFichierSauvegarde()
    -- Créé le nom du fichier de sauvegarde
    -- Le nom du fichier est de la forme "pop_idGen.pop"
    -- Renvoie le nom du fichier
end


-- Sauvegarde la population actuelle dans le fichier getNomFichierSauvegarde()
-- Le dernier argument est reservé si le script detect que la population a terminée le niveau
function sauvegarderPopulation(laPopulation, estFini)
    chemin = getNomFichierSauvegarde()
    if estFini then
        chemin = "FINI " .. chemin
    end

    local fichier = io.open("./IAGen/" .. chemin, "w+")
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

    console.log("Sauvegarde terminee au fichier " .. chemin)
end



-- Charge la population sauvegardé
-- Renvoie la nouvelle population ou nil si le chemin n'est pas celui d'un fichier pop
function chargerPopulation(chemin)
    -- Petit test pour voir si le fichier est ok
    local test = string.find(chemin, ".pop")
    local laPopulation = nil
    if test == nil then
        console.log("Le fichier " .. chemin .. " n'est pas du bon format (.pop)")
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
        -- en mettant le plus fort ici, i lsera forcement lu dans nouvelleGeneration
        table.insert(lesAnciennesPopulation, copier(laPopulation))
        lesAnciennesPopulation[1][1] = chargerUnReseau(fichier)

        console.log("Plus fort charge")
        console.log(lesAnciennesPopulation[1][1])
        -- si le plus fort a fini le niveau, tous les individus de la population deviennent le plus fort
        if lesAnciennesPopulation[1][1].fitness == FITNESS_LEVEL_FINI then
            for i = 1, NB_INDIVIDU_POPULATION, 1 do
                laPopulation[i] = copier(lesAnciennesPopulation[1][1])
            end
        end
        io.close(fichier)
        console.log("Chargement termine de " .. chemin)
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
        -- obligé car actif est un bool
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
    -- On reset le niveau
    -- On reset le savestate
    -- On reset le marioBase
    -- On reset le niveauFini
    -- On reset le nbFrameStop
end
