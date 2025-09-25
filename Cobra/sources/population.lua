--[[
    EPITECH PROJECT, 2024
    SuperMarioWorldIA
    File description:
    population.lua
--]]

-- Créé une population
function newPopulation()
    local population = {}
    for i = 1, NB_INDIVIDU_POPULATION, 1 do
        table.insert(population, newReseau())
    end
    return population
end
