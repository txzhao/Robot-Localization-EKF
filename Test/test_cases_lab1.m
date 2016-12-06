function test_cases_lab1()
clc;
done = 1;
names = {'calculate odometry', 'predict', 'observation' , 'jacobian', 'associate', 'update', 'batch associate','batch update'};
functions = {'calculate_odometry', 'predict', 'observation_model' , 'jacobian_function', 'associate', 'update','batch_associate','batch_update'};
for i = 1 : length(functions)
    if eval(sprintf('test_case_%s()',functions{i}))
        display(sprintf('your %s function seems to be fine!',names{i}));
    else
        display(sprintf('your %s function seems to be wrong, not running other test cases!',names{i}));
        done = 0;
        break;
    end
end
if done
    display('Congratulations! It seems that you are on a good track!');
else
    display('Oops! It seems you still need some debugging!');
end
end