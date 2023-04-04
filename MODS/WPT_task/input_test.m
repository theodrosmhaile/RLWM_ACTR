clear all

SpaceKey = KbName('space');
%RShift = KbName('rightshift');
%LShift = KbName('leftshift');
ESCKey = KbName('escape');


this_span_response = '';
while KbCheck; end

while 1
    
        %KbReleaseWait;
         [ keyIsDown, ~, keyCode ] = KbCheck;
        
         if keyIsDown
             if find(keyCode) == ESCKey
                 
                 break
            elseif find(keyCode) == SpaceKey
               % trials = trials+1;
                fprintf('space triggered')  
               continue
                
             elseif find(keyCode,1) == 40
                 fprintf('return executed')
                 continue
             elseif find(keyCode,1) < 40 &&  find(keyCode,1) > 29
                KbReleaseWait;
                 temp_char= KbName(keyCode);
                 find(keyCode)
               this_span_response  = [this_span_response,temp_char(1) ];              
                
                %FlushEvents
               continue
             end
        
         end
        
 
end