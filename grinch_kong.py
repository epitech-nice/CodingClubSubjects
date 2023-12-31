#!/usr/bin/env python3
##
## EPITECH PROJECT, 2023
## GrinchKong
## File description:
## grinch_kong
##

import sys
import pygame
from src.utils import *

#Define Colour Values (R,G,B)
BLACK = (0, 0, 0)
GREEN = (0, 255, 0)
RED = (255, 0, 0)
LIGHTBLUE = (0, 200, 255)
YELLOW = (255, 255, 0)
PURPLE = (170, 0, 225)
colours = [GREEN, RED, LIGHTBLUE, YELLOW, PURPLE]

class Game:
    def __init__(self):
        # Initialize Pygame
        pygame.init()
        self.width, self.height = 800, 800
        self.walk_sound = pygame.mixer.Sound("./assets/sounds/walk.wav")
        self.jump_sound = pygame.mixer.Sound("./assets/sounds/jump.wav")
        self.intro_sound = pygame.mixer.Sound("./assets/sounds/intro.wav")
        self.death_sound = pygame.mixer.Sound("./assets/sounds/death.wav")
        self.music = pygame.mixer.music.load("./assets/sounds/music.wav")
        self.screen = pygame.display.set_mode((self.width, self.height))
        pygame.display.set_caption("Grinch Kong")

        # Load platform images
        self.platforms = load_images("./assets/images/platform", [f"platform{i}" for i in range(7)])

        # Load level image
        self.level = pygame.image.load("level.png")

        # Load blue and white number images
        self.blueNumbers = load_images("./assets/images/score/blue", [f"blue{i}" for i in range(6)])
        self.whiteNumbers = load_images("./assets/images/score/white", [f"white{i}" for i in range(10)])

        # Load barrel images
        self.barrel = load_images("./assets/images/barrel", [f"barrel{i}" for i in range(4)])

        pygame.sprite.Sprite.__init__(self)
        # self.player = pygame.image.load("mario.png")
        self.enemie = pygame.image.load("./assets/images/grinch.png")
        # self.platforms = pygame.image.load("platform.png")
        # self.ladders = pygame.image.load("ladder.png")
        # self.invisiplats = pygame.image.load("invisiplat.png")
        # self.screen.blit(self.player, (0, 0))
        self.screen.blit(self.enemie, (0, 0))
        # self.screen.blit(self.platforms, (0, 0))
        # self.screen.blit(self.ladders, (0, 0))
        # self.screen.blit(self.invisiplats, (0, 0))

        # Main game loop
        self.run()

    def events(self, event):
        # Event handling
        if event.type == pygame.QUIT:
            pygame.quit()
            sys.exit()
        keys = pygame.key.get_pressed()

        #looks for escape to be pressed
        if keys[pygame.K_ESCAPE]:
            #finds highscore and adds score to the dictionary
            highestScore = highScore()

            #reset variables to quit program
            inPlay = False
            replay = False

        #looks for space to be pressed to make pressed True and start the game
        if keys[pygame.K_SPACE]:
            pressed = True
            if not pygame.mixer.get_busy():
                pygame.mixer.Sound.play(intro)

        #must satisfy all these conditions in order for pressing  the left, right, up, down, space(for jumping), and return key to do anything
        if (gameStart and jumpLeft == False and jumpRight == False and jumpStill == False and winLevel == False and hit == False) or gameDone or winGame:      

            #looks for left arrow to be pressed
            if keys[pygame.K_LEFT] and moveSides and (marioX != 320 or marioY > 232) and moveLeft and marioX != 60:
                #changes mario's y to incline up/go down with the slope
                marioY = incline(marioY, marioX, direction, "mario")
                # if mario is already facing left, subtract 5 from marioX
                if direction == "left":
                    marioX = marioX - 5

                #if the images for mario is marioLeft change it to runLeft
                if marioImage == marioLeft:
                    marioImage = runLeft
                    if not pygame.mixer.get_busy():
                        pygame.mixer.Sound.play(walk)


                #else, change it to marioLeft
                else:
                    marioImage = marioLeft

                #if space is pressed while left is also being pressed, jumpLeft is True and change the image 
                if keys[pygame.K_SPACE]:
                    jumpLeft = True
                    marioImage = marioJumpLeft
                    # if not pygame.mixer.get_busy():
                    pygame.mixer.Sound.stop(walk)
                    pygame.mixer.Sound.play(jump)

                direction = "left"
            #looks for right arrow to be pressed
            elif keys[pygame.K_RIGHT] and moveSides and moveRight and marioX != 710:
                #changes mario's y to incline up/go down with the slope
                marioY = incline(marioY, marioX, direction, "mario")

                #if mario was already facing right, add 5 to the x value
                if direction == "right":
                    marioX = marioX + 5
                #if the images for mario is marioRight change it to runRight
                if marioImage == marioRight:
                    marioImage = runRight
                    if not pygame.mixer.get_busy():
                        pygame.mixer.Sound.play(walk)
                #else change it to marioRight
                else:
                    marioImage = marioRight

                #if space is pressed while right is also being pressed, jumpRight is True and change the image
                if keys[pygame.K_SPACE]:
                    jumpRight = True
                    marioImage = marioJumpRight

                direction = "right"

            #looks for up arrow to be pressed
            elif not keys[pygame.K_LEFT] or not keys[pygame.K_RIGHT]:
                pygame.mixer.Sound.stop(walk)
            if keys[pygame.K_UP] and (upLadder or gameDone or winGame):
                # if upLadder is true, move mario up 5 pixels
                if upLadder:
                    marioY = marioY - 5

                    #if marioImage is marioClimb1, change it to marioClimb2
                    if marioImage == marioClimb1:
                        marioImage = marioClimb2
                    #otherwise, change it to marioClimb1
                    else:
                        marioImage = marioClimb1

                #if the user is on one of the menus, change the option to select the top one
                if gameDone or winGame:
                    option = "top"

            #looks for down arrow to be pressed and only excutes when you can go down a ladder, and to sele
            if keys[pygame.K_DOWN] and (downLadder or gameDone or winGame):
                #if downLadder is true, change mario's y coordinates to go down
                if downLadder:
                    marioY = marioY + 5

                    #if marioImage is marioClimb1, change it to marioClimb2
                    if marioImage == marioClimb1:
                        marioImage = marioClimb2
                    #otherwise, change it to marioClimb1
                    else:
                        marioImage = marioClimb1

                #if user is on one of the menus, change the option to select the bottom one
                if gameDone or winGame:
                    option = "bottom"

            #looks for space bar to be pressed and can only do something when mario already jumping left or right and you're not in the middle of a ladder
            if keys[pygame.K_SPACE] and jumpLeft == False and jumpRight == False and moveSides:
                #it makes jumpStil true
                jumpStill = True

                #if you are facing left, blit the image of mario jumping, facing right
                if direction == "right":
                    marioImage = marioJumpRight

                #else blit mario jumping and facing left
                else:
                    marioImage = marioJumpLeft

            #looks for return to be pressed and it can only do something when the game is lost or won
            if keys[pygame.K_RETURN] and (gameDone or winGame):
                #if the top option is selected, reset the game
                if option == "top":

                    #reset variables to restart
                    inPlay = False
                    winLevel = False
                    pressed = False
                    climbDone = False
                    introDone = False
                    gameStart = False
                    startDone = False
                    gameDone = False
                    throwBarrel = False
                    jumpLeft = False
                    jumpRight = False
                    jumpStill = False
                    winGame = False
                    winLevel = False
                    deathScene = False
                    scoreWin = False
                    winGameSceneDone = False
                    score = 0
                    levelNum = 0
                    dkClimb = 0
                    climbCount = 15
                    platNum = 0
                    dkJumpX = 378
                    dkJumpY = 172
                    dkJumpYNum = 0
                    marioX = 150
                    marioY = 720
                    addJump = -7
                    marioJumpCount = 0
                    lives = 2
                    difficulty = 0
                    barrelX = []
                    barrelY = []
                    barrelPic = []
                    throwCountdown = 0
                    barrelDirection = []
                    fall = []
                    fallCount = []
                    barrelLeft = []
                    barrelRight = []

                #if the bottom option is selected, you will quit the game
                elif option == "bottom":
                    #reset variables
                    inPlay = False
                    replay = False


    def run(self):
        while True:
            self.screen.fill((0, 0, 0))
            # Event handling
            for event in pygame.event.get():
                self.events(event)

            # Update game state
            self.update()




            # Draw everything
            self.draw()

            # Update display
            pygame.display.flip()

    def update(self):
        # Update game logic
        pass

    def draw(self):
        # Clear screen
        self.screen.fill((0, 0, 0))

        # Draw game objects
        self.screen.blit(self.enemie, (0, 0))


if __name__ == "__main__":
    Game()
