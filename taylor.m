syms x
f=input("Escriba la función: ");
a=input("Digite el valor de a: ");
n=input("Digite el valor de n: ");
sumatoria=0;
for i=0:n
    sumatoria=sumatoria + ...
        (subs (diff(f,x,i),a)*(x-a)^i)/factorial(i);
end
disp("El modelo generado es: ");
disp(sumatoria);
