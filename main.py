#!/usr/bin/env python3
##
## EPITECH PROJECT, 2023
## GrinchKong
## File description:
## main
##

import random
import pygame, sys
from src.utils import *
from pygame.locals import *

#Define Colour Values (R,G,B)
BLACK = (0, 0, 0)
GREEN = (0, 255, 0)
RED = (255, 0, 0)
LIGHTBLUE = (0, 200, 255)
YELLOW = (255, 255, 0)
PURPLE = (170, 0, 225)
colours = [GREEN, RED, LIGHTBLUE, YELLOW, PURPLE]

#declaring global variables
leaderboard = {}

levelNum = 0
difficulty = 0

move = 0

replay = True
pressed = False
climbDone, startDone, gameDone = False, False, False
introDone = True
startOutput = False
gameStart = True
throwGift = False
jumpLeft, jumpRight = False, False
jumpStill = False
hit = False
winGame = False
winLevel = False

upLadder = False
downLadder = False
moveSides, moveLeft, moveRight = True, True, True

option = "top"
direction = "right"

platformsX = [55, 55, 51, 60, 56, 56, 56]
platformsY = [9, 10, 8, 9, 11, 9, 9, 11]
platNum = 0

dkClimb = 510
climbCount = 15
platNum = 0
dkJumpX, dkJumpY = 126, 172
dkJumpYNum = 0

marioX, marioY = 150, 720
addJump = -7
jumpCount = 0
jumpPoint = 0
deathCount = 0
lives = 2

giftX = []
giftY = []
throwCountdown = 0
giftDirection = []
fall = []
fallCount = []
giftLeft = []
giftRight = []

platInclineX = [100, 140, 190, 240, 280, 330, 380, 430, 480, 530, 570, 620, 670, 720]
inclineCount = 0

ladderX1 = [295, 605, 295, 345, 345, 150, 245, 385, 600, 600, 245, 150, 265, 265, 315, 555, 555, 600, 440, 320]
ladderX2 = [305, 610, 310, 350, 350, 160, 255, 400, 610, 610, 255, 160, 280, 280, 325, 565, 565, 610, 450, 335]
ladderY1 = [710, 635, 617, 610, 526, 538, 522, 423, 506, 435, 414, 338, 409, 332, 309, 314, 417, 241, 154, 232]
ladderY2 = [720, 705, 657, 620, 571, 608, 532, 523, 511, 475, 464, 408, 414, 382, 329, 369, 432, 311, 232, 272]
fullLadderUp = [False, True, True, False, True, True, False, True, False, True, True, True, False, True, False, True, False, True, True, True]
fullLadderDown = [True, True, False, True, False, True, True, True, True, False, False, True, True, False, True, False, True, True, True, False]

leftBoundariesY, rightBoundariesY = [541, 341], [638, 438, 244]

giftLadderX = [320, 610, 560, 280, 160, 250, 400, 610, 350, 160, 300, 610]
giftLadderY1 = [243, 252, 326, 270, 350, 428, 437, 449, 535, 547, 627, 645]
giftLadderY2 = [343, 322, 446, 344, 420, 538, 527, 519, 625, 617, 727, 715]
giftAdjust = [-2, 1, -1, 4, 2, 3, 5, 1, 5, 1, 4, 1]

#Define Images
title = pygame.image.load("./assets/images/screen/title-screen.png")

selectIcon = pygame.image.load("./assets/images/mario/select-icon.png")
life = pygame.image.load("./assets/images/mario/mario-life.png")

withLadder = pygame.image.load("./assets/images/platform/withLadder.png")

platforms = load_images("./assets/images/platform", [f"platform{i}" for i in range(7)])

level = pygame.image.load("./assets/images/platform/level.png")

marioLeft = pygame.image.load("./assets/images/mario/mario-left.png")
marioRight = pygame.image.load("./assets/images/mario/mario-right.png")
runLeft = pygame.image.load("./assets/images/mario/run-left.png")
runRight = pygame.image.load("./assets/images/mario/run-right.png")
marioJumpLeft = pygame.image.load("./assets/images/mario/jump-left.png")
marioJumpRight = pygame.image.load("./assets/images/mario/jump-right.png")
marioClimb1 = pygame.image.load("./assets/images/mario/marioClimb1.png")
marioClimb2 = pygame.image.load("./assets/images/mario/marioClimb2.png")
dead = pygame.image.load("./assets/images/mario/dead.png")
marioImage = marioRight

