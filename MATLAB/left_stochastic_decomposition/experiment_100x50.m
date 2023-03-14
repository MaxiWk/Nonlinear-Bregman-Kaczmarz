clear
clc

addpath(genpath('../')) 

fprintf('\n Experiment Left stochastic decomposition with r=100, m=50\n')

num_examples = 50;

solvers = {LSD_PNK, ...
           LSD_rNBK, ...
           LSD_NBK(struct(...
           'make_projection_feasibility_check', true, ...
           'tol_linesearch', 1e-9, ...
           'linesearch_optimizer', 'Newton')), ...
           };
writeout = true;


%% run experiments

% 1
disp('1/2')
problem_data = struct( 'system_size', struct('r', 100, 'm', 50), ...                        
                       'sol_distr', struct('type','random_uniform'), ... 
                       'init_properties', struct('type', 'random_uniform') ); 
iter_save_fig1 = 1e4; 
maxiter_fig1 = 2.5e5;
experiment_fig1 = experiment( @left_stochastic_decomposition, ...
                              problem_data, ...
                              solvers, ...
                              num_examples, ...
                              iteration_stopping(struct('iter_save', iter_save_fig1, ...
                                                        'maxiter', maxiter_fig1)), ...
                              {'residual', 'num_empty_intersections'}, ...
                              1/problem_data.system_size.m * ones(1, problem_data.system_size.m), ...
                              struct( ...
                              'random_seed_for_problem', struct('start',1,'increment',1), ...
                              'random_seed_for_solvers', struct('start',0,'increment',0)) );  
stats_fig1 = experiment_fig1.run(); 



% 2
disp('2/2')
experiment_fig2 = experiment( @left_stochastic_decomposition, ...
                              problem_data, ...
                              solvers, ...
                              num_examples, ...
                              runtime_stopping(struct('iter_save', iter_save_fig1, ...
                                                        'max_time', 10)), ...
                              {'residual', 'num_empty_intersections'}, ...
                              1/problem_data.system_size.m * ones(1, problem_data.system_size.m), ...
                              struct( ...
                              'random_seed_for_problem', struct('start',1,'increment',1), ...
                              'random_seed_for_solvers', struct('start',0,'increment',0)) );  
stats_fig2 = experiment_fig2.run(); 




%% generate plots

figure
subplot(1,2,1);
line_plots = plot_minmax_median_quantiles(stats_fig1.residual, experiment_fig1.solvers, ...
                                          1:experiment_fig1.stopping.iter_save:experiment_fig1.stopping.maxiter);                                                            
                                                                                            
xlabel('k');
ylabel('$$\|f(P_k)\|$$', 'Interpreter', 'Latex', 'FontSize', 15);
legend(line_plots, 'NK', 'rNBK', 'NBK', 'location', 'west')


subplot(1,2,2);
line_plots = plot_minmax_median_quantiles(stats_fig2.residual, experiment_fig1.solvers, ...
                                          stats_fig2.timegrid);                                                            
                                                                                            
xlabel('t');
ylabel('$$\|f(P_k)\|$$', 'Interpreter', 'Latex', 'FontSize', 15);
legend(line_plots, 'NK', 'rNBK', 'NBK', 'location', 'west')



%% writeout data

if writeout
    writeout_data_over_array_on_xaxis(... 
          '../../left_stochastic_decomposition/experiment_100x50/fig1.txt', ...
          {'t','POCSmin','rNBKmin','NBKmin', 'POCSmax','rNBKmax','NBKmax', ...
               'POCSmedian','rNBKmedian','NBKmedian', ...
               'POCSquant25','rNBKquant25','NBKquant25', ...
               'POCSquant75','rNBKquant75','NBKquant75'}, ...
          1:iter_save_fig1:maxiter_fig1, ...
          [stats_fig1.residual.mins, ...
          stats_fig1.residual.maxs, ...
          stats_fig1.residual.medians, ...
          stats_fig1.residual.quant25s, ...
          stats_fig1.residual.quant75s]);
     writeout_data_over_array_on_xaxis(... 
          '../../left_stochastic_decomposition/experiment_100x50/fig2.txt', ...
          {'t','POCSmin','rNBKmin','NBKmin', 'POCSmax','rNBKmax','NBKmax', ...
               'POCSmedian','rNBKmedian','NBKmedian', ...
               'POCSquant25','rNBKquant25','NBKquant25', ...
               'POCSquant75','rNBKquant75','NBKquant75'}, ...
          stats_fig2.timegrid, ...
          [stats_fig2.residual.mins, ...
          stats_fig2.residual.maxs, ...
          stats_fig2.residual.medians, ...
          stats_fig2.residual.quant25s, ...
          stats_fig2.residual.quant75s]);
end




