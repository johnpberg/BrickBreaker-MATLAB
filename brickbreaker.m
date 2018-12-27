function brickbreaker(~,~,lives,bx,by,vballx,vbally,difficulty)
% This function operates as the game engine for a
% simple Brick Breaker game. The inputs are:
%-two callback inputs (ignored)
%-lives: the number of lives the player gets
%-bx,by,vballx,vbally: the x and y positions and
%velocities of the ball
%-difficulty:a number between that the wallmaker function uses
%to create the bricks (higer the number, closer the
%bricks are to the paddle)
%These inputs vary based on what difficulty level / button
%the player chose on brickbreakerMenu.
%
%The function creates a figure window for the
%game, and plots and controls the movement of the
%balls, paddles, and controls deletion of the bricks
%until the user wins or loses the game by destroying
%all the bricks, or runs out of lives, at which point the
%brickbreakerGameOver function is called.

%closing all open figure windows (the menu figure
%window)
close all

%Creating a figure window for the game, normalizing
%size according to computer's  screen size, set color
%to navy
gamefig = figure('Units','Normalized','OuterPosition',[.3 .1 .4 .9]);
set(gamefig,'Color',[0.153,0.263,0.808]);

%Preventing the user from resizing the figure, to
%prevent skewing of gameplay
set(gamefig, 'Resize', 'off')

%Hiding the toolbar and title of the figure window
set(gcf,'menubar','none')
set(gcf,'NumberTitle','off');

%Setting the callback functions for pressing and releasing
%a key to 2 nested functions
set(gamefig, 'KeyPressFcn', @paddlePress);
set(gamefig, 'KeyReleaseFcn', @paddleRelease);


%Storing the x and y positions and velocities so they
%can be reset after the user loses a life
bxi = bx;
byi = by;
vballxi = vballx;
vballyi = vbally;

%Creating the axes, plotting the ball as a white dot,
%holding on,setting the axis limits
axes('Position',[.1 .1 .8 .8]);
ballplot = plot(bx,by,'w.','MarkerSize',20);
hold on
axis([0 10 0 10]);
%Preventing the axes from being displayed
axis off

%Creating and plotting the user-controlled paddle
%using the rectangle function, specifying positon, face
%and edge color, line width, and curved corners
paddleplot = rectangle('Position',[4 .75 2 .3], ...
    'FaceColor', [0.949 0.427 0.427], 'EdgeColor', 'w',...
    'LineWidth', 2,'Curvature',[0.2 0.2]);

%Creating a variable for the paddle's position (where
%the left hand side is, only moves parallel to x axis)
px = 4;
%Initializing the paddle's velocity
vpaddle = 0;

%Creating a variable for the timestep for simulating
%motion
dt = .005;

%Calling the wallmaker function with the position of
%the paddle and the input difficulty, obtaining the
%walls matrix and the walls to be plotted, wallstoplot
%(see wallmaker function)
[ walls,wallstoplot ] = wallmaker(px,difficulty);

%Initializing a vector to hold the handles to the plots
%of each line that make up the walls and bricks
brickhandles = [ ];