paulineHelp = pygame.image.load("./assets/images/pauline/pauline-help.png")
paulineStill = pygame.image.load("./assets/images/pauline/pauline-still.png")

dkForward = pygame.image.load("./assets/images/grinch/dkForward.png")
dkLeft = pygame.image.load("./assets/images/grinch/dkLeft.png")
dkRight = pygame.image.load("./assets/images/grinch/dkRight.png")
dkImage = dkForward

giftStack = pygame.image.load("./assets/images/gift/gift-stack.png")
giftDown = pygame.image.load("./assets/images/gift/gift-down.png")

giftSequence = load_images("./assets/images/gift", [f"gift{i}" for i in range(1, 5)])

giftPic = []

brokenHeart = pygame.image.load("./assets/images/life/broken-heart.png")
fullHeart = pygame.image.load("./assets/images/life/full-heart.png")
clock = pygame.time.Clock()


def reset():
    global winLevel, climbDone, startDone, gameStart, throwGift, jumpLeft, jumpRight, jumpStill, hit, giftX, giftY, giftPic, giftDirection, throwCountdown, fall, fallCount, giftLeft, giftRight, inclineCount, dkClimb, platNum, jumpPoint, climbCount, dkJumpX, dkJumpY, marioX, marioY, dkJumpYNum, addJump, jumpCount, direction, marioImage
    winLevel = False
    climbDone, startDone, gameDone = False, False, False
    gameStart = False
    throwGift = False
    jumpLeft, jumpRight, jumpStill = False, False, False
    hit = False
    giftX, giftY = [], []
    giftPic = []
    giftDirection = []
    throwCountdown = 0
    fall = []
    fallCount = []
    giftLeft, giftRight = [], []
    inclineCount = 0
    dkClimb = 0
    platNum = 0
    jumpPoint = 0
    climbCount = 15
    dkJumpX, dkJumpY = 378, 172
    marioX, marioY = 150, 720
    dkJumpYNum = 0
    addJump = -7
    jumpCount = 0
    direction = "right"
    marioImage = marioRight


def collide():
    """
    collide - checks whether or not mario has collided into a gift
    @param: none
    @return: hit(boolean)
    """
    global hit
    for i in range(0, len(giftX)): #goes through all the gifts
        if marioX + 20 >= giftX[i] and marioX <= giftX[i] + 26 and marioY + 30 >= giftY[i] and marioY <= giftY[i] + 20: #if mario's image touches the gifts image anywhere, hit is True
            hit = True
    return hit


def ladderCheck():
    """
    ladderCheck - checks whether or not there is a ladder at mario's location
    @param: none
    @return: upLadder(boolean), downLadder(boolean), moveSides(boolean)
    """
    global marioY
    #declares variables
    upLadder = False
    downLadder = False
    moveSides = True
    #goes through all the ladders
    for i in range(0, len(ladderX1)):
        if marioX >= ladderX1[i] and marioX <= ladderX2[i] and marioY >= ladderY1[i] and marioY <= ladderY2[i]: # if mario is in range of a ladder, he can move up, down, and to the sides
            downLadder = True
            upLadder = True
            moveSides = False
            if marioY == ladderY1[i]: #if mario is at the top of a ladder, he can't move up further
                upLadder = False
                if fullLadderUp[i]: #if the ladder isn't broken going up, he can move to the sides when at the top
                    moveSides = True
            if marioY == ladderY2[i]: #if mario is at the bottom of the ladder, he can't move down further
                downLadder = False
                if fullLadderDown[i]: #if the ladder isn't broken going down, he can move to the sides when at the bottom
                    moveSides = True
        if upLadder or downLadder: #break out of the loop to stop checking for which ladder mario because the computer has already found it
            break
    return upLadder, downLadder, moveSides


