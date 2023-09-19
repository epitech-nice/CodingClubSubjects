--[[
    EPITECH PROJECT, 2024
    SuperMarioWorldIA
    File description:
    main.lua
--]]

require("sources/constantes")
require("sources/utils")
require("sources/neurone")
require("sources/connexion")
require("sources/espece")
require("sources/population")
require("sources/game")
require("sources/generation")
require("sources/mutation")
require("sources/reseau")

console.clear()
-- Petit check pour voir si c'est bien la bonne ROM
if gameinfo.getromname() ~= NOM_JEU then
    console.log("mauvaise rom (actuellement " .. gameinfo.getromname() .. "), marche uniquement avec " .. nomJeu)
else
    console.log("lancement du script")
    math.randomseed(os.time())

    lancerNiveau()

    form = forms.newform(TAILLE_FORM_W, TAILLE_FORM_H, "Informations")
    labelInfo = forms.label(form, "a maj", 0, 0, 350, 220)
    estAccelere = forms.checkbox(form, "Accelerer", 10, 220)
    estAfficheReseau = forms.checkbox(form, "Afficher reseau", 10, 240)
    estAfficheInfo = forms.checkbox(form, "Afficher bandeau", 10, 260)
    forms.button(form, "Pause", traitementPause, 10, 285)
    forms.button(form, "Sauvegarder", activerSauvegarde, 10, 315)
    forms.button(form, "Charger", activerChargement, 100, 315)

    laPopulation = newPopulation()

    for i = 1, #laPopulation, 1 do
        mutation(laPopulation[i])
    end

    for i = 2, #laPopulation, 1 do
        laPopulation[i] = copier(laPopulation[1])
        mutation(laPopulation[i])
    end

    lesEspeces = trierPopulation(laPopulation)
    laPopulation = nouvelleGeneration(laPopulation, lesEspeces)

    -- Boucle principale
    while true do
        -- Ça va permettre de suivre si pendant cette frame il y a du l'evolution
        local fitnessAvant = laPopulation[idPopulation].fitness
        nettoyer = true


        if forms.ischecked(estAccelere) then
            emu.limitframerate(false)
        else
            emu.limitframerate(true)
        end

        if forms.ischecked(estAfficheReseau) then
            dessinerUnReseau(laPopulation[idPopulation])
            nettoyer = false
        end

        if forms.ischecked(estAfficheInfo) then
            dessinerLesInfos(laPopulation, lesEspeces, nbGeneration)
            nettoyer = false
        end



        if nettoyer then
            gui.clearGraphics()
        end


        majReseau(laPopulation[idPopulation], marioBase)
        feedForward(laPopulation[idPopulation])
        appliquerLesBoutons(laPopulation[idPopulation])


        if nbFrame == 0 then
            fitnessInit = laPopulation[idPopulation].fitness
        end

        emu.frameadvance()
        nbFrame = nbFrame + 1


        if fitnessMax < laPopulation[idPopulation].fitness then
            fitnessMax = laPopulation[idPopulation].fitness
        end

        -- Si pas d'évolution ET que le jeu n'est pas en pause, on va voir si on reset ou pas
        if fitnessAvant == laPopulation[idPopulation].fitness and memory.readbyte(0x13D4) == 0 then
            nbFrameStop = nbFrameStop + 1
            local nbFrameReset = NB_FRAME_RESET_BASE
            -- Si il y a eu progrés ET QUE mario n'est pas MORT
            if fitnessInit ~= laPopulation[idPopulation].fitness and memory.readbyte(0x0071) ~= 9 then
                nbFrameReset = NB_FRAME_RESET_PROGRES
            end
            if nbFrameStop > nbFrameReset then
                nbFrameStop = 0
                lancerNiveau()
                idPopulation = idPopulation + 1
                -- Si on en est là, on va refaire une generation
                if idPopulation > #laPopulation then
                    -- Je check avant tout si le niveau a pas été terminé
                    if not niveauFiniSauvegarde then
                        for i = 1, #laPopulation, 1 do
                            -- Le level a été fini une fois,
                            if laPopulation[i].fitness == FITNESS_LEVEL_FINI then
                                sauvegarderPopulation(laPopulation, true)
                                niveauFiniSauvegarde = true
                                console.log("Niveau fini apres " .. nbGeneration .. " generation !")
                            end
                        end
                    end
                    idPopulation = 1
                    nbGeneration = nbGeneration + 1
                    lesEspeces = trierPopulation(laPopulation)
                    laPopulation = nouvelleGeneration(laPopulation, lesEspeces)
                    nbFrame = 0
                    fitnessInit = 0
                end
            end
        else
            nbFrameStop = 0
        end

        -- Maj du label actuel
        local str = "generation " .. nbGeneration .. " Fitness maximal: " ..
            fitnessMax .. "\nInformations sur l'individu actuel:\n" ..
            "id: " .. idPopulation .. "/" .. #laPopulation .. " neurones: " ..
            #laPopulation[idPopulation].lesNeurones .. " connexions: " ..
            #laPopulation[idPopulation].lesConnexions .. " enfant de l'espece " ..
            laPopulation[idPopulation].idEspeceParent ..
            "\n\nInfos sur les especes: " ..
            "\nIl y a " .. #lesEspeces .. " espece(s) "
        for i = 1, #lesEspeces, 1 do
            str = str ..
            "\nespece " ..
            i ..
            " a fait " .. lesEspeces[i].nbEnfant .. " enfant(s)" .. " (fitnessmax " .. lesEspeces[i].fitnessMax .. ") "
        end
        forms.settext(labelInfo, str)
    end
end

event.onexit(function()
    console.log("Fin du script")
    gui.clearGraphics()
    forms.destroy(form)
end)
