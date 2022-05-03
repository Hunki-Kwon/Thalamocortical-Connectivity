%% general setting
clc;clear;
cd('C:\Users\Hunki Kwon\Dropbox (Personal)\Work\MGH\fMRI')

result_folder='results_Sensory2Motor_041622_final_distribution';
suffix1='EEGActive';
% suffix1='ClinicActive';

%% Setting
result_folder=[result_folder '_' suffix1];
mkdir(result_folder)
suffix2='001_008_Inferior_with_Motor2Sensory';
Data = readtable(['FC_BECTS_pCECTS_rest_open_all_info_Final_' suffix2 '.xlsx'],'Sheet',['Data_' suffix1],'Format','auto');

Data(Data.Final_decision==0,:)=[];
% Data(Data.Age>11,:)=[];

%% Log scale
Data.SC_VL2InferiorMotor   = log10(Data.SC_VL2InferiorMotor);     if any(~isfinite(Data.SC_VL2InferiorMotor)); fprintf('\n-Inf\n'); end
Data.FC_VL2InferiorMotor   = log10(Data.FC_VL2InferiorMotor);     if any(~isfinite(Data.FC_VL2InferiorMotor)); fprintf('\n-Inf\n'); end
Data.SC_VP2InferiorSensory = log10(Data.SC_VP2InferiorSensory);   if any(~isfinite(Data.SC_VP2InferiorSensory)); fprintf('\n-Inf\n'); end
Data.FC_VP2InferiorSensory = log10(Data.FC_VP2InferiorSensory);   if any(~isfinite(Data.FC_VP2InferiorSensory)); fprintf('\n-Inf\n'); end

Data.SC_Thal2Rolandic      = log10(Data.SC_Thal2Rolandic);        if any(~isfinite(Data.SC_Thal2Rolandic)); fprintf('\n-Inf\n'); end
Data.FC_Thal2Rolandic      = log10(Data.FC_Thal2Rolandic);        if any(~isfinite(Data.FC_Thal2Rolandic)); fprintf('\n-Inf\n'); end
Data.SC_Thal2InferiorRolandic   = log10(Data.SC_Thal2InferiorRolandic);     if any(~isfinite(Data.SC_Thal2InferiorRolandic)); fprintf('\n-Inf\n'); end
Data.FC_Thal2InferiorRolandic   = log10(Data.FC_Thal2InferiorRolandic);     if any(~isfinite(Data.FC_Thal2InferiorRolandic)); fprintf('\n-Inf\n'); end

% Data.EpilepsyDuration_m = log10(Data.EpilepsyDuration_m);  if any(~isfinite(Data.EpilepsyDuration_m)); fprintf('\n-Inf\n'); end

%% Assign data

% all
Index1 = find(contains(Data.Group,'SeizureFree'));
Data(Index1,4)={'Remission'};

% Active
Index_Active = find(contains(Data.Group,'Active'));
Data_Active=Data(Index_Active,:);

% Healthy
Index_Healthy = find(contains(Data.Group,'Healthy'));
Data_Healthy=Data(Index_Healthy,:);

% Remission
Index_Remission = find(contains(Data.Group,'Remission'));
Data_Remission=Data(Index_Remission,:);

% Combine
Data.Group_Rolandic=Data.Group_Active+Data.Group_Remission;
Data_Rolandic=Data(find(Data.Group_Rolandic==1),:);
for r_i=1:length(Data_Rolandic.Group)
    Data_Rolandic.Group(r_i)={'Rolandic'};
end

Data.Group_HealthyActive=Data.Group_Healthy+Data.Group_Active;
Data_HealthyActive=Data(find(Data.Group_HealthyActive==1),:);

%% Figure FC Sensory2Motor: Healthy, Rolandic, Active and Remission
% GLME: connectivity~1+age+group+age*group+ 1|subject

clc;
FileName='FC_Thal2Rolandic';
y_label='Functional connectivity';
delete([result_folder '/' FileName '.log'])
diary([result_folder '/' FileName '.log'])
glme = fitglme(Data,[FileName ' ~ Gender + Age*(Group_Active + Group_Remission)+ (1|ID)']);
% glme = fitglme(Data,[FileName ' ~ Gender + Age*(Group_Healthy + Group_Remission)+ (1|ID)']);
display(glme.Formula)
display(glme.Coefficients)
% GLME_plot_all(FileName,Data_Healthy,Data_Active,Data_Remission,y_label,[-2.5 0.4]);
% GLME_plot_all(FileName,Data_Healthy,Data_Active,Data_Remission,y_label,[-3.5 0.5]);
GLME_plot_all_with_distribution(FileName,Data_Healthy,Data_Active,Data_Remission,y_label,[-3.5 0.5]);
diary off

