polaris_device = PolarisDriver('/dev/ttyUSB0'); % Creates the serial object
serial_present = instrfind;

if(~isempty(serial_present))    
   
    % Sample Polaris configurations
    polaris_device.openSerialPort();
    polaris_device.init();
    polaris_device.detectAndAssignPortHandles();
    polaris_device.initPortHandleAll();
    polaris_device.enablePortHandleDynamicAll();
    polaris_device.startTracking();
    
    close all;
    polaris_device.BEEP('2');
    
    % Configuring the plot figure
    hold on;
    grid on;
    axis equal; 
    axis([-700 700 -700 700 -1500 -500]); % Ranges may differ depending on physical setup
    xlabel('X')
    ylabel('Y')
    zlabel('Z')
    view([45 30])
    
    plot_handle = plot(DQ([1 0 0 0]));
    drawnow
    for iteration = 1:10000
        
        polaris_device.updateSensorDataAll();
        needle_rot = DQ(polaris_device.port_handles(1,3).rot);
        needle_trans = DQ([0 polaris_device.port_handles(1,3).trans]); % Different markers are stored in different indexes 
        if(any(polaris_device.port_handles(1,3).rot))
            
            needle_rot = needle_rot*inv(norm(needle_rot));
            needle_dq = needle_rot+0.5*DQ.E*needle_trans*needle_rot;
            plot_handle = plot(needle_dq, 'scale', 300, 'erase', plot_handle);
            drawnow
            %polaris_device.BEEP('1');
            
        end
        
    end
    
    polaris_device.BEEP('3');
    polaris_device.stopTracking();
    delete(polaris_device);
    
end
