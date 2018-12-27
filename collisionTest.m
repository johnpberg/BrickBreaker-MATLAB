function [ t ] = collisionTest( walls, x, y, vx, vy)
%This function takes in as inputs the locations of the
%walls, and the x and y positions and velocities of the
%ball. It then checks if the ball is traveling towards
%each of the system walls,calculates the time until the
%ball will pass the plane of each of the walls, and then
%calculates the location where the ball will intersect
%the plane of each wall and sees if this location lies
%between the endpoints of each wall. If this is all
%true, the time is added to the vector t, the output.

%Obtaining the number of walls
sz = size(walls,1);

%Creating a vector for t, initializing to very large
%values so they won't interfere with finding the
%smallest values, while preventing an error in timestep
%if there is only 1 wall the ball is heading to
t = ones(1,sz);
t = t*10000;

%For each wall
for ind = 1:sz
    %If the wall is vertical
    if walls(ind,1) - walls(ind,3) == 0
        %if the ball is traveling towards it
        if (walls(ind,1) - x)*vx > 0
            %Calculate the time until the ball will
            %pass the plane of the wall
            tp = (walls(ind,1)-x)/vx;
            %Calculate the y position at this time
            yc = y + vy*tp;
            %Obtain the endpoints of the wall
            yvals = [walls(ind,2) , walls(ind,4)];
            
            %if the wall position falls between the
            %endpoints, add the time to the time to
            %collision vector
            if yc >= min(yvals) && yc <= max(yvals)
                t(ind) = tp;
            end
        end
        %Horizontal walls
    else
        %If the wall is vertical
        if (walls(ind,2) - y)*vy > 0
            %Calculate the time until the ball will
            %pass the plane of the wall
            tp = (walls(ind,2)-y)/vy;
            %Calculate the x position at this time
            xc = x + vx*tp;
            %Obtain the endpoints of the wall
            xvals = [walls(ind,1) , walls(ind,3)];
            %if the wall position falls between the
            %endpoints, add the time to the time to
            %collision vector
            if xc >= min(xvals) && xc <= max(xvals)
                t(ind) = tp;
            end
        end
    end
end
