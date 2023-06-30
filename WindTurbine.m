%  Created on: 13/06/2023
%      Author: j-Lago
%
classdef WindTurbine
   properties
       c    % coeficientes turbina
       R    % raio turbina
       gear_ratio % gearbox ratio
       rho  % densidade do ar
       
       Pmin
       Pmax
       nrmax
       vwcutoff
   end
   
   methods
       function self = WindTurbine(coefs, radius, gearbox_ratio, air_density, Pmin, Pmax, nrmax, vwcutoff)
           self.c = coefs;
           self.R = radius;
           self.gear_ratio = gearbox_ratio;
           self.rho = air_density;
           
           self.Pmin = Pmin;
           self.Pmax = Pmax;
           self.nrmax = nrmax;
           self.vwcutoff = vwcutoff;
      
       end
       
       function [w,p] = MPPT(self, n_vw, n_nr)
           v = 0 : (self.vwcutoff) / (n_vw-1) : self.vwcutoff;
           wr = ( 0 : (self.nrmax) / (n_nr-1) : self.nrmax ) * pi / 30;
           for k=1:1:length(v)
                P(:,k) = self.Power(v(k), wr, 0);
                [p, id] = max(P(:,k));
                Popt(k) = p;
                wPopt(k) = wr(id);
            end
            
            w = wPopt * 30 / pi;
            p = min(Popt .*  (Popt >= self.Pmin), self.Pmax );
       end
       
       function P = Power(self, wind, omega, beta)
           l = (omega/self.gear_ratio) .* self.R ./ wind;
           tl = 1./(1./(l+self.c(8).*beta)-self.c(9)./(beta.^3+1));
           Cp = max(self.c(1)*(self.c(2)./tl-self.c(3).*(beta)-self.c(4)*(beta).^self.c(5)-self.c(6)).*exp(-self.c(7)./tl),0);
           P = Cp * (0.5 * self.rho * pi * self.R^2.*wind.^3);
       end
       
       function T = Torque(self, wind, omega, beta)
           T = self.Power(wind, omega, beta) ./ omega; 
       end
   end
end