def incline(y, x, direction, objectt):
    """
    incline - moves Mario up so that he can go on an incline when walking/jumping on the platform
    @param: y(int), x(int), direction(str), objectt(str)
    @return: y(int) or move(int)
    """
    global inclineCount
    #lines 344 to 371 checks which platform the object is on and then declares the range where the object inclines and how much it moves vertically when going right on a inclined part
    if y <= 720 and y >= 657: #if the object is on the bottom platform
        startNum = 6
        endNum = len(platInclineX) - 1
        move = 3
    elif (y <= 638 and y >= 553) or (y >= 353 and y <= 438): #if object is on the second or fourth platform
        startNum = 0
        endNum = len(platInclineX) - 2
        move = -3
    elif (y <= 541 and y >= 456) or (y <= 341 and y >= 256): #if object is on the thrid or fifth platform
        startNum = 1
        endNum = len(platInclineX) - 1
        move = 3
    elif y <= 245 and y >= 149: #if object is on the top platform
        startNum = 8
        endNum = len(platInclineX) - 2
        move = -3
    else: #if not on a platform (on a ladder)
        startNum = 0
        endNum = 0
        move = 0
    #goes through the platIncline list, with a range of different numbers depending on which platform the object is on
    for i in range(startNum, endNum):
        if x == platInclineX[i]: #if the object has the same x as one of the x incline spot, the object will incline up or down
            if (jumpLeft or jumpRight) and objectt == "mario": #if the object is mario and he is jumping left or right, keep track of how many inclines he has passed while jumping
                inclineCount = inclineCount + 1
            else: #else find out which direction he is moving
                if direction == "right": #if it's right, minus move from y
                    y = y - move
                elif direction == "left": #if its left, add move to y
                    y = y + move
    if (jumpLeft or jumpRight) and objectt == "mario": #returns move if the function is for mario when jumping
        return move
    else: #else return the new y value
        return y


def boundaries(x, y):
    """
    boundaries - checks all of Mario's, the gifts boundaries
    @param: none
    @return: left(boolean), right(boolean)
    """
    left = True
    right = True

    if x <= 105 and x >= 96: #if x is in that range, mario has reached a possible boundary to the left of him
        #goes through the y coordinate of the left boundaries
        for i in range(0, len(leftBoundariesY)):
            if y <= leftBoundariesY[i] and y >= leftBoundariesY[i] - 49: #if mario is in that range of the y boundary too, left is False and mario can't move left
                left = False
    elif x >= 660 and x <= 669: #if x is in that range, mario has reached a possible boundary to the right of him
        #goes through the y coordinate of the right boundaries
        for i in range(0, len(rightBoundariesY)):
            if y <= rightBoundariesY[i] and y >= rightBoundariesY[i] - 49: #if mario is in that range of the y boundary too, right is False and mario can't move right
                right = False
    return left, right


def introScene():
    """
    introScene - the start scene of the game
    @param: none
    @return: none
    """
    if dkClimb <= 390: #if DK has climbed less than 390 pixels, blit the background with the ladder
        screen.blit(withLadder, (48, 0))
        #images will switch to make it look like DK is moving
    elif dkClimb > 390 and dkClimb <= 580: #if DK has climbed for between 390 and 580 pixels, blit platform0
        screen.blit(platforms[0], (55, 9))
    if climbDone: #if DK is done climbing, blit the falling platforms beams, Pauline and DK jumping
        screen.blit(platforms[platNum], (platformsX[platNum], platformsY[platNum]))
        pauline(paulineStill)
        screen.blit(dkForward, (dkJumpX, dkJumpY))


def background():
    """
    backgroud - outputs the level and gift stack
    @param: none
    @return: none
    """
    screen.blit(level, (31, -14))
    screen.blit(giftStack, (60, 188))


def dk():
    """
    dk - outputs DK onto screen
    @param: none
    @return: none
    """
    screen.blit(dkImage, (130, 176))


def mario():
    """
    mario - outputs Mario onto screen
    @param: none
    @return: none
    """
    screen.blit(marioImage, (marioX, marioY))


def pauline(paulinePic):
    """
    pauline - outputs pauline on to screen
    @param: paulinePic(image)
    @return: none
    """
    screen.blit(paulinePic, (335, 133))


