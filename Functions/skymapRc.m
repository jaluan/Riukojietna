function out=skymapRc(lat,Rcveff)
% Calculate whole-sky cutoff value given latitude and effective vertical Rc

lambda = lat; % geomagnetic latitude in degrees - radial direction

% Directional Rc calculation

phi = (0:1:360); % azimuth
theta = (0:1:90); % zenith angle - along radial direction

for i=1:length(phi);
    phirad(i) = degtorad(phi(i));
end

for i=1:length(theta)
    thetarad(i) = degtorad(theta(i));
end

lambdarad = degtorad(lambda);

%Generate whole-sky cutoff array

for i = 1:length(phi)
    for j = 1:length(theta)
        DirRc(i,j) = 4.*Rcveff.*sin(thetarad(j))./(1 + sqrt(1-sin(thetarad(j)).*cos(phirad(i)).*(cos(lambdarad).^3))).^2;
    end 
end


for i = 1:length(phirad)
    twopirc(i) = trapz(thetarad(1:end),(DirRc(i,1:end)))./trapz(thetarad(1:end),sin(thetarad(1:end)));
%     twopirc(i) = trapz(thetarad(1:end),(DirRc(i,1:end).*cos(thetarad(1:end)-1)))./(pi/2);
end
        
twopicutoff = trapz(phirad(1:end),twopirc(1:end))./(2*pi);


out = twopicutoff;





