function [out] = ADMP2(Z,object)

y=object;
[m2, n2] = size(Z);
a = zeros(n2,1);
a1 = zeros(m2,1);
a2 = zeros(n2,1);

beta1 = 1e-1; 
beta2 = 1e-2;
lambda1 = 1;
lambda2 = 1e-2;

k=0;
ReErr=1;

t  = 1e-6;
a = a;
a1 = a1;
a2 = a2;
while ReErr> t

%while MSE1> tol2
u = sign(y-Z*a-a1).*max(abs(y-Z*a-a1)-lambda1/beta1,0) ;% Calculating u
v = sign(a-a2).*max(abs(a-a2)-lambda2/beta2,0) ;% Calculating v

I = eye(n2,n2);
a_new = (inv(beta1*((Z.')*Z)+beta2.*I))*(beta2*(v+a2)-beta1*(Z.')*(u-y +a1));% Calculating a

a1_new = a1+1.618*(u-(y-Z*a_new));% Calculating a1
a2_new = a2+1.618*(v-a_new);% Calculating a2
a1 = a1_new;
a2 = a2_new;

ReErr = norm((a_new-a),2)./ norm(a_new,2);% The residual between the adjacent iterations.
a = a_new;
k=k+1;

end

out=a;