def gift():
    """
    gifts - blit all the gifts onto the screen
    @param: none
    @return: none
    """
    for i in range(0, len(giftPic)):
        screen.blit(giftPic[i], (giftX[i], giftY[i]))


def end(endScreen):
    """
    end - shows end of the game
    @param: endScreen(image)
    @return: none
    """
    screen.blit(endScreen, (0, 30))
    if option == "bottom": #if the bottom option is selected, blit the icon next to the bottom option
        screen.blit(selectIcon, (270, 640))
    else: #else blit it next to the top option
        screen.blit(selectIcon, (270, 575))


def redraw_screen():
    """
    @redraw_screen - function that redraws the screen
    """
    global climbDone, gameStart, gameDone, startDone, startOutput
    screen.fill(BLACK)
    if gameDone != True: #if the game is not done, blit the lives
        if pressed == False: #if pressed is false, the title screen is being blited
            screen.blit(title, (54, 18))
        elif pressed and introDone == False: #if pressed is true and introDone, blit the intro sequence
            #calls drawing fucntions
            introScene()
        elif introDone == True and gameStart == False: #if intro is done and the game hasn't started yet, blit the start screen
            #calls drawing fucntions
            #establishing the start is done by resetting the variables
            startOutput = True
            startDone = True
        elif (gameStart and winLevel == False): #if the game has started and the level is not won or mario has died, blit the normal game play images
            #calls drawing fucntions
            background()
            dk()
            mario()
            pauline(paulineHelp)
            gift()
    pygame.display.update()


