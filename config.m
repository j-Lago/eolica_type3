%  Created on: 13/06/2023
%      Author: j-Lago
%
function config(hObject, eventdata, handles)

axes(handles.axes2)

config =  get(handles.popupmenu2,'Value');

switch config
    case 1
        image(imread('type_1.png'));
    case 2
        image(imread('type_2.png'));
    case 3
        image(imread('type_3.png'));
end

flag_pot = 'Off';
flag_iv = 'OF';
if get(handles.flag_pot,'Value')
    flag_pot = 'On';
end
if get(handles.flag_iv,'Value')
    flag_iv = 'On';
end

set(handles.perdas_val, 'Visible', flag_pot)
set(handles.pt_val, 'Visible', flag_pot)
set(handles.pest_val, 'Visible', flag_pot)
set(handles.qest_val, 'Visible', flag_pot)
set(handles.ptot_val, 'Visible', flag_pot)
set(handles.qtot_val, 'Visible', flag_pot)
set(handles.fp_val, 'Visible', flag_pot)
set(handles.iest_val, 'Visible', flag_iv)
set(handles.vest_val, 'Visible', flag_iv)

if config == 1 || config ==2
    set(handles.flag_manual, 'Visible', 'Off')     ; set(handles.flag_manual, 'Value', 0)
    set(handles.pinv2_val, 'Visible', 'Off')
    set(handles.qinv2_val, 'Visible', 'Off')
    set(handles.pinv_val, 'Visible', 'Off')
    set(handles.qinv_val, 'Visible', 'Off')
    set(handles.vinv2_val, 'Visible', 'Off')
    set(handles.vinv_val, 'Visible', 'Off')
    set(handles.iinv_val, 'Visible', 'Off')
    set(handles.vdc_val, 'Visible', 'Off')
    set(handles.vinvref_val, 'Visible', 'Off')
    set(handles.deltaref_val, 'Visible', 'Off')
    set(handles.xext_val, 'Visible', 'Off')

    set(handles.vinvref, 'Visible', 'Off')      ; set(handles.vinvref, 'Value', 400)
    set(handles.deltaref, 'Visible', 'Off')     ; set(handles.deltaref, 'Value', 0)
    set(handles.xext, 'Visible', 'Off')         ; set(handles.xext, 'Value', 0)
    set(handles.qbanco_val, 'Visible', flag_pot)
    
    if config == 1
        set(handles.rext, 'Visible', 'Off')         ; set(handles.rext, 'Value', 0)
        set(handles.vrot_val, 'Visible', 'Off')
        set(handles.irot_val, 'Visible', 'Off')
        set(handles.frot_val, 'Visible', 'Off')
        set(handles.rext_val, 'Visible', 'Off') 
        set(handles.prot_val, 'Visible', 'Off')
        set(handles.qrot_val, 'Visible', 'Off')
    else
        set(handles.rext, 'Visible', 'On')        
        set(handles.vrot_val, 'Visible', flag_iv)
        set(handles.irot_val, 'Visible', flag_iv)
        set(handles.frot_val, 'Visible', flag_iv)
        set(handles.rext_val, 'Visible', 'On')
        set(handles.prot_val, 'Visible', flag_pot)
        set(handles.qrot_val, 'Visible', flag_pot)
    end
end
         
if config == 3
    set(handles.flag_manual, 'Visible', 'On')
    set(handles.pinv2_val, 'Visible', flag_pot)
    set(handles.qinv2_val, 'Visible', flag_pot)
    set(handles.pinv_val, 'Visible', flag_pot)
    set(handles.qinv_val, 'Visible', flag_pot)
    set(handles.vinv2_val, 'Visible', flag_iv)
    set(handles.vinv_val, 'Visible', flag_iv)
    set(handles.iinv_val, 'Visible', flag_iv)
    set(handles.vdc_val, 'Visible', flag_iv)
    set(handles.prot_val, 'Visible', flag_pot)
    set(handles.qrot_val, 'Visible', flag_pot)
    set(handles.vinvref_val, 'Visible', 'On')
    set(handles.deltaref_val, 'Visible', 'On')
    set(handles.xext_val, 'Visible', 'On')

    set(handles.vinvref, 'Visible', 'On')
    set(handles.deltaref, 'Visible', 'On')
    set(handles.xext, 'Visible', 'On')
    set(handles.rext, 'Visible', 'On')
    set(handles.vrot_val, 'Visible', flag_iv)
    set(handles.irot_val, 'Visible', flag_iv)
    set(handles.frot_val, 'Visible', flag_iv)
    set(handles.rext_val, 'Visible', 'On')

    set(handles.qbanco_val, 'Visible', 'Off')
end
        

axis off
axis image
plot_refresh(hObject, eventdata, handles)
