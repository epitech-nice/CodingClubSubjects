--[[
    EPITECH PROJECT, 2024
    SuperMarioWorldIA
    File description:
    reseau.lua
--]]

-- Créé un reseau de neurone
function newReseau()
    local reseau = {}
    -- Nombre de neurone 0
	-- Fitness 1
	-- Id de l'espece parent 0
	-- Tableau de neurone vide
	-- Tableau de connexion vide

    -- Pour i allant de 1 a NB_INPUT
        -- Ajoute un neurone au reseau de neurone
    -- Fin pour

    -- Pour i allant de NB_INPUT + 1 a NB_INPUT + NB_OUTPUT
        -- Ajoute un neurone au reseau de neurone
    -- Fin pour

    -- Retourne le reseau
end

-- Mets à jour un réseau de neurone avec ce qu'il y a a l'écran. A appeler à chaque frame quand on en test un reseau
function majReseau(unReseau, marioBase)
    -- Position de mario

    -- Niveau fini ?
    -- Si oui, fitness = FITNESS_LEVEL_FINI
    -- Sinon, fitness = fitness + (mario.x - marioBase.x)
    -- marioBase.x = mario.x

    -- Mise à jour des inputs
    -- Pour i allant de 1 a NB_INPUT
        -- unReseau.lesNeurones[i].valeur = lesInputs[i]
    -- Fin pour
end
