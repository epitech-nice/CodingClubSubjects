--[[
    EPITECH PROJECT, 2024
    SuperMarioWorldIA
    File description:
    neurone.lua
--]]

-- Créé un neurone
function newNeurone()
    local neurone = {}
    neurone.valeur = 0
    neurone.id = 0 -- pas init si à 0, doit être == à l'indice du neurone dans lesNeurones du reseau
    neurone.type = ""
    return neurone
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
