function GLME_plot_inter_SC_FC(FileName,Data_Healthy,Data_Active,Data_Remission,x_range,y_range)

% x_var = (min(x_range):0.001:max(x_range))';
x_var = [min(x_range):0.001:max(x_range)]';
for i = 1:1:size(x_var,1)
    Subject_LR_fixed(i,:) = {'test'};
end

figure('position',[0 0 1500 600],'visible','on');
set(gcf,'color', [1 1 1]);
% sgt = sgtitle(FileName,'Interpreter', 'none');
% sgt.FontSize = 20;
% sgt.FontWeight = 'bold';  

%% Healthy
glme = fitglme(Data_Healthy,[['FC_' FileName] ' ~ ' ['SC_' FileName] '  + (1|ID)']);
display(glme.Formula)
display(glme.Coefficients)

Predict_input_table = table(x_var,Subject_LR_fixed,'VariableNames',{['SC_' FileName],'ID'}) ;
[Mean_FC, CI ] = predict(glme,Predict_input_table,'Conditional',false);
New_g=strcat(Data_Healthy.Group',{', '},Data_Healthy.Side');
subplot(1,3,1)
s=gscatter(eval(['Data_Healthy.SC_' FileName]),eval(['Data_Healthy.FC_' FileName]),New_g',[0.1 0.8 0 ; 0.1 0.8 0],'.o',[30 7]); hold on;
if glme.Coefficients.pValue(2)<0.05
    plot(x_var, Mean_FC, 'k', 'LineWidth', 3); hold on; 
    plot(x_var, CI, '--k','LineWidth', 1.5); hold on;
% elseif glme.Coefficients.pValue(2)>=0.05 & glme.Coefficients.pValue(2)<0.1
else
%     plot(x_var, Mean_FC, 'Color',[0.5 0.5 0.5], 'LineWidth', 1); hold on; 
%     plot(x_var, CI,'Color',[0.5 0.5 0.5],'LineStyle','--','LineWidth', 1.5); hold on;    
end
title(['p=' num2str(round(glme.Coefficients.pValue(2),3)) ', b=' num2str(round(glme.Coefficients.Estimate(2),3)) ])
s(2).LineWidth=2;
axis square;
ll=legend('Location','northwest');
set(ll,'visible','off');
box off
set(gca,'fontsize',15,'LineWidth',2);
xlim(x_range)
ylim(y_range)
ylabel('Functional Connectivity','Fontsize',15)
% ylabel('rsfcMRI','Fontsize',15)
xlabel('Structural Connectivity','Fontsize',15)
set(gca,'fontsize',15,'LineWidth',2);

%% Active
glme = fitglme(Data_Active,[['FC_' FileName] ' ~ ' ['SC_' FileName] ' + (1|ID)']);
display(glme.Formula)
display(glme.Coefficients)

Predict_input_table = table(x_var,Subject_LR_fixed,'VariableNames',{['SC_' FileName],'ID'}) ;
% [Mean_FC, CI ] = predict(glme);
[Mean_FC, CI ] = predict(glme,Predict_input_table,'Conditional',false);
New_g=strcat(Data_Active.Group',{', '},Data_Active.Side');
subplot(1,3,2)
s=gscatter(eval(['Data_Active.SC_' FileName]),eval(['Data_Active.FC_' FileName]),New_g',[0.9 0 0 ; 0.9 0 0],'.o',[30 7]); hold on;
if glme.Coefficients.pValue(2)<0.05
    plot(x_var, Mean_FC, 'k', 'LineWidth', 3); hold on; 
    plot(x_var, CI, '--k','LineWidth', 1.5); hold on;
% elseif glme.Coefficients.pValue(2)>=0.05 & glme.Coefficients.pValue(2)<0.1
else
%     plot(x_var, Mean_FC, 'Color',[0.5 0.5 0.5], 'LineWidth', 1); hold on; 
%     plot(x_var, CI,'Color',[0.5 0.5 0.5],'LineStyle','--','LineWidth', 1.5); hold on;    
end
title(['p=' num2str(round(glme.Coefficients.pValue(2),3)) ', b=' num2str(round(glme.Coefficients.Estimate(2),3)) ])
s(2).LineWidth=2;
axis square;
ll=legend('Location','northwest');
set(ll,'visible','off');
box off
set(gca,'fontsize',15,'LineWidth',2);
xlim(x_range)
ylim(y_range)
ylabel('Functional Connectivity','Fontsize',15)
% ylabel('rsfcMRI','Fontsize',15)
xlabel('Structural Connectivity','Fontsize',15)
set(gca,'fontsize',15,'LineWidth',2);

%% Remission
glme = fitglme(Data_Remission,[['FC_' FileName] ' ~ ' ['SC_' FileName] '  + (1|ID)']);
display(glme.Formula)
display(glme.Coefficients)

Predict_input_table = table(x_var,Subject_LR_fixed,'VariableNames',{['SC_' FileName],'ID'}) ;
[Mean_FC, CI ] = predict(glme,Predict_input_table,'Conditional',false);
New_g=strcat(Data_Remission.Group',{', '},Data_Remission.Side');
subplot(1,3,3)
s=gscatter(eval(['Data_Remission.SC_' FileName]),eval(['Data_Remission.FC_' FileName]),New_g',[0 0.2 0.9 ; 0 0.2 0.9],'.o',[30 7]); hold on;
if glme.Coefficients.pValue(2)<0.05
    plot(x_var, Mean_FC, 'k', 'LineWidth', 3); hold on; 
    plot(x_var, CI, '--k','LineWidth', 1.5); hold on;
% elseif glme.Coefficients.pValue(2)>=0.05 & glme.Coefficients.pValue(2)<0.1
else
%     plot(x_var, Mean_FC, 'Color',[0.5 0.5 0.5], 'LineWidth', 1); hold on; 
%     plot(x_var, CI,'Color',[0.5 0.5 0.5],'LineStyle','--','LineWidth', 1.5); hold on;    
end
title(['p=' num2str(round(glme.Coefficients.pValue(2),3)) ', b=' num2str(round(glme.Coefficients.Estimate(2),3)) ])
s(2).LineWidth=2;
axis square;
ll=legend('Location','northwest');
set(ll,'visible','off');
box off
set(gca,'fontsize',15,'LineWidth',2);
xlim(x_range)
ylim(y_range)
ylabel('Functional Connectivity','Fontsize',15)
% ylabel('rsfcMRI','Fontsize',15)
xlabel('Structural Connectivity','Fontsize',15)
set(gca,'fontsize',15,'LineWidth',2);

end