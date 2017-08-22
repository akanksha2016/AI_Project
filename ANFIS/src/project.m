train_x=xlsread('standardized_training.xlsx','D2:P3288');
train_y_NO2=xlsread('standardized_training.xlsx','Q2:Q3288');
train_y_O3=xlsread('standardized_training.xlsx','R2:R3288');
train_data_NO2=[train_x train_y_NO2];
train_data_O3=[train_x train_y_O3];

valid_x=xlsread('standardized_validation.xlsx','D2:P1095');
valid_y_NO2=xlsread('standardized_validation.xlsx','Q2:Q1095');
valid_y_O3=xlsread('standardized_validation.xlsx','R2:R1095');
valid_data_NO2=[valid_x valid_y_NO2];
valid_data_O3=[valid_x valid_y_O3];

test_x=xlsread('standardized_test.xlsx','D2:P1003');
test_y_NO2=xlsread('standardized_test.xlsx','Q2:Q1003');
test_y_O3=xlsread('standardized_test.xlsx','R2:R1003');
test_data_NO2=[test_x test_y_NO2];
test_data_O3=[test_x test_y_O3];

train_time=xlsread('standardized_training.xlsx','C2:C3288');
valid_time=xlsread('standardized_validation.xlsx','C2:C1095');
test_time=xlsread('standardized_test.xlsx','C2:C1003');

initialfis_NO2=genfis2(train_x,train_y_NO2,0.3);
initialfis_O3=genfis2(train_x,train_y_O3,0.3);

[outfis_NO2_5,error_5,stepsize_5,chkfis_5,chkerror_5]=anfis(train_data_NO2, initialfis_NO2,[10],[],valid_data_NO2);
fisRMSE_5=min(error_5)
[outfis_NO2,error_NO2,stepsize_NO2,chkfis_NO2,chkerror_NO2]=anfis(train_data_NO2, initialfis_NO2,[10],[],valid_data_NO2);
fisRMSE_NO2=min(error_NO2)

[outfis_O3_5,error_O3_5,stepsize_O3_5,chkfis_O3_5,chkerror_O3_5]=anfis(train_data_O3, initialfis_O3,[10],[],valid_data_O3);
fisRMSE_O3_5=min(error_O3_5)
[outfis_O3,error_O3,stepsize_O3,chkfis_O3,chkerror_O3]=anfis(train_data_O3, initialfis_O3,[10],[],valid_data_O3);
fisRMSE_O3=min(error_O3)

% showrule(initialfis_NO2)
%  writefis(initialfis_NO2,'C:\Users\bahuguna\Documents\MATLAB\initialfis_NO2.fis');
 writefis(outfis_NO2_5,'C:\Users\bahuguna\Documents\MATLAB\outfis_NO2_5.fis');
 writefis(outfis_NO2,'C:\Users\bahuguna\Documents\MATLAB\outfis_NO2.fis');
 %  writefis(chkfis_10,'C:\Users\bahuguna\Documents\MATLAB\chkfis_10.fis');
% showrule(outfis_NO_10)
% writefis(initialfis_O3,'C:\Users\bahuguna\Documents\MATLAB\initialfis_O3.fis');
writefis(outfis_O3_5,'C:\Users\bahuguna\Documents\MATLAB\outfis_O3_5.fis');
writefis(outfis_O3,'C:\Users\bahuguna\Documents\MATLAB\outfis_O3.fis');
% writefis(chkfis_O3,'C:\Users\bahuguna\Documents\MATLAB\chkfis_O3.fis');

%plot measured and predicted values with time 
figure(1);      
index=1:size(train_y_NO2);
anfisOutput_NO2_train = evalfis(train_x,outfis_NO2);
% l=size(train_y_NO2);
% train_y_NO2_actual=zeros(l);
% for i=1:l
%    train_y_NO2_actual(i)=train_y_NO2(i)*(1.82236367e+03)+62.50785584; 
% end
% l=size(anfisOutput_train);
% anfisOutput_train_actual=zeros(l);
% for i=1:l
%    anfisOutput_train_actual(i)=anfisOutput_train(i)*(1.82236367e+03)+62.50785584; 
% end
subplot(2,1,1), plot(index,train_y_NO2,'+r',index,anfisOutput_NO2_train,'.b');
xlabel('Time [2011-2013]');
ylabel('NO2 concentration');
legend('Training Data','ANFIS Output','Location','NorthWest');
title('Measured and Predicted values of NO2 concentration(8-hourly avg) for Training data');

