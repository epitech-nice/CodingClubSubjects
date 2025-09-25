--[[
    EPITECH PROJECT, 2024
    SuperMarioWorldIA
    File description:
    connexion.lua
--]]

-- Créé une connexion
function newConnexion()
    local connexion = {}
    connexion.entree = 0
    connexion.sortie = 0
    connexion.actif = true
    connexion.poids = 0
    connexion.innovation = 0
    connexion.allume = false -- Pour le graphique
    return connexion
end

-- Ajoute une connexion a un reseau de neurone
function ajouterConnexion(unReseau, entree, sortie, poids)
    -- On vérifie que les neurones de la connexion existent tous bien
    if unReseau.lesNeurones[entree].id == 0 then
        console.log("Connexion entree " .. entree .. " non initialisé ?")
    elseif unReseau.lesNeurones[sortie].id == 0 then
        console.log("Connexion sortie " .. sortie .. " non initialisé ?")
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
