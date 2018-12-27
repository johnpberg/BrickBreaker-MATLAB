function [ xnew, ynew, vxnew, vynew,wallsnew,brickNum ]...
    = timeStep(walls, xlast, ylast, vx, vy,dt)
%This function takes in the location of walls, the
%current/last x and y positions of the ball, the x and
%y velocity of the ball, and the time step, and outputs
%the new x and y velocities and positions after a 
%completed timestep in the simulation, along with
%wallsnew, the new matrix of wall positions (any bricks
%smashed are removed) and brickNum, the number of the
%brick that the ball collided with (5th column of walls
%matrix, see wallmaker function)

%Initializing the brick number to 1, which corresponds
%to the outer walls and the paddle- these won't be deleted,
%and will be the default if there are no collisions in
%the timestep, as no action is taken in brickbreaker
%with a value of 1
brickNum = 1;

%Obtain vector of time to collision values with all of
%the walls using collisionTest
[ t ] = collisionTest( walls, xlast, ylast, vx, vy);

%Sort this vector in ascending order
tsort = sort(t);


%Corner situation- if the two smallest times are "very
%close" (decided .001 would be fine) and are both less 
%than the time step   
if tsort(2) - tsort(1) < .001 && tsort(2)- eps <= dt
    %Advance the ball as normal until it reaches the collision
    %time
    xnew = xlast + vx*tsort(2);
    ynew = ylast + vy*tsort(2);
    
    %Change the velocities according to the collision
    vxnew = -vx;
    vynew = -vy;
    
    %Calculate the time left in the time step after the
    %collision, note that a collision occurred
    timeleft = dt - tsort(2);
    collis = 1;
    
    
    %Get the index in the original t vector where the
    %minimum value was found
    loc = find(t == tsort(1));
    %Get the brick number of the brick corresponding to
    %that time
    brickNum = walls(loc,5);
    
    %Deleting all walls making up that brick if it
    %isn't the paddle or outer walls (brickNum 1) to make 
    %wallsnew, otherwise just return the original walls
    %(if the collision was with the paddle or outer
    %walls)
    if brickNum ~= 1
        wallsnew = walls(walls(:,5)~= brickNum,:);
    else
        wallsnew = walls;
    end
    
    
%Horizontal or vertical situation- if the smallest time
%to collision is less than the time step
elseif tsort(1) - eps <= dt
    %Advance the ball as normal until it reaches the collision
    %time
    xnew = xlast + vx*tsort(1);
    ynew = ylast + vy*tsort(1);
    
    %Get the index in the original t vector where the
    %minimum value was found
    loc = find(t == tsort(1));
    
    %If the wall that this time to collision
    %corresponds to is vertical 
    if walls(loc,1) - walls(loc,3) == 0
        %Change the x and y velocities accordingly
        vxnew = -vx;
        vynew = vy;
        
    %If the wall that this time to collision
    %corresponds to is horizontal
    else
        %If the wall is the paddle
        if loc == 4
           %If the ball is sufficiently close to the
           %left edge of the paddle
           if xnew - walls(loc,1) < 0.4
               %make the output x velocity negative and
               %update the y velocity 
               vxnew = -abs(vx);
               vynew = -vy;
           %If the ball is sufficiently close to the
           %right edge of the paddle 
           elseif walls(loc,3) - xnew < 0.4
               %make the output x velocity positive and
               %update the y velocity
               vxnew = abs(vx);
               vynew = -vy;
               %if the ball hits roughly in the center
           else
               %update the x and y velocities normally
               vxnew = vx;
               vynew = -vy;
           end
        else
        % Otherwise Change the x and y velocities accordingly 
        vxnew = vx;
        vynew = -vy;
        end
    end
 
    %Calculate the time left in the time step after the
    %collision, note that a collision occurred 
    timeleft = dt - tsort(1);
    collis = 1;
    
    %Get the index in the original t vector where the
    %minimum value was found
    loc = find(t == tsort(1));
    
    %Get the brick number of the brick corresponding to
    %that time
    brickNum = walls(loc,5);
    
    %Deleting all walls making up that brick if it
    %isn't the paddle or  outer walls (brickNum 1) to make 
    %wallsnew, otherwise just return the original walls
    %(if the collision was with the paddle or outer
    %walls)
    if brickNum ~= 1
        wallsnew = walls(walls(:,5)~= brickNum,:);
    else
        wallsnew = walls;
    end
    
else
    %If no collisions are going to occur in this
    %timestep
    
    %Update the x and y positions accordingly, note
    %that a collision did not occur
    xnew = xlast + vx*dt;
    ynew = ylast + vy*dt;
    collis = 0;
    
    %Make the output x and y velocities and walls
    %identical to the input
    vxnew = vx;
    vynew = vy;
    wallsnew = walls;
    
end


%If a collision occurred in the timestep 
if collis ~= 0
    %Call the timestep function recursively, using the
    %newly calculated  x and y positions and velocities 
    %as the initial ones, and the timeleft as the
    %timestep (without wallsnew and brickNum, won't
    %collide with 2 bricks in a timestep, and don't
    %want to reassign these values)
    [xnew, ynew, vxnew, vynew] = ... 
        timeStep(walls, xnew, ynew ,vxnew, vynew,timeleft) ;
end
%If a collision did not occur, that is the end of the
%timestep, and the x and y values for position and
%velocity are returned
end