def in_game():
    global replay, pressed, introDone, gameStart, throwGift, jumpLeft, jumpRight, jumpStill, hit, winGame, winLevel, startOutput, startDone, gameDone, option, direction, levelNum, difficulty, dkClimb, climbCount, platNum, dkJumpX, dkJumpY, dkJumpYNum, marioX, marioY, addJump, jumpCount, jumpPoint, deathCount, lives, giftX, giftY, giftPic, giftDirection, throwCountdown, fall, fallCount, giftLeft, giftRight, inclineCount
    global upLadder, downLadder, moveSides
    global marioImage, dkImage
    global move
    if winLevel == False: #if winLevel are false, check for collisions
        hit = collide()
    #checks if mario has hit a boundary to the left or right of him
    moveLeft, moveRight = boundaries(marioX, marioY)
    if hit == False: #if hit is fallse, mario has not hit a gift and normal game play continues
        #checks if mario is on a ladder and whether he can go up, down or left and right
        upLadder, downLadder, moveSides = ladderCheck()
        if marioY <= 154: #if mario reaches a y value of less than or equal to 154, he has won the game
            #reset variables
            winLevel = True
            dkClimb = -15
            climbCount = 15
            marioX, marioY = 150, 720
            marioImage = marioRight
        if jumpLeft or jumpRight or jumpStill: #if mario is jumping, change x and/or y values accordingly
            #keeps track of how many jumps
            jumpCount = jumpCount + 1
            #changes y coordinates
            marioY = marioY + addJump
            #when jumpCount is 7, make mario come back down by change the number he goes up/down by
            if jumpCount == 7:
                addJump = 7
            if jumpCount == 14: #if jumpCount is 14, mario has come back down
                if direction == "right": #if mario was facing right, change the image back to him facing right, and change mario's Y value if he had jumpped over some inclines
                    marioImage = marioRight
                    marioY = marioY - move * inclineCount
                else: #else mario was facing left, change the image back to him facing left, and change mario's Y value if he had jumpped over some inclines
                    marioImage = marioLeft
                    marioY = marioY + move * inclineCount
                #reseting variables
                addJump = -7
                jumpCount = 0
                jumpPoint = 0
                inclineCount = 0
                jumpLeft, jumpRight, jumpStill = False, False, False
            if marioX != 60 and marioX != 710 and (marioX != 320 or marioY >= 232): #if mario has reached a boundary on the sides, don't add to x values
                #checks how many inclines mario jumped over and whether to move up or down when mario lands
                move = incline(marioY, marioX, direction, "mario")
                if jumpLeft and moveLeft: #if mario is jumping left and he can move left, minus 5 to his x coordinates
                    marioX = marioX - 5
                elif jumpRight and moveRight: #if mario is jumping right and he can move right, add 5 to his x coorinates
                    marioX = marioX + 5
            for i in range(0, len(giftX)): #goes through all the gifts
                #checks if mario has jumped over a gift, if so, there is one point will be added if he completes the jump
                if marioX >= giftX[i] and marioX <= giftX[i]+28 and marioY <= giftY[i]-23 and marioY >= giftY[i]-65:
                    jumpPoint = 1
        for i in range(0, len(giftPic)): #goes through all the gifts
            if giftX[i] <= 31: #if the gift reaches the end of the structure, make the gift disappear off the screen
                giftX[i], giftY[i] = -30, -30
            if fall[i] == False: #if the gift is not falling, check to see if it is
                giftLeft[i], giftRight[i] = boundaries(giftX[i], giftY[i]-15)
                #reset variable if the gift has hit a platform and can't move either left or right
                if giftLeft[i] == False or giftRight[i] == False:
                    fall[i] = True
            #checks which platform the gift is on to determine which direction it's going
            if (giftY[i] <= 255 and giftY[i] >= 243) or (giftY[i] <= 452 and giftY[i] >= 415) or (giftY[i] <= 648 and giftY[i] >= 611):
                giftDirection[i] = "right"
            elif (giftY[i] <= 353 and giftY[i] >= 317) or (giftY[i] <= 550 and giftY[i] >= 513) or (giftY[i] <= 731 and giftY[i] >= 709):
                giftDirection[i] = "left"
            if giftPic[i] != giftDown: #if the gift is not on a ladder it is either rolling or falling
                if fall[i] == False: #if the gift is not falling, it is rolling left or right
                    if giftDirection[i] == "right":
                        giftX[i] = giftX[i] + 10
                    else:
                        giftX[i] = giftX[i] - 10
                    #checks if the gift needs to incline up/down and changes the value in the function
                    giftY[i] = incline(giftY[i]-11, giftX[i], giftDirection[i], "gift")
                    giftY[i] = giftY[i] + 11
                    #subtracted 11 then added it back so that in the function, the values that the functions checks with the y value can be used for both the gift and mario
                else: #else the gift is in the process of falling
                    #add one to keep track of how long it has fallen
                    fallCount[i] = fallCount[i] + 1
                    if giftLeft[i] == False: #if the gift is falling on the left side, x is being subtracted by 5
                        giftX[i] = giftX[i] - 5
                    elif giftRight[i] == False: #if it's falling from the right x is being added by 5
                        giftX[i] = giftX[i] + 5
                    #changing y by 7 each time
                    giftY[i] = giftY[i] + 7
                    if fallCount[i] == 8: #if the count has reached 8, stop falling and reset the values for the next time
                        #adjust to make sure it lands on platform right
                        giftY[i] = giftY[i] + 6
                        #resetting variables
                        fallCount[i] = 0
                        fall[i] = False
                        giftLeft[i], giftRight[i] = True, True
                #changes the picture of the gift each time
                if giftPic[i] == giftSequence[3]: #if the giftPic is at index 3, change it to at index 0
                    giftPic[i] = giftSequence[0]
                else: #else change it to the next number in the list
                    for j in range(0, len(giftSequence)-1):
                        if giftPic[i] == giftSequence[j]:
                            giftPic[i] = giftSequence[j + 1]
            else: #if the giftPic[i] is gift down, the gift is going down a ladder and add 10 to the y value each time
                giftY[i] = giftY[i] + 10
            #goes through all the ladder coordinates for the gifts
            for j in range(0, len(giftLadderX)):
                #if the gift's x and y coordinates are same as both giftLadderX[j] and giftLadderY[j], respectively, use a random number to choose whether the gift should go down it or not
                if giftX[i] == giftLadderX[j] and giftY[i] == giftLadderY1[j]:
                    giftChoice = random.randint(0, 1)
                    if giftChoice == 0: #if the random number that was picked is 0, the gift image and coordinates will be reset
                        giftPic[i] = giftDown
                        #adjust a bit because the gift going down is wider than the other gift images
                        giftX[i] = giftX[i] - 2
                if giftX[i] + 2 == giftLadderX[j] and giftY[i] == giftLadderY2[j]: #if the gift has reached the end of a ladder, reset the variables back
                    giftPic[i] = giftSequence[0]
                    giftX[i] = giftX[i] + 2
                    #this makes sure that when it comes down it lands properly on the platform instead of 5 pixels too high, as the gifts move 10 pixels at a time
                    giftY[i] = giftY[i] + giftAdjust[j]
        if throwGift == False: #if throwGift is false, get a random number to decide whether or not DK will throw another gift
            #after each level the range will be smaller, meaning a higher chance of throwing gifts
            dkChoice = random.randint(0, 50 - difficulty)
            if dkChoice == 0: #if the number is 0, reset variables to throw the gift
                dkImage = dkLeft
                throwGift = True
            else: #else, don't throw any gifts
                dkImage = dkForward
                throwGift = False
        if throwGift: #if throwGift is true, go through these changes
            #add to give DK some time to get gift
            throwCountdown = throwCountdown + 1
            if throwCountdown == 20: #if throwCountdown is 20, create a new gift
                #reset variable
                dkImage = dkRight
                #declaring new gift information
                giftX.append(250)
                giftY.append(243)
                giftDirection.append("right")
                giftPic.append(giftSequence[0])
                fall.append(False)
                fallCount.append(0)
                giftLeft.append(True)
                giftRight.append(True)
            if throwCountdown == 40: #if throwCountdown reaches 40, reset variables to when DK wasn't throwing
                throwCountdown = 0
                dkImage = dkForward
                throwGift = False
    else: #else, mario gets hit, start the death sequences
        if not pygame.mixer.get_busy():
            pygame.mixer.Sound.play(death)
        reset()


