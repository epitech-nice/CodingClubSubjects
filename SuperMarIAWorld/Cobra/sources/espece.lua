--[[
    EPITECH PROJECT, 2024
    SuperMarioWorldIA
    File description:
    espece.lua
--]]

-- Créé une espece (un regroupement de reseaux, d'individus)
function newEspece()
    local espece = {
        nbEnfant = 0,          -- Combien d'enfant cette espece a créé
        fitnessMoyenne = 0,    -- Fitness moyenne de l'espece
        fitnessMax = 0,        -- Fitness max atteinte par l'espece
        lesReseaux = {}        -- Tableau qui regroupe les reseaux}
    }
    return espece
end
