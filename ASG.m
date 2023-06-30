%  Created on: 13/06/2023
%      Author: j-Lago
%
classdef ASG
   properties
       r1
       r2
       rf
       x1
       x2
       xm
       p
       a
   end
   
   methods
       function self = ASG(r1, r2, rf, x1, x2, xm, p, a)
           self.r1 = r1;
           self.r2 = r2;
           self.rf = rf;
           self.x1 = x1;
           self.x2 = x2;
           self.xm = xm;
           self.p = p;
           self.a = a;
       end
       
       function [Pest, Qest, Prot, Qrot, Pconv, Perdas, Iest, Vest, frot, Irot, Vrot] = Solve(self, v1, f1, vext, rext, xext, omegar)
           ws = 4*pi*f1 / self.p;
           s = (ws-omegar)./ws;
           
%            z0 = j*self.xm * self.rf / (j*self.xm + self.rf);
%            z1 = self.r1 + j*self.x1;
%            z2 = ((self.r2)./s +j*(self.x2)) * self.a^2;
%            zext = ((rext ./ s + j*xext) ) * self.a^2;
%            zth = z0*z1 / (z1 + z0);
%            vth = v1 .* z0 ./ (z1 + z0);
%            i2 = (vext./s - vth) ./ (zth+z2+zext);
%            e0 = vth + i2 .* zth;
%            pef = real(3 * e0 .* conj(i2));
%            Pconv = pef / ws .* omegar;
%            i1 = (e0-v1) ./ z1;
%            Iest = i1;
%            Vest = zeros(size(Iest)) + v1; 
%            Sest = 3 * v1 .* conj(i1);
%            Pest = real(Sest);
%            Qest = imag(Sest);
%            v2 = (i2 .* zext + vext ./s) .* s;
%            Vrot = v2 / self.a;
%            Irot = i2 * self.a;
%            Srot = 3 * v2 .* conj(i2);
%            Prot = real(Srot);
%            Qrot = imag(Srot);
%            frot = f1.*s;
%            Perdas = 3 * ( abs(i1).^2 * self.r1 + abs(i2).^2 * self.r2 + abs(e0).^2 / self.rf);

           z0 = (j*self.xm * self.rf / (j*self.xm + self.rf) ) / (self.a^2);
           z1 = (self.r1 + j*self.x1 ) / (self.a^2);
           z2 = ((self.r2)./s +j*(self.x2));
           zext = rext ./ s + j*xext ./s; 
           zth = z0*z1 / (z1 + z0);
           vth = v1 / self.a .* z0 ./ (z1 + z0);
           i2 = (vth - vext./s) ./ (zth+z2+zext);
           e0 = vth - i2 .* zth;
           pef = -real(3 * e0 .* conj(i2));
           Pconv = pef / ws .* omegar;
           i1 = (e0 * self.a - v1) ./ (self.r1 + j*self.x1);
           
           
           v2 = (i2 .* zext + vext ./s) .* s;
           
           Iest = i1;
           Vest = zeros(size(Iest)) + v1; 
           Vrot = v2;
           Irot = i2;
           
           Sest = 3 * v1 .* conj(i1);
           Pest = real(Sest);
           Qest = imag(Sest);
           
           Srot = 3 * v2 .* conj(i2);
           Prot = real(Srot);
           Qrot = imag(Srot);
           
           frot = f1.*s;
           Perdas = 3 * ( abs(i1).^2 * self.r1 + abs(i2).^2 * self.r2 + abs(e0*self.a).^2 / self.rf);
       end
       
   end
end