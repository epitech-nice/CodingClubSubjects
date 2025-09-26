#!/usr/bin/env python3
##
## EPITECH PROJECT, 2023
## GrinchKong
## File description:
## grinch_kong
##

import sys
import random
import pygame
from src.utils import *

BLACK = (0, 0, 0)

class Game:
    def __init__(self):
        """
        The above code is initializing the Pygame library and setting up
        various variables and images for the game "Grinch Kong". It also loads
        sound effects and sets the display caption. Finally, it starts the main
        game loop.
        @param: none
        @return: none
        """
        # Initialize Pygame
        pygame.init()
        self.inLoop, self.inMenu, self.inGame = True, True, False

        self.move = 0
        self.difficulty = 0

        self.hit = False
        self.pressed = False
        self.throwGift = False
        self.jumpLeft, self.jumpRight, self.jumpStill = False, False, False

        self.upLadder = False
        self.downLadder = False
        self.moveSides, self.moveLeft, self.moveRight = True, True, True

        self.direction = "right"

        self.grinchClimb = 510
        self.grinchJumpX, self.grinchJumpY = 126, 172

        self.addJump = -7
        self.marioX, self.marioY = 150, 720
        self.jumpCount, self.jumpPoint = 0, 0

        self.throwCountdown = 0
        self.fall, self.fallCount = [], []
        self.giftLeft, self.giftRight = [], []
        self.giftX, self.giftY, self.giftDirection = [], [], []

        self.inclineCount = 0
        self.platInclineX = [100, 140, 190, 240, 280, 330, 380, 430, 480, 530, 570, 620, 670, 720]

        self.ladderX1 = [295, 605, 295, 345, 345, 150, 245, 385, 600, 600, 245, 150, 265, 265, 315, 555, 555, 600, 440, 320]
        self.ladderX2 = [305, 610, 310, 350, 350, 160, 255, 400, 610, 610, 255, 160, 280, 280, 325, 565, 565, 610, 450, 335]
        self.ladderY1 = [710, 635, 617, 610, 526, 538, 522, 423, 506, 435, 414, 338, 409, 332, 309, 314, 417, 241, 154, 232]
        self.ladderY2 = [720, 705, 657, 620, 571, 608, 532, 523, 511, 475, 464, 408, 414, 382, 329, 369, 432, 311, 232, 272]
        self.fullLadderUp = [False, True, True, False, True, True, False, True, False, True, True, True, False, True, False, True, False, True, True, True]
        self.fullLadderDown = [True, True, False, True, False, True, True, True, True, False, False, True, True, False, True, False, True, True, True, False]

        self.leftBoundariesY, self.rightBoundariesY = [541, 341], [638, 438, 244]

        self.giftLadderX = [320, 610, 560, 280, 160, 250, 400, 610, 350, 160, 300, 610]
        self.giftLadderY1 = [243, 252, 326, 270, 350, 428, 437, 449, 535, 547, 627, 645]
        self.giftLadderY2 = [343, 322, 446, 344, 420, 538, 527, 519, 625, 617, 727, 715]
        self.giftAdjust = [-2, 1, -1, 4, 2, 3, 5, 1, 5, 1, 4, 1]

        self.title = pygame.image.load("./assets/images/screen/title-screen.png")
        self.level = pygame.image.load("./assets/images/platform/level.png")

        self.runLeft = pygame.image.load("./assets/images/mario/run-left.png")
        self.runRight = pygame.image.load("./assets/images/mario/run-right.png")
        self.marioLeft = pygame.image.load("./assets/images/mario/mario-left.png")
        self.marioRight = pygame.image.load("./assets/images/mario/mario-right.png")
        self.marioClimb1 = pygame.image.load("./assets/images/mario/marioClimb1.png")
        self.marioClimb2 = pygame.image.load("./assets/images/mario/marioClimb2.png")
        self.marioJumpLeft = pygame.image.load("./assets/images/mario/jump-left.png")
        self.marioJumpRight = pygame.image.load("./assets/images/mario/jump-right.png")
        self.marioImage = self.marioRight

        self.santaHelp = pygame.image.load("./assets/images/santa/santa-help.png")

        self.grinchLeft = pygame.image.load("./assets/images/grinch/grinchLeft.png")
        self.grinchRight = pygame.image.load("./assets/images/grinch/grinchRight.png")
        self.grinchForward = pygame.image.load("./assets/images/grinch/grinchForward.png")
        self.grinchImage = self.grinchForward

        self.giftDown = pygame.image.load("./assets/images/gift/gift-down.png")
        self.giftStack = pygame.image.load("./assets/images/gift/gift-stack.png")

        self.giftSequence = load_images("./assets/images/gift", [f"gift{i}" for i in range(1, 5)])
        self.giftPic = []

        self.jump = pygame.mixer.Sound("./assets/sounds/jump.wav")
        self.intro = pygame.mixer.Sound("./assets/sounds/intro.wav")
        self.death = pygame.mixer.Sound("./assets/sounds/death.wav")
        self.walk = pygame.mixer.Sound("./assets/sounds/walking.wav")
        self.bac = pygame.mixer.music.load("./assets/sounds/background_music.wav")

        self.screen = pygame.display.set_mode((800, 800))
        pygame.display.set_caption('Grinch Kong')

        self.clock = pygame.time.Clock()

        # Main game loop
        self.run()

    def reset(self):
        """
        The above code is defining and initializing several variables for a
        game. These variables are used to keep track of various states and
        positions in the game, such as whether the player has hit an object,
        whether the player is currently throwing a gift, whether the game is in
        the menu or in gameplay, whether the player is jumping left, right, or
        still, and various other variables related to the player's position and
        movement. The code also assigns initial values to some of these
        variables, such as the starting position of the player character and
        the direction the character is facing.
        @param: none
        @return: none
        """
        self.hit = False
        self.throwGift = False
        self.inMenu, self.inGame = True, False
        self.jumpLeft, self.jumpRight, self.jumpStill = False, False, False
        self.fall, self.fallCount = [], []
        self.giftLeft, self.giftRight = [], []
        self.giftX, self.giftY, self.giftPic, self.giftDirection = [], [], [], []
        self.addJump = -7
        self.jumpPoint = 0
        self.jumpCount = 0
        self.grinchClimb = 0
        self.inclineCount = 0
        self.throwCountdown = 0
        self.marioX, self.marioY = 150, 720
        self.grinchJumpX, self.grinchJumpY = 378, 172
        self.direction = "right"
        self.marioImage = self.marioRight

    def draw_menu(self):
        """
        The above code is calling a function named `display_sprite` and passing
        in the arguments `self.screen`, `self.title`, `54`, and `18`.
        @param: none
        @return: none
        """
        display_sprite(self.screen, self.title, 54, 18)

    def draw_game(self):
        """
        The above code is displaying various sprites on the screen. It calls
        the `display_sprite` function multiple times to display different
        sprites at different positions on the screen. It also uses a for loop
        to display multiple gift sprites at different positions.
        @param: none
        @return: none
        """
        display_sprite(self.screen, self.level, 31, -14)
        display_sprite(self.screen, self.giftStack, 60, 188)
        display_sprite(self.screen, self.grinchImage, 130, 176)
        display_sprite(self.screen, self.marioImage, self.marioX, self.marioY)
        display_sprite(self.screen, self.santaHelp, 335, 133)
        for i in range(0, len(self.giftPic)):
            self.screen.blit(self.giftPic[i], (self.giftX[i], self.giftY[i]))

    def collide(self):
        """
        The above code is checking if the position of the character (marioX,
        marioY) overlaps with any of the gift positions (giftX[i], giftY[i]).
        If there is an overlap, the variable "hit" is set to True. The code
        then returns the value of "hit".
        @param: none
        @return: hit(boolean)
        """
        for i in range(0, len(self.giftX)):
            if self.marioX + 20 >= self.giftX[i] and self.marioX <= self.giftX[i] + 26 and self.marioY + 30 >= self.giftY[i] and self.marioY <= self.giftY[i] + 20:
                self.hit = True
        return self.hit

    def ladderCheck(self):
        """
        The above code is checking if Mario is in range of a ladder. If Mario
        is on a ladder, he can move up, down, and to the sides. The code checks
        if Mario is at the top or bottom of the ladder and if the ladder is
        broken going up or down. It sets the variables upLadder, downLadder,
        and moveSides accordingly. Finally, it returns the values of these
        variables.
        @param: none
        @return: upLadder(boolean), downLadder(boolean), moveSides(boolean)
        """
        upLadder, downLadder, moveSides  = False, False, True
        # Parcourt toutes les échelles
        # Vérifie si Mario se trouve à portée d'une échelle pour lui permettre de se déplacer vers le haut, le bas et sur les côtés
        # Si Mario est en haut de l'échelle, il ne peut pas monter plus haut
        # Si l'échelle n'est pas cassée en haut, il peut se déplacer sur les côtés en haut de l'échelle
        # Si Mario est en bas de l'échelle, il ne peut pas descendre plus bas
        # Si l'échelle n'est pas cassée en bas, il peut se déplacer sur les côtés en bas de l'échelle
        # Si Mario peut monter ou descendre l'échelle, sortir de la boucle car l'échelle appropriée a été trouvée
        return upLadder, downLadder, moveSides

    def incline(self, y, x, direction, objectt):
        """
        The above code is checking which platform the object is on and then
        determining the range where the object inclines and how much it moves
        vertically when going right on an inclined part. It uses a series of
        if-elif statements to determine the platform based on the object's
        y-coordinate. It then sets the startNum, endNum, and move variables
        based on the platform.
        @param: y(int), x(int), direction(str), objectt(str)
        @return: y(int) or move(int)
        """
        #lines 344 to 371 checks which platform the object is on and then declares the range where the object inclines and how much it moves vertically when going right on a inclined part
        if y <= 720 and y >= 657: #if the object is on the bottom platform
            startNum, endNum, move = 6, len(self.platInclineX) - 1, 3
        elif (y <= 638 and y >= 553) or (y >= 353 and y <= 438): #if object is on the second or fourth platform
            startNum, endNum, move = 0, len(self.platInclineX) - 2, -3
        elif (y <= 541 and y >= 456) or (y <= 341 and y >= 256): #if object is on the thrid or fifth platform
            startNum, endNum, move = 1, len(self.platInclineX) - 1, 3
        elif y <= 245 and y >= 149: #if object is on the top platform
            startNum, endNum, move = 8, len(self.platInclineX) - 2, -3
        else: #if not on a platform (on a ladder)
            startNum, endNum, move = 0, 0, 0
        for i in range(startNum, endNum): #goes through the platIncline list, with a range of different numbers depending on which platform the object is on
            if x == self.platInclineX[i]: #if the object has the same x as one of the x incline spot, the object will incline up or down
                if (self.jumpLeft or self.jumpRight) and objectt == "mario": #if the object is mario and he is jumping left or right, keep track of how many inclines he has passed while jumping
                    self.inclineCount = self.inclineCount + 1
                else: #else find out which direction he is moving
                    if direction == "right": #if it's right, minus move from y
                        y = y - move
                    elif direction == "left": #if its left, add move to y
                        y = y + move
        if (self.jumpLeft or self.jumpRight) and objectt == "mario": #returns move if the function is for mario when jumping
            return move
        else: #else return the new y value
            return y

    def boundaries(self, x, y):
        """
        The above code is checking if Mario has reached a possible boundary to
        the left or right of him. It does this by checking if the x-coordinate
        of Mario's position is within a certain range. If Mario is within the
        range, it then checks if his y-coordinate is within a certain range of
        the corresponding boundary. If both conditions are met, it sets the
        left or right variable to False, indicating that Mario cannot move in
        that direction. The code then returns the values of the left and right
        variables.
        @param: none
        @return: left(boolean), right(boolean)
        """
        left, right = True, True
        if x <= 105 and x >= 96: #if x is in that range, mario has reached a possible boundary to the left of him
            for i in range(0, len(self.leftBoundariesY)): #goes through the y coordinate of the left boundaries
                if y <= self.leftBoundariesY[i] and y >= self.leftBoundariesY[i] - 49: #if mario is in that range of the y boundary too, left is False and mario can't move left
                    left = False
        elif x >= 660 and x <= 669: #if x is in that range, mario has reached a possible boundary to the right of him
            for i in range(0, len(self.rightBoundariesY)): #goes through the y coordinate of the right boundaries
                if y <= self.rightBoundariesY[i] and y >= self.rightBoundariesY[i] - 49: #if mario is in that range of the y boundary too, right is False and mario can't move right
                    right = False
        return left, right

    def jump_manager(self):
        """
        The above code is part of a larger code that controls the movement and
        actions of a character named Mario in a game. This specific portion of
        the code is responsible for handling Mario's jumping behavior.
        @param: none
        @return: none
        """
        self.jumpLeft, self.jumpRight, self.jumpStill = False, False, False # A Enlever après avoir complété le code
        if self.jumpLeft or self.jumpRight or self.jumpStill: #if mario is jumping, change x and/or y values accordingly
            self.jumpCount = self.jumpCount + 1
            # Augmenter la position Y de Mario de la quantité de saut. (7)
            # Vérifier si Mario a atteint le sommet de son saut. (14)
            # Changer la quantité de saut pour commencer à descendre.
            # Vérifier si Mario a terminé son saut.
            # Vérifier la direction de Mario et mettre à jour son image et sa position en conséquence.
            # Définir l'image de Mario comme lui faisant face à droite.
            # Ajuster la position Y de Mario en fonction des inclinaisons qu'il a sautées.
            # Définir l'image de Mario comme lui faisant face à gauche.
            # Ajuster la position Y de Mario en fonction des inclinaisons qu'il a sautées.
            # Réinitialiser les variables de saut.

            # Vérifie si Mario a atteint une limite sur les côtés pour ne pas modifier ses coordonnées X
            # Calcule le mouvement en fonction de la position et de la direction de Mario
            # Si Mario saute vers la gauche et peut se déplacer vers la gauche, diminue ses coordonnées X (5)
            # Si Mario saute vers la droite et peut se déplacer vers la droite, augmente ses coordonnées X (5)
            # Parcourt tous les cadeaux
            # Vérifie si Mario a sauté par-dessus un cadeau, ajoute un point s'il complète le saut

    def gift_manager(self):
        """
        The above code is a part of a larger program and it is responsible for
        controlling the movement and behavior of multiple gift objects.
        @param: none
        @return: none
        """
        for i in range(0, len(self.giftPic)):
            if self.giftX[i] <= 31: #if the gift reaches the end of the structure, make the gift disappear off the screen
                self.giftX[i], self.giftY[i] = -30, -30
            if self.fall[i] == False: #if the gift is not falling, check to see if it is
                self.giftLeft[i], self.giftRight[i] = self.boundaries(self.giftX[i], self.giftY[i] - 15)
                if self.giftLeft[i] == False or self.giftRight[i] == False: #reset variable if the gift has hit a platform and can't move either left or right
                    self.fall[i] = True
            if (self.giftY[i] <= 255 and self.giftY[i] >= 243) or (self.giftY[i] <= 452 and self.giftY[i] >= 415) or (self.giftY[i] <= 648 and self.giftY[i] >= 611): #checks which platform the gift is on to determine which direction it's going
                self.giftDirection[i] = "right"
            elif (self.giftY[i] <= 353 and self.giftY[i] >= 317) or (self.giftY[i] <= 550 and self.giftY[i] >= 513) or (self.giftY[i] <= 731 and self.giftY[i] >= 709):
                self.giftDirection[i] = "left"
            if self.giftPic[i] != self.giftDown: #if the gift is not on a ladder it is either rolling or falling
                if self.fall[i] == False: #if the gift is not falling, it is rolling left or right
                    if self.giftDirection[i] == "right":
                        self.giftX[i] = self.giftX[i] + 10
                    else:
                        self.giftX[i] = self.giftX[i] - 10
                    self.giftY[i] = self.incline(self.giftY[i] - 11, self.giftX[i], self.giftDirection[i], "gift")
                    self.giftY[i] = self.giftY[i] + 11
                else: #else the gift is in the process of falling
                    self.fallCount[i] = self.fallCount[i] + 1
                    if self.giftLeft[i] == False: #if the gift is falling on the left side, x is being subtracted by 5
                        self.giftX[i] = self.giftX[i] - 5
                    elif self.giftRight[i] == False: #if it's falling from the right x is being added by 5
                        self.giftX[i] = self.giftX[i] + 5
                    self.giftY[i] = self.giftY[i] + 7
                    if self.fallCount[i] == 8: #if the count has reached 8, stop falling and reset the values for the next time
                        #adjust to make sure it lands on platform right
                        self.giftY[i] = self.giftY[i] + 6
                        #resetting variables
                        self.fallCount[i] = 0
                        self.fall[i] = False
                        self.giftLeft[i], self.giftRight[i] = True, True
                if self.giftPic[i] == self.giftSequence[3]: #if the giftPic is at index 3, change it to at index 0
                    self.giftPic[i] = self.giftSequence[0]
                else: #else change it to the next number in the list
                    for j in range(0, len(self.giftSequence) - 1):
                        if self.giftPic[i] == self.giftSequence[j]:
                            self.giftPic[i] = self.giftSequence[j + 1]
            else: #if the giftPic[i] is gift down, the gift is going down a ladder and add 10 to the y value each time
                self.giftY[i] = self.giftY[i] + 10
            for j in range(0, len(self.giftLadderX)): #goes through all the ladder coordinates for the gifts
                if self.giftX[i] == self.giftLadderX[j] and self.giftY[i] == self.giftLadderY1[j]: #if the gift's x and y coordinates are same as both giftLadderX[j] and giftLadderY[j], respectively, use a random number to choose whether the gift should go down it or not
                    self.giftChoice = random.randint(0, 1)
                    if self.giftChoice == 0: #if the random number that was picked is 0, the gift image and coordinates will be reset
                        self.giftPic[i] = self.giftDown
                        self.giftX[i] = self.giftX[i] - 2
                if self.giftX[i] + 2 == self.giftLadderX[j] and self.giftY[i] == self.giftLadderY2[j]: #if the gift has reached the end of a ladder, reset the variables back
                    self.giftPic[i] = self.giftSequence[0]
                    self.giftX[i] = self.giftX[i] + 2
                    self.giftY[i] = self.giftY[i] + self.giftAdjust[j]

    def game_logic(self):
        """
        The above code is part of a game and it is responsible for managing the
        gameplay of the character "Mario" and the enemy character "Grinch".
        @param: none
        @return: none
        """
        self.hit = self.collide()
        self.moveLeft, self.moveRight = self.boundaries(self.marioX, self.marioY)
        if self.hit == False: #if hit is fallse, mario has not hit a gift and normal game play continues
            self.upLadder, self.downLadder, self.moveSides = self.ladderCheck()
            if self.marioY <= 154: #if mario reaches a y value of less than or equal to 154, he has won the game
                self.grinchClimb = -15
                self.marioX, self.marioY = 150, 720
                self.marioImage = self.marioRight
            self.jump_manager()
            self.gift_manager()
            if self.throwGift == False: #if throwGift is false, get a random number to decide whether or not GRINCH will throw another gift
                self.grinchChoice = 0  # self.grinchChoice = random.randint(0, 50 - self.difficulty)
                if self.grinchChoice == 0: #if the number is 0, reset variables to throw the gift
                    self.grinchImage = self.grinchLeft
                    self.throwGift = True
                else: #else, don't throw any gifts
                    self.grinchImage = self.grinchForward
                    self.throwGift = False
            if self.throwGift: #if throwGift is true, go through these changes
                self.throwCountdown = self.throwCountdown + 1
                if self.throwCountdown == 20: #if throwCountdown is 20, create a new gift
                    self.grinchImage = self.grinchRight
                    self.giftX.append(250)
                    self.giftY.append(243)
                    self.giftDirection.append("right")
                    self.giftPic.append(self.giftSequence[0])
                    self.fall.append(False)
                    self.fallCount.append(0)
                    self.giftLeft.append(True)
                    self.giftRight.append(True)
                if self.throwCountdown == 40: #if throwCountdown reaches 40, reset variables to when GRINCH wasn't throwing
                    self.throwCountdown = 0
                    self.grinchImage = self.grinchForward
                    self.throwGift = False
        else: #else, mario gets hit, start the death sequences
            if not pygame.mixer.get_busy():
                pygame.mixer.Sound.play(self.death)
            self.reset()

    def mouvements(self):
        """
        The above code is handling keyboard inputs for controlling the movement
        of a character named "mario" in a game. It checks for various key
        presses and updates the position and image of the character
        accordingly.
        @param: none
        @return: none
        """
        if self.inGame and self.jumpLeft == False and self.jumpRight == False and self.jumpStill == False and self.hit == False:
            keys = pygame.key.get_pressed()
            if keys[pygame.K_LEFT] and self.moveSides and (self.marioX != 320 or self.marioY > 232) and self.moveLeft and self.marioX != 60: #looks for left arrow to be pressed
                self.marioY = self.incline(self.marioY, self.marioX, self.direction, "mario")
                if self.direction == "left":
                    self.marioX = self.marioX - 5
                if self.marioImage == self.marioLeft: #if the images for mario is marioLeft change it to runLeft
                    self.marioImage = self.runLeft
                    if not pygame.mixer.get_busy():
                        pygame.mixer.Sound.play(self.walk)
                else:
                    self.marioImage = self.marioLeft
                if keys[pygame.K_SPACE]: #if space is pressed while left is also being pressed, jumpLeft is True and change the image
                    self.jumpLeft = True
                    self.marioImage = self.marioJumpLeft
                    if not pygame.mixer.get_busy():
                        pygame.mixer.Sound.stop(self.walk)
                        pygame.mixer.Sound.play(self.jump)
                self.direction = "left"
            elif keys[pygame.K_RIGHT] and self.moveSides and self.moveRight and self.marioX != 710: #looks for right arrow to be pressed
                self.marioY = self.incline(self.marioY, self.marioX, self.direction, "mario")
                if self.direction == "right":
                    self.marioX = self.marioX + 5
                if self.marioImage == self.marioRight: #if the images for mario is marioRight change it to runRight
                    self.marioImage = self.runRight
                    if not pygame.mixer.get_busy():
                        pygame.mixer.Sound.play(self.walk)
                else:
                    self.marioImage = self.marioRight
                if keys[pygame.K_SPACE]: #if space is pressed while right is also being pressed, jumpRight is True and change the image
                    self.jumpRight = True
                    self.marioImage = self.marioJumpRight
                self.direction = "right"
            elif not keys[pygame.K_LEFT] or not keys[pygame.K_RIGHT]: #looks for up arrow to be pressed
                pygame.mixer.Sound.stop(self.walk)
            if keys[pygame.K_UP] and self.upLadder:
                if self.upLadder: # if upLadder is true, move mario up 5 pixels
                    self.marioY = self.marioY - 5
                    if self.marioImage == self.marioClimb1: #if marioImage is marioClimb1, change it to marioClimb2
                        self.marioImage = self.marioClimb2
                    else: #otherwise, change it to marioClimb1
                        self.marioImage = self.marioClimb1
            if keys[pygame.K_DOWN] and self.downLadder: #looks for down arrow to be pressed and only excutes when you can go down a ladder, and to sele
                if self.downLadder: #if downLadder is true, change mario's y coordinates to go down
                    self.marioY = self.marioY + 5
                    if self.marioImage == self.marioClimb1: #if marioImage is marioClimb1, change it to marioClimb2
                        self.marioImage = self.marioClimb2
                    else: #otherwise, change it to marioClimb1
                        self.marioImage = self.marioClimb1
            if keys[pygame.K_SPACE] and self.jumpLeft == False and self.jumpRight == False and self.moveSides: #looks for space bar to be pressed and can only do something when mario already jumping left or right and you're not in the middle of a ladder
                self.jumpStill = True
                if self.direction == "right": #if you are facing left, blit the image of mario jumping, facing right
                    self.marioImage = self.marioJumpRight
                else: #else blit mario jumping and facing left
                    self.marioImage = self.marioJumpLeft

    def run(self):
        """
        The above code is a snippet of a Python program using the Pygame
        library. It appears to be a game loop that handles events, updates the
        game state, and draws the game on the screen.
        @param: none
        @return: none
        """
        try:
            pygame.mixer.music.play(-1)
        except:
            pygame.mixer.init()
        while self.inLoop:
            self.screen.fill(BLACK)
            # Event handling
            for event in pygame.event.get():
                if event.type == pygame.QUIT or event.type == pygame.KEYDOWN and event.key == pygame.K_ESCAPE:
                    pygame.quit()
                    sys.exit()
                if event.type == pygame.KEYDOWN and self.inMenu:
                    break
                    if event.key == pygame.K_SPACE:
                        self.inMenu = False
                        self.inGame = True
                        self.intro.stop()
                        pygame.mixer.music.play(-1)
            # Game Mouvements
            self.mouvements()
            self.clock.tick(30)
            # Update game state
            self.update()
            # Draw everything
            self.draw()

    def update(self):
        """
        The above code is checking the current state of the game and calling
        the game_logic() function if the game is in progress (inGame). If the
        game is in the menu (inMenu), it does nothing.
        @param: none
        @return: none
        """
        if self.inMenu:
            # Do nothing
            pass
        elif self.inGame:
            # Update game logic
            self.game_logic()

    def draw(self):
        """
        The above code is a snippet of code written in Python. It is part of a
        larger program that uses the Pygame library to create a graphical user
        interface.
        Clear screen
        @param: none
        @return: none
        """
        self.screen.fill(BLACK)
        if self.inMenu:
            self.draw_menu()
        elif self.inGame:
            self.draw_game()
        pygame.display.update()


if __name__ == "__main__":
    Game()
