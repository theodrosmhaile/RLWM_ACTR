% Initialize Psychtoolbox
PsychDefaultSetup(2);
Screen('Preference', 'SkipSyncTests', 1); % Only use if you encounter sync errors

% Open a window
window = Screen('OpenWindow', 0);

% Set up text parameters
Screen('TextSize', window, 36);
Screen('TextFont', window, 'Arial');

% Show instructions
DrawFormattedText(window, 'Please type your response:', 'center', 'center', 255);
Screen('Flip', window);

% Get participant response
ListenChar(2);
response = GetEchoString(window, '', 100, 300, 255);

% Save response to file
fileID = fopen('response.txt', 'w');
fprintf(fileID, '%s', response);
fclose(fileID);

% Close the window
Screen('CloseAll');





% Initialize Psychtoolbox
PsychDefaultSetup(2);
Screen('Preference', 'SkipSyncTests', 1); % Only use if you encounter sync errors

% Open a window
window = Screen('OpenWindow', 0);

% Set up text parameters
Screen('TextSize', window, 36);
Screen('TextFont', window, 'Arial');

% Show instructions
DrawFormattedText(window, 'Please type your response:', 'center', 'center', 255);
Screen('Flip', window);

% Wait for keyboard input
response = '';
while true
    [keyIsDown, ~, keyCode] = KbCheck;
    if keyIsDown
        if keyCode(KbName('return')) % Check for 'return' key to end input
            break;
        elseif keyCode(KbName('backspace')) % Check for 'backspace' key to delete last character
            response = response(1:end-1);
        else
            response = [response KbName(keyCode)]; % Append key to response
        end
        
        % Show current response
        DrawFormattedText(window, response, 'center', 'center', 255);
        Screen('Flip', window);
    end
end

% Save response to file
fileID = fopen('response.txt', 'w');
fprintf(fileID, '%s', response);
fclose(fileID);

% Close the window
Screen('CloseAll');
