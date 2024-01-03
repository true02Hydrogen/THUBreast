function saveraw(breast,seed,targetGlaFrac)
modelname = ['p_',num2str(seed),'_',num2str(targetGlaFrac)];
rawname = [modelname,'.raw'];
savedir = ['./raw/',rawname];
fid = fopen(savedir,'wb');%存为raw
fwrite(fid, breast, 'uint8');
fclose(fid);
gzip({savedir},'./raw');
delete(['.\raw\',rawname]);