% set(gca,'LooseInset',get(gca,'TightInset'));
print('-dtiff','-r300',[result_folder '/' FileName])
saveas(gcf,[result_folder '/' FileName],'epsc')
close all;

% clc;
% FileName='FC_Thal2InferiorRolandic';
% y_label='Functional connectivity';
% delete([result_folder '/' FileName '.log'])
% diary([result_folder '/' FileName '.log'])
% % glme = fitglme(Data,[FileName ' ~  Age*(Group_Active + Group_Remission)+ (1|ID)']);
% % glme = fitglme(Data,[FileName ' ~  Group_Active + Group_Remission+ (1|ID)']);
% display(glme.Formula)
% display(glme.Coefficients)
% GLME_plot_all(FileName,Data_Healthy,Data_Active,Data_Remission,y_label,[-2.5 0.4]);
% % GLME_plot_all(FileName,Data_Healthy,Data_Active,Data_Remission,y_label,[0 0.7]);
% diary off
% % set(gca,'LooseInset',get(gca,'TightInset'));
% print('-dtiff','-r300',[result_folder '/' FileName])
% saveas(gcf,[result_folder '/' FileName],'epsc')
% close all;

clc;
FileName='FC_VP2InferiorSensory';
y_label='Functional connectivity';
delete([result_folder '/' FileName '.log'])
diary([result_folder '/' FileName '.log'])
glme = fitglme(Data,[FileName ' ~ Gender + Age*(Group_Active + Group_Remission)+ (1|ID)']);
% glme = fitglme(Data,[FileName ' ~ Gender + Age*(Group_Healthy + Group_Remission)+ (1|ID)']);
display(glme.Formula)
display(glme.Coefficients)
% GLME_plot_all(FileName,Data_Healthy,Data_Active,Data_Remission,y_label,[-3 0.5]);
GLME_plot_all_with_distribution(FileName,Data_Healthy,Data_Active,Data_Remission,y_label,[-3 0.5]);

diary off
print('-dtiff','-r300',[result_folder '/' FileName])
saveas(gcf,[result_folder '/' FileName],'epsc')
close all;

clc;
FileName='FC_VL2InferiorMotor';
y_label='Functional connectivity';
delete([result_folder '/' FileName '.log'])
diary([result_folder '/' FileName '.log'])
glme = fitglme(Data,[FileName ' ~ Age*Group_Active + Age*Group_Remission+ (1|ID)']);
% glme = fitglme(Data,[FileName ' ~ Group_Active + Group_Remission+ (1|ID)']);
% glme = fitglme(Data,[FileName ' ~ Gender + Age*(Group_Healthy + Group_Remission)+ (1|ID)']);
% glme = fitglme(Data_HealthyActive,[FileName ' ~  Age*Group_Active + (1|ID)']);
display(glme.Formula)
display(glme.Coefficients)
% GLME_plot_all(FileName,Data_Healthy,Data_Active,Data_Remission,y_label,[-2.5 0.4]);
% GLME_plot_all(FileName,Data_Healthy,Data_Active,Data_Remission,y_label,[-5 0.5]);
GLME_plot_all_with_distribution(FileName,Data_Healthy,Data_Active,Data_Remission,y_label,[-5 0.5]);
diary off

print('-dtiff','-r300',[result_folder '/' FileName])
saveas(gcf,[result_folder '/' FileName],'epsc')
close all;

%% Figure SC Sensory2Motor: Healthy, Rolandic, Active and Remission
clc;
FileName='SC_Thal2Rolandic';
y_label='Structural connectivity';
delete([result_folder '/' FileName '.log'])
diary([result_folder '/' FileName '.log'])
glme = fitglme(Data,[FileName ' ~ Gender + Age*(Group_Active + Group_Remission)+ (1|ID)']);
display(glme.Formula)
display(glme.Coefficients)
% GLME_plot_all(FileName,Data_Healthy,Data_Active,Data_Remission,y_label,[-2.1 -0.8]);
GLME_plot_all_with_distribution(FileName,Data_Healthy,Data_Active,Data_Remission,y_label,[-2.1 -0.8]);
diary off
print('-dtiff','-r300',[result_folder '/' FileName])
saveas(gcf,[result_folder '/' FileName],'epsc')
close all;

