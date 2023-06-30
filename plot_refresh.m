%  Created on: 13/06/2023
%      Author: j-Lago
%
function plot_refresh(hObject, eventdata, handles)

    axes(handles.axes1);
    cla;
    
    % linhas grafico
    Lgrid        = LineStyle('-.', [.8 1. 1.]*.8, 1, 9);
    Mgrid        = LineStyle('*',  [.8 1. 1.]*.8, 1, 9);
    Lsincrona    = LineStyle('--', [1. .6 .3]*1., 1, 9);
    Lturbina     = LineStyle('-',  [.1 1. .3]*.6, 2, 9);
    Lturbinamax  = LineStyle('*',  [.1 1. .3]*.6, 1, 9);
    LgeradorC    = LineStyle('-',  [1. .3 .1]*1., 2, 9);
    Lacomodacao  = LineStyle('o',  [.8 .1 .8]*1., 2, 9);
    LgeradorP    = LineStyle('-',  [.3 .7 1.]*.9, 2, 9);
    LgeradorQ    = LineStyle('-',  [1. .3 .7]*.9, 2, 9);
    MgeradorP    = LineStyle('s',  [.3 .7 1.]*.9, 2, 8);
    MgeradorQ    = LineStyle('d',  [1. .3 .7]*.9, 2, 8);
    Lmppt        = LineStyle('-.', [1. .3 .4]*.9, 2, 9);
    
    % parâmetros
    f = 60;
    Vacest = 4000*sqrt(3);
    Vacrot = 400*sqrt(3);
    Vdc    = 1200;
    Qbanco = 250e3;
    
    % limites
    angled = @(z) angle(z) * 180 / pi;
    plot_xlim = [str2double(get(handles.xmin, 'String')), str2double(get(handles.xmax, 'String'))];
    plot_ylim = [str2double(get(handles.ymin, 'String')), str2double(get(handles.ymax, 'String'))]*1e6;
    plot_points = 5000;
    
    % vento/turbina
    wv = get(handles.wind, 'Value'); % vel. do vento [m/s]
    beta = get(handles.beta, 'Value'); % angulo de incidência [deg]
    
    %retificador
    rext = get(handles.rext, 'Value'); % resistência externa em série com o rotor [Ohm]
    xext = get(handles.xext, 'Value'); % reatância externa em série com o rotor [Ohm]
    
    %inversor
    vinvref = get(handles.vinvref, 'Value'); % tensão imposta plo inversor [V]
    deltaref = get(handles.deltaref, 'Value'); % ângulo da tensão impomsta pelo inversor [deg]
    
    %banco capacitores
    qbanco = 0;
    
        
    
    
    
    
    % modelos estaticos
    turbina = WindTurbine([0.73 151 0.58 0.002 2.14 13.2 18.4 -0.002 -0.003], 26, str2double(get(handles.gearbox, 'String')), 1.225, 200e3, 1000e3, 3000, 14);
    gerador = ASG(1.9, .15, 2e3, 4, .6, 240, str2double(get(handles.poles, 'String')), 3);  %r1, r2, rf, x1, x2, xm, a=2/3*Ne/Nr
    inversor = InversorRede(Vdc, 0.3);
    
    v= [0, get(handles.wind, 'Min'): 1 :  get(handles.wind, 'Max')];
    wr=( plot_xlim(1) : (plot_xlim(2)-plot_xlim(1)) / (plot_points-1): plot_xlim(2) ) * pi / 30;

    for k=1:1:length(v)
        Pgrid(:,k) = turbina.Power(v(k), wr, beta);
        %Tgrid(:,k) = turbina.Torque(v(k), wr, beta);
        [p, id] = max(Pgrid(:,k));

        Pmax(k) = p;
        wPmax(k) = wr(id);
        %TPmax(k) = p / wPmax(k);

        ids(k) = id;
    end
    Pmax(1) = []; wPmax(1) = []; ids(1) = []; %TPmax(1) = [];clear

    nr = wr * 60 / 2 / pi;
    nPmax = wPmax * 60 / 2 / pi;
    ns = 120*f / gerador.p; % vel. síncrona [rpm]
    
    pt = turbina.Power(wv, wr, beta);
    [~, idmppt] = max(pt);
    
    
    [pest,qest,prot,qrot,pg, perdas,iest,vest,frot,irot,vrot] = gerador.Solve(Vacest/sqrt(3),f,0,rext,xext,wr);
    
    idacom = 2;
    temp = pg(2) >= pt(2); 
    for k=3:length(pt)
       if (pg(k) >= pt(k)) ~= temp
           idacom = k;
           break;
       end
    end
    
    if get(handles.flag_manual, 'Value') == 1
        [pinv, qinv, iinv, vinv, pgridrot, qgridrot, igridrot, vgridrot, delta] = inversor.SolveV(Vacrot/sqrt(3), vinvref*(cosd(deltaref)+j*sind(deltaref)));
    else
        [pinv, qinv, iinv, vinv, pgridrot, qgridrot, igridrot, vgridrot, delta] = inversor.SolveD(Vacrot/sqrt(3), vinvref*(cosd(deltaref)+j*sind(deltaref)), prot(idacom));
        
        delta = max(delta, get(handles.deltaref, 'Min'));
        delta = min(delta, get(handles.deltaref, 'Max'));
        set(handles.deltaref, 'Value', delta);
    end
    
    
    
    % valores de acomodação
    set(handles.vest_val, 'String', sprintf( '%3.0f V < %2.1f°' , abs(vest(idacom)), angled(vest(idacom))));
    set(handles.iest_val, 'String', sprintf( '%2.1f A < %2.1f°' , abs(iest(idacom)), angled(iest(idacom))) );
    set(handles.pest_val, 'String', sprintf('%3.1f kW' , pest(idacom)/1000) );
    set(handles.qest_val, 'String', sprintf('%3.1f kVAr' , qest(idacom)/1000) );
        
    set(handles.vrot_val, 'String', sprintf('%3.0f V < %2.1f°' , abs(vrot(idacom)), angled(vrot(idacom))) );
    set(handles.irot_val, 'String', sprintf('%2.1f A < %2.1f°' , abs(irot(idacom)), angled(irot(idacom))) );
    set(handles.frot_val, 'String', sprintf('%1.2f Hz (%1.1f%%)', abs(frot(idacom)), frot(idacom)/f * 100 ) );
    
    set(handles.nacom_val, 'String', sprintf('%4.0f rpm' , nr(idacom)) );
    set(handles.nt_val,    'String', sprintf('%2.2f rpm' , nr(idacom) / turbina.gear_ratio) );
    
    set(handles.pt_val, 'String', sprintf('%3.1f kW' , pg(idacom)/1000) );
    
    set(handles.prot_val, 'String', sprintf('%3.1f kW' , prot(idacom)/1000) );
    set(handles.qrot_val, 'String', sprintf('%3.1f kVAr' , qrot(idacom)/1000) );
    
    
    if get(handles.popupmenu2, 'Value') == 2
        perdas_totais = perdas(idacom) + prot(idacom);
    else
        perdas_totais = perdas(idacom);
    end
    
    set(handles.perdas_val, 'String', sprintf('Perdas = %3.1f kW' , perdas_totais/1000) );
    set(handles.beta_val, 'String', sprintf('%2.1f°' , beta) );
    set(handles.wind_val, 'String', sprintf('%2.1f m/s' , wv) );
    set(handles.rext_val, 'String', sprintf('%1.2f \x3A9', rext) );
    
    if xext >= 0
        set(handles.xext_val, 'String', sprintf('j%1.2f \x3A9', abs(xext)) );
    else
        set(handles.xext_val, 'String', sprintf('-j%1.2f \x3A9', abs(xext)) );
    end
    
    if abs(pinv -prot(idacom)) > 100 || abs(vrot(idacom)) >= (Vdc / sqrt(2*3))
        set(handles.vdc_val, 'String', sprintf('??????') );
    else
        set(handles.vdc_val, 'String', sprintf('%4.0f V', Vdc) );
    end
    
    set(handles.vinvref_val, 'String', sprintf('%3.0f V', vinvref) );
    set(handles.deltaref_val, 'String', sprintf('%1.2f°', deltaref) );
    
    set(handles.vinv_val, 'String', sprintf( '%3.0f V < %2.1f°' , abs(vinv), angled(vinv)));
    set(handles.iinv_val, 'String', sprintf( '%2.1f A < %2.1f°' , abs(iinv), angled(iinv)) );
    set(handles.pinv_val, 'String', sprintf('%3.1f kW' , pinv/1000) );
    set(handles.qinv_val, 'String', sprintf('%3.1f kVAr' , qinv/1000) );
    
    
    set(handles.vinv2_val, 'String', sprintf( '%3.0f V < %2.1f°' , abs(vgridrot), angled(vgridrot)));
    set(handles.pinv2_val, 'String', sprintf('%3.1f kW' , pgridrot/1000) );
    set(handles.qinv2_val, 'String', sprintf('%3.1f kVAr' , qgridrot / 1000) );
    
    
    if get(handles.popupmenu2, 'Value') ~= 3
        qbanco = Qbanco;
        qgridrot = 0;
        pgridrot = 0;
    end
    ptot = pest(idacom) + pgridrot;
    qtot = qest(idacom) + qgridrot + qbanco;
    stot = sqrt(ptot^2 + qtot^2);
    
    set(handles.ptot_val, 'String', sprintf('%3.1f kW' , (ptot)/1000) );
    set(handles.qtot_val, 'String', sprintf('%3.1f kVAr' , (qtot) / 1000) );
    
    if qtot <= 0
        set(handles.fp_val, 'String', sprintf( '%1.3f atr' , ptot/stot ));
    else
        set(handles.fp_val, 'String', sprintf( '%1.3f adi' , ptot / stot ));
    end
    
    set(handles.qbanco_val, 'String', sprintf('%3.1f kVAr' , (qbanco) / 1000) );
     
    
    

    
    
    
    
    
    
    
    
    
    
    
    %margem = 1e6;
    %plot_ylim = [min(min(pg),min(Pgrid(:,end)))-margem, max(max(pg),max(Pgrid(:,end)))+margem]


    Lgrid.plot(nr, Pgrid);
    hold on
        Mgrid.plot(nPmax, Pmax);
        if get(handles.flag_mppt, 'Value')
            [nr_mppt, p_mppt] = turbina.MPPT(400,600);
            Lmppt.plot(nr_mppt, p_mppt);
        end
        Lsincrona.plot([1 1]*ns, plot_ylim);
        Lturbina.plot(nr, pt);
        Lturbinamax.plot(nr(idmppt), pt(idmppt));
        LgeradorC.plot(nr, pg);
        Lacomodacao.plot(nr(idacom), pg(idacom));
        if get(handles.flag_pqest,'Value')
            LgeradorP.plot(nr, pest);
            LgeradorQ.plot(nr, qest);
            MgeradorP.plot(nr(idacom), pest(idacom));
            MgeradorQ.plot(nr(idacom), qest(idacom));
        end
    hold off
    
    xlim(plot_xlim);
    ylim(plot_ylim); 
    
    switch get(handles.popupmenu2, 'Value')
        case 1
            %set(handles.figure1, 'Name', 'Type 1: fixed speed (±1%) squirrel cage induction generator (SCIG)')
            set(handles.config_val, 'String', 'Type 1: fixed speed (±1%) squirrel cage induction generator (SCIG)')
        case 2
            set(handles.config_val, 'String', 'Type 2: semi variable speed (±10%) with wound rotor induction generator (WRIG)')
        case 3
            set(handles.config_val, 'String', 'Type 3: semi variable speed (±30%) doubly fed induction generator (DFIG)')
        case 4
            set(handles.config_val, 'String', 'Type 4: full variable speed with magnet synchronous speed (PMSG)')
    end
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    