function [ walls,wallstoplot ] = wallmaker(px,difficulty)
%This function takes in as inputs the position of the paddle, 
%and a number difficulty corresponding to the difficulty 
%the player chose. The function then creates output
%wall, a 76x5 matrix containing the x and y endpoints
%of each line, and the number of the brick the line is
%a part of (each row: [x1 y1 x2 y2 bricknumber]). It
%also creates output wallstoplot, a 75x5 matrix which 
%contains the data for every wall except for the top 
%face of the paddle, as this is plotted separately. The
%difficulty number effectively moves the bricks lower
%down on the plot. 

%Creating a matrix containing the x and y endpoints of
%the border walls
walls = [0,10,10,10;0,0,0,10;10,0,10,10];
%incorporating the top side of the paddle into the
%walls matrix
walls(4,:) = [px, 1.05, (px+2), 1.05];

%Creating a variable topbrick that corresponds to the y
%position of the bottom of the top row of bricks -- the
%higher the difficulty, the futher down the bricks are
topbrick = 10 - difficulty;

%Creating a matrix containing the x and y endpoints for
%the 4 lines making up the first brick in the format
%described above
bricks1 = [0.25, topbrick, 1.75, topbrick; 1.75, ...
    topbrick, 1.75, topbrick + 0.5; 0.25,...
    topbrick + 0.5, 1.75, topbrick + 0.5; 0.25, topbrick,...
    0.25, topbrick + 0.5];

%repeating this matrix 6 times in the row direction
bricksrow = repmat(bricks1,6,1);

%Creating 1 full row of bricks by adding 1.6, 2*1.6, etc
%to both x values in each of the 4 lines in each brick
%that follows the 1st brick (total of 6 bricks,
%5 in addition to 1st one) 
for ind = 1:5
    for ind2 = 1:4
   bricksrow((4*ind)+ind2,1:2:end) = ind*1.6 ...
       + bricksrow((4*ind)+ind2,1:2:end);
    end
end

%Repeating the resulting matrix 3 times in the row
%direction
bricksfull = repmat(bricksrow,3,1);

%Creating 2 additional rows of bricks by decreasing the
%y values in rows 25-48 by .6 and decreasing the y
%vaues in rows 49-72 by 2*.6 = 1.2 
for ctr = 1:2
    for ctr2 = 1:24
    bricksfull((24*ctr)+ctr2, 2:2:end) = bricksfull((24*ctr)+ctr2, 2:2:end)-ctr*.6;
    end
end

%Creating the walls matrix by concatenating the bricks
%with the outer walls and top of the paddle
walls = [walls;bricksfull];

%Creating a vector [1 1 1 1 2 2 2 2 3 3 3 3 ...] etc to
%label each line by a bricklabel- the number of the
%brick they are a part of (outer walls and paddle are
%bricklabel 1)
bricklabel = reshape(repmat(1:19, 4, 1), [], 1);

%Adding this vector as a 5th column to the walls matrix
walls = [walls,bricklabel];

%Creating wallstoplot, containing all the walls besides
%the wall corresponding to the paddle, as this is
%plotted separately
wallstoplot = [walls(1:3,:);walls(5:end,:)];


end