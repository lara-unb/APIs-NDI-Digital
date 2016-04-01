aurora_device = AuroraDriver('/dev/ttyUSB0');
serial_present = instrfind;

if(~isempty(serial_present)) 
    
    aurora_device.openSerialPort();
    aurora_device.init();
    aurora_device.detectAndAssignPortHandles();
    aurora_device.initPortHandleAll();
    aurora_device.enablePortHandleDynamicAll();
    aurora_device.startTracking();
    aurora_device.BEEP('1');
    delete(aurora_device);
    
end
