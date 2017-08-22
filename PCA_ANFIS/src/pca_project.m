%read training data
train_x=xlsread('../input/pca_inp_train_NO2_ec.xlsx','A1:I3288');
train_y_NO2=xlsread('../input/pca_inp_train_NO2_ec.xlsx','J1:J3288');
train_y_O3=xlsread('../input/pca_inp_train_O3_ec.xlsx','J1:J3288');
train_data_NO2=[train_x train_y_NO2];
train_data_O3=[train_x train_y_O3];


%read validation data
valid_x=xlsread('../input/pca_inp_val_NO2_ec.xlsx','A1:I1095');
valid_y_NO2=xlsread('../input/pca_inp_val_NO2_ec.xlsx','J1:J1095');
valid_y_O3=xlsread('../input/pca_inp_val_O3_ec.xlsx','J1:J1095');
valid_data_NO2=[valid_x valid_y_NO2];
valid_data_O3=[valid_x valid_y_O3];

%read test data
test_x=xlsread('../input/pca_inp_test_NO2_ec.xlsx','A1:I1003');
test_y_NO2=xlsread('../input/pca_inp_test_NO2_ec.xlsx','J1:J1003');
test_y_O3=xlsread('../input/pca_inp_test_O3_ec.xlsx','J1:J1003');
test_data_NO2=[test_x test_y_NO2];
test_data_O3=[test_x test_y_O3];

%generate initial FIS using subtractive clustering
initialfis_NO2=genfis2(train_x,train_y_NO2,0.35)
initialfis_O3=genfis2(train_x,train_y_O3,0.35)

%train anfis for NO2
[outfis_NO2,error_NO2,stepsize_NO2,chkfis_NO2,chkerror_NO2]=anfis(train_data_NO2, initialfis_NO2,[150],[],valid_data_NO2);
%minimum training error
fisRMSE_NO2=min(error_NO2)
%minimum validation error
fisRMSevalidNO2=min(chkerror_NO2)

%train anfis for O3  
[outfis_O3,error_O3,stepsize_O3,chkfis_O3,chkerror_O3]=anfis(train_data_O3, initialfis_O3,[150],[],valid_data_O3);
%minimum training error
fisRMSE_O3=min(error_O3)
%minimum validation error
fisRMSevalidO3=min(chkerror_O3)

% showrule(initialfis_NO2)
% showrule(outfis_NO2)
%  writefis(outfis_NO2,'C:\Users\bahuguna\Documents\MATLAB\outfis_NO2.fis');

% showrule(initialfis_O3)
% showrule(outfis_O3);
% writefis(outfis_O3,'C:\Users\bahuguna\Documents\MATLAB\outfis_O3.fis');

%plot measured and predicted values with time for NO2 
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
 
%plot measured and predicted values with time for O3
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

% plot validation and training error (RMSE) with epochs during training for NO2
figure(3)
i = [1:150];
plot(i,error_NO2,'.b',i,chkerror_NO2,'*r');
legend('Training RMSE','Validation RMSE','Location','NorthWest');
title('RMSE Vs. epochs for NO2 concentration');
xlabel('Epoch');
ylabel('RMSE');

% plot validation and training error (RMSE) with epochs during training for O3
figure(4)
i = [1:150];
plot(i,error_O3,'.b',i,chkerror_O3,'*r');
legend('Training RMSE','Validation RMSE','Location','NorthWest');
title('RMSE Vs. epochs for O3 concentration');
xlabel('Epoch');
ylabel('RMSE');

%plot Training, Testing and Validation data Predicted Vs. Measured concentartion for NO2
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

%plot Training, Testing and Validation data Predicted Vs. Measured concentration for O3
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

% final NO2 RMSE on testing data
anfisOutput_NO2_test = evalfis(test_x,outfis_NO2);
l=size(test_y_NO2);
test_error_NO2=0;
for i=1:l(1)
    test_error_NO2=test_error_NO2+(test_y_NO2(i)-anfisOutput_NO2_test(i))^2;
end
test_error_NO2=test_error_NO2/l(1);
test_error_NO2=sqrt(test_error_NO2)

% final O3 RMSE on testing data
anfisOutput_O3_test = evalfis(test_x,outfis_O3);
l=size(test_y_O3);
test_error_O3=0;
for i=1:l(1)
    test_error_O3=test_error_O3+(test_y_O3(i)-anfisOutput_O3_test(i))^2;
end
test_error_O3=test_error_O3/l(1);
test_error_O3=sqrt(test_error_O3)
 
%read input values and standardize them
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

%Read pca matrix
pca_m=xlsread('../input/eign_vec_ec.xlsx','A1:I13');

%Convert to pca vector
ip_v=[std_ben std_bp std_co std_mpxy std_no std_no2 std_o3 std_rh std_so2 std_temp std_tol std_wd std_ws];
ip_pca=ip_v * pca_m;

%Calculate predicted values for NO2 and O3 and convert them to actual values
NO2_content=evalfis(ip_pca,outfis_NO2);
actual_NO2=NO2_content*(1.82236367e+03)+62.50785584;
O3_content=evalfis(ip_pca,outfis_O3);
actual_O3=O3_content*(2.84270779e+03)+87.5335371;

%display the results
disp(['NO2 predicted value(standardized): ',num2str(NO2_content)]);
disp(['NO2 predicted value(actual): ',num2str(actual_NO2)]);
disp(['O3 predicted value(standardized): ',num2str(O3_content)]);
disp(['O3 predicted value(actual): ',num2str(actual_O3)]);

%generate alert if predicted values cross threshold
threshold_NO2=200;
if(actual_NO2>=threshold_NO2)
   disp('High NO2 content.Alert!!!'); 
end
threshold_O3=100;
if(actual_O3>=threshold_O3)
   disp('High O3 content.Alert!!!'); 
end
