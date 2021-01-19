#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
-----------------------------------------------------------------
Created on Sun May 10 19:06:21 2021
-----------------------------------------------------------------
@purpose : For every habit in Ping Yang's database, it returns a
	   a plot illustrating the phase matrix elements. 
@author  : Vasileios Barlakas
@email   : vasileios.barlakas@gmail.com
-----------------------------------------------------------------
"""
#################################################################
#################################################################
#
# Load libraries
#
import typhon.arts.xml   as tax
import numpy 		  as np
import matplotlib.pyplot as plt
#################################################################
#################################################################
#
# Definitions
#
def PhaseMatrixPlot(the,pha1,normfac1,pha2,normfac2,pha3,normfac3,opt):
    """
    -------------------------------------------------------------
    Returns phase matrix plot 
    -------------------------------------------------------------
    OUT   *.        Dict with paths to files/folders

    IN    wfolder      Input folder options
          ihabit       Hydrometeor habit
          iroughness   Surface roughness
    -------------------------------------------------------------
    """
    plt.matplotlib.rc('font', family='serif', size = 24 )
    fig = plt.figure(figsize=(opt['width'],opt['height'])) 

    labels = ['P_{11}','P_{12}/P_{11}','P_{22}/P_{11}','P_{33}/P_{11}','P_{34}/P_{11}','P_{44}/P_{11}']
    for i in np.arange(6):
        axi = fig.add_subplot(opt['nrows'],opt['ncols'],i+1)
        if i == 0:
            axi.plot(the,pha1[:,i]*normfac1,label='Smooth')
            axi.plot(the,pha2[:,i]*normfac2,label='Mod. Rough')
            axi.plot(the,pha3[:,i]*normfac3,label='Sev. Rough')
            plt.legend()
            plt.yscale('log')
        else:
            axi.plot(the,pha1[:,i]/pha1[:,0]),label='Smooth')
            axi.plot(the,pha2[:,i]/pha2[:,0]),label='Mod. Rough')
            axi.plot(the,pha3[:,i]/pha3[:,0]),label='Sev. Rough')

        if i == 2:
            axi.set_ylim([0,1])
        if i == 3 or i == 5:
            axi.set_ylim([-1,1])
        axi.set_xlim([0,180])
        axi.set_xticks(np.arange(0,180.1,30))
        axi.set_ylabel(r'$'+str(labels[i])+' [-]$')
        axi.set_xlabel(r'Scattering angle [$^\circ$]')
        plt.grid('true')
    plt.tight_layout()
    plt.savefig(opt['pathout']+opt['name']+'.png')
    return 
#################################################################
#################################################################
if __name__ == "__main__":
    
    #wfolder = 'Data_16.4_99.0/'
    #wid     = 'Lambda_016mu_100mu_'
    
    #wfolder = ''  #'Data_0.2_15.25/'
    #wid     = ''  #'Lambda_002mu_016mu_'
    wfolder = input("Chose directory: Data_0.2_15.25/, Data_16.4_99.0/, OR LEAVE IT EMPTY ? ")
    wid     = input("What is the wavelength id to be used in the output filename: Lambda_002mu_016mu_, Lambda_016mu_100mu_?, OR LEAVE IT EMPTY ")

    wv_id   = int(input('Pick a wavelength index: 0.2~15.25 um => 0:395, 16.4~99.0 um => 0:48 wavelengths, OR 0:444 '))
    dmax_id = int(input('Pick a max dimateter index 2.0~10000 um => 0:188 sizes '))

    # dmax =   20 mu => index =  12
    # dmax = 2000 mu => index = 124
    #dmax_id = 124
  
    # lambda = 0.65 mu => index = 39
    #wv_id   =  39    
    
    # Options for plots
    options = {}
    options['width'] = 30
    options['height']= 15
    options['nrows'] = 2
    options['ncols'] = 3
    options['pathin']  = '/home/barlakas/WORKAREA/IRdata/SSD/Yang2013/'+str(wfolder)+str(wid)
    
    habits = ['5-PlateAggregate','8-ColumnAggregate','10-PlateAggregate','Droxtal','HollowBulletRosette','HollowColumn','Plate','SolidBulletRosette','HexagonalColumn']
    for ih in habits:
        options['name'] = ih
        hS1=options['pathin']+str(ih)+'-Smooth.xml'
        hM1=options['pathin']+str(ih)+'-Smooth.meta.xml'
        
        S1 = tax.load(hS1)
        M1 = tax.load(hM1)
        
        hS2=options['pathin']+str(ih)+'-ModeratelyRough.xml'
        hM2=options['pathin']+str(ih)+'-ModeratelyRough.meta.xml'
        
        S2 = tax.load(hS2)
        M2 = tax.load(hM2)
      	
        hS3=options['pathin']+str(ih)+'-SeverelyRough.xml'
        hM3=options['pathin']+str(ih)+'-SeverelyRough.meta.xml'
        
        S3 = tax.load(hS3)
        M3 = tax.load(hM3)
        
        m1=M1[dmax_id].to_atmlab_dict()
        s1=S1[dmax_id].to_atmlab_dict()
        
        m2=M2[dmax_id].to_atmlab_dict()
        s2=S2[dmax_id].to_atmlab_dict()
        
        m3=M3[dmax_id].to_atmlab_dict()
        s3=S3[dmax_id].to_atmlab_dict()

        pha00 = s1['pha_mat_data'][wv_id,0,:,0,0,0,:]
        ext00 = s1['ext_mat_data'][wv_id,0,0,0,0]
        abs00 = s1['abs_vec_data'][wv_id,0,0,0,0]
        the00 = s1['za_grid']
        sca00 = ext00 - abs00
        normfac00 = 4*np.pi/sca00
        
        pha01 = s2['pha_mat_data'][wv_id,0,:,0,0,0,:]
        ext01 = s2['ext_mat_data'][wv_id,0,0,0,0]
        abs01 = s2['abs_vec_data'][wv_id,0,0,0,0]
        the01 = s2['za_grid']
        sca01 = ext01 - abs01
        normfac01 = 4*np.pi/sca01
        
        pha02 = s3['pha_mat_data'][wv_id,0,:,0,0,0,:]
        ext02 = s3['ext_mat_data'][wv_id,0,0,0,0]
        abs02 = s3['abs_vec_data'][wv_id,0,0,0,0]
        the02 = s3['za_grid']
        sca02 = ext02 - abs02
        normfac02 = 4*np.pi/sca02
        
        dmax = M1[dmax_id].diameter_max/1e-6
        dmax = round(dmax, 2)
        freq = 299792458/s1['f_grid'][wv_id]
        freq/=1e-6
        freq = round(freq, 2)
        #import sys
        #sys.exit()
        options['pathout'] = '/home/barlakas/WORKAREA/IRdata/Plots/'+str(wid)+'Dmax'+str(dmax)+'mu_'+'Freq'+str(freq)+'mu_'
        PhaseMatrixPlot(the00,pha00,normfac00,pha01,normfac01,pha02,normfac02,options)
#################################################################
#################################################################