% clc;
% FileName='SC_Thal2InferiorRolandic';
% y_label='Structural connectivity';
% delete([result_folder '/' FileName '.log'])
% diary([result_folder '/' FileName '.log'])
% glme = fitglme(Data,[FileName ' ~ Gender + Age*(Group_Active + Group_Remission)+ (1|ID)']);
% display(glme.Formula)
% display(glme.Coefficients)
% GLME_plot_all(FileName,Data_Healthy,Data_Active,Data_Remission,y_label,[-4.2 -1.4]);
% % GLME_plot_all(FileName,Data_Healthy,Data_Active,Data_Remission,y_label,[0 0.15]);
% diary off
% % set(gca,'LooseInset',get(gca,'TightInset'));
% print('-dtiff','-r300',[result_folder '/' FileName])
% saveas(gcf,[result_folder '/' FileName],'epsc')
% close all;


clc;
FileName='SC_VP2InferiorSensory';
y_label='Structural connectivity';
delete([result_folder '/' FileName '.log'])
diary([result_folder '/' FileName '.log'])
glme = fitglme(Data,[FileName ' ~ Gender + Age*(Group_Active + Group_Remission)+ (1|ID)']);
display(glme.Formula)
display(glme.Coefficients)
% GLME_plot_all(FileName,Data_Healthy,Data_Active,Data_Remission,y_label,[-5 -1]);
GLME_plot_all_with_distribution(FileName,Data_Healthy,Data_Active,Data_Remission,y_label,[-5 -1]);
diary off
print('-dtiff','-r300',[result_folder '/' FileName])
saveas(gcf,[result_folder '/' FileName],'epsc')
close all;

clc;
FileName='SC_VL2InferiorMotor';
y_label='Structural connectivity';
delete([result_folder '/' FileName '.log'])
diary([result_folder '/' FileName '.log'])
glme = fitglme(Data,[FileName ' ~ Gender + Age*(Group_Active + Group_Remission)+ (1|ID)']);
display(glme.Formula)
display(glme.Coefficients)
% GLME_plot_all(FileName,Data_Healthy,Data_Active,Data_Remission,y_label,[-4.2 -1.4]);
GLME_plot_all_with_distribution(FileName,Data_Healthy,Data_Active,Data_Remission,y_label,[-4.2 -1.4]);

diary off
print('-dtiff','-r300',[result_folder '/' FileName])
saveas(gcf,[result_folder '/' FileName],'epsc')
close all;

%% Figure SC FC Sensory2Motor: Healthy, Rolandic, Active and Remission
clc;
FileName='Thal2Rolandic';
delete([result_folder '/SC_FC_' FileName '.log'])
diary([result_folder '/SC_FC_' FileName '.log'])
GLME_plot_inter_SC_FC(FileName,Data_Healthy,Data_Active,Data_Remission,[-2.1 -0.8],[-3.5 0.5])
% GLME_plot_inter_SC_FC(FileName,Data_Healthy,Data_Active,Data_Remission,[0 0.15],[0 0.7])
diary off
print('-dtiff','-r300',[result_folder '/SC_FC_' FileName])
saveas(gcf,[result_folder '/SC_FC_' FileName],'epsc')
close all;

clc;
FileName='VP2InferiorSensory';
delete([result_folder '/SC_FC_' FileName '.log'])
diary([result_folder '/SC_FC_' FileName '.log'])
GLME_plot_inter_SC_FC(FileName,Data_Healthy,Data_Active,Data_Remission,[-5 -1],[-3 0.5])
diary off
print('-dtiff','-r300',[result_folder '/SC_FC_' FileName])
saveas(gcf,[result_folder '/SC_FC_' FileName],'epsc')
close all;

clc;
FileName='VL2InferiorMotor';
delete([result_folder '/SC_FC_' FileName '.log'])
diary([result_folder '/SC_FC_' FileName '.log'])
GLME_plot_inter_SC_FC(FileName,Data_Healthy,Data_Active,Data_Remission,[-4.2 -1.4],[-5 0.5])
% GLME_plot_inter_SC_FC(FileName,Data_Healthy,Data_Active,Data_Remission,[0 0.01],[0 0.7])
diary off
print('-dtiff','-r300',[result_folder '/SC_FC_' FileName])
saveas(gcf,[result_folder '/SC_FC_' FileName],'epsc')
close all;


