    A0=load('RA.mat');
    NO_scan=length(A0.Mag.scans);
    dummy=A0.Mag.scans{1};
    [N1,N2,N3]=size(dummy);
    Mag=zeros(N1,N2,N3,NO_scan);
    VAP=zeros(N1,N2,N3,NO_scan);
    VFH=zeros(N1,N2,N3,NO_scan);
    VRL=zeros(N1,N2,N3,NO_scan);
    
    for sc=1:NO_scan
        Mag(:,:,:,sc)=A0.Mag.scans{sc};
        VAP(:,:,:,sc)=A0.Vap.scans{sc};
        VRL(:,:,:,sc)=A0.Vrl.scans{sc};
        VFH(:,:,:,sc)=A0.Vfh.scans{sc};
    end 
    Mag=Mag/1e7;
    
%niftiwrite(MAG, 'MAG.nii')    
niftiwrite(VAP, 'VAP.nii')
niftiwrite(VRL, 'VRL.nii')
niftiwrite(VFH, 'VFH.nii')