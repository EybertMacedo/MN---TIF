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
ezplot(f);
hold on 
ezplot(sumatoria);
legend(char(f), char(sumatoria));
equis=input("Digite el valor de x: ");
valor_teorico=double(subs(f, equis));
valor_experimental=double(subs(sumatoria, equis));
error_absoluto=abs(valor_teorico-valor_experimental)
error_relativo=...
abs((valor_teorico-valor_experimental)/valor_teorico)*100
