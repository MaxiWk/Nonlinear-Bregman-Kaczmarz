clear
clc

addpath(genpath('../'))

fprintf('\n Experiment Linear equations with stdnormal coefficients on probability simplex\n')

num_examples = 50; 

solvers = {POCS_Simplex_Kaczmarz, ...
           rNBK_Simplex_Kaczmarz, ...
           NBK_Simplex_Kaczmarz(struct(...
           'make_projection_feasibility_check', true, ...
           'tol_linesearch', 1e-9, ...
           'linesearch_optimizer', 'Newton')), ...
           };

writeout = true;


%% run experiments

% 1
disp('1/4')
problem_data = struct( 'system_size', struct('n', 500, 'd', 200), ...                        
                       'A_distr', struct('type', 'randn'), ...   
                       'sol_distr', 'random_uniform', ...
                       'init_properties', struct('type', 'central') );                    
iter_save_fig11 = 1e3;
maxiter_fig11 = 6e4;
experiment_fig11 = experiment( @linear_equations_on_probability_simplex, ...
                              problem_data, ...
                              solvers, ...
                              num_examples, ...
                              iteration_stopping(struct('iter_save', iter_save_fig11, ...
                                                        'maxiter', maxiter_fig11)), ...
                              {'residual'}, ...
                              1/problem_data.system_size.n * ones(1, problem_data.system_size.n), ...
                              struct( ...
                              'random_seed_for_problem', struct('start',0,'increment',1), ...
                              'random_seed_for_init', struct('start',0,'increment',1), ...
                              'random_seed_for_solvers', struct('start',0,'increment',1)));    
stats_fig11 = experiment_fig11.run(); 


% 2
disp('2/4')
problem_data.system_size = struct('n', 200, 'd', 500);
experiment_fig12 = experiment( @linear_equations_on_probability_simplex, ...
                              problem_data, ...
                              solvers, ...
                              num_examples, ...
                              iteration_stopping(struct('iter_save', iter_save_fig11, ...
                                                        'maxiter', maxiter_fig11)), ...
                              {'residual'}, ...
                              1/problem_data.system_size.n * ones(1, problem_data.system_size.n), ...
                              struct( ...
                              'random_seed_for_problem', struct('start',0,'increment',1), ...
                              'random_seed_for_init', struct('start',0,'increment',1), ...
                              'random_seed_for_solvers', struct('start',0,'increment',1)));  
stats_fig12 = experiment_fig12.run(); 


% 3
disp('3/4')
problem_data.system_size = struct('n', 500, 'd', 200);
experiment_fig21 = experiment( @linear_equations_on_probability_simplex, ...
                              problem_data, ...
                              solvers, ...
                              num_examples, ...
                              runtime_stopping(struct('iter_save', 1e3, 'max_time', 2)), ...
                              {'residual'}, ...
                              1/problem_data.system_size.n * ones(1, problem_data.system_size.n), ...
                              struct( ...
                              'random_seed_for_problem', struct('start',0,'increment',1), ...
                              'random_seed_for_init', struct('start',0,'increment',1), ...
                              'random_seed_for_solvers', struct('start',0,'increment',1)));  
stats_fig21 = experiment_fig21.run(); 


% 4
disp('4/4')
problem_data.system_size = struct('n', 200, 'd', 500);
experiment_fig22 = experiment( @linear_equations_on_probability_simplex, ...
                              problem_data, ...
                              solvers, ...
                              num_examples, ...
                              runtime_stopping(struct('iter_save', 1e3, 'max_time', 2)), ...
                              {'residual'}, ...
                              1/problem_data.system_size.n * ones(1, problem_data.system_size.n), ...
                              struct( ...
                              'random_seed_for_problem', struct('start',0,'increment',1), ...
                              'random_seed_for_init', struct('start',0,'increment',1), ...
                              'random_seed_for_solvers', struct('start',0,'increment',1)));  
stats_fig22 = experiment_fig22.run(); 





%% generate plots

figure
subplot(2,2,1);
line_plots = plot_minmax_median_quantiles(stats_fig11.residual, experiment_fig11.solvers, ...
                                          1:experiment_fig11.stopping.iter_save:experiment_fig11.stopping.maxiter);                                                            
                                                                                            
xlabel('k');
ylabel('$$\|Ax_k-b\|/\|b\|$$', 'Interpreter', 'Latex', 'FontSize', 15);
legend(line_plots, 'NK', 'rNBK', 'NBK', 'location', 'west')

