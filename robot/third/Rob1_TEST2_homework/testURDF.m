clear,clc;
xme7p=importrobot('Robot_ZJU1_CSC309.urdf');%导入URDF文件
showdetails(xme7p)  %显示连杆间的父子关系
% show(xme7p,'Frames','off','Visuals' ,'on')  %figure显示

% xme7p_SM = smimport(xme7p);
interactiveGUI = interactiveRigidBodyTree(xme7p);
% interactiveGUI.Configuration = [1 1 1 1 1 1 1];
% addConfiguration(interactiveGUI);