def game_exit(keys):
    global inPlay, replay
    if keys[pygame.K_ESCAPE]: #reset variables to quit program
        inPlay, replay = False, False


def game_events():
    global replay, pressed, introDone, gameStart, throwGift, jumpLeft, jumpRight, jumpStill, hit, winGame, winLevel, startOutput, startDone, gameDone, option, direction, levelNum, difficulty, dkClimb, climbCount, platNum, dkJumpX, dkJumpY, dkJumpYNum, marioX, marioY, addJump, jumpCount, jumpPoint, deathCount, lives, giftX, giftY, giftPic, giftDirection, throwCountdown, fall, fallCount, giftLeft, giftRight, inclineCount
    global upLadder, downLadder, moveSides
    global marioImage, dkImage
    global move, inPlay
    pygame.event.get()
    keys = pygame.key.get_pressed()
    game_exit(keys)
    if keys[pygame.K_SPACE]: #looks for space to be pressed to make pressed True and start the game
        pressed = True
        if not pygame.mixer.get_busy():
            pygame.mixer.Sound.play(intro)
    #must satisfy all these conditions in order for pressing  the left, right, up, down, space(for jumping), and return key to do anything
    if (gameStart and jumpLeft == False and jumpRight == False and jumpStill == False and winLevel == False and hit == False) or gameDone or winGame:
        if keys[pygame.K_LEFT] and moveSides and (marioX != 320 or marioY > 232) and moveLeft and marioX != 60: #looks for left arrow to be pressed
            #changes mario's y to incline up/go down with the slope
            marioY = incline(marioY, marioX, direction, "mario")
            if direction == "left": # if mario is already facing left, subtract 5 from marioX
                marioX = marioX - 5
            if marioImage == marioLeft: #if the images for mario is marioLeft change it to runLeft
                marioImage = runLeft
                if not pygame.mixer.get_busy():
                    pygame.mixer.Sound.play(walk)
            else: #else, change it to marioLeft
                marioImage = marioLeft
            if keys[pygame.K_SPACE]: #if space is pressed while left is also being pressed, jumpLeft is True and change the image
                jumpLeft = True
                marioImage = marioJumpLeft
                # if not pygame.mixer.get_busy():
                pygame.mixer.Sound.stop(walk)
                pygame.mixer.Sound.play(jump)
            direction = "left"
        elif keys[pygame.K_RIGHT] and moveSides and moveRight and marioX != 710: #looks for right arrow to be pressed
            #changes mario's y to incline up/go down with the slope
            marioY = incline(marioY, marioX, direction, "mario")
            if direction == "right": #if mario was already facing right, add 5 to the x value
                marioX = marioX + 5
            if marioImage == marioRight: #if the images for mario is marioRight change it to runRight
                marioImage = runRight
                if not pygame.mixer.get_busy():
                    pygame.mixer.Sound.play(walk)
            else: #else change it to marioRight
                marioImage = marioRight
            if keys[pygame.K_SPACE]: #if space is pressed while right is also being pressed, jumpRight is True and change the image
                jumpRight = True
                marioImage = marioJumpRight
            direction = "right"
        #looks for up arrow to be pressed
        elif not keys[pygame.K_LEFT] or not keys[pygame.K_RIGHT]:
            pygame.mixer.Sound.stop(walk)
        if keys[pygame.K_UP] and (upLadder or gameDone or winGame):
            if upLadder: # if upLadder is true, move mario up 5 pixels
                marioY = marioY - 5
                if marioImage == marioClimb1: #if marioImage is marioClimb1, change it to marioClimb2
                    marioImage = marioClimb2
                else: #otherwise, change it to marioClimb1
                    marioImage = marioClimb1
            if gameDone or winGame: #if the user is on one of the menus, change the option to select the top one
                option = "top"
        #looks for down arrow to be pressed and only excutes when you can go down a ladder, and to sele
        if keys[pygame.K_DOWN] and (downLadder or gameDone or winGame):
            if downLadder: #if downLadder is true, change mario's y coordinates to go down
                marioY = marioY + 5
                if marioImage == marioClimb1: #if marioImage is marioClimb1, change it to marioClimb2
                    marioImage = marioClimb2
                else: #otherwise, change it to marioClimb1
                    marioImage = marioClimb1
            if gameDone or winGame: #if user is on one of the menus, change the option to select the bottom one
                option = "bottom"
        #looks for space bar to be pressed and can only do something when mario already jumping left or right and you're not in the middle of a ladder
        if keys[pygame.K_SPACE] and jumpLeft == False and jumpRight == False and moveSides:
            #it makes jumpStil true
            jumpStill = True
            if direction == "right": #if you are facing left, blit the image of mario jumping, facing right
                marioImage = marioJumpRight
            else: #else blit mario jumping and facing left
                marioImage = marioJumpLeft
        #looks for return to be pressed and it can only do something when the game is lost or won
        if keys[pygame.K_RETURN] and (gameDone or winGame):
            #if the top option is selected, reset the game
            if option == "top":
                #reset variables to restart
                reset()
                inPlay = False
                winLevel = False
                pressed = False
                winGame = False
                levelNum = 0
                climbCount = 15
                dkJumpYNum = 0
                lives = 2
                difficulty = 0
            elif option == "bottom": #if the bottom option is selected, you will quit the game
                inPlay, replay = False, False
    clock.tick(30)


pygame.init()

walk = pygame.mixer.Sound("./assets/sounds/walking.wav")
jump = pygame.mixer.Sound("./assets/sounds/jump.wav")
intro = pygame.mixer.Sound("./assets/sounds/intro.wav")
death = pygame.mixer.Sound("./assets/sounds/death.wav")
bac = pygame.mixer.music.load("./assets/sounds/background_music.wav")
death_cnt = 0

while replay:
    WIDTH, HEIGHT = 800, 800
    screen = pygame.display.set_mode((WIDTH, HEIGHT))
    pygame.display.set_caption('Grinch Kong')
    inPlay = True
    try:
        pygame.mixer.music.play(-1)
    except:
        pygame.mixer.init()
    while inPlay: #keep looping and keeping graphical interface is run while inPlay is true
        if gameStart: #if the gameStart is true, the game play has started
            in_game()
        if winLevel: #if you win the level, start winLevel processes
            reset()
            difficulty = difficulty + 8 #to make the next level more difficult
        game_events()
        pygame.display.update()
        if inPlay:
            redraw_screen() # the screen window must be constantly redrawn - animation
        if startOutput:
            startOutput = False
            gameStart = True
    pygame.quit()
