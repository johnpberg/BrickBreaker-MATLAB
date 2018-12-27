function brickbreakerGameOver(win)
%This function loads a menu that the user interacts with
%once they have either won or lost the brickbreaker game.
%The interface consists of 2 clickable buttons on a figure
%window, allowing them to either play again (return to
%menu screen) or quit (close the figure). The input win
%is either a 1 or 0 -- when called with a 1 from the
%brickbreaker function it indicates the user has
%won, and when called with a 0, it indicates the user
%has either lost or pressed q to quit the game.

%Closing all existing figures
close all

%creating the figure with normalized units, setting the
%color, and preventing the user from resizing it
figure('Units','Normalized','OuterPosition',[.3 .1 .4 .9]);
set(gcf,'Color',[0.153,0.263,0.808]);
set(gcf, 'Resize', 'off');

%hiding the toolbar and title of the figure window
set(gcf,'menubar','none')
set(gcf,'NumberTitle','off');

%Creating axes for the text, making them invisible.
axes('Position',[0 0 1 1],'Visible','off');

%If win was equal to one, set the display text
%accordingly, otherwise (user lost or quit), set it
%accordingly
if win == 1
    displaytext ='You Won!' ;
else
    displaytext = 'Game Over' ;
end

%Creating the text stored in displaytext on the figure
%window, specifying position, color, and font details
text('position',[0.25 .65],'Color',...
    [0.949 0.427 0.427],'fontsize',48,'FontName',...
    'Courier New','FontWeight','bold','string', ...
    displaytext);

%Create 2 buttons on the interface.
%Each button is created as a pushbutton in normalized
%units with specified position, labelling text, color,
%font, size, style, and weight.

%Button to play again- the callback function is
%brickbreakerMenu
uicontrol('Style','Pushbutton','Units','Normalized','Position',...
    [0 0.1 1 0.1],'String','Play Again','ForegroundColor', ...
    [0.949 0.427 0.427],'FontName', 'Courier New',...
    'FontSize', 24,'FontWeight', 'bold',...
    'CallBack',@brickbreakerMenu);

%button to quit- callback function Quitgame shown below
uicontrol('Style','Pushbutton','Units','Normalized','Position',...
    [0 0.2025 1 0.1],'String','Quit','ForegroundColor', ...
    [0.949 0.427 0.427],'FontName', 'Courier New',...
    'FontSize', 24,'FontWeight', 'bold',...
    'CallBack',@Quitgame);
end


function Quitgame(~,~)
%Callback function for the quit button- ignore the
%callback inputs and close the figure
close all
end
