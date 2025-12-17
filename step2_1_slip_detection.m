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


hFig = figure;


subplot(2, 1, 1);
hPos1 = plot(nan, nan, 'b');
xlabel('Time (s)');
ylabel('Position 1');
title('Real-time Position 1 Data');
grid on;


subplot(2, 1, 2);
hDwt1 = plot(nan, nan, 'r');
xlabel('Time (s)');
ylabel('DWT Coefficients');
title('1st Level DWT Detail Coefficients for Position 1');
grid on;


position1Data = [];
time = [];
dwtTime = [];  
startTime = tic;
tolerance = 1.5;  
bufferSize = 10;  


slip = [];

outlierDetected = false;

try
    while ishandle(hPos1)
        if s.NumBytesAvailable > 0
            str = readline(s);
            disp(['Received string: ' str]); 
            tokens = regexp(str, '\s*(-?\d+)\s+\s*(-?\d+)\s+\s*(-?\d+)\s+\s*(-?\d+)', 'tokens');
            if ~isempty(tokens)
                position1 = str2double(tokens{1}{2});

                currentTime = toc(startTime);

                
                position1Data = [position1Data, position1];
                time = [time, currentTime];

                
                slip = [slip; currentTime, position1];

                
                set(hPos1, 'XData', time, 'YData', position1Data);

                
                if length(position1Data) >= 2
                    [c1, l1] = wavedec(position1Data, 1, 'db1');
                    d1 = detcoef(c1, l1, 1); 
                    
                    
                    dwtTime = time(1:length(d1));
                    
                    
                    set(hDwt1, 'XData', dwtTime, 'YData', d1);

                    
                    if length(d1) >= bufferSize
                        recentDWT = d1(end-bufferSize+1:end);
                        meanDWT = mean(recentDWT);
                        
                        
                        if any(abs(recentDWT - meanDWT) > tolerance)
                            if outlierDetected
                                disp('Outlier detected. Stopping motor.');
                                outlierDetected = true;
                            end
                            writeline(k, 'S'); 
                        else
                            if outlierDetected
                                disp('Outlier condition cleared.');
                                outlierDetected = false;
                            end
                        end
                    end
                end

                drawnow;
            else
                disp('No valid data found in string');
            end
        end
    end
catch e
    disp(e.message);
end

clear s;
clear k;
