clear all;
clc;


serialIn  = "COM3";  
serialOut = "COM4"; 
baudRate  = 9600;

threshold = -34;    


try
    s = serialport(serialIn, baudRate);
catch e
    disp("Error connecting to input serial port:");
    disp(e.message);
    return;
end

try
    k = serialport(serialOut, baudRate);
catch e
    disp("Error connecting to output serial port:");
    disp(e.message);
    clear s;
    return;
end

flush(s);


motor1Stopped = false;   
motor2Stopped = false;   

active1 = true;          
active2 = true;       


hFig = figure('Name', 'Sensor 1 & Sensor 2 - Force');
hLine1 = plot(nan, nan, 'r', 'LineWidth', 1.5); hold on;
hLine2 = plot(nan, nan, 'b', 'LineWidth', 1.5);
grid on;
xlabel('Time (s)');
ylabel('Force');
title('Force data');
legend('Sensor 1', 'Sensor 2');
ylim([-50 0]);


time1 = []; data1 = [];
time2 = []; data2 = [];
t0 = tic;

disp("Start monitoring forces...");

try
    while ishandle(hFig)

        if s.NumBytesAvailable > 0
            str = readline(s);

           
            tokens = regexp(str, '\s*(-?\d+)\s+(-?\d+)\s+(-?\d+)\s+(-?\d+)', 'tokens');
            if isempty(tokens)
                continue;
            end

            force1 = str2double(tokens{1}{1}); 
            force2 = str2double(tokens{1}{3}); 
            t = toc(t0);

           
            if active1
                
                if ~motor1Stopped && (force1 < threshold)
                    disp("Sensor1 below threshold -> send B (and freeze Sensor1)");
                    writeline(k, "B");
                    motor1Stopped = true;
                    active1 = false;   
                else
                    
                    time1(end+1) = t;
                    data1(end+1) = force1;
                end
            end

            
            if active2
                if ~motor2Stopped && (force2 < threshold)
                    disp("Sensor2 below threshold -> send A (and freeze Sensor2)");
                    writeline(k, "A");
                    motor2Stopped = true;
                    active2 = false;   
                else
                    time2(end+1) = t;
                    data2(end+1) = force2;
                end
            end

            
            set(hLine1, 'XData', time1, 'YData', data1);
            set(hLine2, 'XData', time2, 'YData', data2);

            
            tmax = 0;
            if ~isempty(time1), tmax = max(tmax, time1(end)); end
            if ~isempty(time2), tmax = max(tmax, time2(end)); end
            xlim([0, max(0.1, tmax)]);

            drawnow limitrate;

            
            if motor1Stopped && motor2Stopped
                disp("Both motors stopped. Exiting loop.");
                break;
            end

        else
            pause(0.001);  
        end
    end

catch e
    disp("Runtime error:");
    disp(e.message);
end

clear s k;
disp("Done.");
