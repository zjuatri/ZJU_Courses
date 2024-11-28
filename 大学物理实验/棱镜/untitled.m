lambda = [404.7 435.8 546.0 577.1];
LambdaSpace = linspace(400,600);
x = lambda.^(-2);
n = [1.7100 1.6946 1.6770 1.6735];
p = polyfit(x,n,2);
c = p(1)
b = p(2)
a = p(3)
nSpace = c*LambdaSpace.^(-4)+b*LambdaSpace.^(-2)+a;
plot(lambda,n,'bo',LambdaSpace,nSpace,'b-')
legend('数据点','拟合曲线',fontname='黑体')
title('n-\lambda关系曲线',FontName='黑体')
xlabel('\lambda (nm)')
ylabel('n')