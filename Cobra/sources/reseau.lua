--[[
    EPITECH PROJECT, 2024
    SuperMarioWorldIA
    File description:
    reseau.lua
--]]

-- Créé un reseau de neurone
function newReseau()
    local reseau = {
        nbNeurone = 0,          -- Taille des neurones  rajouté par l'algo (hors input output du coup)
        fitness = 1,            -- Beaucoup de division, pour eviter de faire l irreparable
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
