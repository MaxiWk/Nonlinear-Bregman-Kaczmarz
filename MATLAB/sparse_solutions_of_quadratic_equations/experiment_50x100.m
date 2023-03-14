clear
clc

addpath(genpath('../'))

fprintf('\n Experiment Sparse solutions of underdetermined quadratic system\n')

num_examples = 50;
writeout = true; 


% experiment with lambda = 2

lambda = 2;
solvers = {NK, rNBK(lambda), NBK_sparse(lambda)};
problem_data = struct( 'system_size', struct('d', 100, 'n', 50), ...                        
                       'distr_params', struct('A_distr', 'randn', 'b_distr', 'randn'), ...   
                       'lambda', lambda, ...
                       'sol_properties', struct('type', 'sparse_randn', 'nnz', 5), ... 
                       'init_properties', struct('type', 'dual_randn'));
experiment_fig1 = experiment( @sparse_solutions_of_quadratic_equations, ...
                              problem_data, ...
                              solvers, ...
                              num_examples, ...
                              runtime_stopping(struct('iter_save', 1e3, 'max_time', 10)), ...
                              {'residual', 'dist_to_sol', 'nnz'}, ...
                              1/problem_data.system_size.n * ones(1, problem_data.system_size.n), ...
                              struct( ...
                              'random_seed_for_problem', struct('start',1,'increment',0), ...
                              'random_seed_for_init', struct('start',0,'increment',0), ...
                              'random_seed_for_solvers', struct('start',0,'increment',1))); 
stats_fig1 = experiment_fig1.run(); 



% experiment with lambda = 5

lambda = 5;
solvers = {NK, rNBK(lambda), NBK_sparse(lambda)};
problem_data.lambda = lambda;
experiment_fig2 = experiment_fig1;
experiment_fig2.solvers = solvers;
stats_fig2 = experiment_fig2.run(); 



%% generate plots

figure

subplot(1,2,1)
line_plots = plot_minmax_median_quantiles(stats_fig1.residual, experiment_fig1.solvers, ...
                                          stats_fig1.timegrid);                                                                                                   
xlabel('t');
ylabel('$$\|f(x_k)\|_2$$', 'Interpreter', 'Latex', 'FontSize', 15);
legend(line_plots, 'NK', 'rNBK', 'NBK', 'location', 'west')


subplot(1,2,2)
line_plots = plot_minmax_median_quantiles(stats_fig2.residual, experiment_fig2.solvers, ...
                                          stats_fig2.timegrid);                                                                                                   
xlabel('t');
ylabel('$$\|f(x_k)\|_2$$', 'Interpreter', 'Latex', 'FontSize', 15);
legend(line_plots, 'NK', 'rNBK', 'NBK', 'location', 'west')



%% report sparsity
for solver_counter = 1:length(solvers)
    fprintf('\n')
    fprintf('Experiment 1, \n')
    fprintf('%s, nonzero entries(min, median, max): %d, %d, %d \n', ...
            solvers{solver_counter}.id, ...
            stats_fig1.nnz.mins(solver_counter), ...
            stats_fig1.nnz.medians(solver_counter), ...
            stats_fig1.nnz.maxs(solver_counter))
end

for solver_counter = 1:length(solvers)
    fprintf('\n')
    fprintf('Experiment 1, \n')
    fprintf('%s, nonzero entries(min, median, max): %d, %d, %d \n', ...
            solvers{solver_counter}.id, ...
            stats_fig2.nnz.mins(solver_counter), ...
            stats_fig2.nnz.medians(solver_counter), ...
            stats_fig2.nnz.maxs(solver_counter))
end



%% writeout results 

if writeout 
    writeout_data_over_array_on_xaxis(... 
          '../../sparse_quadratic/n=50,d=100/fig1.txt', ...
          {'t','POCSmin','rNBKmin','NBKmin', 'POCSmax','rNBKmax','NBKmax', ...
               'POCSmedian','rNBKmedian','NBKmedian', ...
               'POCSquant25','rNBKquant25','NBKquant25', ...
               'POCSquant75','rNBKquant75','NBKquant75'}, ...
          stats_fig1.timegrid, ...
          [stats_fig1.residual.mins, ... 
          stats_fig1.residual.maxs, ...
          stats_fig1.residual.medians, ...
          stats_fig1.residual.quant25s, ...
          stats_fig1.residual.quant75s]);
    writeout_sparsity(...
                '../../sparse_quadratic/n=50,d=100/fig1_nnz.txt', ...
                {'NK(min/median/max)', 'rNBK(min/median/max)', 'NBK(min/median/max)'}, ...
                stats_fig1.nnz.mins, stats_fig1.nnz.medians, stats_fig1.nnz.maxs);
    writeout_data_over_array_on_xaxis(... 
          '../../sparse_quadratic/n=50,d=100/fig2.txt', ...
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
    writeout_sparsity(...
                '../../sparse_quadratic/n=50,d=100/fig2_nnz.txt', ...
                {'NK(min/median/max)', 'rNBK(min/median/max)', 'NBK(min/median/max)'}, ...
                stats_fig2.nnz.mins, stats_fig2.nnz.medians, stats_fig2.nnz.maxs);

end



