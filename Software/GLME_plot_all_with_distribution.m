function GLME_plot_all_with_distribution(FileName,Data_Healthy,Data_Active,Data_Remission,y_label,y_range)

x_Age = (7:0.01:19)';
for i = 1:1:size(x_Age,1)
    Subject_LR_fixed(i,:) = {'test'};
end

healthy_color=[0.1 0.8 0];
active_color=[0.9 0 0];
remission_color=[0 0.2 0.9];

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
s=gscatter(Data_Healthy.Age,eval(['Data_Healthy.' FileName]),New_g',[healthy_color ; healthy_color],'.o',[30 7]); hold on;
if glme.Coefficients.pValue(2)<0.06
    plot(x_Age, Mean_FC, 'k', 'LineWidth', 3); hold on; 
    plot(x_Age, CI, '--k','LineWidth', 1.5); hold on;
% elseif glme.Coefficients.pValue(2)>=0.05 & glme.Coefficients.pValue(2)<0.1
else
%     plot(x_Age, Mean_FC, 'Color',[0.5 0.5 0.5], 'LineWidth', 1); hold on; 
%     plot(x_Age, CI,'Color',[0.5 0.5 0.5],'LineStyle','--','LineWidth', 1.5); hold on;    
end
title(['p=' num2str(round(glme.Coefficients.pValue(2),3)) ', b=' num2str(round(glme.Coefficients.Estimate(2),3)) ...
    ', [' num2str(round(glme.Coefficients.Lower(2),3)) ' ' num2str(round(glme.Coefficients.Upper(2),3)) ,']'])

% violet plot
Data_Healthy_retest=Data_Healthy;
outlier_index=[];
% Left
data=s(1).YData;
xvalues = linspace( prctile(data,2.5), prctile(data,97.5), 100 );
outlier_index_buf=ismember(Data_Healthy.Side,'Left') & (eval(['Data_Healthy.' FileName]) < prctile(data,2.5) | eval(['Data_Healthy.' FileName]) > prctile(data,97.5));
outlier_index=[find(outlier_index_buf) ; outlier_index];
[f,xi] = ksdensity( data(:),xvalues,'Bandwidth',0.5,'BoundaryCorrection','reflection');
f=f/max(f);
p1=patch(21-[f,zeros(1,numel(xi),1),0],[xi,fliplr(xi),xi(1)],healthy_color);
p1.EdgeColor=healthy_color;
p1.LineWidth=2;

% Right
data=s(2).YData;
xvalues = linspace( prctile(data,2.5), prctile(data,97.5), 100 );
outlier_index_buf=ismember(Data_Healthy.Side,'Right') & (eval(['Data_Healthy.' FileName]) < prctile(data,2.5) | eval(['Data_Healthy.' FileName]) > prctile(data,97.5));
outlier_index=[find(outlier_index_buf) ; outlier_index];
[f,xi] = ksdensity( data(:),xvalues,'Bandwidth',0.5,'BoundaryCorrection','reflection');
f=f/max(f);
p2=patch( 21+[f,zeros(1,numel(xi),1),0],[xi,fliplr(xi),xi(1)],healthy_color);
p2.FaceColor='none';
p2.EdgeColor=healthy_color;
p2.LineWidth=2;

s(2).LineWidth=2;
axis square;
ll=legend('Location','northwest');
set(ll,'visible','off');
box off
set(gca,'fontsize',15,'LineWidth',2);
xlim([6 23])
xticks([8 10 12 14 16 18])
xticklabels({'8','10','12','14','16','18'})
yticks([-5 -4 -3 -2 -1 0])
yticklabels({'-5','-4','-3','-2','-1','0'})
ylim(y_range)
xlabel('Age (Years)','Fontsize',15)
% ylabel('rsfcMRI','Fontsize',15)
ylabel(y_label,'Fontsize',15)
set(gca,'fontsize',15,'LineWidth',2);

% retest after excluding outlier
disp(' ')
disp('Retest')
Data_Healthy_retest(outlier_index,:)=[];
glme = fitglme(Data_Healthy_retest,[FileName ' ~ Age + (1|ID)']);
display(glme.Formula)
display(glme.ModelCriterion)
display(glme.Coefficients)
subtitle(['p=' num2str(round(glme.Coefficients.pValue(2),3)) ', b=' num2str(round(glme.Coefficients.Estimate(2),3)) ...
    ', [' num2str(round(glme.Coefficients.Lower(2),3)) ' ' num2str(round(glme.Coefficients.Upper(2),3)) ,'], ol=' ...
    num2str(length(outlier_index))])

disp(' ')
disp(' ')
disp(' ')
disp(' ')


%% Active
glme = fitglme(Data_Active,[FileName ' ~ Age + (1|ID)']);
display(glme.Formula)
display(glme.ModelCriterion)
display(glme.Coefficients)

Predict_input_table = table(x_Age,Subject_LR_fixed,'VariableNames',{'Age','ID'}) ;
[Mean_FC, CI ] = predict(glme,Predict_input_table,'Conditional',false);
New_g=strcat(Data_Active.Group',{', '},Data_Active.Side');
subplot(1,3,2)
s=gscatter(Data_Active.Age,eval(['Data_Active.' FileName]),New_g',[active_color ; active_color],'.o',[30 7]); hold on;
if glme.Coefficients.pValue(2)<0.06
    plot(x_Age, Mean_FC, 'k', 'LineWidth', 3); hold on; 
    plot(x_Age, CI, '--k','LineWidth', 1.5); hold on;
% elseif glme.Coefficients.pValue(2)>=0.05 & glme.Coefficients.pValue(2)<0.1
else
%     plot(x_Age, Mean_FC, 'Color',[0.5 0.5 0.5], 'LineWidth', 1); hold on; 
%     plot(x_Age, CI,'Color',[0.5 0.5 0.5],'LineStyle','--','LineWidth', 1.5); hold on;    
end
title(['p=' num2str(round(glme.Coefficients.pValue(2),3)) ', b=' num2str(round(glme.Coefficients.Estimate(2),3)) ...
    ', [' num2str(round(glme.Coefficients.Lower(2),3)) ' ' num2str(round(glme.Coefficients.Upper(2),3)) ,']'])

% violet plot
Data_Active_retest=Data_Active;
outlier_index=[];
% Left
data=s(1).YData;
xvalues = linspace( prctile(data,2.5), prctile(data,97.5), 100 );
outlier_index_buf=ismember(Data_Active.Side,'Left') & (eval(['Data_Active.' FileName]) < prctile(data,2.5) | eval(['Data_Active.' FileName]) > prctile(data,97.5));
outlier_index=[find(outlier_index_buf) ; outlier_index];
[f,xi] = ksdensity( data(:),xvalues,'Bandwidth',0.5,'BoundaryCorrection','reflection');
f=f/max(f);
p1=patch(21-[f,zeros(1,numel(xi),1),0],[xi,fliplr(xi),xi(1)],active_color);
p1.EdgeColor=active_color;
p1.LineWidth=2;

% Right
data=s(2).YData;
xvalues = linspace( prctile(data,2.5), prctile(data,97.5), 100 );
outlier_index_buf=ismember(Data_Active.Side,'Right') & (eval(['Data_Active.' FileName]) < prctile(data,2.5) | eval(['Data_Active.' FileName]) > prctile(data,97.5));
outlier_index=[find(outlier_index_buf) ; outlier_index];
[f,xi] = ksdensity( data(:),xvalues,'Bandwidth',0.5,'BoundaryCorrection','reflection');
f=f/max(f);
p2=patch( 21+[f,zeros(1,numel(xi),1),0],[xi,fliplr(xi),xi(1)],active_color);
p2.FaceColor='none';
p2.EdgeColor=active_color;
p2.LineWidth=2;

s(2).LineWidth=2;
axis square;
ll=legend('Location','northwest');
set(ll,'visible','off');
box off
set(gca,'fontsize',15,'LineWidth',2);
xlim([6 23])
xticks([8 10 12 14 16 18])
xticklabels({'8','10','12','14','16','18'})
yticks([-5 -4 -3 -2 -1 0])
yticklabels({'-5','-4','-3','-2','-1','0'})
ylim(y_range)
xlabel('Age (Years)','Fontsize',15)
% ylabel('rsfcMRI','Fontsize',15)
ylabel(y_label,'Fontsize',15)
set(gca,'fontsize',15,'LineWidth',2);

% retest after excluding outlier
disp(' ')
disp('Retest')
Data_Active_retest(outlier_index,:)=[];
glme = fitglme(Data_Active_retest,[FileName ' ~ Age + (1|ID)']);
display(glme.Formula)
display(glme.ModelCriterion)
display(glme.Coefficients)
subtitle(['p=' num2str(round(glme.Coefficients.pValue(2),3)) ', b=' num2str(round(glme.Coefficients.Estimate(2),3)) ...
    ', [' num2str(round(glme.Coefficients.Lower(2),3)) ' ' num2str(round(glme.Coefficients.Upper(2),3)) ,'], ol=' ...
    num2str(length(outlier_index))])

disp(' ')
disp(' ')
disp(' ')
disp(' ')


%% Remission
glme = fitglme(Data_Remission,[FileName ' ~ Age + (1|ID)']);
display(glme.Formula)
display(glme.ModelCriterion)
display(glme.Coefficients)

Predict_input_table = table(x_Age,Subject_LR_fixed,'VariableNames',{'Age','ID'}) ;
[Mean_FC, CI ] = predict(glme,Predict_input_table,'Conditional',false);
New_g=strcat(Data_Remission.Group',{', '},Data_Remission.Side');
subplot(1,3,3)
s=gscatter(Data_Remission.Age,eval(['Data_Remission.' FileName]),New_g',[remission_color ; remission_color],'.o',[30 7]); hold on;
if glme.Coefficients.pValue(2)<0.06
    plot(x_Age, Mean_FC, 'k', 'LineWidth', 3); hold on; 
    plot(x_Age, CI, '--k','LineWidth', 1.5); hold on;
% elseif glme.Coefficients.pValue(2)>=0.05 & glme.Coefficients.pValue(2)<0.1
else
%     plot(x_Age, Mean_FC, 'Color',[0.5 0.5 0.5], 'LineWidth', 1); hold on; 
%     plot(x_Age, CI,'Color',[0.5 0.5 0.5],'LineStyle','--','LineWidth', 1.5); hold on;    
end
title(['p=' num2str(round(glme.Coefficients.pValue(2),3)) ', b=' num2str(round(glme.Coefficients.Estimate(2),3)) ...
    ', [' num2str(round(glme.Coefficients.Lower(2),3)) ' ' num2str(round(glme.Coefficients.Upper(2),3)) ,']'])

% violet plot
Data_Remission_retest=Data_Remission;
outlier_index=[];
% Left
data=s(1).YData;
xvalues = linspace( prctile(data,2.5), prctile(data,97.5), 100 );
outlier_index_buf=ismember(Data_Remission.Side,'Left') & (eval(['Data_Remission.' FileName]) < prctile(data,2.5) | eval(['Data_Remission.' FileName]) > prctile(data,97.5));
outlier_index=[find(outlier_index_buf) ; outlier_index];
[f,xi] = ksdensity( data(:),xvalues,'Bandwidth',0.5,'BoundaryCorrection','reflection');
f=f/max(f);
p1=patch(21-[f,zeros(1,numel(xi),1),0],[xi,fliplr(xi),xi(1)],remission_color);
p1.EdgeColor=remission_color;
p1.LineWidth=2;

% Right
data=s(2).YData;
xvalues = linspace( prctile(data,2.5), prctile(data,97.5), 100 );
outlier_index_buf=ismember(Data_Remission.Side,'Right') & (eval(['Data_Remission.' FileName]) < prctile(data,2.5) | eval(['Data_Remission.' FileName]) > prctile(data,97.5));
outlier_index=[find(outlier_index_buf) ; outlier_index];
[f,xi] = ksdensity( data(:),xvalues,'Bandwidth',0.5,'BoundaryCorrection','reflection');
f=f/max(f);
p2=patch( 21+[f,zeros(1,numel(xi),1),0],[xi,fliplr(xi),xi(1)],remission_color);
p2.FaceColor='none';
p2.EdgeColor=remission_color;
p2.LineWidth=2;

s(2).LineWidth=2;
axis square;
ll=legend('Location','northwest');
set(ll,'visible','off');
box off
set(gca,'fontsize',15,'LineWidth',2);
xlim([6 23])
xticks([8 10 12 14 16 18])
xticklabels({'8','10','12','14','16','18'})
yticks([-5 -4 -3 -2 -1 0])
yticklabels({'-5','-4','-3','-2','-1','0'})
ylim(y_range)
xlabel('Age (Years)','Fontsize',15)
% ylabel('rsfcMRI','Fontsize',15)
ylabel(y_label,'Fontsize',15)
set(gca,'fontsize',15,'LineWidth',2);

% retest after excluding outlier
disp(' ')
disp('Retest')
Data_Remission_retest(outlier_index,:)=[];
glme = fitglme(Data_Remission_retest,[FileName ' ~ Age + (1|ID)']);
display(glme.Formula)
display(glme.ModelCriterion)
display(glme.Coefficients)
subtitle(['p=' num2str(round(glme.Coefficients.pValue(2),3)) ', b=' num2str(round(glme.Coefficients.Estimate(2),3)) ...
    ', [' num2str(round(glme.Coefficients.Lower(2),3)) ' ' num2str(round(glme.Coefficients.Upper(2),3)) ,'], ol=' ...
    num2str(length(outlier_index))])

disp(' ')
disp(' ')
disp(' ')
disp(' ')
end