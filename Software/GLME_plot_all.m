function GLME_plot_all(FileName,Data_Healthy,Data_Active,Data_Remission,y_label,y_range)

x_Age = (7:0.01:19)';
for i = 1:1:size(x_Age,1)
    Subject_LR_fixed(i,:) = {'test'};
end

figure('position',[0 0 1500 600],'visible','on');
set(gcf,'color', [1 1 1]);
% sgt = sgtitle(FileName,'Interpreter', 'none');
% sgt.FontSize = 20;
% sgt.FontWeight = 'bold';  

%% Healthy
glme = fitglme(Data_Healthy,[FileName ' ~ Age + (1|ID)']);
display(glme.Formula)
display(glme.ModelCriterion)
display(glme.Coefficients)

Predict_input_table = table(x_Age,Subject_LR_fixed,'VariableNames',{'Age','ID'}) ;
[Mean_FC, CI ] = predict(glme,Predict_input_table,'Conditional',false);
New_g=strcat(Data_Healthy.Group',{', '},Data_Healthy.Side');
subplot(1,3,1)
% s=gscatter(Data_Healthy.Age,eval(['Data_Healthy.' FileName]),New_g',[0.4660 0.6740 0.1880 ; 0.4660 0.6740 0.1880],'.o',[30 7]); hold on;
s=gscatter(Data_Healthy.Age,eval(['Data_Healthy.' FileName]),New_g',[0.1 0.8 0 ; 0.1 0.8 0],'.o',[30 7]); hold on;
if glme.Coefficients.pValue(2)<0.06
    plot(x_Age, Mean_FC, 'k', 'LineWidth', 3); hold on; 
    plot(x_Age, CI, '--k','LineWidth', 1.5); hold on;
% elseif glme.Coefficients.pValue(2)>=0.05 & glme.Coefficients.pValue(2)<0.1
else
%     plot(x_Age, Mean_FC, 'Color',[0.5 0.5 0.5], 'LineWidth', 1); hold on; 
%     plot(x_Age, CI,'Color',[0.5 0.5 0.5],'LineStyle','--','LineWidth', 1.5); hold on;    
end
title(['p=' num2str(round(glme.Coefficients.pValue(2),3)) ', b=' num2str(round(glme.Coefficients.Estimate(2),3)) ])
s(2).LineWidth=2;
axis square;
ll=legend('Location','northwest');
set(ll,'visible','off');
box off
set(gca,'fontsize',15,'LineWidth',2);
xlim([6 20])
xticks([8 10 12 14 16 18])
xticklabels({'8','10','12','14','16','18'})
ylim(y_range)
xlabel('Age (Years)','Fontsize',15)
% ylabel('rsfcMRI','Fontsize',15)
ylabel(y_label,'Fontsize',15)
set(gca,'fontsize',15,'LineWidth',2);

%% Active
glme = fitglme(Data_Active,[FileName ' ~ Age + (1|ID)']);
% [~,~,stats] = fixedEffects(glme)
display(glme.Formula)
display(glme.ModelCriterion)
display(glme.Coefficients)

Predict_input_table = table(x_Age,Subject_LR_fixed,'VariableNames',{'Age','ID'}) ;
[Mean_FC, CI ] = predict(glme,Predict_input_table,'Conditional',false);
New_g=strcat(Data_Active.Group',{', '},Data_Active.Side');
subplot(1,3,2)
% s=gscatter(Data_Active.Age,eval(['Data_Active.' FileName]),New_g',[0.8500 0.3250 0.0980 ; 0.8500 0.3250 0.0980],'.o',[30 7]); hold on;
s=gscatter(Data_Active.Age,eval(['Data_Active.' FileName]),New_g',[0.9 0 0 ; 0.9 0 0],'.o',[30 7]); hold on;
if glme.Coefficients.pValue(2)<0.05
    plot(x_Age, Mean_FC, 'k', 'LineWidth', 3); hold on; 
    plot(x_Age, CI, '--k','LineWidth', 1.5); hold on;
% elseif glme.Coefficients.pValue(2)>=0.05 & glme.Coefficients.pValue(2)<0.1
else
%     plot(x_Age, Mean_FC, 'Color',[0.5 0.5 0.5], 'LineWidth', 1); hold on; 
%     plot(x_Age, CI,'Color',[0.5 0.5 0.5],'LineStyle','--','LineWidth', 1.5); hold on;    
end
title(['p=' num2str(round(glme.Coefficients.pValue(2),3)) ', b=' num2str(round(glme.Coefficients.Estimate(2),3)) ])
s(2).LineWidth=2;
axis square;
ll=legend('Location','northwest');
set(ll,'visible','off');
box off
set(gca,'fontsize',15,'LineWidth',2);
xlim([6 20])
xticks([8 10 12 14 16 18])
xticklabels({'8','10','12','14','16','18'})
ylim(y_range)
xlabel('Age (Years)','Fontsize',15)
% ylabel('rsfcMRI','Fontsize',15)
ylabel(y_label,'Fontsize',15)
set(gca,'fontsize',15,'LineWidth',2);

%% Remission
glme = fitglme(Data_Remission,[FileName ' ~ Age + (1|ID)']);
display(glme.ModelCriterion)
display(glme.Formula)
display(glme.Coefficients)

Predict_input_table = table(x_Age,Subject_LR_fixed,'VariableNames',{'Age','ID'}) ;
[Mean_FC, CI ] = predict(glme,Predict_input_table,'Conditional',false);
New_g=strcat(Data_Remission.Group',{', '},Data_Remission.Side');
subplot(1,3,3)
% s=gscatter(Data_Remission.Age,eval(['Data_Remission.' FileName]),New_g',[0 0.4470 0.7410 ; 0 0.4470 0.7410],'.o',[30 7]); hold on;
s=gscatter(Data_Remission.Age,eval(['Data_Remission.' FileName]),New_g',[0 0.2 0.9 ; 0 0.2 0.9],'.o',[30 7]); hold on;
if glme.Coefficients.pValue(2)<0.05
    plot(x_Age, Mean_FC, 'k', 'LineWidth', 3); hold on; 
    plot(x_Age, CI, '--k','LineWidth', 1.5); hold on;
% elseif glme.Coefficients.pValue(2)>=0.05 & glme.Coefficients.pValue(2)<0.1
else
%     plot(x_Age, Mean_FC, 'Color',[0.5 0.5 0.5], 'LineWidth', 1); hold on; 
%     plot(x_Age, CI,'Color',[0.5 0.5 0.5],'LineStyle','--','LineWidth', 1.5); hold on;    
end
title(['p=' num2str(round(glme.Coefficients.pValue(2),3)) ', b=' num2str(round(glme.Coefficients.Estimate(2),3)) ])
s(2).LineWidth=2;
axis square;
ll=legend('Location','northwest');
set(ll,'visible','off');
box off
set(gca,'fontsize',15,'LineWidth',2);
xlim([6 20])
xticks([8 10 12 14 16 18])
xticklabels({'8','10','12','14','16','18'})
ylim(y_range)
xlabel('Age (Years)','Fontsize',15)
% ylabel('rsfcMRI','Fontsize',15)
ylabel(y_label,'Fontsize',15)
set(gca,'fontsize',15,'LineWidth',2);

end