index=1:size(test_y_NO2);
anfisOutput_NO2_test = evalfis(test_x,outfis_NO2);
% l=size(test_y_NO2);
% test_y_NO2_actual=zeros(l);
% for i=1:l
%    test_y_NO2_actual(i)=test_y_NO2(i)*(1.82236367e+03)+62.50785584; 
% end
% l=size(anfisOutput_test);
% anfisOutput_test_actual=zeros(l);
% for i=1:l
%    anfisOutput_test_actual(i)=anfisOutput_test(i)*(1.82236367e+03)+62.50785584;
% end
subplot(2,1,2), plot(index,test_y_NO2,'+r',index,anfisOutput_NO2_test,'.b');
xlabel('Time[2015]');
ylabel('NO2 concentration');
legend('Testing Data','ANFIS Output','Location','NorthWest');
title('Measured and Predicted values of NO2 concentration(8-hourly avg) for Testing data');


%plot measured and predicted values with time 
figure(2);      
index=1:size(train_y_O3);
anfisOutput_O3_train = evalfis(train_x,outfis_O3);
subplot(2,1,1), plot(index,train_y_O3,'+r',index,anfisOutput_O3_train,'.b');
xlabel('Time [2011-2013]');
ylabel('O3 concentration');
legend('Training Data','ANFIS Output','Location','NorthWest');
title('Measured and Predicted values of O3 concentration(8-hourly avg) for Training data');

index=1:size(test_y_O3);
anfisOutput_O3_test = evalfis(test_x,outfis_O3);
subplot(2,1,2), plot(index,test_y_O3,'+r',index,anfisOutput_O3_test,'.b');
xlabel('Time[2015]');
ylabel('O3 concentration');
legend('Testing Data','ANFIS Output','Location','NorthWest');
title('Measured and Predicted values of O3 concentration(8-hourly avg) for Testing data');

% figure(2);
% index=1:size(train_y_NO2);
% anfisOutput = evalfis(train_x,outfis_NO_10);
% p=anfisOutput;
% subplot(2,1,1),plot(index, [train_y_NO2(index) anfisOutput]);
% xlabel('Training sample');
% ylabel('NO2 concentration(Standardized)');
% legend('Training Data','ANFIS Output(trained for 150 epochs)','Location','NorthWest');
% title('Measured and Predicted values of NO2 concentration for Training data');
% 
% index=1:size(test_y_NO2);
% anfisOutput = evalfis(test_x,outfis_NO_10);
% subplot(2,1,2),plot(index, [test_y_NO2(index) anfisOutput]);
% xlabel('Testing sample');
% ylabel('NO2 concentration(Standardized)');
% legend('Testing Data','ANFIS Output(trained for 150 epochs)','Location','NorthWest');
% title('Measured and Predicted values of NO2 concentration for Testing data');

figure(3)
i = [1:10];
plot(i,error_NO2,'.b',i,chkerror_NO2,'*r');
legend('Training RMSE','Validation RMSE','Location','NorthWest');
title('RMSE Vs. epochs for NO2 concentration');
xlabel('Epoch');
ylabel('RMSE');

figure(4)
i = [1:10];
plot(i,error_O3,'.b',i,chkerror_O3,'*r');
legend('Training RMSE','Validation RMSE','Location','NorthWest');
title('RMSE Vs. epochs for O3 concentration');
xlabel('Epoch');
ylabel('RMSE');


figure(5)
a=[-4:8];
subplot(1,3,1),plot(train_y_NO2,anfisOutput_NO2_train,'*r')
xlabel('Measured NO2 concentration');
ylabel('Predicted NO2 concentration');
title('Training data')
hold
plot(a,a);
anfisOutput_NO2_valid = evalfis(valid_x,chkfis_NO2);
a=[-4:4];
subplot(1,3,2),plot(valid_y_NO2,anfisOutput_NO2_valid,'*r');
xlabel('Measured NO2 concentration');
ylabel('Predicted NO2 concentration');
title('Validation data')
hold
plot(a,a);
a=[-4:4];
subplot(1,3,3),plot(test_y_NO2,anfisOutput_NO2_test,'*r');
xlabel('Measured NO2 concentration');
ylabel('Predicted NO2 concentration');
title('Testing data')
hold
plot(a,a);

figure(6)
a=[-4:15];
subplot(1,3,1),plot(train_y_O3,anfisOutput_O3_train,'*r')
xlabel('Measured O3 concentration');
ylabel('Predicted O3 concentration');
title('Training data')
hold
plot(a,a);
anfisOutput_O3_valid = evalfis(valid_x,chkfis_O3);
a=[-4:4];
subplot(1,3,2),plot(valid_y_O3,anfisOutput_O3_valid,'*r');
xlabel('Measured O3 concentration');
ylabel('Predicted O3 concentration');
title('Validation data')
hold
plot(a,a);
a=[-4:4];
subplot(1,3,3),plot(test_y_O3,anfisOutput_O3_test,'*r');
xlabel('Measured O3 concentration');
ylabel('Predicted O3 concentration');
title('Testing data')
hold
plot(a,a);

% final NO2 RMSE
l=size(test_y_NO2);
test_error_NO2=0;
for i=1:l(1)
    test_error_NO2=test_error_NO2+(test_y_NO2(i)-anfisOutput_NO2_test(i))^2;
