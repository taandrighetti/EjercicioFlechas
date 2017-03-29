%% Cargar imagen
clt

threshold_horizontal = 0.202082433443471;
threshold_vertical = 0.000596464751347591;

A2 = not(imread('arrows_2.bmp'));
A2dil = imdilate(A2,ones(3,3));
[A2label, n] = bwlabel(A2dil,4);

%% Clasificación

b(1).name = 'basicgeo';
b(1).options.show=1;
b(2).name = 'hugeo';
b(2).options.show=1;
b(3).name = 'flusser';
b(3).options.show=1;
op.b = b;
[Features, FeatureNames] = Bfx_geo(A2label,op);

class = zeros(210, 1500, 3);
class_next_x = [1 1 1];
dc = zeros(n, 1);

for i = 1:n
    if Features(i, 19) < threshold_horizontal
        c = 3;
    elseif Features(i, 21) < threshold_vertical
        c = 2;
    else
        c = 1;
    end
    
    dc(i) = c;
    
    % buscar bordes de la flecha
    left = 1;
    while ~any(A2label(:,left)==i)
        left = left+1;
    end
    
    right = size(A2,2);
    while ~any(A2label(:,right)==i)
        right = right-1;
    end
    
    top = 1;
    while ~any(A2label(top,:)==i)
        top = top+1;
    end
    
    bot = size(A2,1);
    while ~any(A2label(bot,:)==i)
        bot = bot-1;
    end
    
    % copiar flecha a imagen de clase correspondiente
    width = right-left;
    class(1:bot-top+1, class_next_x(c):class_next_x(c)+width, c) = (A2label(top:bot, left:right)==i) .* A2(top:bot, left:right);
    class_next_x(c) = class_next_x(c) + width + 10;
end

close all
for i = 1:3
    figure
    imshow(class(:,:,i), []);
    title(sprintf('Clase %d', i));
end

%% Supervisión

% ds = Bio_labelregion(A2, A2label, 3);
ds = [1;1;1;1;1;2;2;2;1;3;1;3;3;2;1;1;1;2;1;2;2;2;2;1;2;2;2;1;1;1;1;2;2;1;3;3;3;3;1;3;3;1;3;3;3;2;3;3;3];

disp('Matriz de confusión:');
disp(confusionmat(ds, dc));