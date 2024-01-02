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
        # Initialize Pygame
        pygame.init()

        self.inLoop, self.inMenu, self.inGame = True, True, False

        self.difficulty = 0
        self.move = 0

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

        self.giftX, self.giftY, self.giftDirection = [], [], []
        self.throwCountdown = 0
        self.fall, self.fallCount = [], []
        self.giftLeft, self.giftRight = [], []

        self.platInclineX = [100, 140, 190, 240, 280, 330, 380, 430, 480, 530, 570, 620, 670, 720]
        self.inclineCount = 0

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

        self.marioLeft = pygame.image.load("./assets/images/mario/mario-left.png")
        self.marioRight = pygame.image.load("./assets/images/mario/mario-right.png")
        self.runLeft = pygame.image.load("./assets/images/mario/run-left.png")
        self.runRight = pygame.image.load("./assets/images/mario/run-right.png")
        self.marioJumpLeft = pygame.image.load("./assets/images/mario/jump-left.png")
        self.marioJumpRight = pygame.image.load("./assets/images/mario/jump-right.png")
        self.marioClimb1 = pygame.image.load("./assets/images/mario/marioClimb1.png")
        self.marioClimb2 = pygame.image.load("./assets/images/mario/marioClimb2.png")
        self.marioImage = self.marioRight

        self.santaHelp = pygame.image.load("./assets/images/santa/santa-help.png")

        self.grinchForward = pygame.image.load("./assets/images/grinch/grinchForward.png")
        self.grinchLeft = pygame.image.load("./assets/images/grinch/grinchLeft.png")
        self.grinchRight = pygame.image.load("./assets/images/grinch/grinchRight.png")
        self.grinchImage = self.grinchForward

        self.giftStack = pygame.image.load("./assets/images/gift/gift-stack.png")
        self.giftDown = pygame.image.load("./assets/images/gift/gift-down.png")

        self.giftSequence = load_images("./assets/images/gift", [f"gift{i}" for i in range(1, 5)])
        self.giftPic = []

        self.walk = pygame.mixer.Sound("./assets/sounds/walking.wav")
        self.jump = pygame.mixer.Sound("./assets/sounds/jump.wav")
        self.intro = pygame.mixer.Sound("./assets/sounds/intro.wav")
        self.death = pygame.mixer.Sound("./assets/sounds/death.wav")
        self.bac = pygame.mixer.music.load("./assets/sounds/background_music.wav")

        self.screen = pygame.display.set_mode((800, 800))
        pygame.display.set_caption('Grinch Kong')

        self.clock = pygame.time.Clock()

        # Main game loop
        self.run()

    def reset(self):
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
        display_sprite(self.screen, self.title, 54, 18)

    def draw_game(self):
        display_sprite(self.screen, self.level, 31, -14)
        display_sprite(self.screen, self.giftStack, 60, 188)
        display_sprite(self.screen, self.grinchImage, 130, 176)
        display_sprite(self.screen, self.marioImage, self.marioX, self.marioY)
        display_sprite(self.screen, self.santaHelp, 335, 133)
        for i in range(0, len(self.giftPic)):
            self.screen.blit(self.giftPic[i], (self.giftX[i], self.giftY[i]))


    def collide(self):
        """
        collide - checks whether or not mario has collided into a gift
        @param: none
        @return: hit(boolean)
        """
        for i in range(0, len(self.giftX)): #goes through all the gifts
            if self.marioX + 20 >= self.giftX[i] and self.marioX <= self.giftX[i] + 26 and self.marioY + 30 >= self.giftY[i] and self.marioY <= self.giftY[i] + 20:
                self.hit = True
        return self.hit


    def ladderCheck(self):
        """
        ladderCheck - checks whether or not there is a ladder at mario's location
        @param: none
        @return: upLadder(boolean), downLadder(boolean), moveSides(boolean)
        """
        global marioY
        upLadder, downLadder, moveSides  = False, False, True
        for i in range(0, len(self.ladderX1)): #goes through all the ladders
            if self.marioX >= self.ladderX1[i] and self.marioX <= self.ladderX2[i] and self.marioY >= self.ladderY1[i] and self.marioY <= self.ladderY2[i]: # if mario is in range of a ladder, he can move up, down, and to the sides
                downLadder = True
                upLadder = True
                moveSides = False
                if self.marioY == self.ladderY1[i]: #if mario is at the top of a ladder, he can't move up further
                    upLadder = False
                    if self.fullLadderUp[i]: #if the ladder isn't broken going up, he can move to the sides when at the top
                        moveSides = True
                if self.marioY == self.ladderY2[i]: #if mario is at the bottom of the ladder, he can't move down further
                    downLadder = False
                    if self.fullLadderDown[i]: #if the ladder isn't broken going down, he can move to the sides when at the bottom
                        moveSides = True
            if upLadder or downLadder: #break out of the loop to stop checking for which ladder mario because the computer has already found it
                break
        return upLadder, downLadder, moveSides


    def incline(self, y, x, direction, objectt):
        """
        incline - moves Mario up so that he can go on an incline when walking/jumping on the platform
        @param: y(int), x(int), direction(str), objectt(str)
        @return: y(int) or move(int)
        """
        global inclineCount
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
        boundaries - checks all of Mario's, the gifts boundaries
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
        if self.jumpLeft or self.jumpRight or self.jumpStill: #if mario is jumping, change x and/or y values accordingly
            #keeps track of how many jumps
            self.jumpCount = self.jumpCount + 1
            #changes y coordinates
            self.marioY = self.marioY + self.addJump
            if self.jumpCount == 7: #when jumpCount is 7, make mario come back down by change the number he goes up/down by
                self.addJump = 7
            if self.jumpCount == 14: #if jumpCount is 14, mario has come back down
                if self.direction == "right": #if mario was facing right, change the image back to him facing right, and change mario's Y value if he had jumpped over some inclines
                    self.marioImage = self.marioRight
                    self.marioY = self.marioY - self.move * self.inclineCount
                else: #else mario was facing left, change the image back to him facing left, and change mario's Y value if he had jumpped over some inclines
                    self.marioImage = self.marioLeft
                    self.marioY = self.marioY + self.move * self.inclineCount
                self.addJump = -7
                self.jumpCount = 0
                self.jumpPoint = 0
                self.inclineCount = 0
                self.jumpLeft, self.jumpRight, self.jumpStill = False, False, False
            if self.marioX != 60 and self.marioX != 710 and (self.marioX != 320 or self.marioY >= 232): #if mario has reached a boundary on the sides, don't add to x values
                #checks how many inclines mario jumped over and whether to move up or down when mario lands
                self.move = self.incline(self.marioY, self.marioX, self.direction, "mario")
                if self.jumpLeft and self.moveLeft: #if mario is jumping left and he can move left, minus 5 to his x coordinates
                    self.marioX = self.marioX - 5
                elif self.jumpRight and self.moveRight: #if mario is jumping right and he can move right, add 5 to his x coorinates
                    self.marioX = self.marioX + 5
            for i in range(0, len(self.giftX)): #goes through all the gifts
                if self.marioX >= self.giftX[i] and self.marioX <= self.giftX[i] + 28 and self.marioY <= self.giftY[i] - 23 and self.marioY >= self.giftY[i] - 65: #checks if mario has jumped over a gift, if so, there is one point will be added if he completes the jump
                    self.jumpPoint = 1

    def gift_manager(self):
        for i in range(0, len(self.giftPic)): #goes through all the gifts
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
                    #checks if the gift needs to incline up/down and changes the value in the function
                    self.giftY[i] = self.incline(self.giftY[i] - 11, self.giftX[i], self.giftDirection[i], "gift")
                    self.giftY[i] = self.giftY[i] + 11
                    #subtracted 11 then added it back so that in the function, the values that the functions checks with the y value can be used for both the gift and mario
                else: #else the gift is in the process of falling
                    #add one to keep track of how long it has fallen
                    self.fallCount[i] = self.fallCount[i] + 1
                    if self.giftLeft[i] == False: #if the gift is falling on the left side, x is being subtracted by 5
                        self.giftX[i] = self.giftX[i] - 5
                    elif self.giftRight[i] == False: #if it's falling from the right x is being added by 5
                        self.giftX[i] = self.giftX[i] + 5
                    #changing y by 7 each time
                    self.giftY[i] = self.giftY[i] + 7
                    if self.fallCount[i] == 8: #if the count has reached 8, stop falling and reset the values for the next time
                        #adjust to make sure it lands on platform right
                        self.giftY[i] = self.giftY[i] + 6
                        #resetting variables
                        self.fallCount[i] = 0
                        self.fall[i] = False
                        self.giftLeft[i], self.giftRight[i] = True, True
                #changes the picture of the gift each time
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
                        #adjust a bit because the gift going down is wider than the other gift images
                        self.giftX[i] = self.giftX[i] - 2
                if self.giftX[i] + 2 == self.giftLadderX[j] and self.giftY[i] == self.giftLadderY2[j]: #if the gift has reached the end of a ladder, reset the variables back
                    self.giftPic[i] = self.giftSequence[0]
                    self.giftX[i] = self.giftX[i] + 2
                    #this makes sure that when it comes down it lands properly on the platform instead of 5 pixels too high, as the gifts move 10 pixels at a time
                    self.giftY[i] = self.giftY[i] + self.giftAdjust[j]

    def game_logic(self):
        self.hit = self.collide()
        #checks if mario has hit a boundary to the left or right of him
        self.moveLeft, self.moveRight = self.boundaries(self.marioX, self.marioY)
        if self.hit == False: #if hit is fallse, mario has not hit a gift and normal game play continues
            #checks if mario is on a ladder and whether he can go up, down or left and right
            self.upLadder, self.downLadder, self.moveSides = self.ladderCheck()
            if self.marioY <= 154: #if mario reaches a y value of less than or equal to 154, he has won the game
                self.grinchClimb = -15
                self.marioX, self.marioY = 150, 720
                self.marioImage = self.marioRight
            self.jump_manager()
            self.gift_manager()
            if self.throwGift == False: #if throwGift is false, get a random number to decide whether or not GRINCH will throw another gift
                #after each level the range will be smaller, meaning a higher chance of throwing gifts
                self.grinchChoice = random.randint(0, 50 - self.difficulty)
                if self.grinchChoice == 0: #if the number is 0, reset variables to throw the gift
                    self.grinchImage = self.grinchLeft
                    self.throwGift = True
                else: #else, don't throw any gifts
                    self.grinchImage = self.grinchForward
                    self.throwGift = False
            if self.throwGift: #if throwGift is true, go through these changes
                #add to give GRINCH some time to get gift
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
        if self.inGame and self.jumpLeft == False and self.jumpRight == False and self.jumpStill == False and self.hit == False:
            keys = pygame.key.get_pressed()
            if keys[pygame.K_LEFT] and self.moveSides and (self.marioX != 320 or self.marioY > 232) and self.moveLeft and self.marioX != 60: #looks for left arrow to be pressed
                #changes mario's y to incline up/go down with the slope
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
                    # if not pygame.mixer.get_busy():
                    pygame.mixer.Sound.stop(self.walk)
                    pygame.mixer.Sound.play(self.jump)
                self.direction = "left"
            elif keys[pygame.K_RIGHT] and self.moveSides and self.moveRight and self.marioX != 710: #looks for right arrow to be pressed
                #changes mario's y to incline up/go down with the slope
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
        # Update game logic
        if self.inMenu:
            pass
        elif self.inGame:
            self.game_logic()

    def draw(self):
        # Clear screen
        self.screen.fill(BLACK)
        if self.inMenu:
            self.draw_menu()
        elif self.inGame:
            self.draw_game()
        pygame.display.update()


if __name__ == "__main__":
    Game()
