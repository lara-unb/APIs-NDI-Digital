% This script tests the basic functionalities of the PolarisDriver class.
% It retrieves transformation data from one of the markers with an assigned
% port handle and plots its orientation and translational data as a dual
% quaternion, using the tools offered by the DQ Robotics library for
% Matlab.
%
% DQ Robotics is an open-source (LGPLv3) standalone open-source Robotics
% library by Bruno Vilhena Adorno and Murilo Marques Marinho. It provides
% dual quaternion algebra, kinematic calculation algorithms in Python,
% MATLAB and C++ that can be applied in robot control. The library has a
% catkin package wrapper for use in ROS Indigo, and also provides a V-REP
% interface.

if(exist('polaris_device', 'var'))
    polaris_device.stopTracking();
    delete(polaris_device);
    clear polaris_device;
end
polaris_device = PolarisDriver('/dev/ttyUSB0'); % Creates the serial object
serial_present = instrfind;

if(~isempty(serial_present))    
   
    % Sample Polaris configurations
    polaris_device.openSerialPort();
    polaris_device.init();
    polaris_device.detectAndAssignPortHandles();
    
    tool_port = polaris_device.addWirelessTool('probe_tool.rom');
    %tool_port = 3;
    
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
    camup([-1 0 0])
    campos([-800 -400 -2000])
    camtarget([0 400 -700])
    
    plot_handle = plot(DQ([1 0 0 0]));
    drawnow
    needle_rot = DQ(polaris_device.port_handles(1,tool_port).rot);
    exit_counter = 100;
    reply_opt = polaris_device.TRANSFORMATION_DATA;
    while(exit_counter && strcmp(reply_opt, polaris_device.TRANSFORMATION_DATA))
        old_rot = needle_rot;
        polaris_device.updateSensorDataAll(reply_opt); %polaris_device.TRANSFORMATION_DATA
        needle_rot = DQ(polaris_device.port_handles(1,tool_port).rot);
        needle_trans = DQ([0 polaris_device.port_handles(1, tool_port).trans]); % Different markers are stored in different indexes 
        if(any(polaris_device.port_handles(1,tool_port).rot))
            
            needle_rot = needle_rot*inv(norm(needle_rot));
            needle_dq = needle_rot+0.5*DQ.E*needle_trans*needle_rot;
            plot_handle = plot(needle_dq, 'scale', 300, 'erase', plot_handle);
            drawnow
            %polaris_device.BEEP('1');
        end
        if(old_rot == needle_rot)
            exit_counter = exit_counter - 1;
        end
        
    end
    
    while(exit_counter && strcmp(reply_opt, polaris_device.PAS_STRAY_MARKERS_POS))
        marker_trans = polaris_device.updateSensorDataAll(reply_opt);
        
        if(~marker_trans)
            exit_counter = exit_counter - 1;
        else
            marker_dq = DQ([1 0 0 0])+0.5*DQ.E*DQ([0 marker_trans])*DQ([1 0 0 0]);
            plot_handle = plot(marker_dq, 'scale', 300, 'erase', plot_handle);
            drawnow            
        end
    end
    
    polaris_device.BEEP('3');
    polaris_device.stopTracking();
    delete(polaris_device);
    clear polaris_device;
    
end
