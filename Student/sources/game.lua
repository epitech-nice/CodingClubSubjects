--[[
    EPITECH PROJECT, 2024
    SuperMarioWorldIA
    File description:
    game.lua
--]]

-- Renvoie l'indice du tableau lesInputs avec les coordonnées x y
-- Fonction utile également pour acceder aux inputs du réseau de neurone
function getIndiceLesInputs(x, y)
    -- Completer
end

-- Renvoie les inputs, sont créées en fonction d'où est mario
function getLesInputs()
    -- Récupère les inputs
    -- Pour i allant de 1 a NB_INPUT
        -- Mettre lesInputs[i] a 0
    -- Fin pour

    -- Récupère les sprites
    -- Pour i allant de 1 a taille de lesSprites
        -- Si lesSprites[i].x > 0 et lesSprites[i].x < (TAILLE_VUE_W / TAILLE_TILE) + 1
            -- lesInputs[getIndiceLesInputs(lesSprites[i].x, lesSprites[i].y)] = -1
        -- Fin si
    -- Fin pour

    -- Récupère les tiles
    -- Pour i allant de 1 a NB_TILE_W
        -- Pour j allant de 1 a NB_TILE_H
            -- Si lesTiles[getIndiceLesInputs(i, j)] ~= 0
                -- lesInputs[getIndiceLesInputs(i, j)] = lesTiles[getIndiceLesInputs(i, j)]
            -- Fin si
        -- Fin pour
    -- Fin pour

    -- Retourne lesInputs
end

-- Retourne une liste de taille 10 max de la position (x, y) des sprites à l'écran. (sprite = mechant truc)
function getLesSprites()
    local lesSprites = {}
    local j = 1
    for i = 0, NB_SPRITE_MAX, 1 do
        -- si 14C8+i est > 7 il est dans un etat considéré vivant, et si 0x167A == 0 c'est qu'il fait des dégats à Mario
        if memory.readbyte(0x14C8 + i) > 7 then
            -- le sprite existe
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
                -- plus d'info ici pour l'adresse memoire des blocs https://www.smwcentral.net/?p=section&a=details&id=21702
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
    -- Position de Mario en X
    -- Position de Mario en Y
    return mario
end

-- Retourne la position de la camera (x, y)
function getPositionCamera()
    local camera = {}
    -- Position de la Camera en X
    -- Position de la Camera en Y
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

    -- c'est pour que droit est la prio sur la gauche
    if lesBoutonsT["P1 Left"] and lesBoutonsT["P1 Right"] then
        lesBoutonsT["P1 Left"] = false
    end
    joypad.set(lesBoutonsT)
end

function traitementPause()
    local lesBoutons = joypad.get(1)
    -- si lesBoutons["P1 Start"] alors
        -- lesBoutons["P1 Start"] = faux
    -- sinon
        -- lesBoutons["P1 Start"] = vrai
    -- fin si
    joypad.set(lesBoutons)
end
