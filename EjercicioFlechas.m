%% 1. Adquisición de imagen
clt

I = not(imread('arrows_1.bmp'));
% Se usa el 'not' para 'negar' la imagen, es decir, dejar como pixeles
% blancos las flechas y el fondo negro.
figure, imshow(I);

F = I(80:170,100:200);
figure, imshow(F);
[X1,X1n] = Bfx_basicgeo(F);
Bio_printfeatures(X1,X1n);

% El area es de 1533.875 pixeles

[X2,X2n] = Bfx_hugeo(F);
Bio_printfeatures(X2,X2n);
[X3,X3n] = Bfx_fourierdes(F);
Bio_printfeatures(X3,X3n);

%% 2. Segmentación
close all

J = imdilate(I,ones(3,3));
[L,n] = bwlabel(J,4);
figure, imshow(L, []);

%% 3. Supervisión

% d = Bio_labelregion(I,L,3);
% atajo:
d = [1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;2;2;2;2;2;2;2;2;2;2;2;2;3;3;3;3;3;3;3;3;3;3;3;3;3;3];

%% 4. Extracción de características

b(1).name = 'basicgeo';
b(1).options.show=1;
b(2).name = 'hugeo';
b(2).options.show=1;
b(3).name = 'flusser';
b(3).options.show=1;
op.b = b;
[X,Xn] = Bfx_geo(L,op);
Xunnorm = X;
X = Bft_norm(X, 1);

%% Análisis visual de las características
% 5. Ejemplo 1: marcar con una X el centroide de cada flecha
close all

i = Xunnorm(:,1); 
j = Xunnorm(:,2);
figure, imshow(I);
hold on
plot(j,i,'rx');
hold off

%% 6. Ejemplo 2: histogramas de área y centro de gravedad j
close all

figure, Bio_plotfeatures(X(:,5),d,Xn(5,:));     % histograma del área
figure, Bio_plotfeatures(X(:,2),d,Xn(2,:));     % histograma del centro de gravedad j

% La segunda característica no sirve para separar, porque la clasificación
% sería dependiente de la posición de cada flecha en la imagen.

%% 7. Ejemplo 3: visualización del espacio de dos características
close all

[Xunnorm,~] = Bfs_noposition(Xunnorm, Xn);
[X,Xn] = Bfs_noposition(X, Xn);
X = Bft_norm(X, 1);

% Visualizar todas, una a una:
for i = 1:size(X, 2)
    figure, Bio_plotfeatures(X(:,i), d, sprintf('%d - %s', i, Xn(i,:)));
end

%% Visualizar algunos pares de características, con y sin normalizar
close all
figure

k = [14 19];
subplot(2, 4, 1);
Bio_plotfeatures(X(:,k),d,Xn(k,:));
subplot(2, 4, 5);
Bio_plotfeatures(Xunnorm(:,k),d,Xn(k,:));

k = [14 24];
subplot(2, 4, 2);
Bio_plotfeatures(X(:,k),d,Xn(k,:));
subplot(2, 4, 6);
Bio_plotfeatures(Xunnorm(:,k),d,Xn(k,:));

k = [17 24];
subplot(2, 4, 3);
Bio_plotfeatures(X(:,k),d,Xn(k,:));
subplot(2, 4, 7);
Bio_plotfeatures(Xunnorm(:,k),d,Xn(k,:));

k = [17 19];
subplot(2, 4, 4);
Bio_plotfeatures(X(:,k),d,Xn(k,:));
subplot(2, 4, 8);
Bio_plotfeatures(Xunnorm(:,k),d,Xn(k,:));