subplot(2,2,2);
line_plots = plot_minmax_median_quantiles(stats_fig12.residual, experiment_fig11.solvers, ...
                                          1:experiment_fig12.stopping.iter_save:experiment_fig12.stopping.maxiter);                                                            
                                                                                            
xlabel('k');
ylabel('$$\|Ax_k-b\|/\|b\|$$', 'Interpreter', 'Latex', 'FontSize', 15);
legend(line_plots, 'NK', 'rNBK', 'NBK', 'location', 'west')

subplot(2,2,3);
line_plots = plot_minmax_median_quantiles(stats_fig21.residual, experiment_fig21.solvers, ...
                                          stats_fig21.timegrid);                                                            
                                                                                            
xlabel('t');
ylabel('$$\|Ax_k-b\|/\|b\|$$', 'Interpreter', 'Latex', 'FontSize', 15);
legend(line_plots, 'NK', 'rNBK', 'NBK', 'location', 'west')

subplot(2,2,4);
line_plots = plot_minmax_median_quantiles(stats_fig22.residual, experiment_fig21.solvers, ...
                                          stats_fig22.timegrid);                                                            
                                                                                            
xlabel('t');
ylabel('$$\|Ax_k-b\|/\|b\|$$', 'Interpreter', 'Latex', 'FontSize', 15);
legend(line_plots, 'NK', 'rNBK', 'NBK', 'location', 'west')



%% writeout data

if writeout
    writeout_data_over_array_on_xaxis(... 
          '../../linear_equations_on_simplex/randn/fig11.txt', ...
          {'t','POCSmin','rNBKmin','NBKmin', 'POCSmax','rNBKmax','NBKmax', ...
               'POCSmedian','rNBKmedian','NBKmedian', ...
               'POCSquant25','rNBKquant25','NBKquant25', ...
               'POCSquant75','rNBKquant75','NBKquant75'}, ...
          1:iter_save_fig11:maxiter_fig11, ...
          [stats_fig11.residual.mins, ...
          stats_fig11.residual.maxs, ...
          stats_fig11.residual.medians, ...
          stats_fig11.residual.quant25s, ...
          stats_fig11.residual.quant75s]);
     writeout_data_over_array_on_xaxis(... 
          '../../linear_equations_on_simplex/randn/fig12.txt', ...
          {'t','POCSmin','rNBKmin','NBKmin', 'POCSmax','rNBKmax','NBKmax', ...
               'POCSmedian','rNBKmedian','NBKmedian', ...
               'POCSquant25','rNBKquant25','NBKquant25', ...
               'POCSquant75','rNBKquant75','NBKquant75'}, ...
          1:iter_save_fig11:maxiter_fig11, ...
          [stats_fig12.residual.mins, ...
          stats_fig12.residual.maxs, ...
          stats_fig12.residual.medians, ...
          stats_fig12.residual.quant25s, ...
          stats_fig12.residual.quant75s]);
    writeout_data_over_array_on_xaxis(... 
          '../../linear_equations_on_simplex/randn/fig21.txt', ...
          {'t','POCSmin','rNBKmin','NBKmin', 'POCSmax','rNBKmax','NBKmax', ...
               'POCSmedian','rNBKmedian','NBKmedian', ...
               'POCSquant25','rNBKquant25','NBKquant25', ...
               'POCSquant75','rNBKquant75','NBKquant75'}, ...
          stats_fig21.timegrid, ...
          [stats_fig21.residual.mins, ...
          stats_fig21.residual.maxs, ...
          stats_fig21.residual.medians, ...
          stats_fig21.residual.quant25s, ...
          stats_fig21.residual.quant75s]);   
    writeout_data_over_array_on_xaxis(... 
          '../../linear_equations_on_simplex/randn/fig22.txt', ...
          {'t','POCSmin','rNBKmin','NBKmin', 'POCSmax','rNBKmax','NBKmax', ...
               'POCSmedian','rNBKmedian','NBKmedian', ...
               'POCSquant25','rNBKquant25','NBKquant25', ...
               'POCSquant75','rNBKquant75','NBKquant75'}, ...
          stats_fig22.timegrid, ...
          [stats_fig22.residual.mins, ...
          stats_fig22.residual.maxs, ...
          stats_fig22.residual.medians, ...
          stats_fig22.residual.quant25s, ...
          stats_fig22.residual.quant75s]);       
end



