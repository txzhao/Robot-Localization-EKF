% This function displays the map landmark as black circles
%
function drawLandmarkMap(filename)

d = load(filename);

if nargin < 1
    disp('You need to supply the file with landmarks to display (id x y)')
    return
end

plot(d(:,2), d(:,3), 'ko')