%plotting the walls to be plotted using the line function
%specifying color and linewidth, using a for loop to plot
%each of the 75 lines one by one to give them each a unique
%handle to enable individual deletion, and storing these
%handles in the brickhandles vector
for ctr = 1:75
    brickhandles(ctr) = line (wallstoplot(ctr,[1 3])',...
        wallstoplot(ctr,[2 4])','Color','w','LineWidth',3);
end

%holding off
hold off

%creating invisible axes to hold the text
axes('Position',[0 0 1 1],'Visible','off');

%Creating text to display the number of lives with
%position, color, and font specifications
livesDisplay = text('position',[0.05 .95],'Color',...
    [0.949 0.427 0.427],'fontsize',14,'FontName',...
    'Courier New','FontWeight','bold','string', ...
    ['Lives: ' num2str(lives)]);

%Creating a variable to count the number of bricks
%smashed
bricksSmashed = 0;

%Creating a variable and setting it to true, will use
%to control execution of while loop
looper = true;

%While looper is true
while looper
    
    %Simulate the ball's movement in 1 timestep by calling
    %the timeStep function, obtaining new x and y
    %position and velocity values, along with a new
    %walls matrix and the brickNum (1 if no
    %collision/collided with paddles or outer walls)
    [ xnew, ynew, vxnew, vynew, wallsnew, brickNum] = ...
        timeStep(walls, bx, by, vballx, vbally,dt);
    
    %Put these values into the old variables so they
    %can be used in the next loop iteration
    bx = xnew;
    by = ynew;
    vballx = vxnew;
    vbally = vynew;
    walls = wallsnew;
    
    
    %if the ball falls below the paddle
    if by < 0.01
        %reduce the number of lives by 1
        lives = lives - 1;
        %reset ball position and velocity
        bx = bxi;
        by = byi;
        vballx = vballxi;
        vbally = vballyi;
    end
    
    %Step the paddle location based on simple dynamics.
    px = px+ vpaddle *dt;
    %Limiting the position so it can't exit the screen
    if px > 8
        px = 8;
    end
    if px < 0
        px = 0;
    end
    
    %updating the position of the paddle in the walls
    %matrix
    walls(4,:) = [px, 1.05, (px+2), 1.05,1];
    
    % Update the plots of the ball and paddle with
    % their new positions
    set(ballplot,'XData',bx,'YData',by)
    paddleplot.Position = [px .75 2 .3];
    
    %if the brick number was not 1 (the walls it
    %collided with was a brick, rather than the paddle
    %or outer walls or not colliding at all)
    if brickNum ~= 1
        %delete the visualizations of the 4 lines that
        %make up this brick,increase the bricksSmashed by 1
        delete(brickhandles((4*brickNum - 4):(4*brickNum-1)));
        bricksSmashed = bricksSmashed + 1;
    end
    
    %update the text display of the number of lives
    set(livesDisplay,'String',['Lives: ' num2str(lives)]);
    
    %update the visualization, pausing to bring speeds
    %down to a level user can interact with
    drawnow
    pause(0.03);
    
    %If there are zero lives left
    if lives == 0
        %end the while loop, close the figure, and send
        %the user to the game over screen
        %(through function brickbreakerGameOver called
        %with an input of 0 for win, see the function)
        looper = false;
        close(gamefig);
        brickbreakerGameOver(0);
    end
    
    %If the user has smashed all the bricks
    if bricksSmashed == 18
        %end the while loop, close the figure, and send
        %the user to the game over screen
        %(through function brickbreakerGameOver called
        %with an input of 1 for win, see the function)
        looper = false;
        close(gamefig);
        brickbreakerGameOver(1);
    end
end

    function paddlePress(~,eData)
        %This function is the keypress callback function.
        %It sets the paddle velocity or closes the figure
        %when a keyboard key is pressed
        %It ignores the first callback input, and obtains
        %the event data as the second input
        switch eData.Key
            case 'leftarrow'
                %if the left arrow key is pressed, set
                %the velocity to -25
                vpaddle = -25;
            case 'rightarrow'
                %if the right arrow key is pressed, set
                %the velocity to 25
                vpaddle = 25;
            case 'q'
                %if the q key is pressed, end the while
                %loop, close the figure, and send
                %the user to the game over screen
                looper = false;
                close(gamefig);
                brickbreakerGameOver(0);
        end
    end


    function paddleRelease(~,eData)
        %This function is the key release callback function.
        %It sets the paddle velocity to 0 when an arrow
        %key is released
        %It ignores the first callback input, and obtains
        %the event data as the second input
        switch eData.Key
            case 'leftarrow'
                %if the left arrow key is released, set
                %the velocity to 0
                vpaddle = 0;
            case 'rightarrow'
                %if the right arrow key is released, set
                %the velocity to 0
                vpaddle = 0;
        end
    end
end
