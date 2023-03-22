function var = fixsynops(var,synops)
    % separacion de variables
    for i = 1:length(synops)
        synop = synops{i};
        if(length(synop) < 28)
            dir(i) = nan;
            vel(i) = nan;
            u(i) = nan;
            v(i) = nan;
            nub.oct(i) = nan;
        else
            dir(i) = str2double(synop(25:26))*10; % de [10°] a [°] 
            vel(i) = str2double(synop(27:28))*0.514; % de [nudos] a [m/s]
            u(i) = vel(i)*sind(180-dir(i));
            v(i) = vel(i)*cosd(180-dir(i));
            nub.oct(i) = str2double(synop(24));
        end
    end
    % arreglo final
    if(isempty(var))
        var.dir = dir';
        var.vel = vel';
        var.u = u';
        var.v = v';
        var.nub.oct = nub.oct';
    else
        var.dir = [var.dir;dir'];
        var.vel = [var.vel;vel'];
        var.u = [var.u;u'];
        var.v = [var.v;v'];
        var.nub.oct = [var.nub.oct;nub.oct'];
    end
end




  