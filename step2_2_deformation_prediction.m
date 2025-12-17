clear all;
clc;

serialPort = 'COM3'; 
baudRate = 9600;

try
    s = serialport(serialPort, baudRate);
catch e
    disp('Error connecting to serial port:');
    disp(e.message);
    return;
end

k = serialport("COM4", 9600);


hFig = figure('Name', 'Sensor 1 & Sensor 2 - Force');
hLine1 = plot(nan, nan, 'r--'); 
hold on;
xlabel('Time (s)');
ylabel('Force');
title(' Force data');
grid on;
ylim([-200 0]);

hFit1 = plot(nan, nan, 'r', 'LineWidth', 2); 


hMarker1 = plot(nan, nan, 'ro', 'MarkerSize', 10, 'LineWidth', 2);



data1 = [];
time = [];
DEFORM = [];  
startTime = tic;

try
    while ishandle(hLine1)
        if s.NumBytesAvailable > 0
            
            str = readline(s);
            disp(['Received string: ' str]); 
            tokens = regexp(str, '\s*(-?\d+)\s+\s*(-?\d+)\s+\s*(-?\d+)\s+\s*(-?\d+)', 'tokens');
            if ~isempty(tokens)
                force1 = str2double(tokens{1}{1});
                
                
                currentTime = toc(startTime);
                
                
                data1 = [data1, force1];
                time = [time, currentTime];
                
                
                DEFORM = [DEFORM; currentTime, force1];
                
                
                if ishandle(hFig)
                    set(hLine1, 'XData', time, 'YData', data1);
                    xlim([0, max(time)]);
                end
                
                
                if currentTime > 3 && length(time) >= 3
                    t_fit = linspace(min(time), max(time), 100);
                    
                    
                    p1 = polyfit(time, data1, 3);
                    y_fit1 = polyval(p1, t_fit);
                    set(hFit1, 'XData', t_fit, 'YData', y_fit1);
                    
                    if abs(p1(1)) > eps
                        t_zero1 = -p1(2)/(3*p1(1));
                    else
                        t_zero1 = NaN;
                    end
                   
                    
                    
                    if ~isnan(t_zero1) && t_zero1 >= 1.6 && t_zero1 <= currentTime && (p1(1) > 0)
                        y_zero1 = polyval(p1, t_zero1);
                        set(hMarker1, 'XData', t_zero1, 'YData', y_zero1);
                    else
                        set(hMarker1, 'XData', nan, 'YData', nan);
                    end

                    
                    
                    if ( ~isnan(t_zero1) && t_zero1 >= 0 && t_zero1 <= currentTime && (p1(1) > 0) ) 
                        disp('2차 도함수의 0 교차점, 모터 정지 명령 전송.');
                        writeline(k, 'S'); 
                        break;
                    end
                end
                
                drawnow;
            end
        end
    end
catch e
    disp(e.message);
end

clear s k;
