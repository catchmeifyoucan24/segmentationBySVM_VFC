function featVect = featureExtraction(RGB, opt)

switch opt
    case 'rgb'
        featVect = colorExtraction(RGB, 'RGB');
    case 'vfc'
        featVect = VEFExtraction(RGB);
    otherwise
        disp('error in featureExtraction. Please check the opt parameter.');
end

%--------------------------------------------------------------------------

function featVect = colorExtraction(RGB, color)
% Estrazione di descrittori pixelwise per la segmentazione
% input
%           RGB l'immagine originale
%           colour spazione colore utilizzato per l'estrazione
% output
%           featVect il vettore di feature dell'immagine
% EXAMPLE
%           featVect = colorExtraction(RGB, 'RGB')
%           estrae i livelli di grigio dei singoli canali RGB 
if nargin < 2
    color = 'RGB';
end

if contains(color, 'gray')
    img = rgb2gray(RGB);
elseif contains(color, 'RGB')
    img = RGB;
elseif contains(color, 'HSV')
    img = rgb2you(RGB,'HSV');
elseif contains(color, 'Lab')
    img = rgb2you(RGB,'Lab');
elseif contains(color, 'Luv')
    img = rgb2you(RGB,'Luv');
elseif contains(color, 'CMYK')
    img = rgb2you(RGB,'CMYK');
elseif contains(color, 'CMY')
    img = rgb2you(RGB,'CMY');
elseif contains(color, 'Ycbcr')
    img = rgb2you(RGB,'Ycbcr');
else
    error('Unsupported colour channel');
end

featVect = [];
for i = 1:size(img, 3)
    imgi = img(:,:,i);
    featVect = [featVect, imgi(:)];
end

%--------------------------------------------------------------------------

function featVect = VEFExtraction(I)

[Fext,~] = getVEF('',I);
u = Fext(:,:,1)./sqrt(Fext(:,:,1).*Fext(:,:,1) + Fext(:,:,2).*Fext(:,:,2));
v = Fext(:,:,2)./sqrt(Fext(:,:,1).*Fext(:,:,1) + Fext(:,:,2).*Fext(:,:,2));
angle = atan2(-v,u)*180/pi;
angle = angle+180;
angle = round(angle);
% applicare filtro media 3x3 e recuperare il valore medio dell'angolo per
% ogni intorno
%min = ordfilt2(angle, 1, true(3,3));
%med = ordfilt2(angle, 5, true(3,3));
%max = ordfilt2(angle, 9, true(3,3));
lbp = im2lbp(rgb2gray(I), 1, 8, 'ri');
lbp = padarray(lbp, [1 1], 'replicate', 'both');
lbp = im2double(lbp);


%min = round(min);
%med = round(med);
%max = round(max);
%lbp = round(lbp);

%featVect = featVect(:);

%featVect = horzcat(angle(:), min(:), med(:), max(:));
featVect = horzcat(angle(:), lbp(:));
%featVect = angle(:);