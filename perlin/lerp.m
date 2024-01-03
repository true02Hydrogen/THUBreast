function u = lerp(a,b,t) 
    %权重相加
    tw = 3*t.^2-2*t.^3;
%     tw = 6*t.^5-15*t.^4+10*t.^3;
    %6*t.^5-15*t.^4+10*t.^3;   %3*t.^2-2*t.^3;
    u = (1-tw).*a + tw.*b;
end

