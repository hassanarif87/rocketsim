function  log_cleaned = clean_log( t )
    global log
    log_cleaned = [];
    l1 =length(log(:,10));
    l =length(t);
    for i=1:l
        for j=1:l1
            flag =0;
            if (t(i) == log(j,10))
                log_cleaned = [log_cleaned; log(j,:)];
                flag =1;
            end
            if (flag ==1)
                break;
            end
        end
    end
    
end



