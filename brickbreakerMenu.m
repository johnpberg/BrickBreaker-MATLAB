function brickbreakerMenu(~,~)
%This function loads a menu that the user interacts with
%to start the brickbreaker game. The interface consists
%of 4 clickable buttons on a figure window. There are
%no inputs- the two inputs as a result of this function
%being used as a callback in a different function are
%ignored.

%Closing all existing figure windows
close all

%Creating the figure, normalizing to the size of the
%computer screen, setting the color, and preventing the
%user from resizing the figure
figure('Units','Normalized','OuterPosition',[.3 .1 .4 .9]);
set(gcf,'Color',[0.153,0.263,0.808]);
%set(gcf, 'Resize', 'off');

%Hiding the toolbar and title of the figure window
set(gcf,'menubar','none')
set(gcf,'NumberTitle','off');

%Creating axes for the text
axes('Position',[0 0 1 1],'Visible','off');

%Creating text for the title, specifying color, font size,
%name, and style, and the text itself
text('position',[0.05 .9],'Color',...
    [0.949 0.427 0.427],'fontsize',36,'FontName',...
    'Courier New','FontWeight','bold','string', ...
    'Classic Brick Breaker','units','normalized');

%Creating text for my name, specifying color, font size,
%name, and style, and the text itself
text('position',[0.17 .85],'Color',...
    [0.949 0.427 0.427],'fontsize',24,'FontName',...
    'Courier New','FontWeight','bold','string', ...
    'Created by John P. Berg');

%Creating a cell array holding numerous strings of text
%that are the instructions for the game
instr = {'Instructions:';
    '  ';
    'Use the left and right arrow keys';
    'to move the paddle back and forth';
    'and hit the ball';
    '  ';
    'Hit the ball with the edges of the';
    'paddle to adjust its trajectory';
    '  ';
    'Smash all the bricks before running';
    'out of lives to win';
    '  ';
    'Press q to quit';
    '  ';
    '  ';
    'Select difficulty level below:'};

%Plotting the instruction text on the figure window,
%specifying color, font size, name, and style, and the
%text itself
text('position',[0.15 .625],'Color',...
    [0.949 0.427 0.427],'fontsize',14,'FontName',...
    'Courier New','FontWeight','bold','string', ...
    instr);

%Create buttons on the interface. The callback for each
%button is the function brickbreaker, with specified
%inputs for number of lives, initial x and y position
%and velocity of the ball, and a variable difficulty
%that the function wallmaker uses to make the walls.
%These inputs vary depending on difficulty- the ball
%moves faster, the number of lives decreases, and the
%bricks get progessively closer to the paddle as you
%move from easy to medium to hard.

%Each button is created as a pushbutton using uicontrol
%in normalized units with specified position, labelling
%text, color, font, size, style, and weight.

%Button to play easy difficulty
uicontrol('Style','Pushbutton','Units','Normalized','Position',...
    [0 0.305 1 0.1],'String','Easy','ForegroundColor', ...
    [0.949 0.427 0.427],'FontName', 'Courier New',...
    'FontSize', 24,'FontWeight', 'bold',...
    'CallBack',{@brickbreaker,3,5,7,-6,-30,1});

%Button to play medium difficulty
uicontrol('Style','Pushbutton','Units','Normalized','Position',...
    [0 0.2025 1 0.1],'String','Medium','ForegroundColor', ...
    [0.949 0.427 0.427],'FontName', 'Courier New',...
    'FontSize', 24,'FontWeight', 'bold',...
    'CallBack',{@brickbreaker,1,5,5,-6,-30,3});

%Button to play hard difficulty
uicontrol('Style','Pushbutton','Units','Normalized','Position',...
    [0 0.1 1 0.1],'String','Hard','ForegroundColor', ...
    [0.949 0.427 0.427],'FontName', 'Courier New',...
    'FontSize', 24,'FontWeight', 'bold',...
    'CallBack',{@brickbreaker,1,5,3,-14,-80,4});

%A small 'God Mode' button is created in the same
%manner, with all the same inputs as the easy level
%except the user gets 1 million lives.
uicontrol('Style','Pushbutton','Units','Normalized','Position',...
    [.8 0.05 .1 0.05],'String','God Mode','ForegroundColor', ...
    [0.949 0.427 0.427],'FontName', 'Courier New',...
    'FontSize', 8,'FontWeight', 'bold',...
    'CallBack',{@brickbreaker,1000000,5,7, -6, -30,1});

end
