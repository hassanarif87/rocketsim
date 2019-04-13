function prop = init_rocket()

    prop = readtable('rocket_proptethys.txt','Format','%s%f');
%     motorname=char(table2array(prop(end,1)));
%     motordata = rocketmotor(motorname);

end