end
test_error_NO2=test_error_NO2/l(1);
test_error_NO2=sqrt(test_error_NO2)

% final O3 RMSE
l=size(test_y_O3);
test_error_O3=0;
for i=1:l(1)
    test_error_O3=test_error_O3+(test_y_O3(i)-anfisOutput_O3_test(i))^2;
end
test_error_O3=test_error_O3/l(1);
test_error_O3=sqrt(test_error_O3)

% output = evalfis(valid_x, chkfis_10); 
% len=size(valid_x);
% index=1:len(1);
% figure(3)
% % plotting the data and the predicted data
% subplot(2,1,1),plot(index, [valid_data_NO2(index,14) output]);
% legend('Validation Data','ANFIS Output','Location','NorthWest');
% % % plotting the error
%  subplot(2,1,2), plot(index, valid_data_NO2(index,14) - output,'r'); 
%  legend('difference','Location','NorthWest');
% 
% plotmf(outfis_NO_5,'input',1);
% figure(4)
% plot(index,valid_data_NO2(index,14),'*r',index,output,'.b');
% legend('Validation Data','ANFIS Output','Location','NorthWest');
 
% len=size(train_x);
% index=1:len(1);
% figure(5);
% anfisOutput = evalfis(train_x,outfis_O3_10);
% plot(index,train_y_O3,'*r',index,anfisOutput,'.b');
% legend('Training Data','ANFIS 10 epoch Output','Location','NorthWest');
% 
% output = evalfis(valid_x, chkfis_O3_10); 
% len=size(valid_x);
% index=1:len(1);
% figure(6)
% % plotting the data and the predicted data
% plot(index, [valid_data_O3(index,14) output]);
% legend('Validation Data','ANFIS Output','Location','NorthWest');
% 
% figure(7)
% subplot(2,1,1),plotmf(initialfis_NO2, 'input', 1) 
% subplot(2,1,2),plotmf(chkfis_10, 'input', 1) 
% 
% 
%  figure(8)
%  plot(stepsize_10);

ben=input('BEN content = ');
std_ben=(ben-29.66167275)/9.92484156e+02;

bp=input('BP content = ');
std_bp=(bp-963.7569708)/3.93984556e+03;

co=input('CO content = ');
std_co=(co-1.15886557)/3.12051188e+00;

mpxy=input('MPXY content = ');
std_mpxy=(mpxy-14.61837287)/1.99947981e+02;

no=input('NO content = ');
std_no=(no-45.29929745)/2.92796198e+03;

no2=input('NO2 content = ');
std_no2=(no2-62.50785584)/1.82236367e+03;

o3=input('O3 content = ');
std_o3=(o3-87.5335371)/2.84270779e+03;

rh=input('RH content = ');
std_rh=(rh-51.4488899)/5.58119508e+02;

so2=input('SO2 content = ');
std_so2=(so2-17.13806569)/2.43777715e+02;

temp=input('TEMP content = ');
std_temp=(temp-26.39465024)/6.34750145e+01;

tol=input('TOL content = ');
std_tol=(tol-100.72950426)/6.12606999e+03;

wd=input('WD content = ');
std_wd=(wd-210.12961983)/6.32410041e+03;

ws=input('WS content = ');
std_ws=(ws-2.20836375)/1.65635669e+00;

NO2_content=evalfis([std_ben std_bp std_co std_mpxy std_no std_no2 std_o3 std_rh std_so2 std_temp std_tol std_wd std_ws],outfis_NO_10);
actual_NO2=NO2_content*(1.82236367e+03)+62.50785584;
O3_content=evalfis([std_ben std_bp std_co std_mpxy std_no std_no2 std_o3 std_rh std_so2 std_temp std_tol std_wd std_ws],outfis_O3_10);
actual_O3=O3_content*(2.84270779e+03)+87.5335371;
disp(['predicted value(standardized): ',num2str(NO2_content)]);
disp(['predicted value(actual): ',num2str(actual_NO2)]);
disp(['predicted value(standardized): ',num2str(O3_content)]);
disp(['predicted value(actual): ',num2str(actual_O3)]);
threshold_NO2=200;
if(actual_NO2>=threshold_NO2)
   disp('High NO2 content.Alert!!!'); 
end
threshold_O3=100;
if(actual_O3>=threshold_O3)
   disp('High O3 content.Alert!!!'); 
end

% 
% % figure(1)
% % plotmf(outfis_NO,'input',1)
% 
% [outfis_NO_10,error,stepsize]=anfis(train_data_NO, initialfis_NO,[10]);
% writefis(outfis_NO_10,'C:\Users\bahuguna\Documents\MATLAB\outfis_NO_10.fis');
% 
% a=input('previous content');
% g=evalfis([a],outfis_NO_10);
% disp(['predicted value:',num2str(g)]);

% 
% showfis(initialfis_NO2)
% showfis(outfis_NO_10)
% showfis(chkfis_10)

